

pub mod errors;
use crate::{pleroma::Pleroma, font::*, vectors::Vector2};
use std::{fs::OpenOptions, io::prelude::*};
use bitflags::bitflags;
use chrono::Local;


#[derive(Debug, Copy, Clone, PartialEq)]
pub enum LogLevel {
	Raylib,
	Info,
	Error,
	Critical,
	None,
}
impl Into<u8> for LogLevel {
	fn into(self) -> u8 {
		match self {
			LogLevel::Raylib	=> 0,
			LogLevel::Info		=> 1,
			LogLevel::Error		=> 2,
			LogLevel::Critical	=> 3,
			LogLevel::None		=> 4,
		}
	}
}

bitflags! {
	/// ### DebugFlags
	/// Flags designating what the debug system should do.
	#[derive(Debug, Clone, Copy, PartialEq, Eq, Hash)]
	pub struct DebugFlags: u8 {
		const LOG_ENABLE	= 0b00000001;
		const SCRN_ENABLE	= 0b00000010;
		const INFO_ENABLE	= 0b00000100;
		const DEBUG_ENABLE	= 0b10000000;
		
		const _ = !0;
	}
}

impl Pleroma {
	
	/// ### log
	/// Prints a message to Pleroma's log system.
	/// 
	/// ##### Includes:
	/// - Console
	/// - Log file (if enabled)
	/// - Screen (if enabled)
	pub fn log(&mut self, message: errors::PlError) {
		let level_value: u8 = self.get_log_level().into();
		let message_level: LogLevel = message.into();
		let message_level_value: u8 = message_level.into();
		
		let sys_time = Local::now();
		let formatted_message = format!("{}{}", sys_time.format("[%Y-%m-%e] [%T] "), message.to_string());
		
		if level_value <= message_level_value {
			//* Print to console */
			println!("{}", formatted_message);
			
			//* Print to log */
			if self.get_debug_setting(DebugFlags::LOG_ENABLE) {
				let file = OpenOptions::new()
					.append(true)
					.create(true)
					.open("log.txt");
				if let Err(e) = writeln!(file.unwrap(), "{}", formatted_message) {
					eprintln!("Couldn't write to file: {}", e);
				}
			}
			
			//* Print to screen */
			if self.get_debug_setting(DebugFlags::SCRN_ENABLE) {
				self.push_message(message_level, formatted_message);
			}
		}
	}
	/// ### Draw_debug_info
	/// Draws debug info, including current FPS / Target FPS, number of drawn models and textures, etc.
	/// 
	/// TODO
	pub fn draw_debug_info(&self, font: &Font) {
		unsafe{
			let fps = GetFPS();
			let frame_time = GetFrameTime();
			let time = GetTime();
			
			let frm = format!("{fps:03} - {frame_time:.4} - {}\n{}", time as i32, self.camera.target);
			
			font.draw(&frm, Vector2{x: 8.0, y: 8.0});
		}
	}
	
}

//= Timing-related functions
extern "C" { fn GetFrameTime() -> f32; }
extern "C" { fn GetTime() -> f64; }
extern "C" { fn GetFPS() -> i32; }