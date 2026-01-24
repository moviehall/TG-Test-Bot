FROM alpine:latest

RUN apk add --no-cache \
    build-base \
    cmake \
    curl

WORKDIR /app

RUN curl -L https://github.com/ggerganov/llama.cpp/archive/refs/heads/master.tar.gz \
    | tar xz && mv llama.cpp-* llama.cpp

WORKDIR /app/llama.cpp
RUN make server

RUN mkdir models
RUN curl -L -o models/model.gguf \
    https://huggingface.co/Qwen/Qwen2.5-0.5B-Instruct-GGUF/resolve/main/qwen2.5-0.5b-instruct-q4_k_m.gguf

EXPOSE 8080

CMD ["./server", "-m", "models/model.gguf", "-c", "2048", "--host", "0.0.0.0", "--port", "8080"]
