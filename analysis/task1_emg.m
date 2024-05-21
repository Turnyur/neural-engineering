COLOR = [0 188 200] / 255;
COLOR_POWERSPECTRUM = [255 76 00] / 255;

len = 69540;
%Get average signal
accumulator = zeros(1, 69540);

counter =0;
for c = 1:size(SIG, 2)
    col = SIG(:, c);
    
    nonEmptyCells = ~cellfun('isempty', col);


    for row = 1:size(SIG, 1)
        if nonEmptyCells(row)
            %disp("("+col+", "+row+")")
            counter=counter+1;
           accumulator = accumulator + col{row};
        end
    end


end


avgSIG = accumulator / counter;
disp("Valid Cells: "+ counter);




SIGLength = size(avgSIG,2);

t = 0:1/fsamp:(SIGLength-1)/fsamp;

notch_freq = 50; 
bw = 1;  


Wn = notch_freq/(fsamp/2); 
BW = bw/(fsamp/2);         
[b, a] = iirnotch(Wn, BW);
filteredSIG = filtfilt(b, a, avgSIG);



figure;
subplot(2,1,1);
plot(t, avgSIG, 'Color', COLOR);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(2,1,2);
plot(t, filteredSIG, 'Color', COLOR);
title('Filtered Signal (Notch Filtered at 50 Hz)');
xlabel('Time (s)');
ylabel('Amplitude');


figure;

filteredSIGFFT = fft(filteredSIG);
filteredSIGFFT = filteredSIGFFT(1:SIGLength/2+1);

powerSppectrum = abs(filteredSIGFFT).^2;

freq_resolution = fsamp / SIGLength;
xFiltered = 0:freq_resolution:fsamp/2;
plot(xFiltered, powerSppectrum, 'Color', COLOR_POWERSPECTRUM);
xlabel('Frequency (Hz)');
ylabel('Power');
title('Power Spectrum of Filtered Signal');

grid on;
