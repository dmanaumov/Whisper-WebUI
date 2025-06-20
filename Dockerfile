#FROM python:3.10-slim

#WORKDIR /app
#COPY . .

# Устанавливаем зависимости
#RUN apt-get update && \
#    apt-get install -y git ffmpeg && \
#    apt-get clean && rm -rf /var/lib/apt/lists/*

#RUN pip install --no-cache-dir -r requirements.txt

#CMD ["python3", "app.py"]



FROM python:3.10-slim

# Устанавливаем только необходимые системные зависимости
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ffmpeg \
        git \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Устанавливаем рабочую директорию
WORKDIR /app

# Копируем только необходимые файлы (оптимизируй .dockerignore!)
COPY requirements.txt .

# Устанавливаем Python-зависимости без кэша
RUN pip install --no-cache-dir -r requirements.txt

# Копируем остальной код
COPY . .

# CMD ["python3", "app.py"]
CMD ["python3", "app.py", "--server_name", "0.0.0.0", "--server_port", "7860"]

