function plainText = decryptDataWithECDH(cipherBytes, sharedSecret)
% decryptDataWithECDH  Decrypt bytes produced by encryptDataWithECDH.
%
%   cipherBytes  : uint8 vector of encrypted bytes
%   sharedSecret : the ECDH shared secret (must match the encrypting side)
%   plainText    : recovered character array
%
%   The XOR stream cipher is symmetric, so decryption regenerates the same
%   keystream from the shared secret and XORs it back over the ciphertext.

    ks = keystream(sharedSecret, numel(cipherBytes));
    plainBytes = bitxor(uint8(cipherBytes), ks);
    plainText = char(plainBytes);
end

function ks = keystream(seed, n)
% Same deterministic keystream used by encryptDataWithECDH.
    ks = zeros(1, n, 'uint8');
    x = mod(round(seed), 2^20);
    for i = 1:n
        x = mod(1103515245 * x + 12345, 2^20);
        ks(i) = uint8(mod(x, 256));
    end
end
