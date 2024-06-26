

/// Keyboard Keys stolen from raylib
#[derive(Debug, Clone, Copy, PartialEq)]
pub enum KeyboardKey {
	/// Key: NULL, used for no key pressed
	Null		= 0,
	/// Key: '
	Apostrophe	= 39,
	/// Key: ,
	Comma		= 44,
	/// Key: -
	Minus		= 45,
	/// Key: .
	Period		= 46,
	/// Key: /
	Slash		= 47,
	/// Key: 0
	Zero		= 48,
	/// Key: 1
	One			= 49,
	/// Key: 2
	Two			= 50,
	/// Key: 3
	Three		= 51,
	/// Key: 4
	Four		= 52,
	/// Key: 5
	Five		= 53,
	/// Key: 6
	Six			= 54,
	/// Key: 7
	Seven		= 55,
	/// Key: 8
	Eight		= 56,
	/// Key: 9
	Nine		= 57,
	/// Key: ;
	Semicolon	= 59,
	/// Key: =
	Equal		= 61,
	/// Key: A | a
	A			= 65,
	/// Key: B | b
	B			= 66,
	/// Key: C | c
	C			= 67,
	/// Key: D | d
	D			= 68,
	/// Key: E | e
	E			= 69,
	/// Key: F | f
	F			= 70,
	/// Key: G | g
	G			= 71,
	/// Key: H | h
	H			= 72,
	/// Key: I | i
	I			= 73,
	/// Key: J | j
	J			= 74,
	/// Key: K | k
	K			= 75,
	/// Key: L | l
	L			= 76,
	/// Key: M | m
	M			= 77,
	/// Key: N | n
	N			= 78,
	/// Key: O | o
	O			= 79,
	/// Key: P | p
	P			= 80,
	/// Key: Q | q
	Q			= 81,
	/// Key: R | r
	R			= 82,
	/// Key: S | s
	S			= 83,
	/// Key: T | t
	T			= 84,
	/// Key: U | u
	U			= 85,
	/// Key: V | v
	V			= 86,
	/// Key: W | w
	W			= 87,
	/// Key: X | x
	X			= 88,
	/// Key: Y | y
	Y			= 89,
	/// Key: Z | z
	Z			= 90,
	/// Key: [
	LeftBracket	= 91,
	/// Key: '\'
	Backslash	= 92,
	/// Key: ]
	RightBracket = 93,
	/// Key: `
	Grave		= 96,
	/// Key: Space
	Space		= 32,
	/// Key: Esc
	Escape		= 256,
	/// Key: Enter
	Enter		= 257,
	/// Key: Tab
	Tab			= 258,
	/// Key: Backspace
	Backspace 	= 259,
	/// Key: Ins
	Insert		= 260,
	/// Key: Del
	Delete		= 261,
	/// Key: Cursor right
	Right		= 262,
	/// Key: Cursor left
	Left		= 263,
	/// Key: Cursor down
	Down		= 264,
	/// Key: Cursor up
	Up			= 265,
	/// Key: Page up
	PageUp		= 266,
	/// Key: Page down
	PageDown	= 267,
	/// Key: Home
	Home		= 268,
	/// Key: End
	End			= 269,
	/// Key: Caps lock
	CapsLock	= 280,
	/// Key: Scroll down
	ScrollLock	= 281,
	/// Key: Num lock
	NumLock		= 282,
	/// Key: Print screen
	PrintScreen	= 283,
	/// Key: Pause
	Pause		= 284,
	/// Key: F1
	F1			= 290,
	/// Key: F2
	F2			= 291,
	/// Key: F3
	F3			= 292,
	/// Key: F4
	F4			= 293,
	/// Key: F5
	F5			= 294,
	/// Key: F6
	F6			= 295,
	/// Key: F7
	F7			= 296,
	/// Key: F8
	F8			= 297,
	/// Key: F9
	F9			= 298,
	/// Key: F10
	F10			= 299,
	/// Key: F11
	F11			= 300,
	/// Key: F12
	F12			= 301,
	/// Key: Shift left
	LeftShift	= 340,
	/// Key: Control left
	LeftControl	= 341,
	/// Key: Alt left
	LeftAlt		= 342,
	/// Key: Super left
	LeftSuper	= 343,
	/// Key: Shift right
	RightShift	= 344,
	/// Key: Control right
	RightControl = 345,
	/// Key: Alt right
	RightAlt	= 346,
	/// Key: Super right
	RightSuper	= 347,
	/// Key: KB menu
	KbMenu		= 348,
	/// Key: Keypad 0
	Kp0			= 320,
	/// Key: Keypad 1
	Kp1			= 321,
	/// Key: Keypad 2
	Kp2			= 322,
	/// Key: Keypad 3
	Kp3			= 323,
	/// Key: Keypad 4
	Kp4			= 324,
	/// Key: Keypad 5
	Kp5			= 325,
	/// Key: Keypad 6
	Kp6			= 326,
	/// Key: Keypad 7
	Kp7			= 327,
	/// Key: Keypad 8
	Kp8			= 328,
	/// Key: Keypad 9
	Kp9			= 329,
	/// Key: Keypad .
	KpDecimal	= 330,
	/// Key: Keypad /
	KpDivide	= 331,
	/// Key: Keypad *
	KpMultiply	= 332,
	/// Key: Keypad -
	KpSubtract	= 333,
	/// Key: Keypad +
	KpAdd		= 334,
	/// Key: Keypad Enter
	KpEnter		= 335,
	/// Key: Keypad =
	KpEqual		= 336,
	/// Key: Android back button
	Back		= 4,
	/// Key: Android volume up button
	VolumeUp	= 24,
	/// Key: Android volume down button
	VolumeDown	= 25,
}
impl Into<i32> for KeyboardKey {
	fn into(self) -> i32 {
		match self {
			KeyboardKey::Null		=> 0,	
			KeyboardKey::Apostrophe	=> 39,	
			KeyboardKey::Comma		=> 44,	
			KeyboardKey::Minus		=> 45,	
			KeyboardKey::Period		=> 46,	
			KeyboardKey::Slash		=> 47,	
			KeyboardKey::Zero		=> 48,	
			KeyboardKey::One		=> 49,	
			KeyboardKey::Two		=> 50,	
			KeyboardKey::Three		=> 51,	
			KeyboardKey::Four		=> 52,	
			KeyboardKey::Five		=> 53,	
			KeyboardKey::Six		=> 54,	
			KeyboardKey::Seven		=> 55,	
			KeyboardKey::Eight		=> 56,	
			KeyboardKey::Nine		=> 57,	
			KeyboardKey::Semicolon	=> 59,	
			KeyboardKey::Equal		=> 61,	
			KeyboardKey::A			=> 65,	
			KeyboardKey::B			=> 66,	
			KeyboardKey::C			=> 67,	
			KeyboardKey::D			=> 68,	
			KeyboardKey::E			=> 69,	
			KeyboardKey::F			=> 70,	
			KeyboardKey::G			=> 71,	
			KeyboardKey::H			=> 72,	
			KeyboardKey::I			=> 73,	
			KeyboardKey::J			=> 74,	
			KeyboardKey::K			=> 75,	
			KeyboardKey::L			=> 76,	
			KeyboardKey::M			=> 77,	
			KeyboardKey::N			=> 78,	
			KeyboardKey::O			=> 79,	
			KeyboardKey::P			=> 80,	
			KeyboardKey::Q			=> 81,	
			KeyboardKey::R			=> 82,	
			KeyboardKey::S			=> 83,	
			KeyboardKey::T			=> 84,	
			KeyboardKey::U			=> 85,	
			KeyboardKey::V			=> 86,	
			KeyboardKey::W			=> 87,	
			KeyboardKey::X			=> 88,	
			KeyboardKey::Y			=> 89,	
			KeyboardKey::Z			=> 90,	
			KeyboardKey::LeftBracket=> 91,	
			KeyboardKey::Backslash	=> 92,	
			KeyboardKey::RightBracket=> 93,	
			KeyboardKey::Grave		=> 96,	
			KeyboardKey::Space		=> 32,	
			KeyboardKey::Escape		=> 256,	
			KeyboardKey::Enter		=> 257,	
			KeyboardKey::Tab		=> 258,	
			KeyboardKey::Backspace 	=> 259,	
			KeyboardKey::Insert		=> 260,	
			KeyboardKey::Delete		=> 261,	
			KeyboardKey::Right		=> 262,	
			KeyboardKey::Left		=> 263,	
			KeyboardKey::Down		=> 264,	
			KeyboardKey::Up			=> 265,	
			KeyboardKey::PageUp		=> 266,	
			KeyboardKey::PageDown	=> 267,	
			KeyboardKey::Home		=> 268,	
			KeyboardKey::End		=> 269,	
			KeyboardKey::CapsLock	=> 280,	
			KeyboardKey::ScrollLock	=> 281,	
			KeyboardKey::NumLock	=> 282,	
			KeyboardKey::PrintScreen=> 283,	
			KeyboardKey::Pause		=> 284,	
			KeyboardKey::F1			=> 290,	
			KeyboardKey::F2			=> 291,	
			KeyboardKey::F3			=> 292,	
			KeyboardKey::F4			=> 293,	
			KeyboardKey::F5			=> 294,	
			KeyboardKey::F6			=> 295,	
			KeyboardKey::F7			=> 296,	
			KeyboardKey::F8			=> 297,	
			KeyboardKey::F9			=> 298,	
			KeyboardKey::F10		=> 299,	
			KeyboardKey::F11		=> 300,	
			KeyboardKey::F12		=> 301,	
			KeyboardKey::LeftShift	=> 340,	
			KeyboardKey::LeftControl=> 341,	
			KeyboardKey::LeftAlt	=> 342,	
			KeyboardKey::LeftSuper	=> 343,	
			KeyboardKey::RightShift	=> 344,	
			KeyboardKey::RightControl=> 345,
			KeyboardKey::RightAlt	=> 346,	
			KeyboardKey::RightSuper	=> 347,	
			KeyboardKey::KbMenu		=> 348,	
			KeyboardKey::Kp0		=> 320,	
			KeyboardKey::Kp1		=> 321,	
			KeyboardKey::Kp2		=> 322,	
			KeyboardKey::Kp3		=> 323,	
			KeyboardKey::Kp4		=> 324,	
			KeyboardKey::Kp5		=> 325,	
			KeyboardKey::Kp6		=> 326,	
			KeyboardKey::Kp7		=> 327,	
			KeyboardKey::Kp8		=> 328,	
			KeyboardKey::Kp9		=> 329,	
			KeyboardKey::KpDecimal	=> 330,	
			KeyboardKey::KpDivide	=> 331,	
			KeyboardKey::KpMultiply	=> 332,	
			KeyboardKey::KpSubtract	=> 333,	
			KeyboardKey::KpAdd		=> 334,	
			KeyboardKey::KpEnter	=> 335,	
			KeyboardKey::KpEqual	=> 336,	
			KeyboardKey::Back		=> 4,	
			KeyboardKey::VolumeUp	=> 24,	
			KeyboardKey::VolumeDown	=> 25,	
		}
	}
}
impl From<i32> for KeyboardKey {
	fn from(value: i32) -> Self {
		match value {
			4   => { KeyboardKey::Back }
			24  => { KeyboardKey::VolumeUp }
			25  => { KeyboardKey::VolumeDown }
			39  => { KeyboardKey::Apostrophe }
			44  => { KeyboardKey::Comma }
			45  => { KeyboardKey::Minus }
			46  => { KeyboardKey::Period }
			47  => { KeyboardKey::Slash }
			48  => { KeyboardKey::Zero }
			49  => { KeyboardKey::One }
			50  => { KeyboardKey::Two }
			51  => { KeyboardKey::Three }
			52  => { KeyboardKey::Four }
			53  => { KeyboardKey::Five }
			54  => { KeyboardKey::Six }
			55  => { KeyboardKey::Seven }
			56  => { KeyboardKey::Eight }
			57  => { KeyboardKey::Nine }
			59 => { KeyboardKey::Semicolon }
			61  => { KeyboardKey::Equal }
			65  => { KeyboardKey::A }
			66  => { KeyboardKey::B }
			67  => { KeyboardKey::C }
			68  => { KeyboardKey::D }
			69  => { KeyboardKey::E }
			70  => { KeyboardKey::F }
			71  => { KeyboardKey::G }
			72  => { KeyboardKey::H }
			73  => { KeyboardKey::I }
			74  => { KeyboardKey::J }
			75  => { KeyboardKey::K }
			76  => { KeyboardKey::L }
			77  => { KeyboardKey::M }
			78  => { KeyboardKey::N }
			79  => { KeyboardKey::O }
			80  => { KeyboardKey::P }
			81  => { KeyboardKey::Q }
			82  => { KeyboardKey::R }
			83  => { KeyboardKey::S }
			84  => { KeyboardKey::T }
			85  => { KeyboardKey::U }
			86  => { KeyboardKey::V }
			87  => { KeyboardKey::W }
			88  => { KeyboardKey::X }
			89  => { KeyboardKey::Y }
			90  => { KeyboardKey::Z }
			91  => { KeyboardKey::LeftBracket }
			92  => { KeyboardKey::Backslash }
			93  => { KeyboardKey::RightBracket }
			96  => { KeyboardKey::Grave }
			32  => { KeyboardKey::Space }
			256 => { KeyboardKey::Escape }
			257 => { KeyboardKey::Enter }
			258 => { KeyboardKey::Tab }
			259 => { KeyboardKey::Backspace }
			260 => { KeyboardKey::Insert }
			261 => { KeyboardKey::Delete }
			262 => { KeyboardKey::Right }
			263 => { KeyboardKey::Left }
			264 => { KeyboardKey::Down }
			265 => { KeyboardKey::Up }
			266 => { KeyboardKey::PageUp }
			267 => { KeyboardKey::PageDown }
			268 => { KeyboardKey::Home }
			269 => { KeyboardKey::End }
			280 => { KeyboardKey::CapsLock }
			281 => { KeyboardKey::ScrollLock }
			282 => { KeyboardKey::NumLock }
			283 => { KeyboardKey::PrintScreen }
			284 => { KeyboardKey::Pause }
			290 => { KeyboardKey::F1 }
			291 => { KeyboardKey::F2 }
			292 => { KeyboardKey::F3 }
			293 => { KeyboardKey::F4 }
			294 => { KeyboardKey::F5 }
			295 => { KeyboardKey::F6 }
			296 => { KeyboardKey::F7 }
			297 => { KeyboardKey::F8 }
			298 => { KeyboardKey::F9 }
			299 => { KeyboardKey::F10 }
			300 => { KeyboardKey::F11 }
			301 => { KeyboardKey::F12 }
			340 => { KeyboardKey::LeftShift }
			341 => { KeyboardKey::LeftControl }
			342 => { KeyboardKey::LeftAlt }
			343 => { KeyboardKey::LeftSuper }
			344 => { KeyboardKey::RightShift }
			345 => { KeyboardKey::RightControl }
			346 => { KeyboardKey::RightAlt }
			347 => { KeyboardKey::RightSuper }
			348 => { KeyboardKey::KbMenu }
			320 => { KeyboardKey::Kp0 }
			321 => { KeyboardKey::Kp1 }
			322 => { KeyboardKey::Kp2 }
			323 => { KeyboardKey::Kp3 }
			324 => { KeyboardKey::Kp4 }
			325 => { KeyboardKey::Kp5 }
			326 => { KeyboardKey::Kp6 }
			327 => { KeyboardKey::Kp7 }
			328 => { KeyboardKey::Kp8 }
			329 => { KeyboardKey::Kp9 }
			330 => { KeyboardKey::KpDecimal }
			331 => { KeyboardKey::KpDivide }
			332 => { KeyboardKey::KpMultiply }
			333 => { KeyboardKey::KpSubtract }
			334 => { KeyboardKey::KpAdd }
			335 => { KeyboardKey::KpEnter }
			336 => { KeyboardKey::KpEqual }

			_ => { KeyboardKey::Null }
		}
	}
}