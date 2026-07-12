# MATLAB Implementation — Lightweight ECDH Authentication

This is the original project implementation in **MATLAB**. It authenticates an IoT
device to a server using **Elliptic Curve Diffie-Hellman (ECDH)** key exchange and a
shared-secret stream cipher.

## How to run
Open MATLAB in this folder and run:
```matlab
main_demo
```
This generates keys, runs a successful authentication (encrypt + decrypt), shows a
failed authentication with a wrong key, and reports execution time.

## Files
| File | Purpose |
|------|---------|
| `getCurveParams.m` | Elliptic curve parameters (y² = x³ + ax + b mod p, base point G) |
| `ec_mul.m` | EC scalar multiplication (core ECDH operation; includes point add + mod inverse) |
| `generateECDHKeys.m` | Generate one ECDH key pair (private scalar + public point) |
| `GenerateKeys.m` | Generate device + server key pairs → save `ECDH_Keys.mat` |
| `ComputeSharedSecret.m` | Compute the ECDH shared secret (priv × peer-public) |
| `encryptDataWithECDH.m` | Encrypt data with a keystream derived from the shared secret |
| `decryptDataWithECDH.m` | Decrypt data (symmetric to the above) |
| `EncryptData.m` | Authenticate the device (validate keys) and encrypt → `EncryptedData.mat` |
| `DecryptData.m` | Authenticate the server (validate keys) and decrypt |
| `NumericToBinary.m` / `BinaryToNumeric.m` | Convert byte arrays ↔ binary strings for transmission |
| `hex2bin.m` | Convert hexadecimal values to binary |
| `main_demo.m` | End-to-end demonstration |

## Data files (created when you run it)
- `ECDH_Keys.mat` — stored device & server key pairs
- `EncryptedData.mat` — encrypted output

## How authentication works
1. The device and server each generate an ECDH key pair.
2. They compute the same **shared secret** without ever sending their private keys
   (because `iotPriv·(serverPriv·G) = serverPriv·(iotPriv·G)`).
3. Data is encrypted/decrypted with a keystream derived from that shared secret.
4. If a **wrong private/public key** is supplied, key validation fails and
   authentication is rejected — protecting against impersonation and MITM attacks.

> Note: a small, demonstration-scale curve is used so all arithmetic stays exact in
> MATLAB. The protocol logic is identical to one built on a standard 256-bit curve.
