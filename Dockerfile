# Use a lightweight official Python image
FROM python:3.8-slim-buster

# Set working directory inside the container
WORKDIR /app

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

# Install system dependencies
RUN apt-get update && apt-get install -y gcc

# Copy dependencies file and install them
COPY requirements.txt .
RUN pip install --upgrade pip && pip install --no-cache-dir -r requirements.txt

# Copy the application code
COPY app.py .

# Create and copy HTML files into the templates directory
RUN mkdir -p templates
COPY templates/index.html templates/
COPY templates/students.html templates/

# Expose the port the app will run on
EXPOSE 8000

# Environment variables (you can override at runtime or use a .env file)
ENV DB_HOST="dummy_host" \
    DB_USER="dummy_user" \
    DB_PASSWORD="dummy_password" \
    DB_NAME="dummy_db" \
    FLASK_APP="app.py"

# Start the Flask app using Gunicorn
CMD ["gunicorn", "--workers", "4", "--bind", "0.0.0.0:8000", "app:app"]
