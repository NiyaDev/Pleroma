
module pleroma::keybind;
import std::io;
import std::collections;
import pleroma::raylib;
import pleroma::logos;


<* Define Keybindings structure that is a global *>
alias Keybindings = HashMap{String, Keybind};

KeyType last_type = KEYBOARD;

<* Saves keybindings as char array *>
fn char[] Keybindings.save(&self) @export("keybind_save") {
  //* Get length of data and strings
  usz length = self.len() * 16;
  self.@each(; String key, Keybind val) {
    length += key.len + 1;
  };

  char[] output = mem::new_array(char, length);

  usz ptr;
  self.@each(; String key, Keybind val) {
    //* Key string
    for (int i; i < key.len; i++) output[ptr++] = key[i];
    output[ptr++] = '\0';

    //* Type
    output[ptr++] = (char)(val.type.ordinal >>  0);
    output[ptr++] = (char)(val.type.ordinal >>  8);
    output[ptr++] = (char)(val.type.ordinal >> 16);
    output[ptr++] = (char)(val.type.ordinal >> 24);

    //* Keypress
    output[ptr++] = (char)(val.kb >>  0);
    output[ptr++] = (char)(val.kb >>  8);
    output[ptr++] = (char)(val.kb >> 16);
    output[ptr++] = (char)(val.kb >> 24);

    //* Keymod
    output[ptr++] = (char)(val.kb_m >>  0);
    output[ptr++] = (char)(val.kb_m >>  8);
    output[ptr++] = (char)(val.kb_m >> 16);
    output[ptr++] = (char)(val.kb_m >> 24);

    //* Gamepad
    output[ptr++] = (char)(val.pad >>  0);
    output[ptr++] = (char)(val.pad >>  8);
    output[ptr++] = (char)(val.pad >> 16);
    output[ptr++] = (char)(val.pad >> 24); 
  };

  return output;
}
<* Loads keybindings from char array *>
fn Keybindings load(char[] data) @export("keybind_load") {
  Keybindings output;

  Logos file = data.to_logos();

  while (file.head < file.data.len) {
    LogosData key = file.read(STRING);
    defer key.free();
    output.set(key.as_string, {
      .type = KeyType.from_ordinal(file.read(INT).as_int),
      .kb   = (KeyboardKey)file.read(INT).as_int,
      .kb_m = (KeyboardKey)file.read(INT).as_int,
      .pad  = file.read(INT).as_int,
    });
  }
  return output;
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

<* Compare two Keybinds *>
fn bool Keybind.equals(&self, Keybind rhs) {
  return (self.type == rhs.type && self.kb == rhs.kb && self.kb_m == rhs.kb_m && self.pad == rhs.pad);
}

<* Check if Keybind is pressed *>
fn bool Keybindings.is_pressed(&self, String name) @export("keybind_pressed") {
  assert(self.has_key(name), "Keybinding doesn't exist.");

  Keybind bind = self.get(name)!!;

  switch (bind.type) {
    case KEYBOARD:
      if ((bind.kb_m == raylib::KEY_NULL || raylib::is_key_down(bind.kb_m)) && raylib::is_key_pressed(bind.kb)) return true;
    default:
  }

  return false;
}
<* Check if Keybind is down *>
fn bool Keybindings.is_down(&self, String name) @export("keybind_down") {
  assert(self.has_key(name), "Keybinding doesn't exist.");

  Keybind bind = self.get(name)!!;

  switch (bind.type) {
    case KEYBOARD:
      if ((bind.kb_m == raylib::KEY_NULL || raylib::is_key_down(bind.kb_m)) && raylib::is_key_down(bind.kb)) return true;
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
fn void ready_scan(float time = 1) @export("keybind_readyscan") {
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
fn void scan() @export("keybind_scan") {
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
fn Keybind convert_scan() @export("keybind_convertscan") {
  return {
    .type = KEYBOARD,
    .kb_m = key_m,
    .kb   = key_b,
    .pad  = -1,
  };
}

