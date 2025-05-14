# Use the official n8n image as a base
FROM n8nio/n8n:latest

# Switch to root user to install system dependencies and Python packages
USER root

# Install wkhtmltoimage (via wkhtmltopdf), pip, and necessary build tools for Alpine
RUN apk update && \
    apk add --no-cache \
    wkhtmltopdf \
    python3 \
    py3-pip \
    build-base && \
    # Note: Alpine's python3 package often includes pip. py3-pip is an explicit add just in case.
    # build-base is similar to build-essential in Debian.
    rm -rf /var/cache/apk/*

# Copy the requirements file into a temporary location in the image
COPY requirements.txt /tmp/requirements.txt

# Install Python dependencies
RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

# Clean up the requirements file
RUN rm /tmp/requirements.txt

# Revert to the non-root user specified in the base n8n image (usually 'node')
USER node 