COLOR = [0 188 200] / 255;
COLOR_POWERSPECTRUM = [255 76 00] / 255;


figureTitle="Brain Neuron Distribution of Median Frequencies (PWELCH)";
   figure('name', figureTitle);
   hold on
  
powerPWELCHMATRIX = cell(1, size(neuronSTA, 2));
for neuronIndex = 1:size(neuronSTA, 2)
   actionPotential = neuronSTA{1, neuronIndex};
  
   [powerPWELCH, f] = pwelch(actionPotential, 751, [], [], fsamp);
  
   medianFrequency = median(f);
  
   powerPWELCHMATRIX{1,neuronIndex} = powerPWELCH;
   subplot(6, 2, neuronIndex);    
   plot(f, powerPWELCH, 'Color', COLOR_POWERSPECTRUM, 'LineWidth', 2 );
    hold on;
   area(f, powerPWELCH, 'FaceColor',COLOR_POWERSPECTRUM , 'BaseValue', min(powerPWELCH), 'FaceAlpha', 0.3);
   hold off;
   xlim([f(1), f(end)]);
   

   title(strcat('Neuron ', num2str(neuronIndex)));
   xlabel('Frequency (Hz)');
   ylabel('Power');
   grid on
end
hold off




figureTitle="Combined Brain Neurons";
   figure('name', figureTitle);
   hold on

for neuronIndex = 1:size(neuronSTA, 2)

    actionPotential = neuronSTA{1, neuronIndex};
    
    [powerPWELCH, f] = pwelch(actionPotential, [], [], [], fsamp); 
    
    medianFrequency = median(f);
    
  
    plot(f, powerPWELCH,'LineWidth', 2);
    title('Power Spectrum of Action Potential');
    xlabel('Frequency (Hz)');
    ylabel('Power');
    grid on

end



disp(['Median Frequency: ' num2str(medianFrequency) ' Hz']);







