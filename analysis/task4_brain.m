
COLOR = [0 188 200] / 255;
COLOR_POWERSPECTRUM = [255 76 00] / 255;

 COLOR_TEAL =   [0 188 200]/255;   % Teal
 COLOR_RED  = [217 83 79];    % Red
 COLOR_GREEN =   [92 184 92]/255;    % Green
 COLOR_ORANGE  = [240 173 78]/255;   % Orange
 COLOR_BLUE  = [66 139 202]/255;   % Blue
 COLOR_PURPLE =   [153 102 204]/255;  % Purple
    


COLOR_CONTAINER  =cell(1, 5);
COLOR_CONTAINER {1,1} =COLOR_GREEN;
COLOR_CONTAINER {1,2} =COLOR_POWERSPECTRUM;
COLOR_CONTAINER {1,3} =COLOR_BLUE;
COLOR_CONTAINER {1,4} =COLOR_PURPLE;
COLOR_CONTAINER {1,5} =COLOR;

COLOR_CONTAINER {1,3}=[255 127 14]/255;   % Dark orange
COLOR_CONTAINER {1,3} =   [255 192 0]/255;    % Gold
COLOR_CONTAINER {1,3}  =  [128 0 128]/255;     % Indigo

SpikesDiff = cell(1, size(Spikes, 2));


    figureTitle="Histogram of Spikes";
    figure('name', figureTitle);
    hold on

for spikeIndex =1:size(Spikes, 2)
    SpikesDiff{1, spikeIndex} = diff(Spikes{1, spikeIndex});
    subplot(4, 3, spikeIndex);  

   histogram(SpikesDiff{1, spikeIndex}, 60,'Normalization', 'probability','FaceColor',COLOR_POWERSPECTRUM , 'EdgeAlpha', 0.05);
       grid on;
        hold off
    xlabel('Spike');
     ylabel('Frequency');
     text = strcat("Normalized ISI of Spike \{1,", num2str(spikeIndex), "\}");
     title(text);
end




figure;


alphaV = 1;
legendTexts = cell(1, 5);

%for SpikeIndex =1:size(Spikes, 2)
for SpikeIndex =1:5
    SpikesDiff{1, SpikeIndex} = diff(Spikes{1, SpikeIndex});
   %histogram(SpikesDiff{SpikeIndex}, linspace(0, max(SpikesDiff{SpikeIndex}), 200),'Normalization', 'probability','FaceColor',COLOR_CONTAINER{1,SpikeIndex} , 'EdgeAlpha', 0.05);
   histogram(SpikesDiff{SpikeIndex}, 150,'Normalization', 'probability','FaceColor',COLOR_CONTAINER{1,SpikeIndex} , 'FaceAlpha', alphaV, 'EdgeAlpha', 0.05);
   alphaV = alphaV - 0.15;
   xlabel('Spike');
     ylabel('Frequency');
     title('Superimposed Distribution of 5 Spikes ');
     legendTexts{SpikeIndex} = ['Spike ', num2str(SpikeIndex)];
     grid on
     hold on;
end
    

legend(legendTexts);
hold off

