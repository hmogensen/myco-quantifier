function varargout = extract_struct_data(s, varargin)

argout = cell(size(varargin));

for i=1:length(varargin)
  argout(i) = {s.(varargin{i})};
end

varargout = argout;