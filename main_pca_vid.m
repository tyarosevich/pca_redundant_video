%% ***HW 3 ***
clc; clear all; close all;
% *** Part 1 ***

% This code loads all the matlab video files and 
% exports them as .avi files to use the computer Vision
% package

load_format = 'cam%d_%d';
% no use this in the loop load_output = sprintf(load_format, i, j);
mat_format = 'vidFrames%d_%d';
% again use this in loop mat_output = sprintf(mat_format, i, j)
output_format = 'cam%d_%d';
for i = 1:4
    for j = 1:4
        load(sprintf(load_format, i, j))
        v = VideoWriter(sprintf(output_format, i, j));
        open(v)
        writeVideo(v, eval(sprintf(mat_format, i, j)));
        close(v)
    end
end

%% Capture the Region To be Tracked
clc; clear all; close all
videoFileReader = vision.VideoFileReader('cam2_4.avi');
videoPlayer  = vision.VideoPlayer('Position', [100, 100, 680, 520]);

objectFrame = videoFileReader();

figure;
imshow(objectFrame);
objectRegion = round(getPosition(imrect));
%% Display the Object Frame with a red box
objectImage = insertShape(objectFrame,'Rectangle',objectRegion,'Color','red');
figure;
imshow(objectImage);
title('Red box shows object region');
%% Detect Points of Interest
points = detectMinEigenFeatures(rgb2gray(objectFrame),'ROI',objectRegion);
pointImage = insertMarker(objectFrame,points.Location,'+','Color','white');
figure;
imshow(pointImage);
title('Detected interest points');

%% Iterate through the data and capture the points

% Create The Tracker Object
tracker = vision.PointTracker('MaxBidirectionalError',50, 'MaxIterations', 100);
% Initialize the object
initialize(tracker,points.Location,objectFrame);
point_list = [];
count = 1;
while ~isDone(videoFileReader)
      count = count + 1
      frame = videoFileReader();
      [points,validity] = tracker(frame);
      out = insertMarker(frame,points(validity, :),'+');
      videoPlayer(out);
      if mod(count, 2) == 1
          x_ave = mean(points(:,1));
          y_ave = mean(points(:,2));
          point_list = [point_list; [x_ave y_ave]];
      end
end

%% Plot to check the result
close all
    figure(1)
    axis([0 640 0 480])
test_plot = plot(point_list(1,1), 480 - point_list(1,2));
for t = 1:length(point_list(:,1))
    figure(1)
    axis([0 640 0 480])
    hold on
    p = plot(point_list(t,1), 480 - point_list(t,2),'o');
    pause(0.02)
    delete(p)
end

%% Write out to a file
writematrix(point_list, 'coords2_2.csv')

%% Manual Capture For Problematic Videos
% I manually processed 1_4, 2_4, 3_4
clc; clear all; close all

load cam1_4
count = 1;
point_list = [];
t_length = size(vidFrames1_4);
for i = 1:t_length(4)
    count = count + 1;
    if mod(count, 2) == 1

        figure()
        imshow(vidFrames1_4(:,:,:,i)), title('Click a consistent spot')
        [x, y] = ginput(1);
        point_list = [point_list; [x y]];
        close all
    end
    
end

%% Plot to check data
close all
    figure(1)
    axis([0 640 0 480])
test_plot = plot(point_list(1,1), point_list(1,2));
for t = 1:length(point_list(:,1))
    figure(1)
    axis([0 640 0 480])
    hold on
    p = plot(point_list(t,1), point_list(t,2),'o');
    pause(0.02)
    delete(p)
end
%% Write to csv
writematrix(point_list, 'coords1_4_manual.csv')

%%
count = 1;
new_list = []
for i = 1:356
    count = count +1;
    if mod(count,2) == 1
     new_list = [new_list; point_list(i, :)];   
    end
    
end


%% Process all videos and store all the data
clc; clear all; close all
% Cell array of all position data. 1-4 is part 1,
% 5-8 part 2 etc.
master_data_list = cell(16, 1);

% Formats for sprintf calls
load_format = 'cam%d_%d';
% no use this in the loop load_output = sprintf(load_format, i, j);
mat_format = 'vidFrames%d_%d';
% again use this in loop mat_output = sprintf(mat_format, i, j)
output_format = 'cam%d_%d.avi';

% Outer loop iterates through each part of the HW, i.e. i = 1
% corresponds to part 1.
index = 0;
for i = 1:4
    index = index + 1;
    % Inner loop iterates through each camera
    for j = 1:4
        videoFileReader = vision.VideoFileReader(sprintf(output_format, i, j));
        videoPlayer  = vision.VideoPlayer('Position', [100, 100, 680, 520]);

        objectFrame = videoFileReader();
           
        % Capture a box in which to track an object
        figure('units','normalized','outerposition',[0 0 1 1]);
        imshow(objectFrame);
        title('Please draw a box around the object')
        objectRegion = round(getPosition(imrect)); 
        close all
        
        objectImage = insertShape(objectFrame,'Rectangle',objectRegion,'Color','red');
        figure;
        imshow(objectImage);
        title('Red box shows object region');
        pause
        
        close all
        points = detectMinEigenFeatures(rgb2gray(objectFrame),'ROI',objectRegion);
        pointImage = insertMarker(objectFrame,points.Location,'+','Color','white');
        figure;
        imshow(pointImage);
        title('Detected interest points');
        close all
        
        % Create The Tracker Object
        tracker = vision.PointTracker('MaxBidirectionalError',1);
        % Initialize the object
        initialize(tracker,points.Location,objectFrame);
        point_list = [];

        while ~isDone(videoFileReader)
              frame = videoFileReader();
              [points,validity] = tracker(frame);
              point_list = [point_list; points];
        end
        master_data_list{index} = point_list;
    end
end