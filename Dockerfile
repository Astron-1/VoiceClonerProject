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

# Install Python packages in specific order with CPU-only versions
RUN pip install --no-cache-dir torch==2.5.1 --index-url https://download.pytorch.org/whl/cpu \
    && pip install --no-cache-dir numpy==1.22.0 \
    && pip install --no-cache-dir transformers==4.46.2

# Install TTS dependencies with specific versions
RUN pip install --no-cache-dir \
    coqpit==0.0.17 \
    trainer==0.0.36 \
    encodec==0.1.1 \
    librosa==0.10.0 \
    scipy==1.11.4 \
    pandas==1.5.3 \
    unidecode==1.3.8 \
    pypinyin==0.53.0 \
    gruut==2.2.3

# Install TTS
RUN pip install --no-cache-dir TTS==0.22.0

# Install API dependencies
RUN pip install --no-cache-dir \
    fastapi==0.104.1 \
    uvicorn==0.24.0 \
    python-multipart==0.0.6

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