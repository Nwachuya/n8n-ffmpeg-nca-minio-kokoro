version: '3.8'
services:
  n8n:
    image: 'rxchi1d/n8n-ffmpeg:latest'
    container_name: n8n
    environment:
      - 'WEBHOOK_URL=[]'
      - N8N_DEFAULT_BINARY_DATA_MODE=filesystem
      - N8N_RUNNERS_ENABLED=true
    volumes:
      - 'n8n-data:/home/node/.n8n'
    networks:
      - diliguard-network
    restart: unless-stopped
  minio:
    image: 'quay.io/minio/minio:latest'
    container_name: minio
    ports:
      - '9000:9000'
      - '9001:9001'
    environment:
      - MINIO_ROOT_USER=admin
      - MINIO_ROOT_PASSWORD=password123
    volumes:
      - 'minio-data:/data'
    command: 'server /data --console-address ":9001"'
    networks:
      - diliguard-network
    restart: unless-stopped
  kokoro-tts:
    image: 'ghcr.io/remsky/kokoro-fastapi-cpu:v0.2.2'
    container_name: kokoro-tts
    networks:
      - diliguard-network
    restart: unless-stopped
  nca-toolkit:
    image: 'stephengpope/no-code-architects-toolkit:latest'
    container_name: nca-toolkit
    environment:
      - API_KEY=thekey
      - 'S3_ENDPOINT_URL=http://minio:9000'
      - S3_ACCESS_KEY=your-minio-key
      - S3_SECRET_KEY=your-minio-key
      - S3_BUCKET_NAME=nca-toolkit
      - S3_REGION=None
    depends_on:
      - minio
    networks:
      - diliguard-network
    restart: unless-stopped
volumes:
  n8n-data:
    driver: local
  minio-data:
    driver: local
networks:
  diliguard-network:
    driver: bridge
