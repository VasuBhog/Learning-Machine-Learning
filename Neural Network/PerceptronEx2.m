%% Part III - Classification of a 4-class problem with a perceptron

close all, clear all,  clc

% number of samples of each class
N = 30;

% define inputs and outputs
% define 4 clusters of input data

q = .6; % offset of classes

%Define Classes
A = [rand(1,N)-q; rand(1,N)+q];
B = [rand(1,N)+q; rand(1,N)+q];
C = [rand(1,N)+q; rand(1,N)-q];
D = [rand(1,N)-q; rand(1,N)-q];

% VISUALIZE the Input/Target Samples
figure(1)
plot(A(1,:),A(2,:),'b+'),title("Visualize the input/targets samples"),
hold on
grid on
plot(B(1,:),B(2,:),'r*')
plot(C(1,:),C(2,:),'go')
plot(D(1,:),D(2,:),'md')

% text labels for clusters
text(.5-q,.5+2*q,'Class A')
text(.5+q,.5+2*q,'Class B')
text(.5+q,.5-2*q,'Class C')
text(.5-q,.5-2*q,'Class D')

% define output coding for classes
a = [0 1]';
b = [1 1]';
c = [1 0]';
d = [0 0]';

%%%Create a Perceptron
%define inputs (combine samples from all four classes)
P = [A B C D];

%define targets
T = [repmat(a,1,length(A)) repmat(b,1,length(B)) ...
     repmat(c,1,length(C)) repmat(d,1,length(D)) ];
 
%Create a perceptron
net = perceptron;

%ADAPT returns a new network object that performs as a better classifier, 
%the network output, and the error. This loop allows the network to adapt 
%for xx passes, plots the classification line, and continues until the 
%error is zero.
E = 1; %Errors
net.adaptParam.passes = 1;                  %adapts the perceptron
linehandle = plotpc(net.IW{1},net.b{1});    %plots the classification line  
n = 0;                                      
while (sse(E) && n<1000)    %Sum-Squared error
   n = n+1;                 %continues until the error is zero 
   [net,Y,E] = adapt(net,P,T);  %adapt(perceptron,inputs,targets)
   linehandle = plotpc(net.IW{1},net.b{1},linehandle);
   drawnow;
end
% show perceptron structure
view(net);


%Testing
xtest = [0.7; 1.2];
ytest = net(xtest);
figure(2),title("Testing with xtest");
plotpv(xtest,ytest)
point = findobj(gca,'type','line');

hold on,
plotpv(P,T);
title("Decision Boundary Xtest"),
plotpc(net.IW{1},net.b{1});
hold off
point.Color = 'black';
return
