"""
Web demo of the Lightweight ECDH IoT Authentication protocol.

This recreates the MATLAB project's protocol as an interactive web app so it can be
deployed with a live link. The cryptography (ecdh.py) mirrors the MATLAB code.
"""
import time
from flask import Flask, jsonify, request, send_from_directory

import ecdh

app = Flask(__name__, static_folder="static")


def _pt(point):
    return {"x": point[0], "y": point[1]}


@app.route("/")
def index():
    return send_from_directory("static", "index.html")


@app.route("/health")
def health():
    return jsonify(status="healthy"), 200


@app.route("/api/authenticate", methods=["POST"])
def authenticate():
    """Run the ECDH handshake between an IoT device and the server."""
    t0 = time.perf_counter()
    iot_priv, iot_pub = ecdh.generate_keys()
    srv_priv, srv_pub = ecdh.generate_keys()

    iot_secret = ecdh.compute_shared_secret(iot_priv, srv_pub)
    srv_secret = ecdh.compute_shared_secret(srv_priv, iot_pub)
    elapsed = (time.perf_counter() - t0) * 1000

    match = iot_secret == srv_secret
    return jsonify(
        success=match,
        iot_public=_pt(iot_pub),
        server_public=_pt(srv_pub),
        iot_secret=iot_secret,
        server_secret=srv_secret,
        secrets_match=match,
        time_ms=round(elapsed, 3),
        # return the session so the encrypt step can reuse it (demo only)
        session={"iot_priv": iot_priv, "iot_pub": _pt(iot_pub),
                 "srv_priv": srv_priv, "srv_pub": _pt(srv_pub)},
    )


@app.route("/api/encrypt", methods=["POST"])
def encrypt():
    """Encrypt a sensor reading with the ECDH shared secret, then decrypt it back."""
    data = request.get_json(silent=True) or {}
    message = (data.get("message") or "temperature=24.7C").strip() or "temperature=24.7C"

    iot_priv, iot_pub = ecdh.generate_keys()
    srv_priv, srv_pub = ecdh.generate_keys()
    shared = ecdh.compute_shared_secret(iot_priv, srv_pub)

    cipher = ecdh.encrypt(message, shared)
    recovered = ecdh.decrypt(cipher, shared)

    cipher_hex = cipher.hex()
    cipher_bin = " ".join(format(b, "08b") for b in cipher)   # NumericToBinary equivalent
    return jsonify(
        plaintext=message,
        shared_secret=shared,
        ciphertext_hex=cipher_hex,
        ciphertext_binary=cipher_bin,
        decrypted=recovered,
        integrity_ok=(recovered == message),
    )


@app.route("/api/wrong-key", methods=["POST"])
def wrong_key():
    """Show a FAILED authentication: a wrong key yields a different shared secret."""
    iot_priv, iot_pub = ecdh.generate_keys()
    srv_priv, srv_pub = ecdh.generate_keys()

    correct = ecdh.compute_shared_secret(iot_priv, srv_pub)
    attacker_priv, _ = ecdh.generate_keys()          # attacker guesses a wrong key
    wrong = ecdh.compute_shared_secret(attacker_priv, srv_pub)

    return jsonify(
        authenticated=(wrong == correct),
        correct_secret=correct,
        attacker_secret=wrong,
        message="Authentication FAILED - wrong key produces a different shared secret.",
    )


if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8000)
