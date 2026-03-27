import os
import argparse
from kaggle.api.kaggle_api_extended import KaggleApi

# Read arguments passed from Kestra
parser = argparse.ArgumentParser()
parser.add_argument("--download_directory", default=None)
parser.add_argument("--download_file", default=None)
parser.add_argument("--kaggle_dataset", default=None) 

config = vars(parser.parse_args())

# Create the download directory if it does not exist
os.makedirs(config['download_directory'], exist_ok=True)

# Check if the file already exists before downloading
if os.path.exists(os.path.join(config['download_directory'], f"{config['download_file']}.csv")):
    print(f"The file {config['download_file']} already exists in {config['download_directory']}. No need to download.")
# If the file does not exist, download it from Kaggle
else:  
    api = KaggleApi()
    api.authenticate()
    print(f"Now downloading {config['kaggle_dataset']} to {config['download_directory']}")
    api.dataset_download_file(config['kaggle_dataset'], config['download_file'], path=config['download_directory'])
    print("Download complete")  

