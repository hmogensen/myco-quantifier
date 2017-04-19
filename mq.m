clc
clear
sc_clf_all

filename = 'DSC_0611.JPG';%'Untitled (1).png';

h_mq = HyphaeQuantifier(filename, 'lower_threshold', .5);%MycoQuantifier(filename);

h_mq.detect();


return

img = McHyphaeImage(filename);

[xmin, xmax, ymin, ymax, disksize, min_area_1, connectivity_1, ...
  connectivity_2, min_area_2, max_area_2, min_eccentricity, max_eccentricity] = ...
  extract_struct_data(img, 'xmin', 'xmax', 'ymin', 'ymax', 'disksize', 'min_area_1', 'connectivity_1', ...
  'connectivity_2', 'min_area_2', 'max_area_2', 'min_eccentricity', 'max_eccentricity');

m1 = imread(filename);
incr_fig_indx();
imshow(m1);

dim = size(m1);
indx = xmin:min(dim(1), xmax);
indy = ymin:min(dim(2), ymax);
m2 = m1(indx, indy, :);
incr_fig_indx();
imshow(m2);

m3 = rgb2gray(m2);
incr_fig_indx();
imshow(m3);

m4 = m3 - imopen(m3, strel('disk', disksize));
incr_fig_indx();
imshow(m4);

m5 = imadjust(m4);
incr_fig_indx();
imshow(m5);

m6 = imbinarize(m5);
incr_fig_indx();
imshow(m6);

m7 = bwareaopen(m6, min_area_1, connectivity_1);
incr_fig_indx();
imshow(m7)

components = bwconncomp(m7, connectivity_2);
tmp_area = regionprops(components, 'Area');
area = cell2mat({tmp_area.Area});
ind = area >= min_area_2 & area <= max_area_2;

tmp_ecc = regionprops(components, 'Eccentricity');
ecc = cell2mat({tmp_ecc.Eccentricity});
ind = ind & ecc >= min_eccentricity & ecc <= max_eccentricity;

detected_bacteria = components.PixelIdxList(ind);

m8 = m2;
for i=1:length(detected_bacteria)
  fprintf('%d / %d\n', i, length(detected_bacteria));
  [row, col] = ind2sub(size(m3), detected_bacteria{i});
  
  for j=1:numel(row)
    m8(row(j), col(j), :) = [0 255 0];
  end
end

incr_fig_indx();
imshow(m8);