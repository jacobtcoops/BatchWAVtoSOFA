function [SOFA] = generateSOFASingleRoomSRIR(totalSources, sourceNumber, listenerPos, sourcePos, SRIRPath, outputPath, outputFileName)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
%   OMNI

%% Get empty conventions structure for SingleRoomSRIR
Obj = SOFAgetConventions('SingleRoomSRIR');

%% Coordinates
% Combinations of listener and source positions
%   This will be the height of either the listenerPos array or the
%   sourcePos array (both will be the same)
ListenerSourceCombs = height(listenerPos);

%% Import .wav files
% place all .wav files in structs
fileStruct = dir(fullfile(SRIRPath,'*.wav'));

%% Metadata, as defined by the AES standard for file exchange

%% General Metadata
Obj.GLOBAL_Conventions = 'SOFA';
Obj.GLOBAL_Version = '2.1';
Obj.GLOBAL_SOFAConventions = 'SingleRoomSRIR';
% DEFAULT VALUES
% Obj.GLOBAL_SOFAConventionsVersion = '1.0';
Obj.GLOBAL_DataType = 'FIR';
Obj.GLOBAL_RoomType = 'reverberant';
Obj.GLOBAL_Title = 'BBC Maida Vale Impulse Response Dataset';
% DEFAULT VALUES
% Obj.GLOBAL_DateCreated = '2023-09-28, 11:00:00';
% Obj.GLOBAL_DateModified = datestr(now, 'yyyy-mm-dd HH:MM:SS');
% DEFAULT VALUES
% Obj.GLOBAL_APIName = 'SOFA Toolbox for Matlab/Octave';
% Obj.GLOBAL_APIVersion = '2.2.0';
Obj.GLOBAL_AuthorContact = 'gavin.kearney@york.ac.uk';
Obj.GLOBAL_Organization = 'University of York';
Obj.GLOBAL_License = ['You may not use this work except in compliance with ' ...
    'the Apache License, Version 2.0. You may obtain a copy of the ' ...
    'license from the AMT directory "licences" and at: ' ...
    'http://www.apache.org/licenses/LICENSE-2.0 Unless required by ' ...
    'applicable law or agreed to in writing, softwaredistributed ' ...
    'under the License is distributed on an "AS IS" BASIS, WITHOUT ' ...
    'WARRANTIES OR CONDITIONS OF ANY KIND, either express or ' ...
    'implied. See the License for the specific language governing ' ...
    'permissions and limitations under the License.'];
Obj.GLOBAL_ApplicationName = 'MathWorks MATLAB';
Obj.GLOBAL_ApplicationVersion = '9.13.0.2105380 (R2022b Update 2)';
Obj.GLOBAL_Comment = ['The measurements were undertaken in Summer/' ...
    'Autumn 2021 by researchers from the University of York, led by ' ... 
    'Prof Gavin Kearney and Prof Helena Daffern and team members of ' ...
    'BBC R&D. The measured studio live rooms presented here are ' ...
    'studios MV4 and MV5. The dataset for each room includes Higher ' ...
    'Order Ambisonic (3rd Order) spatial impulse responses for 3DOF/'...
    '6DOF rendering.'];
Obj.GLOBAL_History = 'Original dataset, as described in reference paper';
Obj.GLOBAL_References = ['Kearney, G., Daffern, H., Cairns, P., Hunt, ' ...
    'A., Lee, B., Cooper, J., Tsagkarakis, P., Rudzki, T. and ' ...
    'Johnston, D., 2022, September. Measuring the Acoustical ' ...
    'Properties of the BBC Maida Vale Recording Studios for Virtual ' ...
    'Reality. In Acoustics (Vol. 4, No. 3, pp. 783-799). MDPI.'];
Obj.GLOBAL_Origin = 'MH Acoustics Eigenmike SRIRs';

%% Convention-Specific Metadata
Obj.GLOBAL_DatabaseName = 'BBC Maida Vale Impulse Response Dataset';

%% Listener Metadata
% THE FOLLOWING ARE NOT REQUIRED
% Obj.ListenerShortName =
% Obj.ListenerDescription = 
Obj.ListenerPosition = listenerPos;
% DEFAULT VALUES
% Obj.ListenerPosition_Type = 'cartesian';
% Obj.ListenerPosition_Units = 'metre';
% DEFAULT VALUES
% % Defines the positive x-axis of the respective local coordinate system
% Obj.ListenerView = [1, 0, 0];
% % Defines the positive z-axis of the respectivelocal coordinate system
% Obj.ListenerUp = [0, 0, 1];
% Obj.ListenerView:Type = 'cartesian';
% Obj.ListenerView:Units = 'metre';

