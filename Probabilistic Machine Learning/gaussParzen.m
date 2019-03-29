function z=gaussParzen(data,appr,sigParz)

% data: vecteur de points
% appr: donn?es d'apprentissage
% sigParz: std du noyau de parzen

Sigma=sigParz^2*eye(2);
N=size(appr,1);
z=zeros(size(data,2),1);

for i=1:N
    z=z+mvnpdf(data',appr(i,:),Sigma);
end

z=z/N;