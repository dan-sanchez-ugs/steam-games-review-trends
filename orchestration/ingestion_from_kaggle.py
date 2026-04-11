import os
import argparse
import pyarrow
from kaggle.api.kaggle_api_extended import KaggleApi
import pandas as pd

# Read arguments passed from Kestra
parser = argparse.ArgumentParser()
parser.add_argument("--download_directory", default=None)
parser.add_argument("--download_file", default=None)
parser.add_argument("--kaggle_dataset", default=None) 

config = vars(parser.parse_args())

# Create the download directory if it does not exist
os.makedirs(config['download_directory'], exist_ok=True)

# Construct the full path to the CSV file
csv_file_path = os.path.join(config['download_directory'], f"{config['download_file']}.csv")

# Check if the file already exists before downloading
if os.path.exists(csv_file_path):
    print(f"The file {config['download_file']} already exists in {config['download_directory']}. No need to download.")
# If the file does not exist, download it from Kaggle
else:  
    api = KaggleApi()
    api.authenticate()
    print(f"Now downloading {config['kaggle_dataset']} to {config['download_directory']}")
    api.dataset_download_file(config['kaggle_dataset'], f"{config['download_file']}.csv", path=config['download_directory'])
    print("Download complete")  

    # Convert the downloaded CSV file to Parquet format and remove the original CSV file
    parquet_file_path = os.path.join(config['download_directory'], f"{config['download_file']}.parquet")

    if not os.path.exists(csv_file_path):
        print(f"CSV file {csv_file_path} does not exist.")
    else:
        df = pd.read_csv(csv_file_path)
        df.to_parquet(parquet_file_path, index=False)
        os.remove(csv_file_path)  
        print(f"Converted {csv_file_path} to {parquet_file_path}.")