local function monitor()
	shell.run("monitor", "left", "alongtimeago")
end
local function dynamix()
local dfpwm = require("cc.audio.dfpwm")
local speaker = peripheral.find("speaker")


local samples_i, samples_n = 1, 96000 * 1.5
local samples = {}
for i = 1, samples_n do samples[i] = 0 end

local decoder = dfpwm.make_decoder()
for chunk in io.lines("star-wars.wav", 16 * 1024) do
    local buffer = decoder(chunk)

    for i = 1, #buffer do
        local original_value = buffer[i]

        
        buffer[i] = original_value * 0.6 + samples[samples_i] * 0.4

        
        samples[samples_i] = original_value
        samples_i = samples_i + 1
        if samples_i > samples_n then samples_i = 1 end
    end

    while not speaker.playAudio(buffer) do
        os.pullEvent("speaker_audio_empty")
    end

    sleep(0.05)
end
end
parallel.waitForAll(monitor, dynamix)