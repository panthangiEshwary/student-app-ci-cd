# Use a lightweight official Python image
FROM python:3.9-slim

# Set working directory inside the container
WORKDIR /app

# Install system dependencies (if needed) and Python packages
RUN apt-get update && apt-get install -y gcc && rm -rf /var/lib/apt/lists/*

# Copy requirements file and install Python dependencies
COPY app/requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY app/student_app.py ./student_app.py

# Copy templates folder (HTML files)
COPY app/templates/ ./templates/

# Expose the port that the app runs on
EXPOSE 8000

# Set environment variables (these will be overridden in production or CI/CD)
ENV DB_HOST="dummy_host" \
    DB_PORT=3306 \
    DB_USER="dummy_user" \
    DB_PASSWORD="dummy_password" \
    DB_NAME="dummy_db"

# Start the Flask app using Gunicorn
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8000", "student_app:app"]

