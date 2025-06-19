FROM python:3.10-slim

WORKDIR /app
COPY . .

# Устанавливаем зависимости
RUN apt-get update && \
    apt-get install -y git ffmpeg && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN pip install --no-cache-dir -r requirements.txt

CMD ["python3", "app.py"]
