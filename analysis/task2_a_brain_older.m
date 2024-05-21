COLOR = [0 188 200] / 255;
COLOR_POWERSPECTRUM = [255 76 00] / 255;

sigLength = 15000001;
step =1/fsamp;
SIGTimeBox=0:step:(sigLength-1)*step;
SpikesMilliSec = cell(1,11);
for c=1:size(Spikes, 2) 
    SpikesMilliSec{1, c} = round((Spikes{1, c}(:,1)*(1/fsamp))*1000);
end


nonEmptyCells = ~cellfun('isempty', SIG);
numNonEmptyCells = nnz(nonEmptyCells);
linearizeAndCleanedSIG = cell(1, numNonEmptyCells);
linearIndexer = 0;

for electrodeByColumn=1:size(SIG, 2)
    nonEmptyCells = ~cellfun('isempty', SIG(:, electrodeByColumn));
    
    for electrodeByRow=1:size(SIG, 1)
        if nonEmptyCells(electrodeByRow)
            linearIndexer = linearIndexer+1;
            %disp("SIG("+electrodeByRow+", "+electrodeByColumn+")");
            linearizeAndCleanedSIG(linearIndexer) = SIG(electrodeByRow, electrodeByColumn);
        end
    end
    %disp(['Column: ', num2str(electrodeByColumn)]);
end


neuronSTAMatrix = cell(1, size(Spikes, 2));
for neuron =1:size(Spikes, 2)
%for neuron =7:7

    staElectrodes = cell(1, numNonEmptyCells);
    staIndexer =  cell(1, numNonEmptyCells);
    
    
    %Loop through each SIG electrode in a linearized pattern
    for electrodeCell =1:size(linearizeAndCleanedSIG, 2)
    
        window = 751; % %by manual inspection
        capturedSignalAmplitudeMatrix= zeros(size(Spikes{1, neuron}, 1), window);
        capturedSignalAmplitudeMatrixIndex = zeros(size(Spikes{1, neuron}, 1), window);
    
        % For each spike firing time
        for spikeFiringTime=1:size(Spikes{1,neuron}, 1)
            % Capture signal amplitude and index range
            signalIndexRange = makeWindow(SpikesMilliSec{1,neuron}(spikeFiringTime,1), SIGTimeBox);
            capturedSignalAmplitudes = linearizeAndCleanedSIG{electrodeCell}(signalIndexRange);
    
           %disp(capturedSignal);
            
            %plot(signalIndexRange, capturedSignal)
            if length(capturedSignalAmplitudes)==window
                for inWindowFiringTimePoint=1:window
                    %each data point
                    capturedSignalAmplitudeMatrix(spikeFiringTime, inWindowFiringTimePoint) = capturedSignalAmplitudes(inWindowFiringTimePoint);
                    capturedSignalAmplitudeMatrixIndex(spikeFiringTime, inWindowFiringTimePoint) = signalIndexRange(inWindowFiringTimePoint);
                end
            else
               for inWindowFiringTimePoint=1:window-1
                    %each data point
                    capturedSignalAmplitudeMatrix(spikeFiringTime, inWindowFiringTimePoint) = capturedSignalAmplitudes(inWindowFiringTimePoint);
                    capturedSignalAmplitudeMatrixIndex(spikeFiringTime, inWindowFiringTimePoint) = signalIndexRange(inWindowFiringTimePoint);
                end
            end
    
        
            %disp(size(capturedSignal));
            %disp(size(capturedSignal));
        end
    
        staBrain = mean(capturedSignalAmplitudeMatrix, 'omitnan');
        staBrainIndex= mean(capturedSignalAmplitudeMatrixIndex, 'omitnan');
    
        staElectrodes{1, electrodeCell}=staBrain;
        staIndexer{1, electrodeCell}=staBrainIndex;

    end
    

    figureTitle="Neuron "+ num2str(neuron)+" Output Graphs";
    figure('name', figureTitle);
    hold on
       
    for electrodeCell = 1:size(staElectrodes, 2)
       
        
        subplot(8, 4, electrodeCell); 
        t_ms = staIndexer{1, electrodeCell}/1000000;

        plot(t_ms, staElectrodes{1, electrodeCell}, 'Color', COLOR);
        grid on;
        hold off

        title(['Electrode ', num2str(electrodeCell)]);
        xlabel('Time (s)');
        ylabel('Amplitude');
    end

    neuronSTAMatrix{1, neuron} = staElectrodes;

    
end


function indexRange = makeWindow(num_millisec, SIG_time_box)
    window_size = 15;
    
    low = (num_millisec - window_size)/1000;
    high = (num_millisec + window_size)/1000;

    fsamp= 25000;
    sigLength = 15000001;
    sigTotalTime = sigLength * (1/fsamp);
     %disp("low:" + low*1000 + " center:" + num_millisec + " high:" + high*1000)
    start_index = round(low * (length(SIG_time_box)-1) / sigTotalTime) + 1;
    end_index = round(high * (length(SIG_time_box)-1) / sigTotalTime) + 1;
    
    indexRange = start_index:end_index;
end



