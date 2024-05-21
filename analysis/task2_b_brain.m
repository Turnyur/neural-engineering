COLOR = [0 188 200] / 255;
COLOR_POWERSPECTRUM = [255 76 00] / 255;

neuronPeakToPeakValues = zeros(1, size(neuronSTAMatrix, 2));
peakToPeakMatrix = cell(1, 11);
electrodeLength = 32; 
peakToPeakValues = zeros(1, electrodeLength);


for neuron = 1:size(neuronSTAMatrix, 2)
    neuronSTA = neuronSTAMatrix{neuron};
    biggestValues = zeros(1, 3);
    
    for channelIdx = 1:size(neuronSTA, 2)
        staElectrode = neuronSTA{channelIdx};
        peakToPeakValue = max(staElectrode)-min(staElectrode);
        peakToPeakValues(1, channelIdx) = peakToPeakValue;

        [~, minIndex] = min(biggestValues);
        if peakToPeakValue > biggestValues(minIndex)
            biggestValues(minIndex) = peakToPeakValue;
        end
    end

    meanBiggestValue = mean(biggestValues);
    peakToPeakMatrix{1, neuron} = peakToPeakValues/meanBiggestValue;

    neuronPeakToPeakValues(neuron) = meanBiggestValue;
end

    figureTitle="Neuron "+ num2str(neuron)+" Output Graphs";
    figure('name', figureTitle);
    hold on
for neuronIdx = 1:size(neuronPeakToPeakValues, 2)

    subplot(4, 3, neuronIdx);  
    binWidth = 2;

    %histogram(peakToPeakMatrix{1, neuronIdx}, 'BinEdges', linspace(0, max(peakToPeakMatrix{1, neuronIdx}), 32), 'Normalization', 'count', 'FaceColor', COLOR_POWERSPECTRUM);
    histogram(peakToPeakMatrix{1, neuronIdx},'BinEdges', linspace(0, max(peakToPeakMatrix{1, neuronIdx}), 32), 'FaceColor', COLOR_POWERSPECTRUM,'EdgeAlpha', 0.09 );
        grid on;
        hold off
    xlabel('Normalized Peak-to-Peak Values');
    ylabel('Freq.');
    title(['Neuron ' , num2str(neuronIdx)]);
end


average = mean(neuronPeakToPeakValues);
normalizedPeakToPeak = neuronPeakToPeakValues / average;

histogram(normalizedPeakToPeak, 'BinEdges', linspace(0, max(normalizedPeakToPeak), 11), 'FaceColor', COLOR);

xlabel('Normalized Peak-to-Peak Values');
ylabel('Freq.');
title('Distribution of Normalized Peak-to-Peak');
