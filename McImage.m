classdef McImage < handle
  
  properties
    
    filename
    xmin = 1
    xmax = inf
    ymin = 1
    ymax = inf
    disksize = 10
    min_area_1 = 10
    connectivity_1 = 4
    connectivity_2 = 8
    min_area_2 = 30
    max_area_2 = 200
    min_eccentricity = 0;
    max_eccentricity = .9
    
  end
  
  methods
    function obj = McImage(filename, varargin)
      
      obj.filename = filename;
      obj.update_properties(varargin{:});
    end
    
    function update_properties(obj, varargin)
      for i=1:2:length(varargin)
        obj.(varargin{i}) = varargin{i+1};
      end
    end
  end
end