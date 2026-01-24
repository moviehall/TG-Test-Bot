FROM alpine:latest

RUN apk add --no-cache curl ca-certificates

WORKDIR /app

# Download prebuilt llama-server binary
RUN curl -L -o llama-server \
    https://github.com/ggml-org/llama.cpp/releases/download/b2670/llama-server-linux-x86_64 \
    && chmod +x llama-server

# Download small GGUF model
RUN mkdir models && curl -L -o models/model.gguf \
    https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-q4_k_m.gguf

EXPOSE 8080

CMD ["./llama-server", "-m", "models/model.gguf", "-c", "2048", "--host", "0.0.0.0", "--port", "8080"]
