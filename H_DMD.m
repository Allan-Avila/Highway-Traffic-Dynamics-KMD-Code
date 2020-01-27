%% Hankel-DMD
%Highway Traffic Dynamics: Data-Driven Analysis and Forecast 
%Allan M. Avila & Dr. Igor Mezic 2019
%University of California Santa Barbara
function [Eigval,Eigvec,bo,X,Y,H] = H_DMD(X,delay)
H = zeros(delay*size(X,1),size(X,2)-delay+1);
for k=1:delay
H(size(X,1)*(k-1)+1:size(X,1)*k,:) = X(:,k:end-delay+k);
end
% Split Data Matrix
X1=H(:,1:end-1); X2=H(:,2:end);
% Compute Koopman Operator Approximation K
[U,S,V]=svd(X1,'econ'); S(S>0)=1./S(S>0); K=U'*X2*V*S;
% Eigendecomposition of K
[y,Eigval]=eig(K); Eigvec=U*y;
% Project Initial Conditons on Eigenspace
bo=pinv(Eigvec)*X1(:,1); X=X1; Y=X2;
end