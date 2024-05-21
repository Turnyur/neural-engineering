fsamp

COLOR = [0 188 200] / 255;
COLOR_POWERSPECTRUM = [255 76 00] / 255;

sigLength = 69540;
step =1/fsamp;
SIGTimeBox=0:step:(size(SIG{1,1}, 2)-1)*step;
MUPulsesMilliSec = cell(1,32);
for c=1:size(MUPulses, 2) 
    MUPulsesMilliSec{1, c} = round((MUPulses{1, c}(1,:)*(1/fsamp))*1000);
end


nonEmptyCells = ~cellfun('isempty', SIG);
numNonEmptyCells = nnz(nonEmptyCells);
linearizeAndCleanedSIG = cell(1, numNonEmptyCells);
linearIndexer = 0;

for electrodeByColumn=1:size(SIG, 2)
    nonEmptyCells = ~cellfun('isempty', SIG(:, electrodeByColumn));
     %disp(['Column: ', num2str(electrodeByColumn)]);
    
    for electrodeByRow=1:size(SIG, 1)
        if nonEmptyCells(electrodeByRow)
            linearIndexer = linearIndexer+1;
            %disp("SIG("+electrodeByRow+", "+electrodeByColumn+")");
            linearizeAndCleanedSIG(linearIndexer) = SIG(electrodeByRow, electrodeByColumn);
        end
    end
   
end




neuronSTAMatrix = cell(1, size(MUPulses, 2));

for neuron =1:size(MUPulses, 2)
%for neuron =10:10

    staElectrodes = cell(1, numNonEmptyCells);
    staIndexer =  cell(1, numNonEmptyCells);


    %Loop through each SIG electrode in a linearized pattern
     for electrodeCell =1:size(linearizeAndCleanedSIG, 2)
        window = 14; %by manual inspection
        emgSignal= zeros(size(MUPulses{1, neuron}, 2), window);
        emgSignalIndex = zeros(size(MUPulses{1, neuron}, 2), window);

        for spikeSample=1:size(MUPulses{1,neuron}, 2)
            signalIndexRange = make_window(MUPulsesMilliSec{1,neuron}(1,spikeSample), SIGTimeBox);
            %capturedSignal = SIG{1,1}(signalIndexRange);
            capturedSignal = linearizeAndCleanedSIG{electrodeCell}(signalIndexRange);
            
            if length(capturedSignal)==window
                for j=1:window
              
                    emgSignal(spikeSample, j) = capturedSignal(j);
                    emgSignalIndex(spikeSample, j) = signalIndexRange(j);
                end
            else
               for j=1:window-1
                    if numel(capturedSignal) >= j
                        emgSignal(spikeSample, j) = capturedSignal(j);
                        emgSignalIndex(spikeSample, j) = signalIndexRange(j);
                    end
                end
                   
                
            end
        
            %disp(size(capturedSignal));
            %disp(capturedSignal);
        end
    
        staEMG = mean(emgSignal, 'omitnan');
        staEMGIndex= mean(emgSignalIndex, 'omitnan');
        
    
    
        staElectrodes{1, electrodeCell}=staEMG;
        staIndexer{1, electrodeCell}=staEMGIndex;  
      
     end

    figureTitle="EMG Neuron "+ num2str(neuron)+" Output Graphs";
    figure('name', figureTitle);
    hold on

    for electrodeCell = 1:size(staElectrodes, 2)
    

        subplot(8, 8, electrodeCell);  
        t_ms = staIndexer{1, electrodeCell}/1000000;
        plot(staElectrodes{1, electrodeCell},'Color', COLOR);
        grid on;
        hold off

        title(['Electrode ', num2str(electrodeCell)]);
        xlabel('');
        ylabel('Amplitude');
    end


    neuronSTAMatrix{1, neuron} = staElectrodes;
end





function indexRange = make_window(num_millisec, SIG_time_box)
    window_size = 50;
    
    low = (num_millisec - window_size)/1000;
    high = (num_millisec + window_size)/1000;

     %disp("low:" + low*1000 + " center:" + num_millisec + " high:" + high*1000)

    start_index = round(low * (length(SIG_time_box)-1) / 600) + 1;
    end_index = round(high * (length(SIG_time_box)-1) / 600) + 1;
    
    indexRange = start_index:end_index;
end



