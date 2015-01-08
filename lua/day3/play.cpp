extern "C"
{
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
}

#include "RtMidi.h"
#include "stdlib.h"     /* exit, EXIT_FAILURE */

static RtMidiOut midi_main;
RtMidiOut midi_ports [20]; // create a new object for each port and keep in this array; 20 should be enough

// Opens up all available Midi ports and stashes them into midi_ports[]
int initialize_midi_ports() {
  unsigned int ports = midi_main.getPortCount();
  if (ports < 1) { 
    std::cerr << "Error: No Midi Ports available.\n";
    return 0; 
  }
 
  for(int i=0; i<ports && i<20; i++) {
    //std::cout << "Info: Creating port: " << i << "\n";
    RtMidiOut *m = new RtMidiOut(); 
    m->openPort(i);
    midi_ports[i]=*m;
  }

  return ports;
}

int midi_send(lua_State* L) {
  int port    = lua_tonumber(L, -6);

  double channel = lua_tonumber(L, -5);

  // Added support for MIDI channels. It just means adding an offset to
  // the first bit of the messages we send.
  if (channel<1 || channel>16) {
    std::cerr << 
      "Warning: MIDI only has 16 channels. You tried to use channel " << 
      channel << 
      ". Will play on channel 1 instead.\n";
    channel = 1;
  }

  double volume  = lua_tonumber(L, -4);
  double status  = lua_tonumber(L, -3);
  double data1   = lua_tonumber(L, -2);
  double data2   = lua_tonumber(L, -1);

  int channel_offset = channel - 1;

  std::vector<unsigned char> volmsg(3);
  volmsg[0] = static_cast<unsigned char>(176 + channel_offset); // cf: http://www.midi.org/techspecs/midimessages.php
  volmsg[1] = static_cast<unsigned char>(7);
  volmsg[2] = static_cast<unsigned char>(volume);

  // Here we get the required port from our midi_ports array
  midi_ports[port].sendMessage(&volmsg);

  std::vector<unsigned char> message(3);
  message[0] = static_cast<unsigned char>(status + channel_offset);
  message[1] = static_cast<unsigned char>(data1);
  message[2] = static_cast<unsigned char>(data2);

  midi_ports[port].sendMessage(&message);

  return 0;
}

// Catches file errors and pulls the error off the stack
void err_handle(lua_State *state) {
  if (!lua_isstring(state, lua_gettop(state)))
    std::cerr << "Error: Undefined error. What the actual fuck?";

  std::string str = lua_tostring(state, lua_gettop(state));
  lua_pop(state, 1);

  std::cerr << str;
  std::cerr << "\n";
}

int main(int argc, const char* argv[]) {
  if (argc < 1) { 
    std::cerr << "Error: Need a filename to play\n";
    return -1; 
  }

  if (! initialize_midi_ports()) {
    std::cerr << "Error: Can't initialize MIDI ports";
    return -2; 
  };
  lua_State* L = luaL_newstate();
  luaL_openlibs(L);

  lua_pushcfunction(L, midi_send);
  lua_setglobal(L, "midi_send");

  luaL_dostring(L,"song = require 'notation'");
  int err = luaL_dofile(L, argv[1]);
  if(err){
    std::cerr << "Error: Problem reading file\n\n";
    err_handle(L);
    return -3;
  }
  else {
    luaL_dostring(L,"song.go()");
  }

  lua_close(L);
  return 0;
}
