%% Reset
close all;
clear;

%% Paths
% MV4
%   Input omnidirectional SRIRs
MV4_omniSRIRPath = ['D:\_RESOURCE\MaidaVale-IRs\230928-N3D-Omni-All\MV4\' ...
    'AS2\AS2\TOA\'];
%   Output SingleRoomSRIRs
MV4_outputPath_Single = 'D:\_RESOURCE\MaidaVale-IRs\SOFA\MV4\SingleRoomSRIR\';
%   Output SingleRoomMIMOSRIR
MV4_outputPath_SingleMIMO = ['D:\_RESOURCE\MaidaVale-IRs\SOFA\MV4\' ...
    'SingleRoomMIMOSRIR\'];
% MV5
%   Input omnidirectional SRIRs
MV5_omniSRIRPath = ['D:\_RESOURCE\MaidaVale-IRs\230928-N3D-Omni-All\MV5\' ...
    'AS1\AS1\TOA\'];
%   Output SingleRoomSRIRs
MV5_outputPath_Single = ['D:\_RESOURCE\MaidaVale-IRs\SOFA\MV5\' ...
    'SingleRoomSRIR\'];
%   Output SingleRoomMIMOSRIR
MV5_outputPath_SingleMIMO = ['D:\_RESOURCE\MaidaVale-IRs\SOFA\MV5\' ...
    'SingleRoomMIMOSRIR\'];

%% Add required paths
% MATLAB Code
addpath('MATLAB Code\');
% SOFA Toolbox
addpath('externals\SOFAtoolbox\SOFAtoolbox\');
% Co-ordinate Path
addpath('D:\_RESOURCE\MaidaVale-IRs\Maida-Vale-Coordinates\');

%% Start SOFA toolbox
SOFAstart();

%% Import co-ordinates
%% MV4
% Receiver co-ordinates
%   Read from file
MV4_listenerCoordTable = readtable( 'MV4_ListenerCoordinates.csv',...
                                "VariableNamingRule", 'preserve');
%   Convert to array
MV4_listenerPos = table2array(MV4_listenerCoordTable(1:end,2:end));
%   Number of listener positions in the co-ordinate array
MV4_noListenerPos = length(MV4_listenerPos);

% Source co-ordinates
%   Read from file
MV4_sourceCoordTable = readtable(   'MV4_SourceCoordinates.csv',...
                                "VariableNamingRule", 'preserve');
%   Convert to array
MV4_sourcePos = table2array(MV4_sourceCoordTable(1:end,2:end));
%   Number of source positions in the co-ordinate array
MV4_noSourcePos = length(MV4_sourcePos);
%% MV5
% Receiver co-ordinates
%   Read from file
MV5_listenerCoordTable = readtable( 'MV5_ListenerCoordinates.csv',...
                                "VariableNamingRule", 'preserve');
%   Convert to array
MV5_listenerPos = table2array(MV5_listenerCoordTable(1:end,2:end));
%   Number of listener positions in the co-ordinate array
MV5_noListenerPos = length(MV5_listenerPos);

% Source co-ordinates
%   Read from file
MV5_sourceCoordTable = readtable(   'MV5_SourceCoordinates.csv',...
                                "VariableNamingRule", 'preserve');
%   Convert to array
MV5_sourcePos = table2array(MV5_sourceCoordTable(1:end,2:end));
%   Number of source positions in the co-ordinate array
MV5_noSourcePos = length(MV5_sourcePos);

%% Convert co-ordinates for use with SingleRoomMIMOSRIR convention
%% MV4
% Create arrays to hold all combinations of source and listener positions
MV4_MIMOListenerPos = NaN(MV4_noListenerPos * MV4_noSourcePos, width(MV4_listenerPos));
MV4_MIMOSourcePos = NaN(MV4_noListenerPos * MV4_noSourcePos, width(MV4_listenerPos));

% Fill each array by iterating across each listener position for each
% source
for i = 1: MV4_noSourcePos
    MV4_MIMOListenerPos( (i-1)*MV4_noListenerPos + 1: (i-1)*MV4_noListenerPos + ...
                        MV4_noListenerPos, :) = MV4_listenerPos;
    for j = 1:MV4_noListenerPos
        MV4_MIMOSourcePos((i-1)*MV4_noListenerPos + j, :) = MV4_sourcePos(i, :);
    end
end
%% MV5
% Create arrays to hold all combinations of source and listener positions
MV5_MIMOListenerPos = NaN(MV5_noListenerPos * MV5_noSourcePos, width(MV5_listenerPos));
MV5_MIMOSourcePos = NaN(MV5_noListenerPos * MV5_noSourcePos, width(MV5_listenerPos));

% Fill each array by iterating across each listener position for each
% source
for i = 1: MV5_noSourcePos
    MV5_MIMOListenerPos( (i-1)*MV5_noListenerPos + 1: (i-1)*MV5_noListenerPos + ...
                        MV5_noListenerPos, :) = MV5_listenerPos;
    for j = 1:MV5_noListenerPos
        MV5_MIMOSourcePos((i-1)*MV5_noListenerPos + j, :) = MV5_sourcePos(i, :);
    end
end

%% Generate SOFA file
% Create a SingleRoomSRIRSOFA file for each source
%% MV4
% For each source
for index = 1: MV4_noSourcePos

    MV4_sourcePosString = char(table2array(MV4_sourceCoordTable(index, 1)));

    MV4_outputFileNameSingle = strcat('MV4_AS2_Eigen_S_', MV4_sourcePosString, ...
        '_Omni_3OA.sofa');

    % Create array for single source positions
    MV4_singleSourcePos = NaN(MV4_noListenerPos, width(MV4_listenerPos));
    for i = 1: length(MV4_listenerPos)
        MV4_singleSourcePos(i, :) = MV4_sourcePos(index, :);
    end

    generateSOFASingleRoomSRIR(MV4_noSourcePos, index, ...
        MV4_listenerPos, MV4_singleSourcePos, MV4_omniSRIRPath, MV4_outputPath_Single, ...
        MV4_outputFileNameSingle);
end

% Create a SingleRoomMIMOSRIR SOFA file for all sources
MV4_outputFileName_SingleMIMO = 'MV4_AS2_Eigen_Omni_3OA.sofa';
generateSOFASingleRoomMIMOSRIR(MV4_MIMOListenerPos, MV4_MIMOSourcePos, ...
    MV4_omniSRIRPath, MV4_outputPath_SingleMIMO, MV4_outputFileName_SingleMIMO);

%% MV5
% For each source
for index = 1: MV5_noSourcePos

    MV5_sourcePosString = char(table2array(MV5_sourceCoordTable(index, 1)));

    MV5_outputFileNameSingle = strcat('MV5_AS2_Eigen_S_', MV5_sourcePosString, ...
        '_Omni_3OA.sofa');

    % Create array for single source positions
    MV5_singleSourcePos = NaN(MV5_noListenerPos, width(MV5_listenerPos));
    for i = 1: length(MV5_listenerPos)
        MV5_singleSourcePos(i, :) = MV5_sourcePos(index, :);
    end

    generateSOFASingleRoomSRIR(MV5_noSourcePos, index, ...
        MV5_listenerPos, MV5_singleSourcePos, MV5_omniSRIRPath, MV5_outputPath_Single, ...
        MV5_outputFileNameSingle);
end

% Create a SingleRoomMIMOSRIR SOFA file for all sources
MV5_outputFileName_SingleMIMO = 'MV5_AS2_Eigen_Omni_3OA.sofa';
generateSOFASingleRoomMIMOSRIR(MV5_MIMOListenerPos, MV5_MIMOSourcePos, ...
    MV5_omniSRIRPath, MV5_outputPath_SingleMIMO, MV5_outputFileName_SingleMIMO);