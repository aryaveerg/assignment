# Use an official Python base image
FROM python:3.10-slim

# Set the working directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the code
COPY . .

# Expose Flask's default port
EXPOSE 5000

# Run the app
CMD ["python", "app.py"]
