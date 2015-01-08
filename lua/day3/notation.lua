local scheduler = require 'scheduler'
local tempo     = 100

local NOTE_DOWN = 0x90
local NOTE_UP   = 0x80
local VELOCITY  = 0x7f

local DEBUG = false    -- print what is going on verbosely

-- Just a convenience - print stuff if DEBUG flag is true
local function logg(msg) 
  if DEBUG then
    print(msg)
  end
end

local function note(letter, octave)
   local notes = {
      C  = 0,      Cs = 1,      D  = 2,      Ds = 3,      E  = 4,
      F  = 5,      Fs = 6,      G  = 7,      Gs = 8,      A  = 9,
      As = 10,     B  = 11
   }

   local notes_per_octave = 12

   return (octave + 1) * notes_per_octave + notes[letter]
end

local function duration(value)
   local quarter   = 60 / tempo
   local durations = { h  = 2.0
                     , q  = 1.0
                     , ed = 0.75
                     , e  = 0.5
                     , s  = 0.25
                     }

   return durations[value] * quarter
end

local function parse_note(s)
  local letter, octave, value, vol = 
    string.match(s, "([A-Gs]+)(%d+)(%a+)(%d?)")
  if not (letter and octave and value) then
    return
  end

  volume = 5;

  if(vol and tonumber(vol)) then
    volume = 1 + vol;
    if volume < 1 then volume = 1 end
    if volume > 10 then volume = 10 end
  end

  return { note     = note(letter, octave)
         , duration = duration(value)
         , letter   = letter
         , octave   = octave
         , volume   = (volume*10)
         }
end


local function play(note, duration, volume, channel, port)
   midi_send(port, channel, volume, NOTE_DOWN, note, VELOCITY)
   scheduler.wait(duration)
   midi_send(port, channel, volume, NOTE_UP, note, VELOCITY)
end

local mt = {
   __index = function(t, s)
      local result = parse_note(s)
      return result or rawget(t, s)
   end
}

setmetatable(_G, mt)

local function part(t)
   local function play_part()
      local channel = 1; -- default channel
      local port = 1; -- default port

      if(t['port'] ~= nil) then
        port = tonumber(t['port'])
        logg("Part to be played on port: " .. port)
      end

      if(t['channel'] ~= nil) then
        channel = tonumber(t['channel'])
        logg("Part to be played on channel: " .. channel)
      end

      for i = 1, #t do
         logg("Playing " .. t[i].letter 
              .. " in octave " .. t[i].octave 
              .. " for " .. t[i].duration
              .. ". Volume: " .. t[i].volume
              .. ". Channel: " .. channel
              .. ". Port: " .. port)

         play(t[i].note, t[i].duration, t[i].volume, channel, port)
      end
   end

   scheduler.schedule(0.0, coroutine.create(play_part))
end

local function set_tempo(bpm)
   tempo = bpm
end

local function go()
   scheduler.run()
end

return { parse_note = parse_note
       , play = play
       , part = part
       , set_tempo = set_tempo
       , go = go
}
