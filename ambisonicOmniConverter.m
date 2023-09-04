function outputIRsNormalised = ambisonicOmniConverter(rawIRPath, processedIRPath)
%ambisonicOmniConverter     converts folder of SIRs to omnidirectional
%   function takes in a path and converts groups of four SIRs from a single
%   source-receiver combination with 4 orientations to a single,
%   omnidirectional SIR
%   this interfaces with the function NESWtoOmni.m
%   the resultant SIRs are saved in the processedIRPath
%   INPUT
%       rawIRPath           relative path for raw SIRs
%       processedIRPath     relative path for processed SIRs
%   OUTPUT
%       outputIRsNormalised onmidirectional SIRs that have been normalised
%                           relative to one another

    % add in required paths
    %   add in raw audio files to project
    addpath(rawIRPath);
    %   add in directory for processed audio files
    addpath(processedIRPath);
    
    % place all .wav files in structs
    fileStruct = dir(fullfile(rawIRPath,'*.wav'));
    
    % loop through audio files in groups of four
    %   this assumes appropriate naming of files (i.e. N, E, S and W are
    %   located together) and that no other files are present
    %   note:   some primitive error checking is present, however this is 
    %           by no means exhaustive
    for i = 1: length(fileStruct)/4
    
        % put file names in a matrix
        fileNames = [   fileStruct(4*(i-1)+1).name;...
                        fileStruct(4*(i-1)+2).name;...
                        fileStruct(4*(i-1)+3).name;...
                        fileStruct(4*(i-1)+4).name      ];
    
        % locate the north, east, south and west files and assign to
        % variables
        for k = 1: size(fileNames, 1)
                if fileNames(k, end - 8) == 'N'
                    northFileName = strcat(rawIRPath, fileNames(k, :));
                elseif fileNames(k, end - 8) == 'E'
                    eastFileName = strcat(rawIRPath, fileNames(k, :));
                elseif fileNames(k, end - 8) == 'S'
                    southFileName = strcat(rawIRPath, fileNames(k, :));
                elseif fileNames(k, end - 8) == 'W'
                    westFileName = strcat(rawIRPath, fileNames(k, :));
                else
                    % throw error if the file name does not have an 'N', 
                    % 'E', 'S' or 'W' in the expected location
                    error('File names not in the correct format.');
                end
        end
    
        % convert the audio file to omnidirectional
        [outputIRs{i}, Fs] = NESWtoOmni(    northFileName, eastFileName, ...
                                            southFileName, westFileName);
    end

    % find maximum peak across all IRs
    for j = 1: length(outputIRs)
        % array of maxima across the IRs
        maxima(j) = max(abs(outputIRs{j}), [], 'all');
    end
    maximum = max(maxima);

    % normalise IRs relative to the maximum peak across all of them
    for j = 1: length(outputIRs)
        outputIRsNormalised{j} = 0.99 * outputIRs{j}./maximum;
    end

    % write each IR to an audio file
    for k = 1:length(fileStruct)
        % for each North IR
        if fileStruct(k).name(end - 8) == 'N'
            % use this name to construct the name for the omnidirectional
            % IR
            inputFileName = fileStruct(k).name;
            splitName = split(inputFileName, "N");
            outputFileName = strcat(processedIRPath, '/', splitName{1},...
                'Omni', splitName{2});

            % write each IR to an audio file
            audiowrite( outputFileName, outputIRsNormalised{ceil(k/4)}, ...
                        Fs, 'BitsPerSample', 24);
        end
    end
end