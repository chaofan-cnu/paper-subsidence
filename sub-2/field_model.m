load('PS.txt')
load('jd.txt')
load('psorgin.txt')

A=rot90(PS);
A=flipud(A);
B=rot90(jd);
B=flipud(B);

for tp1=1:size(B,2)
    X1(tp1,:)=A(1,:)-B(1,tp1);
    Y1(tp1,:)=A(2,:)-B(2,tp1);
end

R1=sqrt(X1.^2+Y1.^2);
R1=R1';

A=R1./300;
B=-A.^2;
C=exp(B);
F1=mean(C,2);
x=psorgin(:,1);
y=psorgin(:,2);
xi=linspace(min(x),max(x),1000);  
yi=linspace(max(y),min(y),1000);
[xi,yi]=meshgrid(xi,yi);          
zi=griddata(x,y,F1,xi,yi,'cubic'); 
contour(xi,yi,zi,50)
