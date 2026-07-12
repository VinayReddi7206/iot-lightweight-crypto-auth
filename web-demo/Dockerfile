# Production image for the ECDH web demo.
FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1

WORKDIR /app

COPY app/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY app/ .

RUN useradd --create-home appuser
USER appuser

EXPOSE 8000

# Bind to $PORT if the host sets one (e.g. Render), else default to 8000.
CMD gunicorn --bind 0.0.0.0:${PORT:-8000} --workers 2 app:app
