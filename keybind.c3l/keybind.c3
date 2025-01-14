
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


<*  *>
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

<* *>
fn Keybind get_keyboard_bind() {
  Keybind output;
  output.type = KEYBOARD;
  output.pad = -1;

  //* Checking for modifiers
  switch (true) {
    //* Numbers
    case raylib::is_key_down(raylib::KEY_ONE):
      output.kb_m = raylib::KEY_ONE;
    case raylib::is_key_down(raylib::KEY_TWO):
      output.kb_m = raylib::KEY_TWO;
    case raylib::is_key_down(raylib::KEY_THREE):
      output.kb_m = raylib::KEY_THREE;
    case raylib::is_key_down(raylib::KEY_FOUR):
      output.kb_m = raylib::KEY_FOUR;
    case raylib::is_key_down(raylib::KEY_FIVE):
      output.kb_m = raylib::KEY_FIVE;
    case raylib::is_key_down(raylib::KEY_SIX):
      output.kb_m = raylib::KEY_SIX;
    case raylib::is_key_down(raylib::KEY_SEVEN):
      output.kb_m = raylib::KEY_SEVEN;
    case raylib::is_key_down(raylib::KEY_EIGHT):
      output.kb_m = raylib::KEY_EIGHT;
    case raylib::is_key_down(raylib::KEY_NINE):
      output.kb_m = raylib::KEY_NINE;
    case raylib::is_key_down(raylib::KEY_ZERO):
      output.kb_m = raylib::KEY_ZERO;
    //* Characters
    case raylib::is_key_down(raylib::KEY_A):
      output.kb_m = raylib::KEY_A;
    case raylib::is_key_down(raylib::KEY_B):
      output.kb_m = raylib::KEY_B;
    case raylib::is_key_down(raylib::KEY_C):
      output.kb_m = raylib::KEY_C;
    case raylib::is_key_down(raylib::KEY_D):
      output.kb_m = raylib::KEY_D;
    case raylib::is_key_down(raylib::KEY_E):
      output.kb_m = raylib::KEY_E;
    case raylib::is_key_down(raylib::KEY_F):
      output.kb_m = raylib::KEY_F;
    case raylib::is_key_down(raylib::KEY_G):
      output.kb_m = raylib::KEY_G;
    case raylib::is_key_down(raylib::KEY_H):
      output.kb_m = raylib::KEY_H;
    case raylib::is_key_down(raylib::KEY_I):
      output.kb_m = raylib::KEY_I;
    case raylib::is_key_down(raylib::KEY_J):
      output.kb_m = raylib::KEY_J;
    case raylib::is_key_down(raylib::KEY_K):
      output.kb_m = raylib::KEY_K;
    case raylib::is_key_down(raylib::KEY_L):
      output.kb_m = raylib::KEY_L;
    case raylib::is_key_down(raylib::KEY_M):
      output.kb_m = raylib::KEY_M;
    case raylib::is_key_down(raylib::KEY_N):
      output.kb_m = raylib::KEY_N;
    case raylib::is_key_down(raylib::KEY_O):
      output.kb_m = raylib::KEY_O;
    case raylib::is_key_down(raylib::KEY_P):
      output.kb_m = raylib::KEY_P;
    case raylib::is_key_down(raylib::KEY_Q):
      output.kb_m = raylib::KEY_Q;
    case raylib::is_key_down(raylib::KEY_R):
      output.kb_m = raylib::KEY_R;
    case raylib::is_key_down(raylib::KEY_S):
      output.kb_m = raylib::KEY_S;
    case raylib::is_key_down(raylib::KEY_T):
      output.kb_m = raylib::KEY_T;
    case raylib::is_key_down(raylib::KEY_U):
      output.kb_m = raylib::KEY_U;
    case raylib::is_key_down(raylib::KEY_V):
      output.kb_m = raylib::KEY_V;
    case raylib::is_key_down(raylib::KEY_W):
      output.kb_m = raylib::KEY_W;
    case raylib::is_key_down(raylib::KEY_X):
      output.kb_m = raylib::KEY_X;
    case raylib::is_key_down(raylib::KEY_Y):
      output.kb_m = raylib::KEY_Y;
    case raylib::is_key_down(raylib::KEY_Z):
      output.kb_m = raylib::KEY_Z;
    //* Others

    case raylib::is_key_down(raylib::KEY_LEFT_SHIFT):
      output.kb_m = raylib::KEY_LEFT_SHIFT;
    case raylib::is_key_down(raylib::KEY_RIGHT_SHIFT):
      output.kb_m = raylib::KEY_RIGHT_SHIFT;
    case raylib::is_key_down(raylib::KEY_LEFT_CONTROL):
      output.kb_m = raylib::KEY_LEFT_CONTROL;
    case raylib::is_key_down(raylib::KEY_RIGHT_CONTROL):
      output.kb_m = raylib::KEY_RIGHT_CONTROL;
    case raylib::is_key_down(raylib::KEY_LEFT_ALT):
      output.kb_m = raylib::KEY_LEFT_ALT;
    case raylib::is_key_down(raylib::KEY_RIGHT_ALT):
      output.kb_m = raylib::KEY_RIGHT_ALT;
    case raylib::is_key_down(raylib::KEY_UP):
      output.kb_m = raylib::KEY_UP;
    case raylib::is_key_down(raylib::KEY_DOWN):
      output.kb_m = raylib::KEY_DOWN;
    case raylib::is_key_down(raylib::KEY_LEFT):
      output.kb_m = raylib::KEY_LEFT;
    case raylib::is_key_down(raylib::KEY_RIGHT):
      output.kb_m = raylib::KEY_RIGHT;
  }
  while (true) {
    KeyboardKey key = raylib::get_key_pressed();
    if (key != raylib::KEY_NULL) {
      output.kb = key;
      break;
    }
  }

  return output;
}

