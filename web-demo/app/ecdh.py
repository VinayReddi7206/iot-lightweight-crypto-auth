"""
Elliptic-Curve Diffie-Hellman used by the web demo.

This mirrors the MATLAB implementation (../../matlab): the same small demonstration
curve, the same scalar multiplication, and the same shared-secret keystream cipher.
The device and server derive an identical shared secret without exchanging private
keys, then use it to encrypt/decrypt data.
"""
from __future__ import annotations
import secrets

# Curve:  y^2 = x^3 + a*x + b  (mod p)   -- same params as getCurveParams.m
A, B, P = 497, 1768, 9739
G = (1804, 5368)


def _inv(v: int, m: int) -> int:
    return pow(v % m, -1, m)


def _add(pt1, pt2):
    if pt1 is None:
        return pt2
    if pt2 is None:
        return pt1
    x1, y1 = pt1
    x2, y2 = pt2
    if x1 == x2 and (y1 + y2) % P == 0:
        return None
    if x1 == x2 and y1 == y2:
        m = (3 * x1 * x1 + A) * _inv(2 * y1, P) % P
    else:
        m = (y2 - y1) * _inv(x2 - x1, P) % P
    x3 = (m * m - x1 - x2) % P
    y3 = (m * (x1 - x3) - y1) % P
    return (x3, y3)


def ec_mul(k: int, point):
    """Scalar multiplication k*point (double-and-add)."""
    result = None
    addend = point
    while k > 0:
        if k & 1:
            result = _add(result, addend)
        addend = _add(addend, addend)
        k >>= 1
    return result


def generate_keys():
    """Return (private_scalar, public_point)."""
    priv = secrets.randbelow(P - 3) + 2
    return priv, ec_mul(priv, G)


def compute_shared_secret(my_priv: int, peer_pub) -> int:
    """ECDH shared secret = x-coordinate of (my_priv * peer_pub)."""
    return ec_mul(my_priv, peer_pub)[0]


def _keystream(seed: int, n: int):
    """Deterministic keystream - identical LCG to the MATLAB version."""
    ks = []
    x = seed % (2 ** 20)
    for _ in range(n):
        x = (1103515245 * x + 12345) % (2 ** 20)
        ks.append(x % 256)
    return ks


def encrypt(plaintext: str, shared_secret: int) -> bytes:
    data = plaintext.encode()
    ks = _keystream(shared_secret, len(data))
    return bytes(b ^ k for b, k in zip(data, ks))


def decrypt(cipher: bytes, shared_secret: int) -> str:
    ks = _keystream(shared_secret, len(cipher))
    return bytes(b ^ k for b, k in zip(cipher, ks)).decode(errors="replace")
