# Path to your GCP service account JSON key file
credentials        = "./keys/my-service-account.json"

# Your GCP project ID
project         = "YOUR_GCP_PROJECT_ID"

# Region for resources like Cloud Storage buckets (use a valid GCP region code)
region             = "YOUR_REGION"

# Location for BigQuery dataset (use valid BigQuery location codes like 'EU', 'US', or a region)
location           = "YOUR_LOCATION"

# Name for your Google Cloud Storage bucket (must be globally unique)
gcs_bucket_name    = "YOUR_GCP_BUCKET_NAME"

# Storage class for the bucket (e.g., STANDARD, NEARLINE, COLDLINE, ARCHIVE)
gcs_storage_class  = "STANDARD"

# BigQuery dataset name
bq_dataset_name    = "YOUR_BIGQUERY_DATASET_NAME"