
COLOR = [0 188 200] / 255;
COLOR_POWERSPECTRUM = [255 76 00] / 255;

 COLOR_TEAL =   [0 188 200]/255;   % Teal
 COLOR_RED  = [217 83 79];    % Red
 COLOR_GREEN =   [92 184 92]/255;    % Green
 COLOR_ORANGE  = [240 173 78]/255;   % Orange
 COLOR_BLUE  = [66 139 202]/255;   % Blue
 COLOR_PURPLE =   [153 102 204]/255;  % Purple
    


COLOR_CONTAINER  =cell(1, 5);
COLOR_CONTAINER {1,1} =COLOR_POWERSPECTRUM;
COLOR_CONTAINER {1,2} =COLOR;
COLOR_CONTAINER {1,3} =COLOR_BLUE;
COLOR_CONTAINER {1,4} =COLOR_PURPLE;
COLOR_CONTAINER {1,5} =COLOR_TEAL;

MUPulsesDiff = cell(1, size(MUPulses, 2));

    figureTitle="Histogram of MUPulses";
    figure('name', figureTitle);
    hold on

for muPulseIndex =1:size(MUPulses, 2)
    MUPulsesDiff{1, muPulseIndex} = diff(MUPulses{1, muPulseIndex});
    subplot(8, 4, muPulseIndex);  

   histogram(MUPulsesDiff{1, muPulseIndex}, 60,'Normalization', 'probability','FaceColor',COLOR_POWERSPECTRUM , 'EdgeAlpha', 0.05);
       grid on;
        hold off
    xlabel('MUPulse');
     ylabel('Frequency');
     text = strcat("Normalized ISI of MUPulses \{1, ", num2str(muPulseIndex), "\}");
     title(text);
end


figure;

alphaV = 1;
legendTexts = cell(1, 5);

%for muPulseIndex =1:size(MUPulses, 2)
for muPulseIndex =1:5
   MUPulsesDiff{1, muPulseIndex} = diff(MUPulses{1, muPulseIndex});
   %histogram(MUPulsesDiff{muPulseIndex}, linspace(0, max(MUPulsesDiff{muPulseIndex}), 200),'Normalization', 'probability','FaceColor',COLOR_CONTAINER{1,muPulseIndex} , 'EdgeAlpha', 0.05);
   histogram(MUPulsesDiff{muPulseIndex}, 150,'Normalization', 'probability','FaceColor',COLOR_CONTAINER{1,muPulseIndex} ,'FaceAlpha', alphaV, 'EdgeAlpha', 0.05);
      alphaV = alphaV - 0.15;
   xlabel('MUPulse');
     ylabel('Frequency');
     title(['Normalized Distribution of 5 MUPulses ']);
     legendTexts{muPulseIndex} = ['MUPulse ', num2str(muPulseIndex)];
     grid on
     hold on;
end
    
legend(legendTexts);
hold off;
