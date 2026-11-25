FROM python:3.11-slim

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PORT=7860

WORKDIR /app

COPY backend/requirements.txt ./backend/requirements.txt

# Install CPU-only PyTorch first so pip does not pull multi-GB CUDA libraries.
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir "torch>=2.2,<2.6" --index-url https://download.pytorch.org/whl/cpu && \
    pip install --no-cache-dir -r backend/requirements.txt

COPY backend ./backend
COPY ml ./ml
COPY data/processed ./data/processed
COPY models ./models
COPY experiments ./experiments

# Hugging Face Spaces runs containers as uid 1000; ensure data/, models/, and experiments/ are writable.
RUN useradd -m -u 1000 user && \
    mkdir -p /app/data && \
    chown -R user:user /app

USER user

EXPOSE 7860

CMD ["sh", "-c", "python -m uvicorn backend.app.main:app --host 0.0.0.0 --port ${PORT:-7860}"]
