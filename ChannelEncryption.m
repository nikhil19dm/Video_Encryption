%spliting video into frames
tic
workingDir = '.';
mkdir(workingDir);
mkdir(workingDir,'frames');
mkdir(workingDir,'encryptedFrames');

video= VideoReader("xylophone.mp4");

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
    
    redChannel = img(:,:,1); % Red channel
    greenChannel = img(:,:,2); % Green channel
    blueChannel = img(:,:,3); % Blue channel

    %RED
    TopLeftredChannel=redChannel(1:size(img,1)/2,size(img,2)/2+1:size(img,2),:);
    TopRightredChannel=redChannel(1:size(img,1)/2,1:size(img,2)/2,:);
    BottomLeftredChannel=redChannel(size(img,1)/2+1:size(img,1),1:size(img,2)/2,:);
    BottomRightredChannel= redChannel(size(img,1)/2+1:size(img,1),size(img,2)/2+1:size(img,2),:);

     %GREEN
    TopLeftgreenChannel=greenChannel(1:size(img,1)/2,size(img,2)/2+1:size(img,2),:);
    TopRightgreenChannel=greenChannel(1:size(img,1)/2,1:size(img,2)/2,:);
    BottomLeftgreenChannel=greenChannel(size(img,1)/2+1:size(img,1),1:size(img,2)/2,:);
    BottomRightgreenChannel= greenChannel(size(img,1)/2+1:size(img,1),size(img,2)/2+1:size(img,2),:);

    %BLUE
    TopLeftblueChannel=blueChannel(1:size(img,1)/2,size(img,2)/2+1:size(img,2),:);
    TopRightblueChannel=blueChannel(1:size(img,1)/2,1:size(img,2)/2,:);
    BottomLeftblueChannel=blueChannel(size(img,1)/2+1:size(img,1),1:size(img,2)/2,:);
    BottomRightblueChannel= blueChannel(size(img,1)/2+1:size(img,1),size(img,2)/2+1:size(img,2),:);

    op1redChannel=bitxor(TopLeftredChannel,BottomRightredChannel);
    op2redChannel=bitxor(TopRightredChannel,BottomLeftredChannel);
    op3redChannel=bitxor(BottomRightredChannel,TopLeftredChannel);
    op4redChannel=bitxor(BottomLeftredChannel,TopRightredChannel);

    OutputImageredChannel=[op1redChannel op2redChannel; op3redChannel op4redChannel];
    
   

    op1greenChannel=bitxor(TopLeftgreenChannel,BottomRightgreenChannel);
    op2greenChannel=bitxor(TopRightgreenChannel,BottomLeftgreenChannel);
    op3greenChannel=bitxor(BottomRightgreenChannel,TopLeftgreenChannel);
    op4greenChannel=bitxor(BottomLeftgreenChannel,TopRightgreenChannel);

    OutputImagegreenChannel=[op1greenChannel op2greenChannel; op3greenChannel op4greenChannel];

    


    op1blueChannel=bitxor(TopLeftblueChannel,BottomRightblueChannel);
    op2blueChannel=bitxor(TopRightblueChannel,BottomLeftblueChannel);
    op3blueChannel=bitxor(BottomRightblueChannel,TopLeftblueChannel);
    op4blueChannel=bitxor(BottomLeftblueChannel,TopRightblueChannel);

    OutputImageblueChannel=[op1blueChannel op2blueChannel; op3blueChannel op4blueChannel];

    OutputImage = cat(3, OutputImageredChannel, OutputImagegreenChannel, OutputImageblueChannel);
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