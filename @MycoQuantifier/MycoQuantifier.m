classdef MycoQuantifier < handle
  
  properties
    
    img
    raw_img
    h_img
    components
    detection_areas
    rejection_areas
    ignore_areas
    
  end
  
  properties
    
    filename
    xmin = 1
    xmax = inf
    ymin = 1
    ymax = inf
    disksize = 10
    lower_threshold = 0
    upper_threshold = 1
    min_area_1 = 10
    connectivity_1 = 4
    connectivity_2 = 8
    min_area_2 = 30
    max_area_2 = 200
    min_eccentricity = 0;
    max_eccentricity = .9
    
  end
  
  methods
    
    function obj = MycoQuantifier(filename, varargin)
      
      obj.filename = filename;
      
      obj.update_properties(varargin{:});
      
    end
    
    
    function detect(obj)
      
      reset_fig_indx();
      
      obj.read_img();
      incr_fig_indx();
      obj.update();
      title('Original')
      
      obj.crop_image();
      incr_fig_indx();
      obj.update();
      title('Cropped');
      
      obj.convert_to_gray();
      incr_fig_indx();
      obj.update();
      title('Gray-scale')
      
      obj.rm_background();
      incr_fig_indx();
      obj.update();
      title('Background removed');
      
      obj.adjust_img();
      incr_fig_indx();
      obj.update();
      title('Adjusted');
      
      obj.threshold_img();
      incr_fig_indx();
      obj.update();
      title('Thresholded');
      
      obj.make_binary();
      incr_fig_indx();
      obj.update();
      title('Binarized');
      
      obj.filter_connectivity();
      incr_fig_indx();
      obj.update();
      title('Connectivity filtered')
            
      obj.detect_objects();
      incr_fig_indx();
      obj.update();
      title('Final result')
      
    end
    
    function read_img(obj)
      
      obj.img = imread(obj.filename);
      obj.raw_img = obj.img;
      
    end
    
    
    function crop_image(obj)
      
      dim = size(obj.img);
      indx = obj.xmin:min(dim(1), obj.xmax);
      indy = obj.ymin:min(dim(2), obj.ymax);
      
      obj.img = obj.img(indx, indy, :);
      
    end
    
    
    function convert_to_gray(obj)
      
      obj.img = rgb2gray(obj.img);
      
    end
    
    
    function rm_background(obj)
      
      obj.img = obj.img - imopen(obj.img, strel('disk', obj.disksize));
      
    end
    
    
    function adjust_img(obj)
      
      obj.img = imadjust(obj.img);
      
    end
    
    
    function threshold_img(obj)
      
      min_val = min(obj.img(:));
      max_val = max(obj.img(:));
      
      under_threshold = obj.img < min_val + ...
        obj.lower_threshold*(max_val-min_val); 
      above_threshold = obj.img > min_val + ...
        obj.upper_threshold*(max_val-min_val); 
      
      obj.img(under_threshold) = min_val;
      obj.img(above_threshold) = max_val;
      
    end
    
      
    function make_binary(obj)
      
      obj.img = imbinarize(obj.img);
      
    end
    
    
    function filter_connectivity(obj)
      
      obj.img = bwareaopen(obj.img, obj.min_area_1, obj.connectivity_1);
      
    end
    
    
    function detect_objects(obj)
      
      obj.components = bwconncomp(obj.img, obj.connectivity_2);
      
      tmp_area = regionprops(obj.components, 'Area');
      area = cell2mat({tmp_area.Area});
      ind = area >= obj.min_area_2 & area <= obj.max_area_2;
      
      tmp_ecc = regionprops(obj.components, 'Eccentricity');
      ecc = cell2mat({tmp_ecc.Eccentricity});
      ind = ind & ecc >= obj.min_eccentricity & ecc <= obj.max_eccentricity;
      
      detected_bacteria = obj.components.PixelIdxList(ind);
      
      dim = size(obj.img);
      obj.img = obj.raw_img;
      
      for i=1:length(detected_bacteria)
        fprintf('%d / %d\n', i, length(detected_bacteria));
        [row, col] = ind2sub(dim, detected_bacteria{i});
        
        for j=1:numel(row)
          obj.img(row(j), col(j), :) = [0 255 0];
        end
      end
      
    end
    
    
    function update(obj)

      obj.h_img = imshow(obj.img);
      
    end
    
    
    function update_properties(obj, varargin)
      
      for i=1:2:length(varargin)
        obj.(varargin{i}) = varargin{i+1};
      end
      
    end
    
  end
  
end