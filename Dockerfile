# Use the official n8n image as a base
FROM n8nio/n8n:latest

# Switch to root user to install system dependencies and Python packages
USER root

# Install wkhtmltoimage (via wkhtmltopdf), pip, and necessary build tools
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    wkhtmltopdf \
    python3-pip \
    python3-dev \
    build-essential && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Copy the requirements file into a temporary location in the image
COPY requirements.txt /tmp/requirements.txt

# Install Python dependencies
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Clean up the requirements file
RUN rm /tmp/requirements.txt

# Revert to the non-root user specified in the base n8n image (usually 'node')
USER node 