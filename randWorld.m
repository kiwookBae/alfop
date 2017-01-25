clear
gamma = 0.8; %discount rate

n= 100; %# of states
Tran = zeros(n); %transition matrix
Reward = zeros(n,1); %reward

%%Reward
for i=1:n
    Reward(i,1)=randi(n);
    if Reward(i,1)<n/10
        Reward(i,1)=1;
    else
        Reward(i,1)=0;
    end
end

% %%Deterministic
% for i=1:n
%     Tran(i,randi(n))=1;
% end

%%Stochastic
Tran = rand(n);
for i=1:n
   Tran(i,:)=Tran(i,:)./sum(Tran(i,:));
end

A=eye(n)-gamma*Tran;
v=A\Reward;

%%Sampling
sampleSize=10^5;%Sampling size
sample=zeros(sampleSize,2); %state, reward, 
doubleSample=zeros(sampleSize,2); %double sampling, double reward
sample(1,1)=randi(n);
cumTran = cumsum(Tran,2);
for i=1:sampleSize-1
   state1 = sample(i,1);
   j=1;
   k=rand(1);
   while k>cumTran(state1,j)
       j=j+1;
   end
   sample(i+1,1)=j; %s'
   sample(i+1,2)=Reward(j,1); 
   l=1;
   m=rand(1);
   while m>cumTran(state1,l)
       l=l+1;
   end
   doubleSample(i+1,1)=l;
   doubleSample(i+1,2)=Reward(l,1);
end 

%%Approximation
k=50; %feature space
Pi=rand(n,k); %feature matrix
while rank(Pi)~=k
   Pi=rand(n,k);
end
% 
% theta_td=zeros(k,1); %parameter
theta_br=zeros(k,1);
theta_lstd=zeros(k,1);
theta_projected=zeros(k,1);

% 
% %%Bootstrapping
% alpha_td=1;
% for i=1:size(sample,1)-1
%     alpha_td=(100+alpha_td)/(100+i);
%     theta_td = theta_td+alpha_td*Pi(sample(i,1),:)'*(sample(i,2)+gamma*Pi(sample(i+1,1),:)*theta_td-Pi(sample(i,1),:)*theta_td);
% end
% 
%%Bellman Residual
alpha_br=1;
for i=1:size(sample,1)-1
    alpha_br=(100+alpha_br)/(100+i);
%     theta_br=theta_br+alpha_br*(Pi(sample(i,1),:)'-gamma*Pi(sample(i+1,1),:)')*(doubleSample(i,2)+gamma*Pi(doubleSample(i+1,1),:)*theta_br-Pi(sample(i,1),:)*theta_br);
    theta_br=theta_br+alpha_br*(Pi(sample(i,1),:)'-gamma*Pi(sample(i+1,1),:)')*(sample(i,2)+gamma*Pi(sample(i+1,1),:)*theta_br-Pi(sample(i,1),:)*theta_br);
end


%%LSTD
A_ls=zeros(k);
b_ls=zeros(k,1);
for i=1:size(sample,1)-1
   A_ls=A_ls+Pi(sample(i,1),:)'*(Pi(sample(i,1),:)-gamma*Pi(sample(i+1,1),:));
   b_ls=b_ls+Pi(sample(i,1),:)'*sample(i,2);
end
theta_lstd=A_ls\b_ls;

%%Projected
A_pj = Pi'*A'*A*Pi;
b_pj = Pi'*A'*Reward;
theta_pj=A_pj\b_pj;

%%Orthogonal projection
A_orth=Pi'*A*Pi;
b_orth=Pi'*Reward;
theta_orth=A_orth\b_orth;


% 
% V_td=Pi*theta_td;
V_br=Pi*theta_br;
V_lstd=Pi*theta_lstd;
V_pj=Pi*theta_pj;
V_orth=Pi*theta_orth;


figure
plot(v,'black')
hold on
% plot(V_td,'r')
% plot(V_br,'b')
plot(V_lstd,'g')
plot(V_pj,'cyan')
plot(V_orth,'r')

% e_td=sum((v-V_td).^2);
e_br=sum((v-V_br).^2);
e_lstd=sum((v-V_lstd).^2);
e_pj=sum((v-V_pj).^2);
e_orth=sum((v-V_orth).^2);