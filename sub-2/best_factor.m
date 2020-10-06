load('ps33.txt')
load('jdpy.txt')

A=rot90(ps33);
A=flipud(A);
B=rot90(jdpy);
B=flipud(B);

for tp1=1:size(B,2)
    X1(tp1,:)=A(1,:)-B(1,tp1);
    Y1(tp1,:)=A(2,:)-B(2,tp1);
end

R1=sqrt(X1.^2+Y1.^2);
R1=R1';



minval=double(min(R1(:)))
maxval=double(max(R1(:)))
a = 0.471404*minval;%0.471404=¸ùºÅ2³ý3
b = 0.471404*maxval;
precision = 0.1;
t = (sqrt(5)-1)/2;
res_l = a+(1-t)*(b-a);
res_t = a+t*(b-a);


A=R1./res_l;
B=-A.^2;
C=exp(B);
F1=mean(C,2);
Z= sum(F1(1,:));
H_l=0;
for i=1:size(F1,1)
	per=F1(i,1)/Z;
	H_l=H_l-per*log(per)
end

A=R1./res_t;
B=-A.^2;
C=exp(B);
F1=mean(C,2);
Z= sum(F1(1,:));
H_t=0;
for i=1:size(F1,1)
	per=F1(i,1)/Z;
	H_t=H_t-per*log(per)
end

while(abs(b-a) > precision) 
	if H_l < H_t
		b = res_t;
		res_t = res_l;
		H_t = H_l;		
		res_l = a+(1-t)*(b-a);
		
		A=R1./res_l;
		B=-A.^2;
		C=exp(B);
		F1=mean(C,2);
		Z= sum(F1(1,:));
		H_l=0;
		for i=1:size(F1,1)
			per=F1(i,1)/Z;
			H_l=H_l-per*log(per);
		end
	else
		a = res_l;
		res_l = res_t;
		H_l  = H_t;		
		res_t = a+t*(b-a);
		
		A=R1./res_t;
		B=-A.^2;
		C=exp(B);
		F1=mean(C,2);
		Z= sum(F1(1,:));
		H_t=0;
		for i=1:size(F1,1)
			per=F1(i,1)/Z;
			H_t=H_t-per*log(per);
		end
	end
end
res=0;
if H_l < H_t
	res = res_l;
else
	res = res_t;
end
res 