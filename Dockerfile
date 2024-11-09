# Dockerfile
FROM python:3.11-slim

WORKDIR /app

# Install system dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first to leverage Docker cache
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the entire project
COPY . .

# This ensures Python can find your modules
ENV PYTHONPATH=/app

# Expose the port the app runs on
EXPOSE 8000

# Create a non-root user and switch to it
RUN useradd -m myuser
RUN chown -R myuser:myuser /app
USER myuser

# Command to run the application with uvicorn
CMD ["uvicorn", "src.main:app", "--host", "0.0.0.0", "--port", "8000", "--reload"]