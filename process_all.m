files = dir('/media/yannicko/DATA/TestImages/Development/**/*c3.tif');
myFilterHandle2 = @(block_struct) ...
semanticseg(block_struct.data,net,'OutputType','uint8');
%toread=3:3:length(files);

toread=1:length(files);
for i=1:length(toread)
    i
    name=files(toread(i)).name;
    testImage = imread(name);
    sum (testImage(:))
    if sum (testImage(:))>0

    try
        windowSize = 1280;
        blockyImage = blockproc(testImage, [windowSize windowSize], myFilterHandle2);
        name2=files(toread(i)).folder;
        name3='2/';
        name4=strcat(name2,name3);
        nm=strcat(name4,name);
        imwrite(blockyImage,nm);
    catch
        try
            windowSize = 768;
            blockyImage = blockproc(testImage, [windowSize windowSize], myFilterHandle2);
            name2=files(toread(i)).folder;
            name3='2/';
            name4=strcat(name2,name3);
            nm=strcat(name4,name);
            imwrite(blockyImage,nm);
        catch
            windowSize = 381;
            blockyImage = blockproc(testImage, [windowSize windowSize], myFilterHandle2);
            name2=files(toread(i)).folder;
            name3='2/';
            name4=strcat(name2,name3);
            nm=strcat(name4,name);
            imwrite(blockyImage,nm);
        end
    end
    else
        [n1,n2]=size(testImage);
        blockyImage=zeros(n1,n2);
        name2=files(toread(i)).folder;
        name3='2/';
        name4=strcat(name2,name3);
        nm=strcat(name4,name);
        imwrite(blockyImage,nm);
    end
    save('file.mat','toread', 'i', 'myFilterHandle2','files', 'net'),
    clear
    load('file.mat'); 
    
end