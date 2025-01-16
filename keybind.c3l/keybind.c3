
module keybind;
import std::io;
import std::collections;
import raylib;


<* Distinct keybindings structure that is a global *>
HashMap(<String, Keybind>) data;
KeyType last_type = KEYBOARD;
<* Initialize keybindings *>
fn void initialize() @init {
  data.new_init();
}


<* Core keybind structure *>
struct Keybind {
  KeyType type;

  union {
    KeyboardKey kb;
    MouseButton mb;
    MouseAxis ma;
    GamepadButton gpb;
    GamepadAxis gpa;
  }
  union {
    KeyboardKey kb_m;
    MouseButton mb_m;
    GamepadButton gpb_m;
  }

  int pad;
}

enum KeyType {
  KEYBOARD,
  MOUSE_BUTTON,
  MOUSE_AXIS,
  GAMEPAD_BUTTON,
  GAMEPAD_AXIS,
}

fault KeybindFault {
  NO_BINDING,
}


<* Check if Keybind is pressed *>
fn bool! is_pressed(String name) {
  if (!data.has_key(name)) {
    io::printf("ERROR - Keybinding doesn't exist [%s]", name);
    return KeybindFault.NO_BINDING?;
  }

  Keybind bind = data[name]!!;

  switch (bind.type) {
    case KEYBOARD:
      if ((bind.kb_m == raylib::KEY_NULL || raylib::is_key_down(bind.kb_m)) && raylib::is_key_pressed(bind.kb)) return true;
    default:
  }

  return false;
}

// TODO: Function to make sure only main key is pressed in bindingds without modifiers?


bool is_scanning;
float scanning_time = 1;
KeyboardKey key_m;
KeyboardKey key_b;

<* Gets ready for scan *>
fn void ready_scan(float time = 1) {
  //* Reset everything
  key_m = raylib::KEY_NULL;
  key_b = raylib::KEY_NULL;
  is_scanning = true;
  scanning_time = time;

  //* Clear key queue
  while (true) {
    KeyboardKey key = raylib::get_key_pressed();
    if (key == raylib::KEY_NULL) return;
  }
}
<* Scans get_key_pressed() *>
fn void scan() {
  if (is_scanning) {
    if (scanning_time > 0) {
      scanning_time -= raylib::get_frame_time();
      KeyboardKey key = raylib::get_key_pressed();
      
      if (key == raylib::KEY_NULL) return;
      if (key_b != raylib::KEY_NULL) {
        is_scanning = false;
        scanning_time = 1;
        key_m = key_b;
      }
      key_b = key;
    } else {
      scanning_time = 1;
      is_scanning = false;
    }
  }
}
<* Converts scanned keybind into structure *>
fn Keybind convert_scan() {
  return {
    .type = KEYBOARD,
    .kb_m = key_m,
    .kb   = key_b,
    .pad  = -1,
  };
}