%% Receiver Metadata
% THE FOLLOWING ARE NOT REQUIRED
% ReceiverShortName = 
% ReceiverDescriptions = 
AmbisonicOrder = 3;
L = AmbisonicOrder;
R = (L + 1)^2;
Obj.ReceiverPosition = zeros(R, 3);
Obj.ReceiverPosition_Type = 'cartesian';
Obj.ReceiverPosition_Units = 'metre';
% THE FOLLOWING ARE NOT REQUIRED
% Obj.ReceiverView = 
% Obj.ReceiverUp = 
% Obj.ReceiverView_Type = 
% Obj.ReceiverView_Units = 

%% Source Metadata
% THE FOLLOWING ARE NOT REQUIRED
% Obj.SourceShortName = 
% Obj.SourceDescription = 
Obj.SourcePosition = sourcePos;
% DEFAULT VALUES
% Obj.SourcePosition_Type = 'cartesian';
% Obj.SourcePosition_Units = 'metre';
% DEFAULT VALUES
% Obj.SourceView = [1, 0, 0];
% Obj.SourceUp = [0, 0, 1];
% Obj.SourceView_Type = 'cartesian';
% Obj.SourceView_Units = 'metre';

%% Emitter Metadata
% THE FOLLOWING ARE NOT REQUIRED
% Obj.EmitterShortName = 
% Obj.EmitterDescriptions = 
% Default values
Obj.EmitterPosition = [0, 0, 0];
% Obj.EmitterPosition_Type = 'cartesian';
% Obj.EmitterPosition_Units = 'metre';
% THE FOLLOWING ARE NOT REQUIRED
% Obj.EmitterView = 
% Obj.EmitterUp = 
% Obj.EmitterView_Type = 
% Obj.EmitterView_Units = 

%% Room Metadata
% Obj.RoomShortName = 
Obj.GLOBAL_RoomDescription = 'Please see publication for full details';
% Obj.RoomLocation = 
% Obj.RoomTemperature = 
% Obj.RoomTemperature:Units = 
% Obj.RoomGeometry = 
% Obj.RoomVolume = 
% Obj.RoomVolume:Units = 'cubic metre';
% Obj.RoomCornerA = 
% Obj.RoomCornerB = 
% Obj.RoomCorners:Type = 
% Obj.RoomCorners:Units = 

%% API Values

% Omni responses used - only one direction for each source and listener
SourceOrientations = 1;
ListenerOritentations = 1;

% Number of measurements
M = ListenerSourceCombs * SourceOrientations * ListenerOritentations;

% Number of emitters
E = height(Obj.EmitterPosition);

% Read in first audio file to get sample rate and length
[sampleAudio, Fs] = audioread(strcat(SRIRPath, fileStruct(1).name));
N = length(sampleAudio);

% Set API values
Obj.API.M = M;
Obj.API.R = R;
Obj.API.E = E;
Obj.API.N = N;

% Set sample rate value
Obj.Data.SamplingRate = Fs;

%% Data

% Initialise IR array
Obj.Data.IR = NaN(M, R, N);

for i = 1: M
    % Add each wav file
    [audio, ~] = audioread(strcat(SRIRPath, fileStruct((i-1)*totalSources+sourceNumber,1).name));
    Obj.Data.IR(i, :, :) = audio';

    % Display progress
    % disp(fileStruct((i-1)*totalSources+sourceNumber,1).name);
    % disp(strcat('Listener Position: ', num2str(listenerPos(i,1)), ', ', num2str(listenerPos(i,2)), ', ', num2str(listenerPos(i,3))));
    % disp(strcat('Source Position: ', num2str(sourcePos(i,1)), ', ', num2str(sourcePos(i,2)), ', ', num2str(sourcePos(i,3))));

end

% Set all delays to zero
Obj.Data.Delay = zeros(1, R);

%% Write SOFA file
compression = 0;
disp(['Saving: ' outputFileName]);
SOFA = SOFAsave(strcat(outputPath, outputFileName), Obj, compression);

end