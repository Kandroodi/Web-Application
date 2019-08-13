% 
% 
% Mojtaba Rostami Kandroodi
% Start date:      11 August 2019
% Last Updatre:    11 August 2019
%__________________________________________________________________________
clc; clear all; close all;
%% Import data
Newspapers = readtable('Papers.xlsx','ReadVariableNames',false);
% Add Variable Names
Newspapers.Properties.VariableNames = {'PublisherName', 'Number', 'Year', 'City'};

Articles = readtable('articles.xlsx','ReadVariableNames',false);
% Add Variable Names
Articles.Properties.VariableNames = {'RowNo', 'PublisherName', 'NewspaperYearNumber', 'ArticleTopic'};

%% Data cleaning and preparation
% Creat Publisher Table
PublisherName = table2array(unique(Newspapers(:,1)));
StartNumberPubID = 100;
PublisherID      = StartNumberPubID + [1:length(PublisherName)];
PublisherTable   = table(PublisherID',PublisherName,'VariableNames',{'PublisherID','Name'}); 

% Creat Newspaper Table
StartNumberNewsID  = 10000;
NewspaperID        = table(StartNumberNewsID + [1:height(Newspapers)]','VariableNames',{'NewspaperID'});
NewsTable = join(Newspapers,PublisherTable,'LeftKeys','PublisherName','RightKeys','Name');
NewsTable = [NewsTable NewspaperID];
NewspaperTable   = NewsTable(: ,{'NewspaperID', 'PublisherID', 'Number', 'Year', 'City'});

% Creat Article Table
PublisherNameInArticle = unique(Articles(:,2));
% Note: Next line is hard-coded but in general it can be replaced by an automatic
% function to find different names that related to a specific Publisher name
CorrectionTablePublisher = [table([101, 101, 101, 101, 102, 102, 102, 102, 103, 103, 103, 104, 104, 104, 104]','VariableNames',{'PublisherID'}), PublisherNameInArticle];
StartNumberArtID  = 1000000;
ArticleID         = table(StartNumberArtID + [1:height(Articles)]','VariableNames',{'ArticleID'});
ArtTable          = [join(Articles,CorrectionTablePublisher,'LeftKeys','PublisherName','RightKeys','PublisherName'), ArticleID];
% Separate Year No
YN = table2array(ArtTable(:,3));
[YEAR,remain] = strtok(YN, ':');
[NO,m] = strtok(remain, ':');
YEA = str2double(YEAR);
NNO = str2double(NO);
YEAR         = table(YEA,'VariableNames',{'Year2'});
NO         = table(NNO,'VariableNames',{'No'});
ArtTable = [ArtTable YEAR NO];
ArtTable2          = join(ArtTable,NewspaperTable,'LeftKeys',{'PublisherID','No', 'Year2'},'RightKeys',{'PublisherID', 'Number', 'Year'});
ArticleTable       = ArtTable2(:,{'ArticleID', 'NewspaperID', 'ArticleTopic'});


