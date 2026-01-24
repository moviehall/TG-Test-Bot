from fastapi import FastAPI
from transformers import pipeline

app = FastAPI()

pipe = pipeline(
    "text-generation",
    model="TinyLlama/TinyLlama-1.1B-Chat-v1.0",
    device=-1
)

SYSTEM_PROMPT = """
You are WebCoder AI.
You are a helpful assistant for programming and APIs.
"""

@app.post("/chat")
async def chat(prompt: str):
    full_prompt = f"<|system|>{SYSTEM_PROMPT}<|user|>{prompt}<|assistant|>"
    result = pipe(full_prompt, max_new_tokens=200)
    return {"reply": result[0]["generated_text"]}
