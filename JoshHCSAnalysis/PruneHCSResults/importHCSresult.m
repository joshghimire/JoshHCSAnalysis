%function [sessionResults, accessoryResults] = importHCSresult
%8.10.22, ask for input about where session document is/are
%Gets HCS session analysis results.
%Returns accessoryResults cell array with other data (name of experiement, total time doing behavior x)
%Returns sessionResults cell array with data from analysis of session (from time x to time y, animal was doing behavior z)
%Rows 10 and 11 in accessoryResults aren't important and might just need to
%get deleted.

if ~exist("fileName",'var')
    fileName = uigetfile('*.csv');
end

tempSessionResults = read_mixed_csv_HCS(fileName);
numColumns = size(tempSessionResults, 2); 

%% Make a second accessoryresults file, move sessionResults to a sessionResults variable
accessoryResults = cell(57, numColumns);                                                    %Create a new cell array for the 57 rows of non-critical/additional results.
accessoryResults(1:11, 1:end) = tempSessionResults(1:11, 1:end);                            %copy top portion of tempSessionResults to new matrix

numRowsResults = size(tempSessionResults, 1) - 57;                                          %Get the number of rows of actual results(From Frame, Length Frame, Behavrior etc.)
accessoryResults(12:end, 1:end) = tempSessionResults(( (numRowsResults+1) + 11):end, 1:end);%copy bottom portion of tempSessionResults 

sessionResults = tempSessionResults(12:(11+numRowsResults), 1:end);

%% Baking some pie charts
behavcol = sessionResults(:,4);
uniqueBehavs = unique(behavcol);
cop = uniqueBehavs; %It's used somewhere down there... I can take some time to make this a hair more efficient, but i'm lazy, and my phd apps are due this week, so I guess I'm just gonna go fuck myself...
framecounts = sessionResults(:,3);
framecounts = ConvertEveryGoddamnedStringInsideThisGoddamnedCellIntoaMotherfuckingInteger(framecounts);

for i = 1:length(uniqueBehavs)
    indicesofbehavs = strcmp(behavcol,uniqueBehavs{i});
    uniqueBehavs{i,2} = sum(framecounts(indicesofbehavs));
end

[sortedFramecounts,permutatrix] = sort(cell2mat(uniqueBehavs(:,2)),'descend');
sortedBehavs = cop(permutatrix);

figure;
FramecountPercentages = sortedFramecounts / sum(sortedFramecounts);
pie(FramecountPercentages(FramecountPercentages > .01))%, sortedBehavs(FramecountPercentages > .01));

%end



function [numbers] = ConvertEveryGoddamnedStringInsideThisGoddamnedCellIntoaMotherfuckingInteger(allStrings)
    % Holy shit...
    numbers = zeros(length(allStrings),1);
    for i = 1:length(allStrings)
        numbers(i) = str2num(allStrings{i});
    end
end

function [bigassBehavs, bigassFramecounts] = CombineHCSData()
    bigass = [hana(:); dul(:)];
end