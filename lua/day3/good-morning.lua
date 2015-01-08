local scheduler = require 'scheduler'
local notation  = require 'notation'

notes = { 'D4e'
        , 'D4e'
        , 'E4q'
        , 'D4q'
        , 'G4q'
        , 'Fs4h'
        }

function play_song()
   for i = 1, #notes do
      local symbol = notation.parse_note(notes[i])
      -- print("playing: " .. notes[i])
      notation.play(symbol.note, symbol.duration)
   end
end

scheduler.schedule(0.0, coroutine.create(play_song))
scheduler.run()
