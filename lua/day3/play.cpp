extern "C"
{
#include "lua.h"
#include "lauxlib.h"
#include "lualib.h"
}

#include "RtMidi.h"
static RtMidiOut midi;

int midi_send(lua_State* L)
{
    double volume = lua_tonumber(L, -4);
    double status = lua_tonumber(L, -3);
    double data1  = lua_tonumber(L, -2);
    double data2  = lua_tonumber(L, -1);

    std::vector<unsigned char> volmsg(3);
    volmsg[0] = static_cast<unsigned char>(176); // cf: http://www.midi.org/techspecs/midimessages.php
    volmsg[1] = static_cast<unsigned char>(7);
    volmsg[2] = static_cast<unsigned char>(volume);

    //std::cout << "Volume: " << volume;

    midi.sendMessage(&volmsg);

    std::vector<unsigned char> message(3);
    message[0] = static_cast<unsigned char>(status);
    message[1] = static_cast<unsigned char>(data1);
    message[2] = static_cast<unsigned char>(data2);

    midi.sendMessage(&message);

    return 0;
}

int err_handle(lua_State *state) 
{
      if (!lua_isstring(state, lua_gettop(state)))
        std::cout << "Undefined error. What the actual fuck?";
      
      std::string str = lua_tostring(state, lua_gettop(state));
      lua_pop(state, 1);

      std::cout << str;
      std::cout << "\n";
  return 1;
}

int main(int argc, const char* argv[])
{
    if (argc < 1) { return -1; }

    unsigned int ports = midi.getPortCount();
    if (ports < 1) { return -1; }
    //    std::cout << "port 1";
    midi.openPort(1);   // Note: on my system, running timidity port is 1

    lua_State* L = luaL_newstate();
    luaL_openlibs(L);

    lua_pushcfunction(L, midi_send);
    lua_setglobal(L, "midi_send");

    luaL_dostring(L,"song = require 'notation'");
    int err = luaL_dofile(L, argv[1]);
    if(err){
      std::cout << "Error: Problem reading file:\n\n";
      err_handle(L);
    }
    else {
      luaL_dostring(L,"song.go()");
    }
    //luaL_dofile(L, argv[1]);

    lua_close(L);
    return 0;
}


