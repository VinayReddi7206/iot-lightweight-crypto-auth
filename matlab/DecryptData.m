function plainText = DecryptData(serverPrivIn, iotPubIn)
% DecryptData  Authenticate the server and decrypt the stored ciphertext.
%
%   Usage:  msg = DecryptData(serverPriv, iotPub)
%
%   Steps:
%     1. Load ECDH_Keys.mat and EncryptedData.mat.
%     2. AUTHENTICATE: validate the supplied server private key and IoT public
%        key against the stored keys. Wrong keys -> authentication fails.
%     3. Compute the ECDH shared secret (server private * IoT public).
%     4. Decrypt with decryptDataWithECDH and display the original data.

    S = load('ECDH_Keys.mat');
    E = load('EncryptedData.mat');   % encryptedData

    % ---- authentication ----
    validServer = isequal(serverPrivIn, S.serverPriv);
    validIot    = isequal(iotPubIn, S.iotPub);
    if ~(validServer && validIot)
        error('DecryptData:authFailed', ...
              'Authentication FAILED: invalid server private key or IoT public key.');
    end
    fprintf('Authentication SUCCESSFUL - keys validated.\n');

    % ---- ECDH shared secret + decryption ----
    sharedSecret = ComputeSharedSecret(S.serverPriv, S.iotPub);
    plainText    = decryptDataWithECDH(E.encryptedData, sharedSecret);

    fprintf('Decrypted data: %s\n', plainText);
end
