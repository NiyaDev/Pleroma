

import std::io;
import keybind;
import raylib;



fn void keyb_init_close() @test {
  //* Test if "initialize()" has gone off
  assert(keybind::data.is_initialized(), "Keybind data not initialized");
  
  //keybind::get_keyboard_bind();
  //keybind::is_scanning = false;
  //while (!raylib::window_should_close()) {
  //  
  //  if (raylib::is_mouse_button_pressed(raylib::MouseButton.LEFT)) keybind::ready_scan();
  //  keybind::scan();
  //  if (raylib::is_key_pressed(raylib::KEY_ENTER)) io::printfn("%s - %s", keybind::key_m, keybind::key_b);
//
  //  keybind::data.set("test_1", {.type = KEYBOARD, .kb = raylib::KEY_S, .kb_m = raylib::KEY_NULL});
  //  keybind::data.set("test_2", {.type = KEYBOARD, .kb = raylib::KEY_S, .kb_m = raylib::KEY_LEFT_SHIFT});
  //  if (keybind::is_pressed("test_1")!!) io::printfn("S");
  //  if (keybind::is_pressed("test_2")!!) io::printfn("SHIFT-S");
//
  //  raylib::begin_drawing();
  //    if (keybind::is_scanning) {
  //      raylib::clear_background(raylib::RED);
  //    } else {
  //      raylib::clear_background(raylib::GRAY);
  //    }
  //  raylib::end_drawing();
  //}
  //Keybind kb = keybind::convert_scan();
  //assert(kb.kb == raylib::KEY_A && kb.kb_m == raylib::KEY_LEFT_SHIFT, "Converted scan not correct");
}

