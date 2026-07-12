function EncryptData(inputData, iotPrivIn, serverPubIn)
% EncryptData  Authenticate the IoT device and encrypt its data with ECDH.
%
%   Usage:  EncryptData('temperature=24.7', iotPriv, serverPub)
%
%   Steps:
%     1. Load the stored key pairs from ECDH_Keys.mat.
%     2. AUTHENTICATE: validate the supplied IoT private key and server public
%        key against the stored keys. Wrong keys -> authentication fails.
%     3. Compute the ECDH shared secret (IoT private * server public).
%     4. Encrypt the data with encryptDataWithECDH and save EncryptedData.mat.

    S = load('ECDH_Keys.mat');   % iotPriv, iotPub, serverPriv, serverPub

    % ---- authentication: keys must match the provisioned key pairs ----
    validIot    = isequal(iotPrivIn, S.iotPriv);
    validServer = isequal(serverPubIn, S.serverPub);
    if ~(validIot && validServer)
        error('EncryptData:authFailed', ...
              'Authentication FAILED: invalid IoT private key or server public key.');
    end
    fprintf('Authentication SUCCESSFUL - keys validated.\n');

    % ---- ECDH shared secret + encryption ----
    sharedSecret  = ComputeSharedSecret(S.iotPriv, S.serverPub);
    encryptedData = encryptDataWithECDH(inputData, sharedSecret);

    save('EncryptedData.mat', 'encryptedData');
    fprintf('Data encrypted and saved to EncryptedData.mat\n');
    fprintf('Ciphertext (hex): %s\n', sprintf('%02x', encryptedData));
end
