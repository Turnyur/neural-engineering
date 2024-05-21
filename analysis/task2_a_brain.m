COLOR = [0 188 200] / 255;
COLOR_POWERSPECTRUM = [255 76 00] / 255;

sigLength = 15000001;
step =1/fsamp;
SIGTimeBox=0:step:(sigLength-1)*step;
SpikesMilliSec = cell(1,11);
for c=1:size(Spikes, 2) 
    SpikesMilliSec{1, c} = round((Spikes{1, c}(:,1)*(1/fsamp))*1000);
end



%cleaned_SIG = cell(1, 1);
%cleaned_SIG{1,1}= filteredSIG;

linearIndexer = 0;

% for electrodeByColumn=1:size(SIG, 2)
%     nonEmptyCells = ~cellfun('isempty', SIG(:, electrodeByColumn));
% 
%     for electrodeByRow=1:size(SIG, 1)
%         if nonEmptyCells(electrodeByRow)
%             linearIndexer = linearIndexer+1;
%             %disp("SIG("+electrodeByRow+", "+electrodeByColumn+")");
%             cleaned_SIG(linearIndexer) = SIG(electrodeByRow, electrodeByColumn);
%         end
%     end
%     %disp(['Column: ', num2str(electrodeByColumn)]);
% end


neuronSTA = cell(1, size(Spikes, 2));
neuronSTAIndex = cell(1, size(Spikes, 2));

for neuron =1:size(Spikes, 2)
%for neuron =1:1

  
    
    
    %Loop through each SIG electrode in a linearized pattern

    %for electrodeCell =1:size(cleaned_SIG, 2)
    
        window = 751; % I inpected the number of data points generated manually, given the window size, i.e 15 milliseconds
        capturedSignalAmplitudeMatrix= zeros(size(Spikes{1, neuron}, 1), window);
        capturedSignalAmplitudeMatrixIndex = zeros(size(Spikes{1, neuron}, 1), window);
    
        %
        for spikeFiringTime=1:size(Spikes{1,neuron}, 1)
            % Capture signal amplitude and index range
            signalIndexRange = makeWindow(SpikesMilliSec{1,neuron}(spikeFiringTime,1), SIGTimeBox);
            capturedSignalAmplitudes = filteredSIG(signalIndexRange);
    
           %disp(capturedSignal);
            
            %plot(signalIndexRange, capturedSignal)
            if length(capturedSignalAmplitudes)==window
                for inWindowFiringTime=1:window
                    %each data point
                    capturedSignalAmplitudeMatrix(spikeFiringTime, inWindowFiringTime) = capturedSignalAmplitudes(inWindowFiringTime);
                    capturedSignalAmplitudeMatrixIndex(spikeFiringTime, inWindowFiringTime) = signalIndexRange(inWindowFiringTime);
                end
            else
               for inWindowFiringTime=1:window-1
                    %each data point
                    capturedSignalAmplitudeMatrix(spikeFiringTime, inWindowFiringTime) = capturedSignalAmplitudes(inWindowFiringTime);
                    capturedSignalAmplitudeMatrixIndex(spikeFiringTime, inWindowFiringTime) = signalIndexRange(inWindowFiringTime);
                end
            end
    
        
            %disp(size(capturedSignal));
            %disp(size(capturedSignal));
        end
    
        staBrain = mean(capturedSignalAmplitudeMatrix, 'omitnan');
        staBrainIndex= mean(capturedSignalAmplitudeMatrixIndex, 'omitnan');
    
        neuronSTA{1, neuron} = staBrain;
        neuronSTAIndex{1, neuron} = staBrainIndex;


    %end
    

    
    
    
end



figureTitle="Spike triggered Average Showing the identified neurons";
figure('name', figureTitle);
hold on

  for sta = 1:size(neuronSTA, 2)
    %start = neuronSTAIndex{1, sta}(1,1);
    %stop = neuronSTAIndex{1, neuron}(end);
    %t_axis = linspace(start, stop * (1/fsamp), numel(neuronSTA{1, sta}));

    t_ms = neuronSTAIndex{1, sta}/1000000;

    subplot(6, 2, sta);     
    plot(t_ms, neuronSTA{1, sta} , 'Color', COLOR);
    grid on;
    hold off

    title(['Neuron ', num2str(sta)]);
    xlabel('Time (s)');
    ylabel('Signal Amplitude');

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



