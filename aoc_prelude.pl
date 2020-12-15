% Useful stuff

%! read_input(-Lines:[String])
% Get the `input.txt` as a list of strings, filtering out any blank lines.
read_input(Lines) :- 
    % [] means no options
    read_file_to_string("input.txt", Input, []),
    split_string(Input, '\n', '', LinesWithEnd),
    % Exclude blank lines
    exclude(=(""), LinesWithEnd, Lines).