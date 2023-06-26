function [text] = istext(A)
%ISTEXT Determine whether input is a character array or string scalar
%    ISTEXT(A) returns 1 (true) if A is a character array or string scalar,
%    and 0 (false) otherwise.
text = (ischar(A) || isStringScalar(A));
end