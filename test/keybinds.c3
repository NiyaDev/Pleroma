

import std::io;
import pleroma::keybind;
import pleroma::raylib;



fn void keyb_init_close() @test {
  Keybind kb_up    = {.type=KEYBOARD,.kb=raylib::KEY_W};
  Keybind kb_down  = {.type=KEYBOARD,.kb=raylib::KEY_S};
  Keybind kb_left  = {.type=KEYBOARD,.kb=raylib::KEY_A};
  Keybind kb_right = {.type=KEYBOARD,.kb=raylib::KEY_D}; 
  keybind::set("move_up",    kb_up);
  keybind::set("move_down",  kb_down); 
  keybind::set("move_left",  kb_left); 
  keybind::set("move_right", kb_right);

  char[] saved_kb = keybind::save();

  //* KB move_left
  assert((String)saved_kb[0:9] == "move_left", "Failed to save Keybind \"move_left\"");
  //* KB move_down
  assert((String)saved_kb[26:9] == "move_down", "Failed to save Keybind \"move_down\"");
  //* KB move_right
  assert((String)saved_kb[52:10] == "move_right", "Failed to save Keybind \"move_right\"");
  //* KB move_right
  assert((String)saved_kb[79:7] == "move_up", "Failed to save Keybind \"move_up\"");

  //* Clear old keybinding and load from saved
  keybind::clear();
  keybind::load(saved_kb);
  
  assert(keybind::get("move_up").equals(kb_up), "Failed to load \"move_up\"");
  assert(keybind::get("move_down").equals(kb_down), "Failed to load \"move_down\"");
  assert(keybind::get("move_left").equals(kb_left), "Failed to load \"move_left\"");
  assert(keybind::get("move_right").equals(kb_right), "Failed to load \"move_right\""); 
}

