# Use official devcontainer base image (includes git, curl, wget, build-essential)
FROM mcr.microsoft.com/devcontainers/base:ubuntu-24.04

# Prevent interactive prompts
ENV DEBIAN_FRONTEND=noninteractive

# Install pandoc and LibreOffice for PDF to PPTX conversion
RUN apt-get update && apt-get install -y --no-install-recommends \
    pandoc \
    libreoffice \
    libreoffice-impress \
    && rm -rf /var/lib/apt/lists/*
