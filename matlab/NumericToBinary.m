function binStr = NumericToBinary(numArray)
% NumericToBinary  Convert a numeric array (0-255 bytes) into a binary string.
%
%   Each value becomes 8 bits; the results are concatenated. Useful for
%   representing encrypted output in a transmittable binary form.

    numArray = uint8(numArray);
    bits = dec2bin(numArray, 8);       % rows of 8-bit strings
    binStr = reshape(bits.', 1, []);   % concatenate row-wise into one string
end
