clear;
%% Global variable declaration
FS = 44100;
nBits = 8;
nChannels = 1;
record_length = 7;

FI = 0;
FF = 8000;


%% Select audio devices
[user_selected_input_ID, user_slected_output_ID] = get_user_selected_device();

sine = sinewave(record_length, 5000, FS);
save_audio_to_wav(sine, FS);
[sine_loaded,sine_FS_loaded] = load_audio_from_wav();
plot_spectrogram(sine_loaded, sine_FS_loaded, "Spectrogram of 5000Hz sine");

chirp = sine_chirp(record_length, FI, FF, FS);
plot_spectrogram(chirp, FS, "Spectrogram of chirp");
cetk_sound = cetk(record_length, FS);
plot_spectrogram(cetk_sound, FS, "Spectrogram of cetk");


%% load fox and plot
[audio_data_loaded_1,FS_loaded] = load_audio_from_wav();
plot_spectrogram(audio_data_loaded_1, FS_loaded, "Spectrogram of the first WAV");

%% A function that lets the user select their audio device by typing them in the command window
function [input_device_ID, output_device_ID] = get_user_selected_device()
    devices = audiodevinfo;                                                    %get all devices
    input_devices = struct2table(devices.input, 'AsArray', true);              %put them in printable formats
    output_devices = struct2table(devices.output, 'AsArray', true);
    disp ('list of input devices')
    disp(input_devices)                                                        %print out all input devices
    input_device_ID = input ('please select input device by typing its ID');   %get user input
    disp ('list of output devices')
    disp(output_devices)                                                       %print out all output devices
    output_device_ID = input ('please select output device by typing its ID'); %get user input
end

function [chirp] = sine_chirp(record_length, FI, FF, FS)
    chirp = zeros;
    n = 0:(1/FS):(record_length);
    f = linspace (FI, FF, length(n));   
    for i = 1:length(n)
        chirp(i) = sin(pi*f(i)*n(i));
    end
end
function [output] = sinewave(record_length, F, FS)
    n = 0:(1/FS):(record_length);
    output = sin(2*pi*n*F);
end

%% CETK notes frequency: 1174.66, 1318.51, 1046.50, 523.25, 783.99
function [cetk] = cetk(record_length, FS)
    cetk = zeros;
    note_durations = [0.5 0.7 1 0.7 4];
    n = 0:(1/FS):(record_length);
    f = zeros;
    f(1:(FS*note_durations(1))) = 1174.66;
    f((1+FS*note_durations(1)):(FS*note_durations(2))) = 1318.51;
    f((1+FS*note_durations(2)):(FS*note_durations(3))) = 1046.5;
    f((1+FS*note_durations(3)):(FS*note_durations(4))) = 523.25;
    f((1+FS*note_durations(4)):(FS*note_durations(5))) = 783.99;
    for i = 1:length(f)
        cetk(i) = sin(pi*f(i)*n(i));
    end
end

%% A function that creates a recorder objects and records audio with specified parameters
function [myVoice, audio_data] = record_voice(FS, nBits, nChannels, length, ID)
    myVoice = audiorecorder(FS, nBits, nChannels, ID);                         %create recorder object
    disp('Start Recording')                                       
    record(myVoice, length);                                                   %record
    pause(length);                                                             %pause executation till record finish
    audio_data = getaudiodata(myVoice);                                        %put audio data in array
end

%% A function that plots the spectrogram of a given audio data
function plot_spectrogram(audio_data, FS, my_title)
    figure;
    window = hamming(512);                                                     %set parameters
    N_overlap = 256;
    N_fft = 1024;
    spectrogram(audio_data, window, N_overlap, N_fft, FS, 'yaxis');            %plot it
    ylim([0 8]);                                                               %limit to 8kHz
    title(my_title);                                                           %add custom title
end

%% A function that converts samples to seconds and does time domain plot
function plot_time(audio_data,  record_length, my_title)
    figure;
    time = linspace (0, record_length, length(audio_data));                    %create time in seconds
    plot(time, audio_data);                                                    %plot it
    xlabel("Time(seconds)");                                                   %labels and custom title
    ylabel("Amplitude");
    title(my_title);
end

%% A fucntion that saves audio as a WAV file with GUI
function save_audio_to_wav(audio_data, FS)
    disp("Please save the audio")
    [filename, pathname] = uiputfile('*.wav', 'Save recorded audio as');      %get file and path
    savepath = fullfile(pathname, filename);                                  %combine to get full path
    audiowrite(savepath, audio_data, FS);                                     %save with specified sample rate
    disp("done saving")
end

%% A fucntion that loads WAV audio with GUI
function [y,FS] = load_audio_from_wav()
    disp("Please open an audio clip")
    [filename, pathname] = uigetfile('*.wav');                                %get file and path
    loadpath = fullfile(pathname, filename);                                  %get full path
    [y,FS] = audioread(loadpath);                                             %read audio data and sample rate 
    disp("done loading")
end

%% A function that converts the mono audio to stereo by adding zeros to the right channel
function audio_data_stereo =  mono2stereo(audio_data)
    audio_data_stereo = [audio_data zeros(size(audio_data))];
end
