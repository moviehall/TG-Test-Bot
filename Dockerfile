FROM debian:bookworm-slim

RUN apt-get update && apt-get install -y \
    curl ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Download ARM64 llama-server (THIS IS THE KEY FIX)
RUN curl -L -o llama-server \
    https://github.com/ggml-org/llama.cpp/releases/latest/download/llama-server-linux-aarch64 \
    && chmod +x llama-server

# Download small GGUF model
RUN mkdir models && curl -L -o models/model.gguf \
    https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-q4_k_m.gguf

EXPOSE 8080

CMD ["./llama-server", "-m", "models/model.gguf", "-c", "2048", "--host", "0.0.0.0", "--port", "8080"]
