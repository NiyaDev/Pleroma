
module pleroma::raylib;


<* Mouse buttons *>
enum MouseButton {
  LEFT,       // Mouse button left
  RIGHT,      // Mouse button right
  MIDDLE,     // Mouse button middle (pressed wheel)
  SIDE,       // Mouse button side (advanced mouse device)
  EXTRA,      // Mouse button extra (advanced mouse device)
  FORWARD,    // Mouse button fordward (advanced mouse device)
  BACK,       // Mouse button back (advanced mouse device)
}
<* Mouse axis *>
enum MouseAxis {
  X,
  Y,
  SCROLL,
}
<* Gamepad buttons *>
enum GamepadButton : int {
  UNKNOWN,             // Unknown button, just for error checking
  LEFT_FACE_UP,        // Gamepad left DPAD up button
  LEFT_FACE_RIGHT,     // Gamepad left DPAD right button
  LEFT_FACE_DOWN,      // Gamepad left DPAD down button
  LEFT_FACE_LEFT,      // Gamepad left DPAD left button
  RIGHT_FACE_UP,       // Gamepad right button up (i.e. PS3: Triangle, Xbox: Y)
  RIGHT_FACE_RIGHT,    // Gamepad right button right (i.e. PS3: Square, Xbox: X)
  RIGHT_FACE_DOWN,     // Gamepad right button down (i.e. PS3: Cross, Xbox: A)
  RIGHT_FACE_LEFT,     // Gamepad right button left (i.e. PS3: Circle, Xbox: B)
  LEFT_TRIGGER_1,      // Gamepad top/back trigger left (first), it could be a trailing button
  LEFT_TRIGGER_2,      // Gamepad top/back trigger left (second), it could be a trailing button
  RIGHT_TRIGGER_1,     // Gamepad top/back trigger right (one), it could be a trailing button
  RIGHT_TRIGGER_2,     // Gamepad top/back trigger right (second), it could be a trailing button
  MIDDLE_LEFT,         // Gamepad center buttons, left one (i.e. PS3: Select)
  MIDDLE,              // Gamepad center buttons, middle one (i.e. PS3: PS, Xbox: XBOX)
  MIDDLE_RIGHT,        // Gamepad center buttons, right one (i.e. PS3: Start)
  LEFT_THUMB,          // Gamepad joystick pressed button left
  RIGHT_THUMB          // Gamepad joystick pressed button right
}
<* Gamepad Axis *>
enum GamepadAxis : int {
  LEFT_X,           // Gamepad left stick X axis
  LEFT_Y,           // Gamepad left stick Y axis
  RIGHT_X,          // Gamepad right stick X axis
  RIGHT_Y,          // Gamepad right stick Y axis
  LEFT_TRIGGER,     // Gamepad back trigger left, pressure level: [1..-1]
  RIGHT_TRIGGER     // Gamepad back trigger right, pressure level: [1..-1]
}


<* Keyboard Keys *>
distinct KeyboardKey = int;

