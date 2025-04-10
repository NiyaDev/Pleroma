

import std::io;
import pleroma::keybind;
import pleroma::raylib;



fn void keyb_init_close() @test {
  Keybindings kb;

  Keybind kb_up    = {.type=KEYBOARD,.kb=raylib::KEY_W};
  Keybind kb_down  = {.type=KEYBOARD,.kb=raylib::KEY_S};
  Keybind kb_left  = {.type=KEYBOARD,.kb=raylib::KEY_A};
  Keybind kb_right = {.type=KEYBOARD,.kb=raylib::KEY_D};

  kb.set("move_up",    kb_up);
  kb.set("move_down",  kb_down); 
  kb.set("move_left",  kb_left); 
  kb.set("move_right", kb_right);

  char[] saved_kb = kb.save();
  defer free(saved_kb);

  //* KB move_left
  assert((String)saved_kb[0:9] == "move_left", "Failed to save Keybind \"move_left\"");
  //* KB move_down
  assert((String)saved_kb[26:9] == "move_down", "Failed to save Keybind \"move_down\"");
  //* KB move_right
  assert((String)saved_kb[52:10] == "move_right", "Failed to save Keybind \"move_right\"");
  //* KB move_right
  assert((String)saved_kb[79:7] == "move_up", "Failed to save Keybind \"move_up\""); 

  //* Clear old keybinding and load from saved
  kb.clear();
  kb = keybind::load(saved_kb);
  
  assert(kb.get("move_up")!!.equals(kb_up), "Failed to load \"move_up\"");
  assert(kb.get("move_down")!!.equals(kb_down), "Failed to load \"move_down\"");
  assert(kb.get("move_left")!!.equals(kb_left), "Failed to load \"move_left\"");
  assert(kb.get("move_right")!!.equals(kb_right), "Failed to load \"move_right\""); 

}

