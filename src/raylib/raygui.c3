
module pleroma::raygui;
import pleroma::raylib;

struct GuiStyleProp {
  ushort control_id;
  ushort property_id;
  int property_value;
}

enum GuiState {
  NORMAL,
  FOCUSED,
  PRESSED,
  DISABLE,
}

enum GuiTextAlignment {
  LEFT,
  CENTER,
  RIGHT,
}

enum GuiTextAlignmentVertical {
  TOP,
  MIDDLE,
  BOTTOM,
}

enum GuiTextWrapMode {
  NONE,
  CHAR,
  WORD,
}

enum GuiControl {
  DEFAULT,
  LABEL,
  BUTTON,
  TOGGLE,
  SLIDER,
  PROGRESSBAR,
  CHECKBOX,
  COMBOBOX,
  DROPDOWNBOX,
  TEXTBOX,
  VALUEBOX,
  CONTROL11,
  LISTVIEW,
  COLORPICKER,
  SCROLLBAR,
  STATUSBAR,
}

enum GuiControlProperty {
  BORDER_COLOR_NORMAL,
  BASE_COLOR_NORMAL,
  TEXT_COLOR_NORMAL,
  BORDER_COLOR_FOCUSED,
  BASE_COLOR_FOCUSED,
  TEXT_COLOR_FOCUSED,
  BORDER_COLOR_PRESSED,
  BASE_COLOR_PRESSED,
  TEXT_COLOR_PRESSED,
  BORDER_COLOR_DISABLED,
  BASE_COLOR_DISABLED,
  TEXT_COLOR_DISABLED,
  BORDER_WIDTH,
  //TEXT_SIZE,
  //TEXT_SPACING,
  //TEXT_LINE_SPACING,
  TEXT_PADDING,
  TEXT_ALIGNMENT,
  //TEXT_WRAP_MODE,
}

enum GuiDefaultProperty {
  TEXT_SIZE, // 16
  TEXT_SPACING,
  LINE_COLOR,
  BACKGROUND_COLOR,
  TEXT_LINE_SPACING,
  TEXT_ALIGNMENT_VERTICAL,
  TEXT_WRAP_MODE,
}

enum GuiToggleProperty {
  GROUP_PADDING, // 16
}

enum GuiSliderProperty {
  SLIDER_WIDTH, // 16
  SLIDER_PADDING,
}

enum GuiProgressBarrProperty {
  PROGRESS_PADDING, // 16
}

enum GuiScrollBarProperty {
  ARROWS_SIZE, // 16
  ARROWS_VISIBLE,
  SCROLL_SLIDER_PADDING,
  SCROLL_SLIDER_SIZE,
  SCROLL_PADDING,
  SCROLL_SPEED,
}

enum GuiCheckBoxProperty {
  CHECK_PADDING, // 16
}

enum GuiComboBoxProperty {
  COMBO_BUTTON_WIDTH, // 16
  COMBO_BUTTON_SPACING,
}

enum GuiDropdownBoxProperty {
  ARROW_PADDING, // 16
  DROPDOWN_ITEMS_SPACING,
  DROPDOWN_ARROW_HIDDEN,
  DROPDOWN_ROLLUP,
}

enum GuiTextBoxProperty {
  TEXT_READONLY, // 16
}

enum GuiValueBoxProperty {
  SPINNER_BUTTON_WIDTH, // 16
  SPINNER_BUTTON_SPACING,
}

enum GuiListViewProperty {
  LIST_ITEMS_HEIGHT, // 16
  LIST_ITEMS_SPACING,
  SCROLLBAR_WIDTH,
  SCROLLBAR_SIDE,
  LIST_ITEMS_BORDER_NORMAL,
  LIST_ITEMS_BORDER_WIDTH,
}

enum GuiColorPickerProperty {
  COLOR_SELECTOR_SIZE, // 16
  HUEBAR_WIDTH,
  HUEBAR_PADDING,
  HUEBAR_SELECTOR_HEIGHT,
  HUEBAR_SELECTOR_OVERFLOW,
}

const int SCROLLBAR_LEFT_SIDE  = 0;
const int SCROLLBAR_RIGHT_SIDE = 1;


extern fn void enable() @extern("GuiEnable");
extern fn void disable() @extern("GuiDisable");
extern fn void lock() @extern("GuiLock");
extern fn void unlock() @extern("GuiUnlock");
extern fn bool is_locked() @extern("GuiIsLocked");
extern fn void set_alpha(float) @extern("GuiSetAlpha");
extern fn void set_state(int) @extern("GuiSetState");
extern fn int  get_state() @extern("GuiGetState");

extern fn void set_font(Font) @extern("GuiSetFont");
extern fn Font get_font() @extern("GuiGetFont");

extern fn void set_style(int, int, int) @extern("GuiSetStyle");
extern fn int  get_style(int, int) @extern("GuiGetStyle");

extern fn void load_style(char*) @extern("GuiLoadStyle");
extern fn void load_style_def() @extern("GuiLoadStyleDefault");

extern fn void enable_tooltip() @extern("GuiEnableTooltip");
extern fn void disable_tooltip() @extern("GuiDisableTooltip");
extern fn void set_tooltip(char*) @extern("GuiSetTooltip");

extern fn char*  icon_text(int, char*) @extern("GuiIconText");
extern fn void   set_icon_scale(int) @extern("GuiSetIconScale");
extern fn uint*  get_icons() @extern("GuiGetIcons");
extern fn char** load_icons(char*, bool) @extern("GuiLoadIcons");
extern fn void   draw_icon(int, int, int, int, Color) @extern("GuiDrawIcon");


extern fn int window_box(Rectangle, char*) @extern("GuiWindowBox");
extern fn int group_box(Rectangle, char*) @extern("GuiGroupBox");
extern fn int line(Rectangle, char*) @extern("GuiLine");
extern fn int panel(Rectangle, char*) @extern("GuiPanel");
extern fn int tab_bar(Rectangle, char**, int, int*) @extern("GuiTabBar");
extern fn int scroll_panel(Rectangle, char*, Rectangle, Vector2*, Rectangle*) @extern("GuiScrollPanel");


