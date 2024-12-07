-- Load the data files
noc_region_data = LOAD '/input/noc_region.csv' USING PigStorage(',') AS (region_id:int, noc_code:chararray, region_name:chararray);
person_region_data = LOAD '/input/person_region.csv' USING PigStorage(',') AS (person_id:int, region_id:int);
person_data = LOAD '/input/person.csv' USING PigStorage(',') AS (person_id:int, full_name:chararray, gender:chararray, height:int, weight:int);
competitor_event_data = LOAD '/input/competitor_event.csv' USING PigStorage(',') AS (event_id:int, competitor_id:int, medal_id:int);
medal_data = LOAD '/input/medal.csv' USING PigStorage(',') AS (medal_id:int, medal_name:chararray);

-- Joining the tables 
joined_noc_person_region = JOIN noc_region_data BY region_id, person_region_data BY region_id;
joined_person_data = JOIN joined_noc_person_region BY person_region_data::person_id, person_data BY person_id;
joined_competitor_event_data = JOIN joined_person_data BY person_data::person_id, competitor_event_data BY competitor_id;
joined_medal_data = JOIN joined_competitor_event_data BY competitor_event_data::medal_id, medal_data BY medal_id;

-- Filter for gold medals
gold_medal_data = FILTER joined_medal_data BY medal_data::medal_name == 'Gold';
gold_grouped_data = GROUP gold_medal_data BY noc_region_data::region_id;
gold_medal_count = FOREACH gold_grouped_data GENERATE group AS region_id, COUNT(gold_medal_data) AS gold_count;

-- Filter for silver medals
silver_medal_data = FILTER joined_medal_data BY medal_data::medal_name == 'Silver';
silver_grouped_data = GROUP silver_medal_data BY noc_region_data::region_id;
silver_medal_count = FOREACH silver_grouped_data GENERATE group AS region_id, COUNT(silver_medal_data) AS silver_count;

-- Join gold and silver counts on region_id using FULL OUTER to keep all regions
combined_medal_data = JOIN gold_medal_count BY region_id FULL OUTER, silver_medal_count BY region_id;

-- Join the combined results with noc_region_data to get the region_name
final_combined_data = JOIN combined_medal_data BY gold_medal_count::region_id, noc_region_data BY region_id;

-- Format the final output
final_output_data = FOREACH final_combined_data GENERATE
    noc_region_data::region_name AS region_name,
    (gold_count IS NULL ? '' : (chararray) gold_count) AS Gold,  -- Cast the Gold count to chararray
    (silver_count IS NULL ? '' : (chararray) silver_count) AS Silver;  -- Cast the Silver count to chararray

-- Order the final output by Gold (descending) and region_name (ascending)
ordered_final_output = ORDER final_output_data BY Gold DESC, region_name ASC;

-- Store the result
STORE ordered_final_output INTO '/output/task2-1' USING PigStorage(' ');

