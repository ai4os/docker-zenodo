# Use an official Python runtime as a parent image
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY download.sh .

RUN pip install datahugger

RUN export PATH="$HOME/.local/bin:$PATH"

# Run download.py when the container launches
CMD sh ./download.sh
