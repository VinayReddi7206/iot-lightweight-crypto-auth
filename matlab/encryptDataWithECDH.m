function cipherBytes = encryptDataWithECDH(plainText, sharedSecret)
% encryptDataWithECDH  Encrypt text using a keystream derived from the ECDH
%                      shared secret (a lightweight XOR stream cipher).
%
%   plainText    : character array to encrypt
%   sharedSecret : the ECDH shared secret (from ComputeSharedSecret)
%   cipherBytes  : uint8 vector of encrypted bytes
%
%   A deterministic keystream is generated from the shared secret and XOR-ed
%   with the plaintext bytes. Only a party holding the same shared secret can
%   reproduce the keystream and recover the data.

    dataBytes = uint8(plainText);
    ks = keystream(sharedSecret, numel(dataBytes));
    cipherBytes = bitxor(dataBytes, ks);
end

function ks = keystream(seed, n)
% Deterministic byte keystream from a numeric seed (linear congruential PRNG).
    ks = zeros(1, n, 'uint8');
    x = mod(round(seed), 2^20);
    for i = 1:n
        x = mod(1103515245 * x + 12345, 2^20);   % stays exact in double precision
        ks(i) = uint8(mod(x, 256));
    end
end
