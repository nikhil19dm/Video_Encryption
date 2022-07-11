%spliting video into frames
tic
workingDir = '.';
mkdir(workingDir);
mkdir(workingDir,'frames');
mkdir(workingDir,'encryptedFrames');

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

    TopLeft=img(1:size(img,1)/2,size(img,2)/2+1:size(img,2),:);
    TopRight=img(1:size(img,1)/2,1:size(img,2)/2,:);
    BottomLeft=img(size(img,1)/2+1:size(img,1),1:size(img,2)/2,:);
    BottomRight= img(size(img,1)/2+1:size(img,1),size(img,2)/2+1:size(img,2),:);
    

    op1=bitxor(TopLeft,BottomRight);
    op2=bitxor(TopRight,BottomLeft);
    op3=bitxor(BottomRight,TopLeft);
    op4=bitxor(BottomLeft,TopRight);

    OutputImage1=[op1 op2; op3 op4];
    
    OutputImage=bitxor(OutputImage1,169); 
    outputfile = [sprintf('%03d',i) '.jpg'];
    encryptedfilename=fullfile(workingDir,'encryptedFrames',outputfile);
    imwrite(OutputImage,encryptedfilename);
    i=i+1;

end


%frames to video
imageNames = dir(fullfile(workingDir,'encryptedFrames','*.jpg'));
imageNames = {imageNames.name}';

outputVideo = VideoWriter(fullfile(workingDir,'encryptedVideo.avi'));
outputVideo.FrameRate = video.FrameRate;
open(outputVideo)

for i = 1:length(imageNames)
   eImg = imread(fullfile(workingDir,'encryptedFrames',imageNames{i}));
   writeVideo(outputVideo,eImg)
end

close(outputVideo)

EncryptedVideo = VideoReader(fullfile(workingDir,'encryptedVideo.avi'));
toc