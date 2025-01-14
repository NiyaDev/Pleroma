

import std::io;
import keybind;
import raylib;



fn void keyb_init_close() @test {
  //* Test if "initialize()" has gone off
  assert(keybind::data.is_initialized(), "Keybind data not initialized");
  
  keybind::get_keyboard_bind();
}

