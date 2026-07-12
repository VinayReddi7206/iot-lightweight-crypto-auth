% main_demo.m  End-to-end demonstration of the lightweight ECDH authentication
%              protocol for IoT devices. Run this file in MATLAB.
%
%   Flow:
%     1. Generate ECDH key pairs for the IoT device and the server.
%     2. Successful case  - correct keys authenticate and encrypt/decrypt data.
%     3. Unsuccessful case - a wrong key fails authentication (as in the report).
%     4. Performance       - measure encryption/decryption execution time.

clc; clear;

fprintf('=== Lightweight Cryptographic Protocol for IoT Device Authentication ===\n\n');

% ---- 1. Key generation ----
GenerateKeys();
S = load('ECDH_Keys.mat');
fprintf('\n');

% ---- 2. Successful authentication + encryption/decryption ----
fprintf('--- Successful Authentication ---\n');
message = 'temperature=24.7C; humidity=60%';
tEnc = tic;
EncryptData(message, S.iotPriv, S.serverPub);
encTime = toc(tEnc);

tDec = tic;
recovered = DecryptData(S.serverPriv, S.iotPub);
decTime = toc(tDec);

fprintf('Original : %s\n', message);
fprintf('Recovered: %s\n', recovered);
fprintf('Match    : %d\n\n', strcmp(message, recovered));

% ---- 3. Unsuccessful authentication (wrong key) ----
fprintf('--- Unsuccessful Authentication (wrong key) ---\n');
try
    wrongPriv = S.iotPriv + 1;   % tampered / incorrect private key
    EncryptData(message, wrongPriv, S.serverPub);
catch err
    fprintf('%s\n\n', err.message);
end

% ---- 4. Performance ----
fprintf('--- Performance ---\n');
fprintf('Encryption time: %.6f s\n', encTime);
fprintf('Decryption time: %.6f s\n', decTime);
