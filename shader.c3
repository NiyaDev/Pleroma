module pleroma;


struct Shader {
	uint id;
	int* locs;
}


/// Wrapper for Raylib::UnloadShader(shader: ShaderRl)
fn void Shader.unload(&self) {
	unload_shader(*self);
}
/// Wrapper for Raylib::IsShaderReady(shader: ShaderRl) -> bool
fn bool Shader.ready(&self) {
	return is_shader_ready(*self);
}
/// Wrapper for raylib::BeginShaderMode()
fn Shader* Shader.begin(&self) {
	begin_shader_mode(*self);
	
	return self;
}
/// Wrapper for raylib::EndShaderMode()
fn Shader* Shader.end(&self) {
	end_shader_mode();
	
	return self;
}



/// Drawing-related functions
extern fn void begin_shader_mode(Shader shader) @extern("BeginShaderMode");
extern fn void end_shader_mode() @extern("EndShaderMode");

/// Shader management functions
extern fn Shader load_shader(char* vsFilename, char* fsFilename) @extern("LoadShader");
extern fn bool is_shader_ready(Shader shader) @extern("IsShaderReady");
extern fn int get_shader_location(Shader shader, char* uniformName) @extern("GetShaderLocation");
//extern "C" { fn GetShaderLocationAttrib(shader: ShaderRl, atttribName: *const i8) -> i32; }
extern fn void set_shader_value(Shader shader, int locIndex, void* value, int uniformType) @extern("SetShaderValue");
extern fn void set_shader_value_v(Shader shader, int locIndex, void* value, int uniformType) @extern("SetShaderValueV");
//extern "C" { fn SetShaderValueMatrix(shader: ShaderRl, locIndex: i32, value: *const c_void, uniformType: i32); }
extern fn void set_shader_value_texture(Shader shader, int locIndex, void* value, int uniformType) @extern("SetShaderValueTexture");
extern fn void unload_shader(Shader shader) @extern("UnloadShader");