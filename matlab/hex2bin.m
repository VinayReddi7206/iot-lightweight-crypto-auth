function binStr = hex2bin(hexStr)
% hex2bin  Convert a hexadecimal string into a binary string.
%
%   Some crypto workflows output keys or data in hexadecimal; this converts
%   those hex values into a binary representation (4 bits per hex digit).

    hexStr = hexStr(~isspace(hexStr));
    bits = dec2bin(hex2dec(hexStr(:)), 4);   % 4 bits per hex digit
    binStr = reshape(bits.', 1, []);
end
