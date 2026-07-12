# Lightweight Cryptographic Protocol for IoT Device Authentication

A capstone project that designs a **lightweight authentication protocol for IoT
devices** using **Elliptic-Curve Diffie-Hellman (ECDH)** key exchange, plus an
interactive **secure-messaging web demo** that shows the encryption in action.

## 🔴 Live Demo — SecureShare
**▶ https://VinayReddi7206.github.io/iot-lightweight-crypto-auth/**

Lock a message with a secret key, share the scrambled code with anyone, and only the
person who enters the **exact same key** can unlock it. A **"Show what's inside"** panel
reveals the plaintext, ciphertext (hex) and 8-bit binary — and shows how the same
message produces different ciphertext every time (random salt + IV). Real **AES-256-GCM**
encryption running entirely in the browser.

*(If the link above 404s, enable GitHub Pages: Settings → Pages → Source = `main` / `/docs`.)*

## What's in this repository
| Folder | What it is |
|--------|-----------|
| **`matlab/`** | The original project implementation in **MATLAB** — ECDH key generation, shared-secret computation, encryption/decryption, and key-validation authentication. |
| **`docs/`** | **SecureShare** — the live web demo (static HTML, served by GitHub Pages). |
| **`web-demo/`** | A Python/Flask demo that visualises the ECDH authentication handshake between an IoT device and a server. |

## How the protocol works
1. The IoT device and the server each generate an **ECDH key pair** (private scalar + public point on an elliptic curve).
2. They exchange **public keys** and each computes the **same shared secret** — without ever transmitting their private keys, because `iotPriv·(serverPriv·G) = serverPriv·(iotPriv·G)`.
3. Data is **encrypted / decrypted** using a key derived from that shared secret.
4. **Authentication:** a wrong key produces a different secret, so authentication is rejected — protecting against **impersonation, man-in-the-middle, and replay attacks**.

## Key features
- Lightweight ECDH key exchange suited to low-power IoT devices
- Mutual authentication via key validation
- Shared-secret encryption of transmitted data
- Interactive, shareable secure-messaging demo (AES-256-GCM)
- Resistance to MITM and replay attacks

## Run it locally
- **MATLAB:** open `matlab/` and run `main_demo` (see `matlab/README.md`)
- **SecureShare demo:** open `docs/index.html` in a browser
- **Flask ECDH demo:** `cd web-demo && pip install -r app/requirements.txt && python app/app.py` → http://localhost:8000

## Tech
| | |
|---|---|
| Original implementation | MATLAB |
| Algorithm | Elliptic-Curve Diffie-Hellman (ECDH) |
| Web demo encryption | AES-256-GCM + PBKDF2 (browser Web Crypto API) |
| Flask demo | Python, Flask, Docker |

---
Capstone project — **Team CSE(A9), GITAM (Deemed to be University), Bengaluru**
Built & extended by **Vinay Kumar Reddy Palavalli** · [GitHub](https://github.com/VinayReddi7206)
