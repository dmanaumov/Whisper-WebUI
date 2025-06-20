FROM python:3.10-slim

# Устанавливаем
системные зависимости
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        git \
        curl \
        unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Копируем requirements
COPY requirements.txt .

RUN pip install --no-cache-dir -r requirements.txt

COPY . .

# Скачиваем модель faster-whisper (пример, меняй ссылку на нужную)
RUN mkdir -p /app/models/Whisper/faster-whisper && \
    curl -L -o /tmp/faster-whisper-large-v2.zip https://huggingface.co/Systran/faster-whisper-large-v2/resolve/main/faster-whisper-large-v2.zip && \
    unzip /tmp/faster-whisper-large-v2.zip -d /app/models/Whisper/faster-whisper/ && \
    rm /tmp/faster-whisper-large-v2.zip

# Установим huggingface_hub, если ещё нет
RUN pip install huggingface_hub

# Скачиваем модель правильно
RUN python3 -c "\
from huggingface_hub import snapshot_download; \
snapshot_download(repo_id='Systran/faster-whisper-large-v2', local_dir='/app/models/Whisper/faster-whisper/models--Systran--faster-whisper-large-v2', local_dir_use_symlinks=False)"

CMD ["python3", "app.py", "--server_name", "0.0.0.0", "--server_port", "7860"]
