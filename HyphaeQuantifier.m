classdef HyphaeQuantifier < MqGuiManager
  
  methods
    
    function obj = HyphaeQuantifier(filename, varargin)
      
      obj@MqGuiManager(filename);
      
      obj.min_area_2 = 200;
      obj.max_area_2 = inf;
      obj.connectivity_2 = 4;
      obj.min_eccentricity = 0.5;
      obj.max_eccentricity = 1;
      
      obj.update_properties(varargin{:});
      
    end
  end
end