COLOR = [0 188 200] / 255;
COLOR_POWERSPECTRUM = [255 76 00] / 255;

%Get average signal
len = 15000001;
accumulator = zeros(1, len);

counter =0;
for c = 1:size(SIG, 2)
    col = SIG(:, c);
    
    non_empty_cells = ~cellfun('isempty', col);
    for row = 1:size(SIG, 1)
        if non_empty_cells(row)
            %disp("("+col+", "+row+")")
            counter=counter+1;
           accumulator = accumulator + col{row};
        end
    end


end

avgSIG = accumulator / counter;
avgSIGLength = size(avgSIG,2);

t = 0:1/fsamp:(avgSIGLength-1)/fsamp;

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
filteredSIGFFT = filteredSIGFFT(1:avgSIGLength/2+1);

powerSpectrumFiltered = abs(filteredSIGFFT).^2;

freq_resolution = fsamp / avgSIGLength;
x_filtered = 0:freq_resolution:fsamp/2;
plot(x_filtered, powerSpectrumFiltered,'Color', COLOR_POWERSPECTRUM); 
xlabel('Frequency (Hz)');
ylabel('Power');
title('Power Spectrum of Filtered Signal');

grid on;
