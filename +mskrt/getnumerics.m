function numerics = getnumerics(S)
    %GETNUMERICS Obtain numeric values from input structure array
    %   getnumerics(S) returns a structure array of numeric values
    %   extracted from the structure array S.  If the value associated
    %   with a field of S is of type character or string, an attempt
    %   is be made to convert this to a numeric type.

    import mskrt.istext

    numerics = struct;

    names = fieldnames(S);
    for idx = 1:numel(names)
        parameter = names{idx};
        if istext(S.(parameter))
            value = str2num(S.(parameter));
            if ~isempty(value)
                numerics.(parameter) = value;
            end
        elseif isnumeric(S.(parameter))
            numerics.(parameter) = S.(parameter);
        end
    end
end

