# Use an official Python runtime as a parent image
FROM python:3.11

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the required files into the container at /usr/src/app
COPY polardns.py .
COPY polardns.toml .

# Run polardns.py when the container launches
CMD ["python", "polardns.py"]
