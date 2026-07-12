function [privKey, pubKey] = generateECDHKeys()
% generateECDHKeys  Generate one ECDH key pair (private scalar + public point).
%
%   privKey : a random secret scalar
%   pubKey  : the public point = privKey * G  (a point [x y] on the curve)
%
%   Each IoT device and the server call this to get their own key pair.

    [a, ~, p, G] = getCurveParams();

    privKey = randi([2, p - 2]);      % secret scalar
    pubKey  = ec_mul(privKey, G, a, p);  % public point priv*G
end
