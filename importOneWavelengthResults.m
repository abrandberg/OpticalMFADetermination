function imCollector = importOneWavelengthResults(targetDir)

fileNames = subdirImport(targetDir,'regex','png');

for xLoop = 1:numel(fileNames)
   
    % Import the image
    % Convert to gray scale
    imCollector(xLoop).raw = imread(horzcat(targetDir,'\',fileNames{xLoop}));
    imCollector(xLoop).gray = rgb2gray(imCollector(xLoop).raw);
    
    imCollector(xLoop).grayFiltered = imCollector(xLoop).gray;
    imCollector(xLoop).grayFiltered(imCollector(xLoop).grayFiltered<1) = NaN;
    imCollector(xLoop).grayFiltered(imCollector(xLoop).grayFiltered>254) = NaN;
end
    