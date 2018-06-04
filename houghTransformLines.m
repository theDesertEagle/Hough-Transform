%%% Author: the.desert.eagle
%%% Program: Implementation of Hough-Transform to estimate Line Parameters
%%%          from scratch without in-built MATLAB toolbox utilities
%%% Line-Parameters Type: Polar-Coordinate System
%%% Threshold for Detection of All Lines / Minimum Number of Votes: 100

function a = houghTransformLines(minimumNumberOfVotes)
    %% Reading image, detecting edges and computing size of the image
    inputImage = imread('line.gif');
    image = double(inputImage);
    [imgNumberOfRows, imgNumberOfCols] = size(inputImage);
    %% Thresholding and inverting black and white image
    for i=1:imgNumberOfRows
        for j=1:imgNumberOfCols
            if inputImage(i, j) < 1
                image(i, j) = 255;
            else
                image(i, j) = 0;
            end            
        end
    end
    image = bwmorph(image,'skel',Inf);

    %% Tuning the polar-coordinate resolution parameters for 'r' and 'theta'
    thetaResolution = 1; %1/1000;
    rResolution = 1; %1/1000;

    %% Creating two vectors consisting 'r' and 'theta' respectively 
    rMax = sqrt(imgNumberOfRows.^2 + imgNumberOfCols.^2);
    thetaMax = 90;
    rValuesMatrix = 1:rResolution:rMax;
    thetaValuesMatrix = -90:thetaResolution:thetaMax;

    %% Accumulator Initialization
    [~, accNumberOfRows] = size(rValuesMatrix);
    [~, accNumberOfCols] = size(thetaValuesMatrix);
    accumulator = double(zeros(accNumberOfRows, accNumberOfCols));

    %% Displaying the edge-thinned image
    figure(1);
    subplot(1, 2, 1)
    imshow(image)
    title('Line Extraction using Hough Transform')
    axis on
    hold on
    xlabel('X-Axis')
    ylabel('Y-Axis')

    %% Looping pixels and finding edge element pixels
    for y = 1:imgNumberOfRows
        for x = 1:imgNumberOfCols
            % Considering edge-pixels having high values
            if image(y, x) > 0             
                % Looping for each possible value for theta
                for thetaIndex=1:accNumberOfCols                
                    theta = thetaValuesMatrix(thetaIndex);
                    r = abs(round(x*cosd(theta)+y*sind(theta)));
                    rIndex = 1 + 1/rResolution*r;
                    accumulator(rIndex, thetaIndex) = accumulator(rIndex, thetaIndex) + 1;
                end
            end
        end
    end

    %% Copying the accumulator for display purposes
    accumulatorCopy = accumulator;
    
    %% Displaying all of the lines rom the parameters collected
    rParameter = 0;
    thetaParameter = 0;
    %default minimumNumberOfVotes should be = 100;
    lineNumber = 0;
    peakBreak = 1;
    fprintf('The parameters of the each line was found to be as follows:\n')
    while peakBreak == 1
        peakBreak = 0;
        maxRIndex = 1;
        lineNumber = lineNumber + 1;
        maxThetaIndex = 1;
        for i=1:accNumberOfRows
            for j=1:accNumberOfCols
                if accumulator(i, j) > accumulator(maxRIndex, maxThetaIndex) && accumulator(i, j) > minimumNumberOfVotes
                    maxRIndex = i;
                    maxThetaIndex = j;
                    peakBreak = 1;
                end
            end
        end

        %Assigning the respective 'r' and 'theta' values
        rParameter = rValuesMatrix(maxRIndex);
        thetaParameter = thetaValuesMatrix(maxThetaIndex);

        %Creating 'x' and 'y' vectors with their corresponding points to be
        %plotted, and then plotting the line on the image
        x = 0:imgNumberOfCols;
        y = (rParameter - x*cosd(thetaParameter) )/ sind(thetaParameter);
        line(x, y);    
        
        %Displaying all parameters of the line extracted
        if peakBreak == 1
            fprintf('Line-%d: r = "%f", theta = "%f"\n',lineNumber, rParameter, thetaParameter)
        end
            
        %Blacking out neighbouring pixels
        for i=maxRIndex-1:maxRIndex+1
            for j=maxThetaIndex-1:maxThetaIndex+1
                if i < 1 || j < 1 || i > accNumberOfRows || j > accNumberOfCols 
                    continue
                end
                accumulator(i, j) = 0;
            end
        end

    end
    
    %% Displaying Hough Space
    subplot(1, 2, 2)
    imshow(accumulatorCopy, []);
    title('Hough Space')
end