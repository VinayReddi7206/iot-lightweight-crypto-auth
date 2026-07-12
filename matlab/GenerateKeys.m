function GenerateKeys()
% GenerateKeys  Generate ECDH key pairs for the IoT device and the server,
%               and store them in ECDH_Keys.mat for the encrypt/decrypt scripts.
%
%   This provides a single interface for key generation and can be extended to
%   other key types in future. Run this once before EncryptData / DecryptData.

    [iotPriv, iotPub]       = generateECDHKeys();   % IoT device key pair
    [serverPriv, serverPub] = generateECDHKeys();   % server key pair

    save('ECDH_Keys.mat', 'iotPriv', 'iotPub', 'serverPriv', 'serverPub');

    fprintf('Keys generated and saved to ECDH_Keys.mat\n');
    fprintf('  IoT    public key : (%d, %d)\n', iotPub(1), iotPub(2));
    fprintf('  Server public key : (%d, %d)\n', serverPub(1), serverPub(2));
end
