classdef McHyphaeImage < McImage
  
  properties
  end
  
  methods
    function obj = McHyphaeImage(varargin)
      obj@McImage(varargin{1});
      
      obj.min_area_2 = 200;
      obj.max_area_2 = inf;
      obj.connectivity_2 = 4;
      obj.min_eccentricity = 0.5;
      obj.max_eccentricity = 1;
      
      obj.update_properties(varargin{2:end});
    end
  end
end