clear;
%% Global variable declaration
FS = 44100;
nBits = 8;
nChannels = 1;
record_length = 7;

%% Call the main function
main(FS, nBits, nChannels, record_length);

%% Main function
function main(FS, nBits, nChannels, record_length)
    %% Select audio devices
    [user_selected_input_ID, user_slected_output_ID] = get_user_selected_device();

    %% record, plot, save, and load the first clip
    disp("recording the first clip")
    [myVoice_1, audio_data_1] = record_voice(FS, nBits, nChannels, record_length, user_selected_input_ID);
    plot_time(audio_data_1, record_length, "Time domain plot of the first clip");
    plot_spectrogram(audio_data_1, FS, "Spectrogram of the first clip");
    save_audio_to_wav(audio_data_1, FS);
    [audio_data_loaded_1,FS_loaded] = load_audio_from_wav();
    plot_spectrogram(audio_data_loaded_1, FS_loaded, "Spectrogram of the first WAV");

    %% record, plot, save, and load the second clip
    disp("recording the second clip")
    [myVoice_2, audio_data_2] = record_voice(FS, nBits, nChannels, record_length, user_selected_input_ID);
    plot_time(audio_data_2, record_length, "Time domain plot of the second clip");
    plot_spectrogram(audio_data_2, FS, "Spectrogram of the second clip");
    save_audio_to_wav(audio_data_2, FS);
    [audio_data_loaded_2,FS_loaded] = load_audio_from_wav();
    plot_spectrogram(audio_data_loaded_2, FS_loaded, "Spectrogram of the second WAV");

    %% record, plot, save, and load the third clip
    disp("recording the third clip")
    [myVoice_3, audio_data_3] = record_voice(FS, nBits, nChannels, record_length, user_selected_input_ID);
    plot_time(audio_data_3, record_length, "Time domain plot of the third clip");
    plot_spectrogram(audio_data_3, FS, "Spectrogram of the third clip");
    save_audio_to_wav(audio_data_3, FS);
    [audio_data_loaded_3,FS_loaded] = load_audio_from_wav();
    plot_spectrogram(audio_data_loaded_3, FS_loaded, "Spectrogram of the third WAV");

    %% Convert the third clip to mono and save as WAV
    audio_data_stereo =  mono2stereo(audio_data_3);
    save_audio_to_wav(audio_data_stereo, FS);
end 

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
    time = linspace (0, record_length, length(audio_data));                   %create time in seconds
    plot(time, audio_data);                                                   %plot it
    xlabel("Time(seconds)");                                                  %labels and custom title
    ylabel("Amplitude");
    title(my_title);
end

%% A fucntion that saves audio as a WAV file with GUI
function save_audio_to_wav(audio_data, FS)
    disp("Please save the audio")
    [filename, pathname] = uiputfile('*.wav', 'Save recorded audio as');    %get file and path
    savepath = fullfile(pathname, filename);                                %combine to get full path
    audiowrite(savepath, audio_data, FS);                                   %save with specified sample rate
    disp("done saving")
end

%% A fucntion that loads WAV audio with GUI
function [y,FS] = load_audio_from_wav()
    disp("Please open an audio clip")
    [filename, pathname] = uigetfile('*.wav');                              %get file and path
    loadpath = fullfile(pathname, filename);                                %get full path
    [y,FS] = audioread(loadpath);                                           %read audio data and sample rate 
    disp("done loading")
end

%% A function that converts the mono audio to stereo by adding zeros to the right channel
function audio_data_stereo =  mono2stereo(audio_data)
    audio_data_stereo = [audio_data zeros(size(audio_data))];
end
