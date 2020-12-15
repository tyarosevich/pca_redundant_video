% Plot check
clc; clear all; close all
point_list = readmatrix('coords1_3.csv')
figure(1)
axis([0 640 0 480])
test_plot = plot(point_list(1,1), point_list(1,2));
for t = 1:length(point_list(:,1))
    figure(1)
    axis([0 640 0 480])
    hold on
    p = plot(point_list(t,1), point_list(t,2),'o');
    pause(0.05)
    delete(p)
end