files = dir('/media/yannicko/DATA/TestImages/Development/**/*c3.tif');

newimg=[];

for kk=100:length(files)

if mod(kk,5)==0
   name=files(kk).name;
   testImage = imread(name);
   imagesc(imadjust(testImage));
   colormap('gray')
   [x,y,z]=ginput(10);
   x=round(x);
   y=round(y);
   for i=1:10
       if z==1
           newimg(:,:,end+1)=testImage(y(i)-33:y(i)+34,x(i)-33:x(i)+34);
       end
   end
end
end

B = reshape(newimg2,68,68*100);

A=B(1:68,1:2448);
C=B(1:68,2449:2448*2);
D=B(1:68,2448*2+1:end);

A1=vertcat(A,C,D);
A2=uint16(A1);
imwrite(B,'testC3new.tif')

seg=[];
img=[];
for i=1:1
    for j=1:100
        seg(:,:,end+1)=cdata(68*i-68+1:68*i,68*j-68+1:68*j);
        img(:,:,end+1)=testC2(68*i-68+1:68*i,68*j-68+1:68*j);
    end
end

img=img(:,:,2:end);
seg=seg(:,:,2:end);

for i=1:100
    name2='img.tif';
    name3=num2str(i+158);
    name4=strcat(name3,name2);
    im=uint8(img(:,:,i));
    imwrite(im,name4);
end

for i=1:100
    name2='seg.tif';
    name3=num2str(i+158);
    name4=strcat(name3,name2);
    im=uint8(seg(:,:,i));
    imwrite(im,name4);
end