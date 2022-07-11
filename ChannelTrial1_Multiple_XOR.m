
img=imread("Dubrovik\frames\001.jpg");
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
    X1=bitxor(OutputImageblueChannel,OutputImageredChannel);
    X2=bitxor(OutputImageredChannel,OutputImagegreenChannel);
    X3=bitxor(OutputImagegreenChannel,OutputImageblueChannel);
    Op1=cat(3,X1,X2,X3);
    OutputImage = cat(3, OutputImageredChannel, OutputImagegreenChannel, OutputImageblueChannel);
    subplot(2, 2, 2);
    imshow(Op1);
    title('redchannel')
    subplot(2, 2, 1);
    imshow(OutputImage); 
    title('double xor')
   