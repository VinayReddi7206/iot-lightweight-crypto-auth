function numArray = BinaryToNumeric(binStr)
% BinaryToNumeric  Convert a binary string back into a numeric byte array.
%
%   The input length must be a multiple of 8. Includes basic validation so
%   malformed binary input raises a clear error.

    binStr = binStr(~isspace(binStr));           % ignore any spaces
    if mod(numel(binStr), 8) ~= 0
        error('BinaryToNumeric:badLength', ...
              'Binary string length must be a multiple of 8.');
    end
    if any(binStr ~= '0' & binStr ~= '1')
        error('BinaryToNumeric:badChar', ...
              'Binary string may only contain 0 and 1.');
    end

    rows = reshape(binStr, 8, []).';   % each row = one byte
    numArray = uint8(bin2dec(rows)).';
end
