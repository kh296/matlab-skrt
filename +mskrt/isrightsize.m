function [rightsize] = isrightsize(A, varargin)
    %ISRIGHTSIZE Determine whether input is a numeric array of required size
    %
    %   ISRIGHTSIZE(A) returns 1 (true) if A is a numeric array
    %   of size [1, 1].
    %   ISRIGHTSIZE(A, nrow) returns 1 (true) if A is a numeric array
    %   of size [nrow, 1].
    %   ISRIGHTSIZE(A, nrow, ncol) returns 1 (true) if A is a numeric array
    %   of size [nrow, ncol].

    import mskrt.istext

    % Set numbers of rows and columns.
    p = inputParser;
    addOptional(p, 'nrow', 1, @isscalar);
    addOptional(p, 'ncol', 1, @isscalar);
    parse(p, varargin{:});

    % Convert to numeric array if input is a character array or string scalar.
    if istext(A)
        A = str2num(A);
    end

    rightsize = (isnumeric(A) && all(size(A) == ...
        [p.Results.nrow, p.Results.ncol]));
end
