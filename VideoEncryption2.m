%spliting video into frames
tic
workingDir = '.';
mkdir(workingDir);
mkdir(workingDir,'frames');
mkdir(workingDir,'encryptedFrames');
workingKeyDir='.';
mkdir(workingKeyDir,'topleft');
mkdir(workingKeyDir,'topright');
mkdir(workingKeyDir,'bottomleft');
mkdir(workingKeyDir,'bottomright');

video= VideoReader("png.mp4");

i=1;

while hasFrame(video)
    img=readFrame(video);
    filename = [sprintf('%03d',i) '.jpg'];
    fullname=fullfile(workingDir,'frames',filename);
    imwrite(img,fullname);
    i=i+1;
end

%xor on all images
location = 'frames/*.jpg';
imgDataset= imageDatastore(location);
i=1;

while hasdata(imgDataset)
    img=read(imgDataset);

    TopRight=img(1:size(img,1)/2,size(img,2)/2+1:size(img,2),:);
    toprightfile = [sprintf('%03d',i) '.jpg'];
    toprightfilename=fullfile(workingKeyDir,'topright',toprightfile);
    imwrite(TopRight,toprightfilename);

    TopLeft=img(1:size(img,1)/2,1:size(img,2)/2,:);
    topleftfile = [sprintf('%03d',i) '.jpg'];
    topleftfilename=fullfile(workingKeyDir,'topleft',topleftfile);
    imwrite(TopLeft,topleftfilename);

    BottomLeft=img(size(img,1)/2+1:size(img,1),1:size(img,2)/2,:);
    bottomleftfile = [sprintf('%03d',i) '.jpg'];
    bottomleftfilename=fullfile(workingKeyDir,'bottomleft',bottomleftfile);
    imwrite(BottomLeft,bottomleftfilename);

    BottomRight= img(size(img,1)/2+1:size(img,1),size(img,2)/2+1:size(img,2),:);
    bottomrightfile = [sprintf('%03d',i) '.jpg'];
    bottomrightfilename=fullfile(workingKeyDir,'bottomright',bottomrightfile);
    imwrite(BottomRight,bottomrightfilename);

    op1=bitxor(TopLeft,TopRight);
    op2=bitxor(TopRight,BottomRight);
    op3=bitxor(BottomRight,BottomLeft);
    op4=bitxor(BottomLeft,TopLeft);

    OutputImage=[op1 op2; op3 op4];

    outputfile = [sprintf('%03d',i) '.jpg'];
    encryptedfilename=fullfile(workingDir,'encryptedFrames',outputfile);
    imwrite(OutputImage,encryptedfilename);
    i=i+1;

end


%frames to video
imageNames = dir(fullfile(workingDir,'encryptedFrames','*.jpg'));
imageNames = {imageNames.name}';

outputVideo = VideoWriter(fullfile(workingDir,'encryptedVideo1.avi'));
outputVideo.FrameRate = video.FrameRate;
open(outputVideo)

for i = 1:length(imageNames)
   eImg = imread(fullfile(workingDir,'encryptedFrames',imageNames{i}));
   writeVideo(outputVideo,eImg)
end

close(outputVideo)

EncryptedVideo = VideoReader(fullfile(workingDir,'encryptedVideo1.avi'));
toc