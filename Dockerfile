# Use Python 3.10 as base image
FROM python:3.10.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    git \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements file
COPY requirements.txt .

# Install Python packages in specific order
RUN pip install --no-cache-dir --upgrade pip && \
    # Install torch CPU version first
    pip install --no-cache-dir torch==2.5.1 --index-url https://download.pytorch.org/whl/cpu && \
    # Install numpy and transformers
    pip install --no-cache-dir numpy==1.22.0 transformers==4.46.2 && \
    # Install the rest of the requirements
    pip install --no-cache-dir -r requirements.txt

# Create necessary directories
RUN mkdir -p /app/uploads /app/output

# Copy application code
COPY ./app ./app

# Set environment variables
ENV PYTHONUNBUFFERED=1
ENV PYTHONPATH=/app

# Expose port
EXPOSE 8000

# Run the application
CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]