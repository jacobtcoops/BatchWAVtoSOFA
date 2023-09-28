%% Reset
close all;
clear;

%% Paths
% Input omnidirectional SRIRs
omniSRIRPath = ['D:\_RESOURCE\MaidaVale-IRs\230928-N3D-Omni-All\MV4\' ...
    'AS2\AS2\TOA\'];
% Output SingleRoomSRIRs
outputPath_Single = 'D:\_RESOURCE\MaidaVale-IRs\SOFA\MV4\SingleRoomSRIR\';
% Output SingleRoomMIMOSRIR
outputPath_SingleMIMO = ['D:\_RESOURCE\MaidaVale-IRs\SOFA\MV4\' ...
    'SingleRoomMIMOSRIR\'];

%% Add required paths
% MATLAB Code
addpath('MATLAB Code/');
% SOFA Toolbox
addpath(['D:\GitHub-Directory\BatchWAVtoSOFA\externals\SOFAtoolbox\' ...
    'SOFAtoolbox\']);
%Iinput omni SRIRs
addpath(omniSRIRPath);
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
MIMOListenerPos = NaN(noListenerPos * noSourcePos, width(listenerPos));
MIMOSourcePos = NaN(noListenerPos * noSourcePos, width(listenerPos));

% Fill each array by iterating across each listener position for each
% source
for i = 1: noSourcePos
    MIMOListenerPos( (i-1)*noListenerPos + 1: (i-1)*noListenerPos + ...
                        noListenerPos, :) = listenerPos;
    for j = 1:noListenerPos
        MIMOSourcePos((i-1)*noListenerPos + j, :) = sourcePos(i, :);
    end
end

%% Generate SOFA file
% Create a SingleRoomSRIRSOFA file for each source

% For each source
for index = 1: noSourcePos

    sourcePosString = char(table2array(sourceCoordTable(index, 1)));

    outputFileNameSingle = strcat('MV4_AS2_Eigen_S_', sourcePosString, ...
        '_Omni_3OA.sofa');

    % Create array for single source positions
    singleSourcePos = NaN(noListenerPos, width(listenerPos));
    for i = 1: length(listenerPos)
        singleSourcePos(i, :) = sourcePos(index, :);
    end

    SOFAFile = generateSOFASingleRoomSRIR(noSourcePos, index, ...
        listenerPos, singleSourcePos, omniSRIRPath, outputPath_Single, ...
        outputFileNameSingle);
end

% Create a SingleRoomMIMOSRIR SOFA file for all sources
outputFileName_SingleMIMO = 'MV4_AS2_Eigen_Omni_3OA.sofa';
object = generateSOFASingleRoomMIMOSRIR(MIMOListenerPos, MIMOSourcePos, ...
    omniSRIRPath, outputPath_SingleMIMO, outputFileName_SingleMIMO);
