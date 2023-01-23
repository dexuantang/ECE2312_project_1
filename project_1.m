clear;
FS = 44100;
nBits = 8;
nChannels = 1;
record_length = 5;

[user_selected_input_ID, user_slected_output_ID] = get_user_selected_device();
[myVoice, audio_data] = record_voice(FS, nBits, nChannels, record_length, user_selected_input_ID);
plot(audio_data);
function [input_device_ID, output_device_ID] = get_user_selected_device()
    % this function enables the user to select the device they want incase
    % they have multiple audio devices.
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
    % records audio with specified parameters
    myVoice = audiorecorder(FS, nBits, nChannels, ID);
    record(myVoice, length);
    pause(length);
    audio_data = getaudiodata(myVoice);
end