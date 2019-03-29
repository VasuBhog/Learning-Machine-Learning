%% 
clear all
close all

LeafType={'papaya','pimento','chrysanthemum','chocolate_tree'};%,...
% 'duranta_gold','eggplant','ficus','fruitcitere','geranium','guava',...
% 'hibiscus','jackfruit','ketembilla','lychee','ashanti_blood','mulberry_leaf',...
% 'barbados_cherry','beaumier_du_perou','betel','pomme_jacquot','bitter_orange',...
% 'rose','caricature_plant','star_apple','chinese_guava','sweet_olive','sweet_potato',...
% 'thevetia','coeur_demoiselle','vieux_garcon','coffee','croton'};


%%
label=[];
X=[];

for LT=LeafType([1 2 3 4])
    
    filenames= dir([LT{1},filesep,'Training',filesep,'*.png']);
    
    %Training 
    for ifile=1:length(filenames)
        img=imread([filenames(ifile).folder,filesep,filenames(ifile).name]);
        X=[X;extractFeatures(img)];
        label=[label,LT];
        close all; 
    end
end  

%% Test 
    %Test
X2 = [];
label2 = [];
for LT=LeafType([1 2 3 4])
    filenamesTest = dir([LT{1},filesep,'Test',filesep,'*.png']);

    for ifile=1:length(filenamesTest)

        img=imread([filenamesTest(ifile).folder,filesep,filenamesTest(ifile).name]);
        X2=[X2;extractFeatures(img)];
        label2=[label2,LT];
        close all; 
    end
end

%% manual feature selection

Xs=X(:,[1:3]);
X2s = X2(:,[1:3]);

figure, hold,
for LT=LeafType
    Ilt=find(strcmp(label,LT));
    scatter3(Xs(Ilt,1),Xs(Ilt,2),Xs(Ilt,3),'o','filled');
    title('Feature Extract and Select Training');
    
end
legend(LeafType(1:4),'Location','SouthWest');

figure, hold,
for LT = LeafType
    Ilt2=find(strcmp(label2,LT));
    scatter3(X2s(Ilt2,1),X2s(Ilt2,2),X2s(Ilt2,3),'o','filled');
    title('Feature Extract and Select for TEST');
%     pause
end
legend(LeafType(1:4),'Location','SouthWest');

%% Dimension reduction by PCA

%Training Deminsion Reduction
X = X-mean(X);
covV=X'*X;
[U,D,V] = eig(covV);
[d,Isort] = sort(diag(D),'desc');
V=V(:,Isort);
Xp = X*V;

%TEST Deminsion Reduction
X2 = X2-mean(X2);
covV2=X2'*X2;
[U2,D2,V2] = eig(covV2);
[d2,Isort2] = sort(diag(D2),'desc');
V2=V2(:,Isort2);
Xp2 = X2*V2;

figure, hold;
for LT = LeafType
    Ilt = find(strcmp(label,LT));
    scatter3(Xp(Ilt,1),Xp(Ilt,2),Xp(Ilt,3),'o','filled');
    title('Dimension Reduction by PCA TRAINING');
    
end

%Xp is the reduced matrix after PCA
legend(LeafType(1:4),'Location','SouthWest'); 

figure,hold,
for LT = LeafType
   
    Ilt2=find(strcmp(label2,LT));
    scatter3(Xp2(Ilt2,1),Xp2(Ilt2,2),Xp2(Ilt2,3),'o','filled');
    title('Dimension Reduction by PCA TEST');
    %pause
end
legend(LeafType(1:4),'Location','SouthWest'); 


%% Supervised Approaches (nonparamatric - parzen)

% Training - Not used
Sigma = .5*eye(3);
K = length(LeafType);
Xtraining = Xp(1,1:3); %order of leaf based on LeafType
s=zeros(K,1);
for k=1:4
    for j = 1:15
        %Multivariate normal probability density function
        s(k) = s(k) + mvnpdf(Xtraining,Xp((k-1)*15+j,1:3),Sigma);
    end
    s(k) = s(k)/15;
end
[ms,c] = max(s);

disp(['Classify Result: ', LeafType(c)]);

figure,hold,
for LT = LeafType
   
    Ilt=find(strcmp(label,LT));
    isoContoursParzen(Xp(Ilt,1:2),0.5);
    scatter3(Xp(Ilt,1),Xp(Ilt,2),Xp(Ilt,3),'o','filled');
    title('Classification Non-Parametric Training');
    %pause
end

% Test (Images) using Training Model (Xp)
Xtest = Xp2(1,1:3); %order of leaf based on LeafType
s2=zeros(K,1);
for k=1:4
    for j = 1:15
        %Multivariate normal probability density function
        s2(k) = s2(k) + mvnpdf(Xtest,Xp((k-1)*15+j,1:3),Sigma);
    end
    s2(k) = s2(k)/15;
end
[ms2,c2] = max(s2);

disp(['Classify Result: ', LeafType(c2)]);

figure,hold,
for LT = LeafType
   
    Ilt2=find(strcmp(label2,LT));
    isoContoursParzen(Xp2(Ilt2,1:2),0.5);
    scatter3(Xp2(Ilt2,1),Xp2(Ilt2,2),Xp2(Ilt2,3),'o','filled');
    title('Classification Non-Parametric Test');
    %pause
end

%% Supervised Approaches (parametric)

% Training and Test - Use Training Distribution on Test 
K=length(LeafType);
muT=zeros(2,K);
CovT=zeros(2,2,K);

figure; hold on;
i=1;
for LT=LeafType
    Ilt=find(strcmp(label,LT));
    muT(:,i) = mean(Xp(Ilt,1:2))';
    CovT(:,:,i) = cov(Xp(Ilt,1:2));
    isoContoursGauss(muT(:,i),CovT(:,:,i));
    
    title('Classification Parametric - Training');
    i = i + 1;
end
scatter3(Xp2(:,1),Xp2(:,2),Xp2(:,3),'o','filled');

%Test

%% Unsupervised Approaches: K-means and GMM-EM









