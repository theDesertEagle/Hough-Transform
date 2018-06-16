# Hough-Transform for Line Detection
A voting-based computer vision algorithm to estimate the parameters of straight lines present in an image. This algorithm can be useful to detect lane-markers on the road, which are essentially a set of lines in the rudimentary form.

## Instructions
Run `houghTransformLines(minimumNumberOfVotes)` in the MATLAB terminal where `minimumNumberOfVotes` is a user-dependent input that provides the minimum threshold that must be attained to confirm the detection of lines for the pair of line parameters. The recommended value for the minimum number of votes is 100 for the sample image.

## Implementation Overview
A simple line in is represented by the standard equation in polar coordinate system: </br>
x.cos(&theta;) + y.sin(&theta;) = r  ; where 'r' and '&theta;' are the parameters of the line, in the Hough Space. </br>

It is to be noted that a standard slope-intercept equation form, y = m.x + b (where the slope 'm' and y-intercept 'y' are line parameters) is avoided since vertical lines will not be detected due to the inherent problems associated with slope for vertical lines.   

The following steps were used to detect 
1. The Hough Space is defined as  an accumulator 2D-array which records the counts of the achieved votes for all given pairs of parameters (r, &theta;), and whose size is determined by the resolution of the parameters. For this application, the resolution for 'r' is 1 unit and '&theta;' is 1&deg;. 
2. Thresholding and Line-thinning is performed on the image to get the foundation-structure (edge-elements) for all present image objects.
3. For each edge-element, 1 vote is incremented in the accumulator for all possible-lines in the image, based on the pair of their respective parameters 'r' and '&theta;'.
4. All peaks in the Hough Space are extracted from the image, the line-parameters of which are displayed on the terminal.
5. The line-parameters are used to draw the detected lines by the algorithm.

## Observations
### Binarized Input Image
![Input Image](/line.gif)

### Lines Detected by Hough Transform
The blue-lines highlight the detected-lines which are plotted using their estimated parameters. 
![Sample Output](/sampleOutput.PNG)

### Parameters for Detected Lines
The terminal lists the estimate parameters for all detected lines.
![Console Output](/consoleOutput.PNG)

### Peaks in the Hough Space
The tiny and whitest dots represent the peaks of the Hough Space, which is essentially the visual representation of the accumulator array.

![Hough Space](/houghSpace.PNG)

## Limitations
1. The preprocessing of input-images may be crucial for detecting the required set of lines accurately.
2. The user would have to manually find a suitable threshold to detect a required number of lines based on his/her requirement.

## @the.desert.eagle
