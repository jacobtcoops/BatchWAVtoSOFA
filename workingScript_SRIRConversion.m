close all
clear

addpath('MATLAB Code/');

% convert third order files
ThirdOAIRsNormalised = ambisonicOmniConverter(  'Rotation Compensated SRIRs/NESW/',...
                                                'Rotation Compensated SRIRs/Omni/'    );
