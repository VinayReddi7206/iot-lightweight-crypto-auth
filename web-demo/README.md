# Web Demo — Lightweight ECDH IoT Authentication

An interactive web version of the MATLAB project. It runs the **same ECDH protocol**
(see `app/ecdh.py`, which mirrors the MATLAB code) and lets you watch an IoT device
authenticate with a server, encrypt a sensor reading, and see a wrong-key attack fail.

## Run locally
```bash
pip install -r app/requirements.txt
python app/app.py
# open http://localhost:8000
```

## Run with Docker
```bash
docker build -t secureiot .
docker run -p 8000:8000 secureiot
```

## Deploy to Render (free live link)
1. Push this repo to GitHub.
2. On Render → New → Web Service → connect the repo.
3. Set **Root Directory** to `web-demo` (the Dockerfile lives here).
4. Instance type: Free → Create Web Service.

## API
| Endpoint | Purpose |
|----------|---------|
| `GET /` | Interactive UI |
| `POST /api/authenticate` | Runs the ECDH handshake, returns keys + shared secret |
| `POST /api/encrypt` | Encrypts a message with the shared secret, returns hex/binary + decrypted |
| `POST /api/wrong-key` | Shows a failed authentication (wrong key → different secret) |
| `GET /health` | Health probe |
