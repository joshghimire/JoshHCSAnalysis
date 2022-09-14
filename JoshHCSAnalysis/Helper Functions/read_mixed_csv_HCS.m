function lineArray = read_mixed_csv_HCS(fileName,delimiter)
% copied from http://stackoverflow.com/questions/4747834/import-csv-file-with-mixed-data-types
% Brendon Watson 2014
% Edited for HomeCageScan Josh Ghimire 2022

tic
tempSessionResults = readcell(fileName);
numRowsinHCSresultsFile = size(tempSessionResults,1);   %The number of rows found in the HomeCageScan results file.
clear("tempSessionResults");                            %Deleting this instead of using this as a pre-allocated cell aray for lineArray to make troubleshooting a little easier.

if ~exist('delimiter','var')
    delimiter = ',';
end

  fid = fopen(fileName,'r');   %# Open the file
  lineArray = cell(numRowsinHCSresultsFile,1);     %# Preallocate a cell array (ideally slightly
                               %#   larger than is needed)
                               % Josh- I'm preallocating the exact #rows.
                         
  lineIndex = 1;               %# Index of cell to place the next line in
  nextLine = fgetl(fid);       %# Read the first line from the file
  while ~isequal(nextLine,-1)         %# Loop while not at the end of the file
    lineArray{lineIndex} = nextLine;  %# Add the line to the cell array
    lineIndex = lineIndex+1;          %# Increment the line index
    nextLine = fgetl(fid);            %# Read the next line from the file
  end
  fclose(fid);                 %# Close the file
  
 
  lineArray = lineArray(~cellfun('isempty', lineArray));                    %Use 'isempty' function on lineArray to get the rows where lineArray is NOT empty. AKA remove the empty ([]) rows in line Array.
  
  for iLine = 1:((lineIndex-1)-2)              %# Loop over lines. HCS results always have 2 extra blank lines that need to be accounted for.
    lineData = textscan(lineArray{iLine},'%s',...  %# Read strings
                        'Delimiter',delimiter);
    lineData = lineData{1};              %# Remove cell encapsulation
    if strcmp(lineArray{iLine}(end),delimiter)  %# Account for when the line
      lineData{end+1} = '';                     %#   ends with a delimiter
    end
    lineArray(iLine,1:numel(lineData)) = lineData;  %# Overwrite line data
  end
  toc