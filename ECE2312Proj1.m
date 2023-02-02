clear;
FS = 44100;
nBits = 8;
nChannels_mono = 1;
nChannels_stereo = 2;
record_length = 5;

[user_selected_input_ID, user_slected_output_ID] = get_user_selected_device();
disp("recording mono")
[myVoice, audio_data] = record_voice(FS, nBits, nChannels_mono, record_length, user_selected_input_ID);
plot_time(audio_data);
plot_spectrogram(audio_data, FS);
save_audio_to_wav(audio_data, FS);
[audio_data_loaded,FS_loaded] = load_audio_from_wav();
[myVoice_stereo, audio_data_stereo] = record_voice(FS, nBits, nChannels_stereo, record_length, user_selected_input_ID);
plot_spectrogram(audio_data_stereo, FS);

function [input_device_ID, output_device_ID] = get_user_selected_device()
    devices = audiodevinfo;
    input_devices = struct2table(devices.input, 'AsArray', true);
    output_devices = struct2table(devices.output, 'AsArray', true);
    disp ('list of input devices')
    disp(input_devices)
    input_device_ID = input ('please select input device by typing its ID');
    disp ('list of output devices')
    disp(output_devices)
    output_device_ID = input ('please select output device by typing its ID');
end

function [myVoice, audio_data] = record_voice(FS, nBits, nChannels, length, ID)
    myVoice = audiorecorder(FS, nBits, nChannels, ID);
    disp('Start Recording')
    record(myVoice, length);
    pause(length);
    audio_data = getaudiodata(myVoice);
end

function plot_spectrogram(audio_data, FS)
    figure;
    window = hamming(512);
    N_overlap = 256;
    N_fft = 1024;
    spectrogram(audio_data, window, N_overlap, N_fft, FS, 'yaxis');
    title('Spectrogram of the recorded audio signal');
end
function plot_time(audio_data)
    figure;
    plot(audio_data);
    xlabel("Samples");
    ylabel("Amplitude");
    title('Time domain plot');
end


function save_audio_to_wav(audio_data, FS)
    [filename, pathname] = uiputfile('*.wav', 'Save recorded audio as');
    savepath = fullfile(pathname, filename);
    audiowrite(savepath, audio_data, FS);
    disp("done saving")
end

function [y,FS] = load_audio_from_wav()
    [filename, pathname] = uigetfile('*.wav');
    loadpath = fullfile(pathname, filename);
    [y,FS] = audioread(loadpath);
end
