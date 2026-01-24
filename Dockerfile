FROM alpine:latest

# Install build deps
RUN apk add --no-cache \
    build-base \
    cmake \
    curl \
    git

WORKDIR /app

# Clone llama.cpp
RUN git clone https://github.com/ggml-org/llama.cpp.git

WORKDIR /app/llama.cpp

# Build llama-server (NEW WAY)
RUN cmake -B build
RUN cmake --build build --config Release -j 2

# Download model
RUN mkdir -p models
RUN curl -L -o models/model.gguf \
    https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-q4_k_m.gguf

EXPOSE 8080

# Start server
CMD ["./build/bin/llama-server", "-m", "models/model.gguf", "-c", "2048", "--host", "0.0.0.0", "--port", "8080"]
