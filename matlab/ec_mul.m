function R = ec_mul(k, P, a, p)
% ec_mul  Elliptic-curve scalar multiplication:  R = k * P  (mod p).
%
%   Uses the double-and-add algorithm. This is the core operation of ECDH:
%   a public key is priv*G, and a shared secret is priv*(peer public key).
%
%   The point at infinity (identity element) is represented as [].

    R = [];          % start at the point at infinity
    addend = P;
    while k > 0
        if mod(k, 2) == 1
            R = ec_add(R, addend, a, p);
        end
        addend = ec_add(addend, addend, a, p);
        k = floor(k / 2);
    end
end

% ---- local helper functions (used only inside this file) ----

function R = ec_add(P, Q, a, p)
% Point addition on the curve y^2 = x^3 + a*x + b (mod p).
    if isempty(P), R = Q; return; end
    if isempty(Q), R = P; return; end

    x1 = P(1); y1 = P(2);
    x2 = Q(1); y2 = Q(2);

    % P + (-P) = point at infinity
    if x1 == x2 && mod(y1 + y2, p) == 0
        R = [];
        return;
    end

    if x1 == x2 && y1 == y2
        % point doubling
        m = mod((3 * x1^2 + a) * mod_inv(mod(2 * y1, p), p), p);
    else
        % general addition
        m = mod((y2 - y1) * mod_inv(mod(x2 - x1, p), p), p);
    end

    x3 = mod(m^2 - x1 - x2, p);
    y3 = mod(m * (x1 - x3) - y1, p);
    R = [x3, y3];
end

function inv = mod_inv(v, m)
% Modular inverse of v (mod m) via the extended Euclidean algorithm.
    v = mod(v, m);
    old_r = v; r = m;
    old_s = 1; s = 0;
    while r ~= 0
        q = floor(old_r / r);
        [old_r, r] = deal(r, old_r - q * r);
        [old_s, s] = deal(s, old_s - q * s);
    end
    inv = mod(old_s, m);
end
