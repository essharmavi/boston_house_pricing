# Use a supported Python image (consider upgrading to 3.11 soon)
FROM python:3.10-slim

# Do not write .pyc files and flush stdout/stderr
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

# Install minimal build deps needed for building wheels (only if required)
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy only requirements first to leverage Docker cache
COPY requirements.txt /app/requirements.txt

# Upgrade pip and install dependencies (no cache)
RUN python -m pip install --upgrade pip \
    && python -m pip install --no-cache-dir -r /app/requirements.txt

# Copy application code
COPY . /app

# (Optional) create a non-root user for better security
RUN useradd --create-home appuser && chown -R appuser /app
USER appuser

# EXPOSE is informational — use a fixed value (Heroku sets actual port via $PORT)
EXPOSE 8000

# Use sh -c so ${PORT} is expanded at runtime; this execs gunicorn so signals are delivered
CMD ["sh", "-c", "gunicorn --workers=4 --bind 0.0.0.0:${PORT:-8000} app:app"]
