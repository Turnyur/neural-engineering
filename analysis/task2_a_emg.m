COLOR = [0 188 200] / 255;
COLOR_POWERSPECTRUM = [255 76 00] / 255;

sigLength = 69540;
step =1/fsamp;
SIGTimeBox=0:step:(size(SIG{1,1}, 2)-1)*step;
MUPulsesMilliSec = cell(1,32);
for c=1:size(MUPulses, 2) 
    MUPulsesMilliSec{1, c} = round((MUPulses{1, c}(1,:)*(1/fsamp))*1000);
end




neuronSTA = cell(1, size(MUPulses, 2));
neuronSTAIndex = cell(1, size(MUPulses, 2));

for neuron =1:size(MUPulses, 2)
%for neuron =1:10

  
    %Loop through each SIG electrode in a linearized pattern
    
        window = 10; %by inspection
        capturedSignalAmplitudeMatrix= zeros(size(MUPulses{1, neuron}, 2), window);
        capturedSignalAmplitudeMatrixIndex = zeros(size(MUPulses{1, neuron}, 2), window);

        for spikeSample=1:size(MUPulses{1,neuron}, 2)
            signalIndexRange = make_window(MUPulsesMilliSec{1,neuron}(1,spikeSample), SIGTimeBox);
            %capturedSignal = SIG{1,1}(signalIndexRange);
            capturedSignalAmplitudes = filteredSIG(signalIndexRange);
            
            if length(capturedSignalAmplitudes)==window
                for j=1:window
              
                    capturedSignalAmplitudeMatrix(spikeSample, j) = capturedSignalAmplitudes(j);
                    capturedSignalAmplitudeMatrixIndex(spikeSample, j) = signalIndexRange(j);
                end
            else
               for j=1:window-1
                    if numel(capturedSignalAmplitudes) >= j
                        capturedSignalAmplitudeMatrix(spikeSample, j) = capturedSignalAmplitudes(j);
                        capturedSignalAmplitudeMatrixIndex(spikeSample, j) = signalIndexRange(j);
                    end
                end
                   
                
            end
        
            %disp(size(capturedSignal));
            %disp(capturedSignal);
        end
    
        staEMG = mean(capturedSignalAmplitudeMatrix, 'omitnan');
        staEMGIndex= mean(capturedSignalAmplitudeMatrixIndex, 'omitnan');
        
    
    
        neuronSTA{1, neuron} = staEMG;
        neuronSTAIndex{1, neuron} = staEMGIndex;
      
 end

   
    

%figureTitle="Spike triggered Average Showing the identified MUPulses";
%figure('name', figureTitle);
%hold on

  for sta = 1:size(neuronSTA, 2)
    %start = neuronSTAIndex{1, sta}(1,1);
    %stop = neuronSTAIndex{1, neuron}(end);
    %t_axis = linspace(start, stop * (1/fsamp), numel(neuronSTA{1, sta}));

    t_ms = neuronSTAIndex{1, sta};
    figure;
    %subplot(1, 1, sta);     
    %plot(t_ms, neuronSTA{1, sta} , 'Color', COLOR);
    plot(neuronSTA{1, sta} , 'Color', COLOR);

    grid on;
    hold off

    title(['Neuron ', num2str(sta)]);
    xlabel('Time (s)');
    ylabel('Amplitude (Avg)');

  end
    






function indexRange = make_window(num_millisec, SIG_time_box)
    window_size = 30;
    
    low = (num_millisec - window_size)/1000;
    high = (num_millisec + window_size)/1000;

     %disp("low:" + low*1000 + " center:" + num_millisec + " high:" + high*1000)

    start_index = round(low * (length(SIG_time_box)-1) / 600) + 1;
    end_index = round(high * (length(SIG_time_box)-1) / 600) + 1;
    
    indexRange = start_index:end_index;
end



