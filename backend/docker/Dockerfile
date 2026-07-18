FROM python:3.11

WORKDIR /app

# Install system dependencies (important for ML)
RUN apt-get update && apt-get install -y \
    build-essential \
    gcc \
    libgl1 \
    libglib2.0-0 \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements first (better caching)
COPY requirements.txt /app/

RUN pip install --upgrade pip
RUN pip install -r requirements.txt

# Copy full backend project
COPY . /app/

# Create media folder
RUN mkdir -p /app/media

EXPOSE 8000

# Run Django
CMD ["python", "manage.py", "runserver", "0.0.0.0:8000"]