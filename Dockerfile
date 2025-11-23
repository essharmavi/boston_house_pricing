
FROM python:3.9

COPY . /app

WORKDIR /app

RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN python -m pip install --upgrade pip \
    && python -m pip install --no-cache-dir -r /app/requirements.txt

EXPOSE $PORT


CMD gunicorn --workers=4 --bind 0.0.0.0:$PORT app:app