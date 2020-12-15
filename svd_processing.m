%% HW 3 SVD an Analysis

% Process the computer vision captured values by converting
% the y-coords. They have to be changed from y to 480 - y.
clc; clear all; close all
load_format = 'coords%d_%d';

% The master_data_mat matrix will be organized like the two columns of:
% 1_1 2_1 3_1 1_2 2_2 3_2 1_3 2_3 3_3 1_4 2_4 3_4
master_data_mat = {};
count = 0;
for j = 1:4
    for i = 1:3
        count = count + 1;
        
        % Switch the y-matrix from pixel form to 
        % standard y coordinates due to imshow() function.
        mat = readmatrix(sprintf(load_format, i, j));
        mat = [mat(:,1) 480 - mat(:,2)];
        master_data_mat{1,count} = mat;
            
    end
end
%% Part 1 Processing. 
% Start each position vector at the bottom of the trajectory. For 1_1, 2_1
% this means a y min, and for 3_1 an x_max
mat = master_data_mat{1};
mat = mat(14:end,:);
master_data_mat{1,1} = mat;

mat = master_data_mat{2};
mat = mat(19:end,:);
master_data_mat{1,2} = mat;

mat = master_data_mat{3};
mat = mat(14:end,:);
master_data_mat{1,3} = mat;


%% Chop off the end to make them all the same lengths
for i = 1:3
   mat = master_data_mat{i};
   mat = mat(1:98, :);
   master_data_mat{1, i} = mat;
end
%% Part 2 Processing
mat = master_data_mat{4};
mat = mat(6:end,:);
master_data_mat{1,4} = mat;

mat = master_data_mat{5};
mat = mat(17:end,:);
master_data_mat{1,5} = mat;

mat = master_data_mat{6};
mat = mat(7:end,:);
master_data_mat{1,6} = mat;
%% Chop off ends

for i = 4:6
   mat = master_data_mat{i};
   mat = mat(1:99, :);
   master_data_mat{1, i} = mat;
end

%% Part 3 Processing
mat = master_data_mat{7};
mat = mat(8:end,:);
master_data_mat{1,7} = mat;

mat = master_data_mat{8};
mat = mat(22:end,:);
master_data_mat{1,8} = mat;

mat = master_data_mat{9};
mat = mat(1:end,:);
master_data_mat{1,9} = mat;
%% Chop off ends

for i = 7:9
   mat = master_data_mat{i};
   mat = mat(1:112, :);
   master_data_mat{1, i} = mat;
end

%% Part 4 Processing
mat = master_data_mat{10};
mat = mat(16:end,:);
master_data_mat{1,10} = mat;

mat = master_data_mat{11};
mat = mat(20:end,:);
master_data_mat{1,11} = mat;

mat = master_data_mat{12};
mat = mat(17:end,:);
master_data_mat{1,12} = mat;
%% Chop off ends

for i = 10:12
   mat = master_data_mat{i};
   mat = mat(1:180, :);
   master_data_mat{1, i} = mat;
end

%% To do: loop through the cell list and subtract the average from each measurement vector.

for i = 1:12
   A = master_data_mat{i};
   A(:,1) = A(:,1) - mean(A(:,1));
   A(:,2) = A(:,2) - mean(A(:,2));
   master_data_mat{1,i} = A;
end

% %% Section for plotting to check orientations
% 
% point_list = master_data_mat{1};
% figure(1)
% axis([0 640 0 480])
% test_plot = plot(point_list(1,1), point_list(1,2));
% for t = 1:length(point_list(:,1))
%     figure(1)
%     axis([0 640 0 480])
%     hold on
%     p = plot(point_list(t,1), point_list(t,2),'o');
%     pause(0.05)
%     delete(p)
% end
%% Part 1 Analysis

