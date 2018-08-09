%
%  Infrared Small Target Detection Based on Local Intensity and Gradient Properties
%  Lei Zhang, 2018
%   This demo script runs LIG on an infrared image.
%
% 

% parameter set
k=0.2;
N=19;
%  set your image path here
I=imread('infrared.bmp');

if size(I,3) == 3
   I = I(:,:,1);
end

[Xsize,Ysize]=size(I);

I=double(I);

Gradient_Img1=zeros(Xsize,Ysize);%
Gradient_Img2=zeros(Xsize,Ysize);
Gradient_Img3=zeros(Xsize,Ysize);     
Gradient_Img4=zeros(Xsize,Ysize);
Gmap=zeros(Xsize,Ysize);
Imap=zeros(Xsize,Ysize);


% We took four directions to simplify the calculation
G315=imfilter(I,[ 0,0,0; 0,-1,0; 0,0,1],'replicate');
G225=imfilter(I,[0,0,0; 0,-1,0; 1,0,0],'replicate');
G45=imfilter(I,[0,0,1;0,-1,0; 0,0,0],'replicate');
G135=imfilter(I,[1,0,0; 0,-1,0; 0,0,0],'replicate');

Mapscale=(N-1)/2;
Scale=Mapscale+1;
for i=Scale:Xsize-Scale
    for j=Scale:Ysize-Scale
	   %--------------------------------------
        C0=G315(i-Mapscale:i,j-Mapscale:j);
        [x0,v0]=find(C0(:)>0);      
        Gradient_Img1(i,j)=sum(C0(x0).^2)/(length(x0)+0.001);
       %--------------------------------------
        C1=G225(i-Mapscale:i,j:j+Mapscale);
        [x1,v1]=find(C1(:)>0);
        Gradient_Img2(i,j)=sum(C1(x1).^2)/(length(x1)+0.001);
       %--------------------------------------
        C2=G45(i:i+Mapscale,j-Mapscale:j);
        [x2,v2]=find(C2(:)>0);
        Gradient_Img3(i,j)=sum(C2(x2).^2)/(length(x2)+0.001);
       %--------------------------------------
        C3=G135(i:i+Mapscale,j:j+Mapscale);
        [x3,v3]=find(C3(:)>0);
        Gradient_Img4(i,j)=sum(C3(x3).^2)/(length(x3)+0.001);   
        
        dnmax=max([Gradient_Img1(i,j),Gradient_Img2(i,j),Gradient_Img3(i,j),Gradient_Img4(i,j)]);
        dnmin=min([Gradient_Img1(i,j),Gradient_Img2(i,j),Gradient_Img3(i,j),Gradient_Img4(i,j)]);
         if((dnmin/dnmax)<k)
            Gmap(i,j)=0;
         else
            Gmap(i,j)=sum([Gradient_Img1(i,j),Gradient_Img2(i,j),Gradient_Img3(i,j),Gradient_Img4(i,j)]);
         end
        
		K_temp=(I(i,j)-mean2(I(i-Mapscale:i+Mapscale,j-Mapscale:j+Mapscale)))^2;
        if (K_temp>0)
            Imap(i,j)=K_temp;
        end    
    end
end

Gmap=Gmap.*Imap;
LIGmap=mat2gray(Gmap);
imwrite(LIGmap,'LIGmap.bmp');


