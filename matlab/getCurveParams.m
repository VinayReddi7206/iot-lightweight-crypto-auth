function [a, b, p, G] = getCurveParams()
% getCurveParams  Elliptic curve parameters used for the lightweight ECDH protocol.
%
%   The curve is:  y^2 = x^3 + a*x + b  (mod p)
%   A small, demonstration-scale curve is used so all arithmetic stays exact in
%   MATLAB double precision. Real deployments use a standardized 256-bit curve;
%   the protocol logic is identical - only the parameter sizes differ.
%
%   Returns:
%     a, b : curve coefficients
%     p    : prime field modulus
%     G    : base point [x y] (generator)

    a = 497;
    b = 1768;
    p = 9739;
    G = [1804, 5368];   % a generator point on the curve
end
