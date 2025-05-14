# Use the official n8n image as a base
FROM n8nio/n8n:latest

# Switch to root user to install system dependencies and Python packages
USER root

ENV WKHTMLTOPDF_VERSION=0.12.6.1-2
ENV WKHTMLTOPDF_DEB=wkhtmltox_${WKHTMLTOPDF_VERSION}.bullseye_arm64.deb
ENV WKHTMLTOPDF_URL=https://github.com/wkhtmltopdf/packaging/releases/download/${WKHTMLTOPDF_VERSION}/${WKHTMLTOPDF_DEB}

# Install Python, build tools, and utilities for manual wkhtmltopdf installation
# and runtime dependencies for wkhtmltopdf
RUN apk update && \
    apk add --no-cache \
    # For Python
    python3 \
    py3-pip \
    build-base \
    # For downloading and extracting wkhtmltopdf
    curl \
    tar \
    xz \
    binutils \
    # Runtime dependencies for wkhtmltopdf
    xvfb-run \
    fontconfig \
    freetype \
    libjpeg-turbo \
    libpng \
    libxrender \
    libxext \
    openssl \
    libstdc++ \
    # Common font packages
    ttf-dejavu \
    ttf-droid \
    ttf-freefont \
    ttf-liberation && \
    # Download and install wkhtmltopdf manually
    curl -L -o /tmp/${WKHTMLTOPDF_DEB} ${WKHTMLTOPDF_URL} && \
    cd /tmp && \
    ar -x ${WKHTMLTOPDF_DEB} data.tar.xz && \
    tar -xf data.tar.xz -C / ./usr/local/bin/wkhtmltopdf ./usr/local/bin/wkhtmltoimage && \
    chmod +x /usr/local/bin/wkhtmltopdf /usr/local/bin/wkhtmltoimage && \
    # Clean up downloaded files and apk cache
    rm -rf /tmp/* /var/cache/apk/*

# Copy the requirements file into a temporary location in the image
COPY requirements.txt /tmp/requirements.txt

# Install Python dependencies
RUN pip3 install --no-cache-dir --break-system-packages -r /tmp/requirements.txt && \
    rm /tmp/requirements.txt

# Revert to the non-root user specified in the base n8n image (usually 'node')
USER node 