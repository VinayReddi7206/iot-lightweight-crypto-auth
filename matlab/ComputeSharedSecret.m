function secret = ComputeSharedSecret(myPriv, peerPub)
% ComputeSharedSecret  Compute the ECDH shared secret.
%
%   secret = x-coordinate of (myPriv * peerPub)
%
%   Because  iotPriv*(serverPriv*G) == serverPriv*(iotPriv*G),  the IoT device
%   and the server independently arrive at the SAME shared secret without ever
%   transmitting their private keys. This shared secret is then used as the
%   symmetric key for encrypting and decrypting data.

    [a, ~, p, ~] = getCurveParams();

    S = ec_mul(myPriv, peerPub, a, p);
    if isempty(S)
        error('ComputeSharedSecret:infinity', 'Invalid shared point (identity).');
    end
    secret = S(1);   % use the x-coordinate as the shared secret
end
