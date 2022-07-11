%spliting video into frames
tic
workingDir = '.';
mkdir(workingDir);
mkdir(workingDir,'encypframes');
mkdir(workingDir,'doubleencryptedFrames');

video= VideoReader("encryptedVideo.avi");

i=1;

while hasFrame(video)
    img=readFrame(video);
    filename = [sprintf('%03d',i) '.jpg'];
    fullname=fullfile(workingDir,'encypframes',filename);
    imwrite(img,fullname);
    i=i+1;
end

%xor on all images
location = 'encypframes/*.jpg';
imgDataset= imageDatastore(location);
i=1;

while hasdata(imgDataset)
    img=read(imgDataset);

    TopRight=img(1:size(img,1)/2,size(img,2)/2+1:size(img,2),:);
    TopLeft=img(1:size(img,1)/2,1:size(img,2)/2,:);
    BottomLeft=img(size(img,1)/2+1:size(img,1),1:size(img,2)/2,:);
    BottomRight= img(size(img,1)/2+1:size(img,1),size(img,2)/2+1:size(img,2),:);
    

    op1=bitxor(TopLeft,BottomRight);
    op2=bitxor(TopRight,BottomLeft);
    op3=bitxor(BottomRight,TopLeft);
    op4=bitxor(BottomLeft,TopRight);

    OutputImage=[op1 op2; op3 op4];
    

    outputfile = [sprintf('%03d',i) '.jpg'];
    encryptedfilename=fullfile(workingDir,'doubleencryptedFrames',outputfile);
    imwrite(OutputImage,encryptedfilename);
    i=i+1;

end


%frames to video
imageNames = dir(fullfile(workingDir,'doubleencryptedFrames','*.jpg'));
imageNames = {imageNames.name}';

outputVideo = VideoWriter(fullfile(workingDir,'doubleencryptedVideo.avi'));
outputVideo.FrameRate = video.FrameRate;
open(outputVideo)

for i = 1:length(imageNames)
   eImg = imread(fullfile(workingDir,'doubleencryptedFrames',imageNames{i}));
   writeVideo(outputVideo,eImg)
end

close(outputVideo)

EncryptedVideo = VideoReader(fullfile(workingDir,'doubleencryptedVideo.avi'));
toc