function [outputIR, Fs] = NESWtoOmni(northFileName, eastFileName,...
    southFileName, westFileName)
% NEWStoOmni    sums and normalises IR inputs
%   function takes the file names (including relative paths) of SIRs 
%   recorded from a single source-receiver combination with four source 
%   orientations
%   these are summed and normalised to simulate the IR for an
%   onmidirectional source
%   this will work for any number of channels, provided they are the same
%   for each audio file
%   INPUTS
%       northFileName       file name and relative path for the north SIR
%       eastFileName        file name and relative path for the east SIR
%       southFileName       file name and relative path for the south SIR
%       westFileName        file name and relative path for the west SIR
%   OUTPUTS
%       outputIR            output IR stored as a matrix
%       Fs                  sample rate for SIR

    % load in requried audio files
    [north, Fs] = audioread(northFileName);
    [east, FsE] = audioread(eastFileName);
    [south, FsS] = audioread(southFileName);
    [west, FsW] = audioread(westFileName);

    % check sample rates all match
    if FsE ~= Fs || FsS ~= Fs || FsW ~= Fs
        error('Error: Sample rates of audio files do not match.');
    end

    % check number of channels match
    if width(north) ~= width(east) || width(north) ~= width(south) || ...
        width(north) ~= width(west)
        error('Error: Audio files have different numbers of channels.');
    end

    % check length of files match
    if length(north) ~= length(east) || length(north) ~= length(south) || ...
        length(north) ~= length(west)
        error('Error: Audio files lengths do not match.');
    end

    % sum audio
    outputIR = north + south + east + west;
end