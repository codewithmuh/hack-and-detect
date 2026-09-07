FROM python:3.12-slim
WORKDIR /app
COPY sensor.py .
RUN mkdir -p /var/log/sensor
EXPOSE 9000-9020
CMD ["python", "sensor.py"]
