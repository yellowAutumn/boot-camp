# Use the official Python image.
FROM python:3.11-slim

# Set work directory
WORKDIR /app

# Copy requirements.txt
COPY requirements.txt .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy application code
COPY . .

# Expose the port Cloud Run will use
EXPOSE 5000

# Set the environment variable for Flask
ENV FLASK_APP=inventory_api.py

# Run the application
CMD ["flask", "run", "--host=0.0.0.0"]
