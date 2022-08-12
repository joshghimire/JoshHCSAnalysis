function [sessionResults, accessoryResults] = importHCSresult
%8.10.22, ask for input about where session document is/are
%Gets HCS session analysis results.
%Returns accessoryResults cell array with other data (name of experiement, total time doing behavior x)
%Returns sessionResults cell array with data from analysis of session (from time x to time y, animal was doing behavior z)

clear;
close all;
tempSessionResults = readcell('ExampleHCSResultsFileFrames.csv');

%% Make a second accessoryresults file, move sessionResults to a sessionResults variable
accessoryResults = cell(57, 6); %Create a new cell array for the 56 rows of non-critical/additional results.
accessoryResults(1:11, 1:end) = tempSessionResults(1:11, 1:end);%copy top portion of tempSessionResults to new matrix

numRowsResults = size(tempSessionResults, 1) - 57; %Get the number of rows of actual results(From Frame, Length Frame, Behavrior etc.)
accessoryResults(12:end, 1:end) = tempSessionResults(( (numRowsResults+1) + 11):end, 1:end);%copy bottom portion of tempSessionResults 

sessionResults = tempSessionResults(12:(11+numRowsResults), 1:end);
end
