function [Obj] = generateSOFASingleRoomSRIR(totalSources, sourceNumber, listenerPos, sourcePos, SRIRPath, outputPath, outputFileName)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

%% Get empty conventions structure for SingleRoomSRIR
Obj = SOFAgetConventions('SingleRoomSRIR');

%% Coordinates
% REMOVE COMMENTED CODE AND UPDATE SINGLE ROOM SRIR TO REFLECT
% % Number of source and listener positions required
% NoListenerPositions = height(listenerPos);
% %   Source positions = 1 gives a SOFA file for each source
% NoSourcePositions = height(sourcePos);
%   Combinations of listener and source positions
ListenerSourceCombs = height(listenerPos);

%% Import .wav files
% place all .wav files in structs
fileStruct = dir(fullfile(SRIRPath,'*.wav'));

%% Metadata, as defined by the AES standard for file exchange

%% General Metadata
% Deafult values
% GLOBAL_Conventions = 'SOFA';
% GLOBAL_Version = '2.1';
% GLOBAL_SOFAConventions = 'SingleRoomSRIR';
% CHECK THIS - Alternative value - default value is 1.0
% Obj.GLOBAL_SOFAConventionsVersion = '1.1';
% Default values
% GLOBAL_DataType = 'FIR';
Obj.GLOBAL_RoomType = 'dae';
Obj.GLOBAL_Title = 'BBC Maida Vale Impulse Response Dataset';
% Default values
% Obj.GLOBAL_DateCreated = '2023-03-16, 11:01:00';
% Date modified set by SOFAsave code
% Obj.GLOBAL_DateModified = datestr(now, 'yyyy-mm-dd HH:MM:SS');
% Default values
% Obj.GLOBAL_APIName = 'SOFA Toolbox for Matlab/Octave';
% Obj.GLOBAL_APIVersion = '2.1.4';
Obj.GLOBAL_AuthorContact = 'gavin.kearney@york.ac.uk';
Obj.GLOBAL_Organization = 'University of York';
Obj.GLOBAL_License = ['Creative Commons (CC-BY 3.0). Visit http://'...
    'https://creativecommons.org/licenses/by/3.0/ for licence details.'];
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
% Obj.ListenerShortName = 'Eigenmike'
% Obj.ListenerDescription = 
Obj.ListenerPosition = listenerPos;
% Default values
% Obj.ListenerPosition_Type = 'cartesian';
% Obj.ListenerPosition_Units = 'metre';
% THE FOLLOWING ARE NOT REQUIRED
% % Defines the positive x-axis of the respective local coordinate system
% Obj.ListenerView = [1, 0, 0];
% % Defines the positive z-axis of the respectivelocal coordinate system
% Obj.ListenerUp = [0, 0, 1];
% Obj.ListenerView:Type = 'cartesian';
% Obj.ListenerView:Units = 'metre';

%% Receiver Metadata
% THE FOLLOWING ARE NOT REQUIRED
% ReceiverShortName = 'Eigenmike Capsules';
% ReceiverDescriptions = 
% TODO - Check this...
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
% TODO
Obj.SourcePosition = sourcePos;
%disp(sourcePos);
%Obj.SourcePosition = [0, 0, 0];
% Default values
% Obj.SourcePosition_Type = 'cartesian';
% Obj.SourcePosition_Units = 'metre';
% Default values
Obj.SourceView = [1, 0, 0];
Obj.SourceUp = [0, 0, 1];
Obj.SourceView_Type = 'cartesian';
Obj.SourceView_Units = 'metre';

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
% TODO - Check if info is necessary given the dae file
% Obj.RoomShortName = 
% Obj.RoomDescription = 
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

SourceOrientations = 1;
ListenerOritentations = 1;

M = ListenerSourceCombs * SourceOrientations * ...
    ListenerOritentations;

% disp(M);

Obj.API.M = M;
Obj.API.R = R;

E = height(Obj.EmitterPosition);

Obj.API.E = E;

% TODO - Remove this
[sampleAudio, Fs] = audioread(strcat(SRIRPath, 'MV4_AS2_Eigen_R_OA-01_S_PA-03_Omni_3OA.wav'));

N = length(sampleAudio);

Obj.API.N = N;

%% Data

Obj.Data.IR = NaN(M, R, N);

for i = 1: M
    
    [audio, ~] = audioread(strcat(SRIRPath, fileStruct((i-1)*totalSources+sourceNumber,1).name));

%     disp((i-1)*totalSources+sourceNumber);

    % OLD - DELETE THIS LINE
    %[audio, ~] = audioread(strcat(SRIRPath, fileStruct(i,1).name));

    disp(fileStruct((i-1)*totalSources+sourceNumber,1).name);

    disp(strcat('Listener Position: ', num2str(listenerPos(i,1)), ', ', num2str(listenerPos(i,2)), ', ', num2str(listenerPos(i,3))));
    disp(strcat('Source Position: ', num2str(sourcePos(i,1)), ', ', num2str(sourcePos(i,2)), ', ', num2str(sourcePos(i,3))));

%     if i == 1 || i == 21
%         disp(listenerPos(i, :));
%         disp(fileStruct(i,1).name);
%     end
   
    Obj.Data.IR(i, :, :) = audio';

end

% Should this be M rather than R?
Obj.Data.Delay = zeros(1, R);

%% Write SOFA file
% TODO - Come up with output file name

% Remove this when done - in SOFAsave code
% Obj=SOFAupdateDimensions(Obj, 'verbose', 1);

compression = 0;

disp(['Saving: ' outputFileName]);

Obj = SOFAsave(strcat(outputPath, outputFileName), Obj, compression);


end