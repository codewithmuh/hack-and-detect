FROM python:3.12-slim
# iputils-ping so the intended `ping` tool actually works
RUN apt-get update && apt-get install -y --no-install-recommends iputils-ping \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
RUN mkdir -p /var/log/app \
    && echo 'HND{c0mm4nd_1nj3ction_pwn3d_th3_sh3ll}' > /flag \
    && chmod 644 /flag
EXPOSE 8080
CMD ["python", "app.py"]
