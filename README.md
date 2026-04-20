# Steam Games Review Trends
*A reproducible end-to-end data engineering pipeline for analytics on steam reviews*

# Problem Statement
There are countless available tools to access and view steam data, but a simple way to view review data was not immediately found. I wanted to create a way to view simple review metrics- total reviews across all games in steam(both positive and negative), general stats regarding most positively and negatively reviewed games, and trends between review counts and other data points of steam games.

# Solution
This project aims to solve this problem with an automated ELT pipeline via Kestra:
- Extract the raw data from Kaggle
- Load the data into Google Cloud
- Transform the data using some simple SQL and dbt implementation
- Visualize the data using Metabase

# Dataset
The project uses a [dataset found on Kaggle](https://www.kaggle.com/datasets/artermiloff/steam-games-dataset/data) of over 90,000 games published on steam, trimmed down to only those with at least 100 total reviews. Each record contains a nearly cohesive set of data points, from name, price, DLC count, to review counts, languages supported, tags, genres, and much more. Credit to Artemiy Ermilov and all collaborators for their work in making this dataset publicly available.

# Tools
- Python – used for data ingestion
- Terraform – Infrastructure as Code. Automatically creates the cloud resources needed for the project
- Google Cloud Platform – provides the cloud services that the project uses: BigQuery (Data Warehouse), Cloud Storage (Data Lake), and IAM
- dbt – used to transform and enrich the data
- Kestra – workflow orchestration. A majority of the pipeline is automated through its use
- Docker –  allows the project to be easily reproducible. Kestra and Metabase make use of this tool
- Metabase – a relatively simple dashboard creation tool. Chosen for its ease of use

# Pipeline Workflow
Following the Kestra Gantt view:
- extract
    - Uses the python script `ingestion_from_kaggle.py` to ingest the data as a CSV and convert it to parquet
- load_send_to_gcs
    - Sends the parquet file to the Data Lake on Google Cloud Platform
- load_initialize_table
    - If the table does not exist, creates the table in BigQuery that will hold the raw data of the ingested file along with an additional timestamp column
    - The table is partitioned by timestamp, which is generated based on the file ingested. While not used in the pipeline, it could be used to optimize future queries that want to target data from a specific file ingested
- load_to_extenral_table
    - Creates an external table using the parquet file for an immediate transformation
    - This transformation is necessary here to ensure there is an easy way to distinguish between rows containing the same game's data that were added from different files
- transform_add_timestamp
    - Creates a new table that will hold only this file's data. Adds a timestamp in the form of yyyymmmmdd to a new column at the start of the data
- transform_merge_into_main_table
    - Adds the transformed data to the table created in the load_initialize_table step
    - This table will hold the data loaded from ALL files
- purge_files
    - Purge files created by the current Execution
- dbt
    - clone_repository
        - clones the github repository for use by dbt
    - dbt_build
        - builds the dbt project in the repository to transform the data and remove unnecessary columns

# Dashboard
Metabase was used to create a dashboard to visualize key datapoints within the data set. This can easily be expanded upon for much more in depth analysis, but it sufficiently demonstrates the pipeline's ability to be used for data analysis

# Insights
- Positive reviews outnumber negative reviews by a staggering amount! While the ratio will of course fluctuate from game to game, seeing well over 80% of reviews being positive is fascinating
- Counter Strike 2 is absurdly popular. The next most positively reviewed game, Rainbow Six Seige, doesn't even come close to having half as many positive reviews.
- The comparison between Counter Strike 2 and PUBG is stark. While PUBG is ranked 5th in positive reviews, it is rankled 2nd in negative. It is the only game close to Counter Strike 2's negative reviews, and all other games have less than half of the negative reviews that Counter Strike 2 has.
- Release date(and therefore age) of a game doesn't seem to affected the amount of reviews a game gets.
- Games under $19 generally see far less reviews than those more expensive. The dataset removes all games with less than 100 reviews, so the games in this data all have, at the minimum, a niche audience.
- The number of reviews trends upwards with a higher amount of peak concurrent players for a game. Peak concurrent players is a good measure of how popular a game is/was at its most popular time, so it makes sense that a game with a larger audience would have more reviews.

# Challenges
- The data source has files available from only two times, limiting how much the data can be compared across time. A data set that was updated more frequently could lead to analytics than measure trends over time.
  
# Reproducing the Project