A1 = [master_data_mat{1}';
      master_data_mat{2}';
      master_data_mat{3}'];
[U1, S1, V1] = svd(A1);
sig = diag(S1);

% Calculate time-step of each data point. The .avi files are all 30 FPS
% and I used every other frame, so each data point represents 1/15 seconds.
t = (1/15)*(1:length(A1(1,:)));
% energy and log energy plots
figure(1)
subplot(1,2,1)
plot((sig / sum(sig)) * 100,'o', 'MarkerFaceColor', 'b')
xlabel('$\sigma_i$', 'Interpreter', 'latex')
ylabel('% of total energy')
set(gca, 'Fontsize', [10])
axis('square')
subplot(1,2,2)
semilogy((sig / sum(sig)) * 100,'o', 'MarkerFaceColor', 'b')
xlabel('$\sigma_i$', 'Interpreter', 'latex')
ylabel('Log of total energy')
set(gca, 'Fontsize', [10])
axis('square')
sgtitle('Percentage of total energy in each $\sigma$', 'interpreter', 'latex')

e_1 = sig(1)/sum(sig); e_2 = sum(sig(1:2)) / sum(sig); e_3 = sum(sig(1:3))/sum(sig);
e_list1 = [e_1; e_2; e_3];

% project onto U
Y1_U = U1.'*A1;
% Plot result
figure(2)
plot(t, Y1_U(1,:), t, Y1_U(2,:), t, Y1_U(3,:))
xlabel('time(seconds)', 'Interpreter', 'latex')
legend('mode 1', 'mode 2', 'mode 3', 'Location', 'NorthEast')
set(gca, 'Fontsize', [15])
title('Projection of $\sigma_i$ onto $u_i$', 'interpreter', 'latex')

% Spatial Modes
figure(3)
x = 1:6;
plot(x, U1(:,1),'-', x, U1(:,2),'--', x, U1(:,3), ':', 'linewidth', 1.5)
xlabel('$\sigma_i$', 'Interpreter', 'latex')
legend('mode 1', 'mode 2', 'mode 3', 'Location', 'NorthEast')
set(gca, 'Fontsize', [15])
title('Linear POD modes', 'interpreter', 'latex')

% Time Behavior
figure(4)
plot(t, V1(:,1), '-', t, V1(:,2),'--', t, V1(:,3),':', 'linewidth', 1.5)
xlabel('time(t)', 'Interpreter', 'latex')
legend('mode 1', 'mode 2', 'mode 3', 'Location', 'NorthEast')
set(gca, 'Fontsize', [15])
title('Behavior of POD modes in time', 'interpreter', 'latex')


%% Part 2 Analysis
close all
A2 = [master_data_mat{4}';
      master_data_mat{5}';
      master_data_mat{6}'];
[U2, S2, V2] = svd(A2);
sig = diag(S2);
t = (1/15)*(1:length(A2(1,:)));

% energy and log energy plots
figure(1)
subplot(1,2,1)
plot((sig / sum(sig)) * 100,'o', 'MarkerFaceColor', 'b')
xlabel('$\sigma_n$', 'Interpreter', 'latex')
ylabel('% of total energy')
set(gca, 'Fontsize', [10])
axis('square')
subplot(1,2,2)
semilogy((sig / sum(sig)) * 100,'o', 'MarkerFaceColor', 'b')
xlabel('$\sigma_n$', 'Interpreter', 'latex')
ylabel('Log of total energy')
set(gca, 'Fontsize', [10])
axis('square')


e_1 = sig(1)/sum(sig); e_2 = sum(sig(1:2)) / sum(sig); e_3 = sum(sig(1:3))/sum(sig);
e_list2 = [e_1; e_2; e_3];

% project onto U
Y2_U = U2.'*A2;
% Plot result
figure(2)
plot(t, Y2_U(1,:), t, Y2_U(2,:), t, Y2_U(3,:))
xlabel('time(seconds)', 'Interpreter', 'latex')
legend('mode 1', 'mode 2', 'mode 3', 'Location', 'NorthEast')
set(gca, 'Fontsize', [15])

% Spatial Modes
figure(3)
x = 1:6;
plot(x, U2(:,1),'-', x, U2(:,2),'--', x, U2(:,3), ':', 'linewidth', 1.5)
xlabel('$\sigma_n$', 'Interpreter', 'latex')
legend('mode 1', 'mode 2', 'mode 3', 'Location', 'NorthEast')
set(gca, 'Fontsize', [15])

% Time Behavior
figure(4)
plot(t, V2(:,1), '-', t, V2(:,2),'--', t, V2(:,3),':', 'linewidth', 1.5)
xlabel('$\sigma_n$', 'Interpreter', 'latex')
legend('mode 1', 'mode 2', 'mode 3', 'Location', 'NorthEast')
set(gca, 'Fontsize', [15])

%% Part 3 Analysis

A3 = [master_data_mat{7}';
      master_data_mat{8}';
      master_data_mat{9}'];
[U3, S3, V3] = svd(A3);
sig = diag(S3);
t = (1/15)*(1:length(A3(1,:)));

% energy and log energy plots
figure(1)
subplot(1,2,1)
plot((sig / sum(sig)) * 100,'o', 'MarkerFaceColor', 'b')
xlabel('$\sigma_n$', 'Interpreter', 'latex')
ylabel('% of total energy')
set(gca, 'Fontsize', [10])
axis('square')
subplot(1,2,2)
semilogy((sig / sum(sig)) * 100,'o', 'MarkerFaceColor', 'b')
xlabel('$\sigma_n$', 'Interpreter', 'latex')
ylabel('Log of total energy')
set(gca, 'Fontsize', [10])
axis('square')


e_1 = sig(1)/sum(sig); e_2 = sum(sig(1:2)) / sum(sig); e_3 = sum(sig(1:3))/sum(sig);
e_list3 = [e_1; e_2; e_3];

% project onto U
Y3_U = U3.'*A3;
% Plot result
figure(2)
plot(t, Y3_U(1,:), t, Y3_U(2,:), t, Y3_U(3,:))
xlabel('time(seconds)', 'Interpreter', 'latex')
legend('mode 1', 'mode 2', 'mode 3', 'Location', 'NorthEast')
set(gca, 'Fontsize', [15])

% Spatial Modes
figure(3)
x = 1:6;
plot(x, U3(:,1),'-', x, U3(:,2),'--', x, U3(:,3), ':', 'linewidth', 1.5)
xlabel('$\sigma_n$', 'Interpreter', 'latex')
legend('mode 1', 'mode 2', 'mode 3', 'Location', 'NorthEast')
set(gca, 'Fontsize', [15])

% Time Behavior
figure(4)
plot(t, V3(:,1), '-', t, V3(:,2),'--', t, V3(:,3),':', 'linewidth', 1.5)
xlabel('$\sigma_n$', 'Interpreter', 'latex')
legend('mode 1', 'mode 2', 'mode 3', 'Location', 'NorthEast')
set(gca, 'Fontsize', [15])

%% Part 4 Analysis

A4 = [master_data_mat{10}';
      master_data_mat{11}';
      master_data_mat{12}'];
[U4, S4, V4] = svd(A4);
sig = diag(S4);
t = (1/15)*(1:length(A4(1,:)));

% energy and log energy plots
figure(1)
subplot(1,2,1)
plot((sig / sum(sig)) * 100,'o', 'MarkerFaceColor', 'b')
xlabel('$\sigma_n$', 'Interpreter', 'latex')
ylabel('% of total energy')
set(gca, 'Fontsize', [10])
axis('square')
subplot(1,2,2)
semilogy((sig / sum(sig)) * 100,'o', 'MarkerFaceColor', 'b')
xlabel('$\sigma_n$', 'Interpreter', 'latex')
ylabel('Log of total energy')
set(gca, 'Fontsize', [10])
axis('square')


e_1 = sig(1)/sum(sig); e_2 = sum(sig(1:2)) / sum(sig); e_3 = sum(sig(1:3))/sum(sig);
e_list4 = [e_1; e_2; e_3];

% project onto U
Y4_U = U4.'*A4;
% Plot result
figure(2)
plot(t, Y4_U(1,:), t, Y4_U(2,:), t, Y4_U(3,:))
xlabel('time(seconds)', 'Interpreter', 'latex')
legend('mode 1', 'mode 2', 'mode 3', 'Location', 'NorthEast')
set(gca, 'Fontsize', [15])

% Spatial Modes
figure(3)
x = 1:6;
plot(x, U4(:,1),'-', x, U4(:,2),'--', x, U4(:,3), ':', 'linewidth', 1.5)
xlabel('$\sigma_n$', 'Interpreter', 'latex')
legend('mode 1', 'mode 2', 'mode 3', 'Location', 'NorthEast')
set(gca, 'Fontsize', [15])

% Time Behavior
figure(4)
plot(t, V4(:,1), '-', t, V4(:,2),'--', t, V4(:,3),':', 'linewidth', 1.5)
xlabel('$\sigma_n$', 'Interpreter', 'latex')
legend('mode 1', 'mode 2', 'mode 3', 'Location', 'NorthEast')
set(gca, 'Fontsize', [15])

%% Plot to compare to everyone else's 

x_s = 1:6;
s_1 = cumsum(diag(S1).^2 / sum(diag(S1).^2));
s_2 = cumsum(diag(S2).^2 / sum(diag(S2).^2));
s_3 = cumsum(diag(S3).^2 / sum(diag(S3).^2));
s_4 = cumsum(diag(S4).^2 / sum(diag(S4).^2));

plot(x_s, s_1, x_s, s_2, x_s, s_3, x_s, s_4, 'linewidth', 2)
xlabel('Sum of $\sigma_n$', 'Interpreter', 'latex')
ylabel('\% of variance by sum of $\sigma_n$', 'Interpreter', 'latex')
legend('Part 1', 'Part 2', 'Part 3', 'Part 4')
set(gca, 'Fontsize', [15])
