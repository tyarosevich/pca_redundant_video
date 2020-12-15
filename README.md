[![Ask Me Anything !](https://img.shields.io/badge/Ask%20me-anything-1abc9c.svg)](https://GitHub.com/Naereen/ama)
# Image Tracking and Principal Component Analysis of Redundant Video
This project analyzes noisy video of an oscillating paint can in order to expose the usage and capabilities of PCA. [Here](https://github.com/tyarosevich/pca_redundant_video/blob/master/Final%20Presentation%20for%20Github/pca_of_redundant_vid_pres.pdf) is a linke to a presentation covering the project, it's methods, and background.

# Motivation
This project was completed for a graduate level course in Scientific Computing at the University of Washington's Applied Mathematics department.

# Framework
MATLAB - 2019

# Figure Examples
These figures show variance of the singular values across data, from very little noise (Part 1) to very very noisy, with rotation, lateral movement, and camera shake in Part 4. The figure on the right shows Part 4's Principal Modes, which reveal the oscillation in the principal mode directions.


![Principal Component Variance across Sample Types](1_to_4_compare.jpg)
![Principal Modes Showing Oscillation and Rotation](part4_v.jpg)

# Code Example
```
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
```