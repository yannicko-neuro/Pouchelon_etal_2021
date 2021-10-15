aa=cases{jjj};
bb='/**/*c1.tif';
cc=strcat(aa,bb);
files2 = dir(cc);
a=slices{jjj};
b=allen{jjj};
dat={};

curdir='/home/yannicko/Documents/matching';

for i=1:length(a)
    name=files2(a(i)).name;
    tomatch=imread(name);
    
    dirname=name(1:end-6);
    mkdir(dirname);
    gotodir=strcat(curdir,dirname);
    cd(gotodir);
    
    Z=b(i);
    siz=size(tomatch);
    Xfac=(800/siz(1));
    Yfac=(1140/siz(2));
    tomatch2=imresize(tomatch,[800,1140]);
    
    nii = make_nii(tomatch2, [1 1 1]);
    save_nii(nii, 'green.nii');
   
    S='export ANTSPATH=/home/yannicko/Documents/ANTS/bin && export PATH=${ANTSPATH}:$PATH &&  antsreg.sh -d 2 -f /home/yannicko/Documents/matching/tomatch/green';
    SS=num2str(Z(1));
    SSS='.nii -m /home/yannicko/Documents/matching/';
    SSSS=dirname;
    SSSSS='/green.nii -t s -o /home/yannicko/Documents/matching/';
    St=strcat(S,SS,SSS,SSSS,SSSSS,SSSS);
    [status,cmdout] = system(St);
    
    
    for j=1:2
        name=files2(a(i)).name;
        name2=name(1:end-6);
        if j==1
            nm='c1.tif';
        end
        if j==2
            nm='c2.tif';
        end
        
        name=strcat(name2,nm);
        tomatch=imread(name);
        
        tomatch3=imresize(tomatch,[800,1140]);
        
        niii = make_nii(tomatch3, [1 1 1]);
        save_nii(niii, 'current.nii');
        
        SSSS='antsApplyTransforms -d 2 -i';
        S='export ANTSPATH=/home/yannicko/Documents/ANTS/bin && export PATH=${ANTSPATH}:$PATH &&  antsApplyTransform -d 2 -i';
        SS='gotodir';
        SSS='/current.nii';
        St=strcat(S,SSSS,SS,'/current.nii -o ',{' '},SS,'/current2.nii -t',{' '},SS,'/InverseComposite.h5 -r ',{' '},SS,'/current.nii');
        St=St{1};
        [status,cmdout] = system(St);
         load_untouch_nii('current2.nii');
        warped_image=ans.img;
    
    fixedimage=atl1(:,:,Z(1));
    fixed_image=permute(fixedimage,[2,1]);
    fixed_image=double(fixed_image);
       allVals = unique(fixed_image);
    imagesc(warped_image)
    colormap('gray');
    hold on;
    for ij = 1:numel(allVals)
        newOutline = bwperim(fixed_image==allVals(ij), 26)*allVals(ij);
        visboundaries(newOutline,'LineWidth',1)
    end
    
    set(gcf, 'Position',  [100, 100, 1240, 900])
    saveas(gcf,name);
    close all
    end
    
    
    for j=1:3
    name=files2(a(i)).name;
    name2=name(1:end-6);
    if j==1
        nm='c1.tif';
    end
    if j==2
        nm='c2.tif';
    end
    if j==3
        nm='c3.tif';
    end
    name=strcat(name2,nm);
    tomatch=imread(name);
    siz=size(tomatch);
    Xfac=(800/siz(1));
    Yfac=(1140/siz(2));
    index=[];
    cells=[];
    try
        index = find(strcmp({files.name}, name)==1);
        cells=[];
        cells=files(index).center;
    catch
        cells=[];
    end
    if  sum(cells)>1
        X1=[];
        Y1=[];
        M=[];
        X1=cells(:,1).*Yfac;
        Y1=cells(:,2).*Xfac;
        
        
        T=zeros(1,length(X1));
        Z=repmat(b(i),length(X1),1);
        
        M(:,1)=X1.*(-1);
        M(:,2)=Y1.*(-1);
        M(:,3)=Z;
        M(:,4)=T;
        csvwrite('soma.csv',M)
        if length(M(:,1))>1
        else
            M(2,1)=0;
            M(2,2)=0;
            M(2,3)=0;
            M(2,4)=0;
        end
    else
        M(1,1)=0;
        M(1,2)=0;
        M(1,3)=0;
        M(1,4)=0;
        M(2,1)=0;
        M(2,2)=0;
        M(2,3)=0;
        M(2,4)=0;
    end
    
    S='export ANTSPATH=/home/yannicko/Documents/ANTS/bin && export PATH=${ANTSPATH}:$PATH && antsApplyTransformsToPoints -d 2 -i';
    SS=gotodir;
    SSS='/soma.csv -o';
    SSSS='/soma1.csv -t';
    SSSSS='InverseComposite.h5';
    St=strcat(S,{''},SS,SSS,{''},SS,SSSS,{''},SS,SSSSS);
    [status,cmdout] = system(St);
    
    filename='soma1.csv';
    
    x=[]; y=[]; z=[]; count=[]; sm=[];
    delimiter = ',';
    startRow = 2;
    formatSpec = '%f%f%f%*s%[^\n\r]';
    fileID = fopen(filename,'r');
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN,'HeaderLines' ,startRow-1, 'ReturnOnError', false, 'EndOfLine', '\r\n');
    fclose(fileID);
    x = dataArray{:, 1};
    y = dataArray{:, 2};
    z = dataArray{:, 3};
    x=x.*(-1);
    y=y.*(-1);
    clls=[];
    clls(:,3)=round(z);
    clls(:,2)=round(y);
    clls(:,1)=round(x);
    name4=name(1:end-4);
    name5='.mat';
    St=strcat(name4,name5);
    save(St,clls)
    end
end