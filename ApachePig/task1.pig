-- Load the data files
noc_region_data = LOAD '/input/noc_region.csv' USING PigStorage(',') AS (region_id:int, noc_code:chararray, region_name:chararray);
person_region_data = LOAD '/input/person_region.csv' USING PigStorage(',') AS (person_id:int, region_id:int);
person_data = LOAD '/input/person.csv' USING PigStorage(',') AS (person_id:int, full_name:chararray, gender:chararray, height:int, weight:int);
competitor_event_data = LOAD '/input/competitor_event.csv' USING PigStorage(',') AS (event_id:int, competitor_id:int, medal_id:int);
medal_data = LOAD '/input/medal.csv' USING PigStorage(',') AS (medal_id:int, medal_name:chararray);

-- Joining the tables 
joined_noc_person_region = JOIN noc_region_data BY region_id, person_region_data BY region_id;
joined_person = JOIN joined_noc_person_region BY person_region_data::person_id, person_data BY person_id;
joined_competitor_event = JOIN joined_person BY person_data::person_id, competitor_event_data BY competitor_id;
joined_medal = JOIN joined_competitor_event BY competitor_event_data::medal_id, medal_data BY medal_id;

-- Filtering gold medals
gold_medal = FILTER joined_medal BY medal_data::medal_name == 'Gold';

-- Group by region_id (noc_region_data.region_id) and count the gold medals
grouped_by_region = GROUP gold_medal BY noc_region_data::region_id;

-- Count the number of gold medals per region
gold_medal_count = FOREACH grouped_by_region GENERATE group AS region_id, COUNT(gold_medal) AS gold_count;
joined_with_region = JOIN gold_medal_count BY region_id, noc_region_data BY region_id; -- Join back with noc_region_data to get the region_name
final_output_data = FOREACH joined_with_region GENERATE noc_region_data::region_name AS region_name, gold_count AS Gold; -- Select only the region_name and Gold count for output
ordered_final_data = ORDER final_output_data BY Gold DESC, region_name ASC; -- Order the result by Gold count (DESC) and then by region_name (ASC)

STORE ordered_final_data INTO '/output/task1' USING PigStorage(' '); -- Store the final result

