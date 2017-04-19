classdef MqGuiManager < MycoQuantifier
  
  properties
    
    main_figure
    
  end
  
  
  methods
    
    function obj = MqGuiManager(varargin)
      
      obj@MycoQuantifier(varargin{:});
      
    end
    
    function detect(obj)
      
      detect@MycoQuantifier(obj);
      
      obj.main_figure = get_current_fig();
      
    end
    
    
    function add_detection_area(obj)
      
      h_polygon = impoly();
      
      if ~isempty(h_polygon)
        obj.detection_areas = [obj.detection_areas; h_polygon];
        set(h_polygon, 'DeleteFcn', @(polygon, ~) obj.rm_detection_area(polygon))
      end
      
    end
    
    
    function add_rejection_area(obj)
      
      h_polygon = impoly();
      
      if ~isempty(h_polygon)
        obj.rejection_areas = [obj.rejection_areas; h_polygon];
        set(h_polygon, 'DeleteFcn', @(polygon, ~) obj.rm_rejection_area(polygon))
      end
      
    end
    
    
    function add_ignore_area(obj)
      
      h_polygon = impoly();
      
      if ~isempty(h_polygon)
        obj.ignore_areas = [obj.ignore_areas; h_polygon];
        set(h_polygon, 'DeleteFcn', @(polygon, ~) obj.rm_ignore_area(polygon))

      end
      
    end
    
    
    function rm_detection_area(obj, polygon)
      
      indx = arrayfun(@(x) MqGuiManager.has_identical_children(x, polygon), ...
        obj.detection_areas);
      obj.detection_areas(indx) = [];
      
    end
    
    function rm_rejection_area(obj, polygon)
      
      indx = arrayfun(@(x) MqGuiManager.has_identical_children(x, polygon), ...
        obj.rejection_areas);
      obj.rejection_areas(indx) = [];
      
    end
    
    
    function rm_ignore_area(obj, polygon)
      
      indx = arrayfun(@(x) MqGuiManager.has_identical_children(x, polygon), ...
        obj.ignore_areas);
      obj.ignore_areas(indx) = [];
      
    end
    
  end
  
  methods (Static)
    
    function val = has_identical_children(s1, s2)
      c1 = get(s1, 'Children');
      c2 = get(s2, 'Children');
      
      if length(c1) ~= length(c2)
        val = false;
      else
        for i=1:length(c1)
          if ~any(c1(i) == c2)
            val = false;
            return
          end
        end
        val = true;
      end
    end
  end
  
end