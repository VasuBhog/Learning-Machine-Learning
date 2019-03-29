%% Part I - Classification of lineraly separable data with a perceptron

close all, clear all,  clc

% number of samples of each class
N = 20;

% define inputs and outputs
offset = 5; % offset for second class
x = [randn(2,N) randn(2,N)+offset]; % inputs
y = [zeros(1,N) ones(1,N)];         % outputs

% Plot input samples with PLOTPV (Plot perceptron input/target vectors)
figure(1),hold on,title("Visualize the input/target samples");
plotpv(x,y);

%Create and train a perceptron
net = perceptron;
net = train(net,x,y); %can also use configure(net,x,y)
view(net);

%Descision Boundary
figure(1),title("Decision Boundary");
plotpc(net.IW{1},net.b{1});

%Testing
xtest = [0.7; 1.2];
ytest = net(xtest);
figure(2),title("Testing with xtest");
plotpv(xtest,ytest)
point = findobj(gca,'type','line');

hold on,
plotpv(x,y);
title("Decision Boundary Xtest"),
plotpc(net.IW{1},net.b{1});
hold off
point.Color = 'red';
return

