# Path to your GCP service account JSON key file
credentials        = "./keys/my-service-account.json"

# Your GCP project ID
project         = "steam-review-trends"

# Region for resources like Cloud Storage buckets (use a valid GCP region code)
region             = "us-central1"

# Location for BigQuery dataset (use valid BigQuery location codes like 'EU', 'US', or a region)
location           = "US"

# Name for your Google Cloud Storage bucket (must be globally unique)
gcs_bucket_name    = "steam_review_trends_bucket"

# Storage class for the bucket (e.g., STANDARD, NEARLINE, COLDLINE, ARCHIVE)
gcs_storage_class  = "STANDARD"

# BigQuery dataset name
bq_dataset_name    = "steam_review_trends_dataset"