% Aide pour l'affichage d'isocontours d'une loi en 2D

% determination du range de calcul
xmin= -1.5;
xmax= 1.5;
ymin= -.6;
ymax= .9;

% discr?tisation de chaque axe sur 100 points
pasx=(xmax-xmin)/100;
x=(xmin:pasx:xmax-pasx);
pasy=(ymax-ymin)/100;
y=(ymin:pasy:ymax-pasy);

% d?termination des coordonn?es 2D (10000 points):
% le point (i,j) de l'espace a pour coordonn?e (X(i,j), Y(i,j))
[X,Y]=meshgrid(x,y);


% vectorisation des 10000 coordonn?es 
XYvec=zeros(2,size(X,1)*size(X,2));
XYvec(1,:)=reshape(X,1,size(X,1)*size(X,2));
XYvec(2,:)=reshape(Y,1,size(X,1)*size(X,2));

% calcul de la distribution sur les 10000 points
Zvec=FONCTION_A_CODER(XYvec,...);
Z = reshape(Zvec,size(X,1),size(X,2));


Nc=10; % nombre d'isocontours ? afficher
figure,
contour(X,Y,Z,Nc);  