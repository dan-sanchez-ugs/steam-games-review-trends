# Set the base image to Kestra
FROM kestra/kestra:latest

USER root

# Set the working directory
WORKDIR /app

# Copy the requirements file from the orchestration directory
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

USER kestra