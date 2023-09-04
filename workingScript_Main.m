%% Reset
close all;
clear;

%% Paths
SRIRPath = 'Rotation Compensated SRIRs/Omni/';
outputPath = 'Rotation Compensated SRIRs/SOFA Files/';

%% Add required paths
% MATLAB Code
addpath('MATLAB Code/');
% SOFA Toolbox
addpath('MATLAB Code/SOFAtoolbox-master/SOFAtoolbox/');
% SRIRs
addpath(SRIRPath);
% Co-ordinate Path
addpath('Maida Vale Coordinates/');

%% Start SOFA toolbox
SOFAstart();

%% Import co-ordinates
% Receiver co-ordinates
%   Read from file
listenerCoordTable = readtable( 'ListenerCoordinates.csv',...
                                "VariableNamingRule", 'preserve');
%   Convert to array
listenerPos = table2array(listenerCoordTable(1:end,2:end));
%   Number of listener positions in the co-ordinate array
noListenerPos = length(listenerPos);

% Source co-ordinates
%   Read from file
sourceCoordTable = readtable(   'SourceCoordinates.csv',...
                                "VariableNamingRule", 'preserve');
%   Convert to array
sourcePos = table2array(sourceCoordTable(1:end,2:end));
%   Number of source positions in the co-ordinate array
noSourcePos = length(sourcePos);

%% Convert co-ordinates for use with SingleRoomMIMOSRIR convention
% Create arrays to hold all combinations of source and listener positions
updatedListenerPos = NaN(noListenerPos * noSourcePos, width(listenerPos));
updatedSourcePos = NaN(noListenerPos * noSourcePos, width(listenerPos));

% Fill each array by iterating across each listener position for each
% source
for i = 1: noSourcePos
    updatedListenerPos( (i-1)*noListenerPos + 1: (i-1)*noListenerPos + ...
                        noListenerPos, :) = listenerPos;
    for j = 1:noListenerPos
        updatedSourcePos((i-1)*noListenerPos + j, :) = sourcePos(i, :);
    end
end

%% Generate SOFA file
% Create a SOFA file for each source
% ADD IN FOR LOOP FOR MULTIPLE SOURCES
for index = 1: noSourcePos
%     index = 1;
    sourcePosString = char(table2array(sourceCoordTable(index, 1)));

    outputFileName = strcat('MV4_AS2_Eigen_S_', sourcePosString, ...
        '_Omni_3OA.sofa');
    % Create array for single source positions
    
    singleSourcePos = NaN(noListenerPos, width(listenerPos));
    for i = 1: length(listenerPos)
        singleSourcePos(i, :) = sourcePos(index, :);
    end

    SOFAFile = generateSOFASingleRoomSRIR(noSourcePos, index, listenerPos, singleSourcePos, SRIRPath, outputPath, outputFileName);

end

% Create a SOFA file for all soruces
% CHECK ORDER FOR THIS - IT IS PROBABLY INCORRECT
% outputFileName_All = 'MV4_AS2_Eigen_Omni_3OA.sofa';
% object = generateSOFASingleRoomMIMOSRIR(updatedListenerPos, updatedSourcePos, SRIRPath, outputPath, outputFileName_All);