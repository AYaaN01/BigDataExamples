package org.example
import org.apache.spark.SparkConf
import org.apache.spark.streaming.{Seconds, StreamingContext}
import org.apache.spark.streaming.dstream.DStream
import org.apache.spark.rdd.RDD
import java.util.concurrent.atomic.AtomicInteger

object StreamingApp {
  // Atomic counters for unique sequence suffixes
  private val taskACounter = new AtomicInteger(1)
  private val taskBCounter = new AtomicInteger(1)
  private val taskCCounter = new AtomicInteger(1)

  def main(args: Array[String]): Unit = {
    if (args.length < 2) {
      System.err.println("Usage: StreamingApp <inputDir> <outputDir>")
      System.exit(1)
    }

    StreamingExamples.setStreamingLogLevels()

    val Array(inputDir, outputDir) = args

    // Initialize Spark configuration and streaming context
    val conf = new SparkConf().setAppName("StreamingApp").setMaster("local[*]")
    val ssc = new StreamingContext(conf, Seconds(3))
    ssc.checkpoint(".")  // Set checkpoint directory

    // Monitor directory for new text files
    val fileStream = ssc.textFileStream(inputDir)

    // Task A: Word Frequency Count
    runTaskA(fileStream, outputDir)

    // Task B: Co-occurrence Frequency
    runTaskB(fileStream, outputDir)

    // Task C: Update Co-occurrence Frequency Over Time
    runTaskC(fileStream, outputDir)

    ssc.start()
    ssc.awaitTermination()
}

  /**
   * Task A: Count word frequency, filter out invalid and short words, and save to HDFS.
   */
  private def runTaskA(fileStream: DStream[String], outputDir: String): Unit = {
    val filteredText = fileStream
      .flatMap(line => line.split(" "))
      .filter(word => word.matches("^[a-zA-Z]+$") && word.length >= 3)
      .transform(rdd => rdd.coalesce(1)) // Ensure single partition for a single line output
      .mapPartitions(iter => Iterator(iter.mkString(" "))) // Concatenate words into a single line

    filteredText.foreachRDD { (rdd: RDD[String], _) =>
      if (!rdd.isEmpty()) {
        val taskASeqNum = f"${taskACounter.getAndIncrement()}%03d"
        rdd.saveAsTextFile(s"$outputDir/taskA-$taskASeqNum")
      }
    }
  }

  // Helper function to generate word pairs from lines
  private def generateWordPairs(line: String): Seq[((String, String), Int)] = {
    val words = line.split(" ")
      .filter(word => word.matches("^[a-zA-Z]+$") && word.length >= 3)
      .map(_.toLowerCase)

    for {
      i <- words.indices
      j <- words.indices if i != j // skipping pairs with same index
    } yield ((words(i), words(j)), 1)
  }

  /**
   * Task B: Calculate co-occurrence frequency of words appearing in the same line.
   */
  private def runTaskB(fileStream: DStream[String], outputDir: String): Unit = {
    val coOccurrenceCounts = fileStream
      .flatMap(generateWordPairs)
      .reduceByKey(_ + _)

    coOccurrenceCounts.foreachRDD { (rdd: RDD[((String, String), Int)], _) =>
      if (!rdd.isEmpty()) {
        val taskBSeqNum = f"${taskBCounter.getAndIncrement()}%03d"
        rdd.saveAsTextFile(s"$outputDir/taskB-$taskBSeqNum")
      }
    }
  }

  /**
   * Task C: Update co-occurrence frequency over time using updateStateByKey.
   */
  private def runTaskC(fileStream: DStream[String], outputDir: String): Unit = {
    val wordPairs = fileStream.flatMap(generateWordPairs)

    // Update state with cumulative counts
    val updateFunc = (newCounts: Seq[Int], state: Option[Int]) => {
      val newCount = newCounts.sum
      Some(state.getOrElse(0) + newCount)
    }

    val cumulativeCoOccurrences = wordPairs.updateStateByKey(updateFunc)

    // Add a mutable variable to hold the previous batch data
    var previousRDD: Option[Array[((String, String), Int)]] = None

    cumulativeCoOccurrences.foreachRDD { (rdd: RDD[((String, String), Int)], _) =>
      if (!rdd.isEmpty()) {
        // Collect current batch data to the driver for comparison
        val currentBatch = rdd.collect()

        // Compare current batch with the previous batch
        val hasChanges = previousRDD match {
          case Some(prevData) => !currentBatch.sameElements(prevData)
          case None => true // No previous data means this is the first batch, so save it
        }

        if (hasChanges) {
          // Save the output since there are changes
          val taskCSeqNum = f"${taskCCounter.getAndIncrement()}%03d"
          rdd.saveAsTextFile(s"$outputDir/taskC-$taskCSeqNum")

          // Update previousRDD to current batch for the next comparison
          previousRDD = Some(currentBatch)
        }
      }
    }
  }
}
