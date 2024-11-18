# Use Python 3.10 as base image
FROM python:3.10.12-slim

# Set working directory
WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    python3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install Python packages in order to handle dependencies correctly
COPY requirements.txt .

# Install packages in the correct order
RUN pip install --no-cache-dir torch==2.1.0 && \
    pip install --no-cache-dir numpy==1.24.3 && \
    pip install --no-cache-dir TTS==0.22.0 && \
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