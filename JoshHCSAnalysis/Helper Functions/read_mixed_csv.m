function lineArray = read_mixed_csv(fileName,delimiter)
% copied from http://stackoverflow.com/questions/4747834/import-csv-file-with-mixed-data-types
% Brendon Watson 2014

tempSessionResults = readcell(fileName);
numRowsinHCSresultsFile = size(tempSessionResults,1);   %The number of rows found in HCS results File.
numRowsinHCSresultsFile = numRowsinHCSresultsFile + 10; %Add a few more rows to help with next steps. 
clear("tempSessionResults");                            %Deleting this instead of using this as a pre-allocated cell aray for lineArray to make troubleshooting a little easier.

if ~exist('delimiter','var')
    delimiter = ',';
end

  fid = fopen(fileName,'r');   %# Open the file
  lineArray = cell(numRowsinHCSresultsFile,1);     %# Preallocate a cell array (ideally slightly
                               %#   larger than is needed)
  lineIndex = 1;               %# Index of cell to place the next line in
  nextLine = fgetl(fid);       %# Read the first line from the file
  while ~isequal(nextLine,-1)         %# Loop while not at the end of the file
    lineArray{lineIndex} = nextLine;  %# Add the line to the cell array
    lineIndex = lineIndex+1;          %# Increment the line index
    nextLine = fgetl(fid);            %# Read the next line from the file
  end
  fclose(fid);                 %# Close the file

  emptyRowsinlineArray = find(cellfun('isempty', lineArray)); %find the empty rows in cell lineArray
  lineArray = lineArray(1:lineIndex-1);                 %# Remove empty cells, if needed(This only removes the "[]" in lineArray)
  lineArray(emptyRowsinlineArray,:) = [];            % Josh_8.31.22 Actually delete the empty rows. 
  
  for iLine = 1:lineIndex-1              %# Loop over lines
    lineData = textscan(lineArray{iLine},'%s',...  %# Read strings
                        'Delimiter',delimiter);
    lineData = lineData{1};              %# Remove cell encapsulation
    if strcmp(lineArray{iLine}(end),delimiter)  %# Account for when the line
      lineData{end+1} = '';                     %#   ends with a delimiter
    end
    lineArray(iLine,1:numel(lineData)) = lineData;  %# Overwrite line data
  end