const KeyboardKey KEY_NULL            = 0;        // Key: NULL; used for no key pressed
// Alphanumeric keys
const KeyboardKey KEY_APOSTROPHE      = 39;       // Key: '
const KeyboardKey KEY_COMMA           = 44;       // Key: ;
const KeyboardKey KEY_MINUS           = 45;       // Key: -
const KeyboardKey KEY_PERIOD          = 46;       // Key: .
const KeyboardKey KEY_SLASH           = 47;       // Key: /
const KeyboardKey KEY_ZERO            = 48;       // Key: 0
const KeyboardKey KEY_ONE             = 49;       // Key: 1
const KeyboardKey KEY_TWO             = 50;       // Key: 2
const KeyboardKey KEY_THREE           = 51;       // Key: 3
const KeyboardKey KEY_FOUR            = 52;       // Key: 4
const KeyboardKey KEY_FIVE            = 53;       // Key: 5
const KeyboardKey KEY_SIX             = 54;       // Key: 6
const KeyboardKey KEY_SEVEN           = 55;       // Key: 7
const KeyboardKey KEY_EIGHT           = 56;       // Key: 8
const KeyboardKey KEY_NINE            = 57;       // Key: 9
const KeyboardKey KEY_SEMICOLON       = 59;       // Key: ;
const KeyboardKey KEY_EQUAL           = 61;       // Key: =
const KeyboardKey KEY_A               = 65;       // Key: A | a
const KeyboardKey KEY_B               = 66;       // Key: B | b
const KeyboardKey KEY_C               = 67;       // Key: C | c
const KeyboardKey KEY_D               = 68;       // Key: D | d
const KeyboardKey KEY_E               = 69;       // Key: E | e
const KeyboardKey KEY_F               = 70;       // Key: F | f
const KeyboardKey KEY_G               = 71;       // Key: G | g
const KeyboardKey KEY_H               = 72;       // Key: H | h
const KeyboardKey KEY_I               = 73;       // Key: I | i
const KeyboardKey KEY_J               = 74;       // Key: J | j
const KeyboardKey KEY_K               = 75;       // Key: K | k
const KeyboardKey KEY_L               = 76;       // Key: L | l
const KeyboardKey KEY_M               = 77;       // Key: M | m
const KeyboardKey KEY_N               = 78;       // Key: N | n
const KeyboardKey KEY_O               = 79;       // Key: O | o
const KeyboardKey KEY_P               = 80;       // Key: P | p
const KeyboardKey KEY_Q               = 81;       // Key: Q | q
const KeyboardKey KEY_R               = 82;       // Key: R | r
const KeyboardKey KEY_S               = 83;       // Key: S | s
const KeyboardKey KEY_T               = 84;       // Key: T | t
const KeyboardKey KEY_U               = 85;       // Key: U | u
const KeyboardKey KEY_V               = 86;       // Key: V | v
const KeyboardKey KEY_W               = 87;       // Key: W | w
const KeyboardKey KEY_X               = 88;       // Key: X | x
const KeyboardKey KEY_Y               = 89;       // Key: Y | y
const KeyboardKey KEY_Z               = 90;       // Key: Z | z
const KeyboardKey KEY_LEFT_BRACKET    = 91;       // Key: [
const KeyboardKey KEY_BACKSLASH       = 92;       // Key: '\'
const KeyboardKey KEY_RIGHT_BRACKET   = 93;       // Key: ]
const KeyboardKey KEY_GRAVE           = 96;       // Key: `
// Function keys
const KeyboardKey KEY_SPACE           = 32;       // Key: Space
const KeyboardKey KEY_ESCAPE          = 256;      // Key: Esc
const KeyboardKey KEY_ENTER           = 257;      // Key: Enter
const KeyboardKey KEY_TAB             = 258;      // Key: Tab
const KeyboardKey KEY_BACKSPACE       = 259;      // Key: Backspace
const KeyboardKey KEY_INSERT          = 260;      // Key: Ins
const KeyboardKey KEY_DELETE          = 261;      // Key: Del
const KeyboardKey KEY_RIGHT           = 262;      // Key: Cursor right
const KeyboardKey KEY_LEFT            = 263;      // Key: Cursor left
const KeyboardKey KEY_DOWN            = 264;      // Key: Cursor down
const KeyboardKey KEY_UP              = 265;      // Key: Cursor up
const KeyboardKey KEY_PAGE_UP         = 266;      // Key: Page up
const KeyboardKey KEY_PAGE_DOWN       = 267;      // Key: Page down
const KeyboardKey KEY_HOME            = 268;      // Key: Home
const KeyboardKey KEY_END             = 269;      // Key: End
const KeyboardKey KEY_CAPS_LOCK       = 280;      // Key: Caps lock
const KeyboardKey KEY_SCROLL_LOCK     = 281;      // Key: Scroll down
const KeyboardKey KEY_NUM_LOCK        = 282;      // Key: Num lock
const KeyboardKey KEY_PRINT_SCREEN    = 283;      // Key: Print screen
const KeyboardKey KEY_PAUSE           = 284;      // Key: Pause
const KeyboardKey KEY_F1              = 290;      // Key: F1
const KeyboardKey KEY_F2              = 291;      // Key: F2
const KeyboardKey KEY_F3              = 292;      // Key: F3
const KeyboardKey KEY_F4              = 293;      // Key: F4
const KeyboardKey KEY_F5              = 294;      // Key: F5
const KeyboardKey KEY_F6              = 295;      // Key: F6
const KeyboardKey KEY_F7              = 296;      // Key: F7
const KeyboardKey KEY_F8              = 297;      // Key: F8
const KeyboardKey KEY_F9              = 298;      // Key: F9
const KeyboardKey KEY_F10             = 299;      // Key: F10
const KeyboardKey KEY_F11             = 300;      // Key: F11
const KeyboardKey KEY_F12             = 301;      // Key: F12
const KeyboardKey KEY_LEFT_SHIFT      = 340;      // Key: Shift left
const KeyboardKey KEY_LEFT_CONTROL    = 341;      // Key: Control left
const KeyboardKey KEY_LEFT_ALT        = 342;      // Key: Alt left
const KeyboardKey KEY_LEFT_SUPER      = 343;      // Key: Super left
const KeyboardKey KEY_RIGHT_SHIFT     = 344;      // Key: Shift right
const KeyboardKey KEY_RIGHT_CONTROL   = 345;      // Key: Control right
const KeyboardKey KEY_RIGHT_ALT       = 346;      // Key: Alt right
const KeyboardKey KEY_RIGHT_SUPER     = 347;      // Key: Super right
const KeyboardKey KEY_KB_MENU         = 348;      // Key: KB menu
// Keypad keys
const KeyboardKey KEY_KP_0            = 320;      // Key: Keypad 0
const KeyboardKey KEY_KP_1            = 321;      // Key: Keypad 1
const KeyboardKey KEY_KP_2            = 322;      // Key: Keypad 2
const KeyboardKey KEY_KP_3            = 323;      // Key: Keypad 3
const KeyboardKey KEY_KP_4            = 324;      // Key: Keypad 4
const KeyboardKey KEY_KP_5            = 325;      // Key: Keypad 5
const KeyboardKey KEY_KP_6            = 326;      // Key: Keypad 6
const KeyboardKey KEY_KP_7            = 327;      // Key: Keypad 7
const KeyboardKey KEY_KP_8            = 328;      // Key: Keypad 8
const KeyboardKey KEY_KP_9            = 329;      // Key: Keypad 9
const KeyboardKey KEY_KP_DECIMAL      = 330;      // Key: Keypad .
const KeyboardKey KEY_KP_DIVIDE       = 331;      // Key: Keypad /
const KeyboardKey KEY_KP_MULTIPLY     = 332;      // Key: Keypad *
const KeyboardKey KEY_KP_SUBTRACT     = 333;      // Key: Keypad -
const KeyboardKey KEY_KP_ADD          = 334;      // Key: Keypad +
const KeyboardKey KEY_KP_ENTER        = 335;      // Key: Keypad Enter
const KeyboardKey KEY_KP_EQUAL        = 336;      // Key: Keypad =
// Android key buttons
const KeyboardKey KEY_BACK            = 4;        // Key: Android back button
const KeyboardKey KEY_MENU            = 82;       // Key: Android menu button
const KeyboardKey KEY_VOLUME_UP       = 24;       // Key: Android volume up button
const KeyboardKey KEY_VOLUME_DOWN     = 25;       // Key: Android volume down button

