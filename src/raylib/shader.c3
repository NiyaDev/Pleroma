
module pleroma::raylib;


<* Shader *>
struct Shader {
  uint id;
  int* locs;
}


<* Wrapper for Raylib::UnloadShader(shader: ShaderRl) *>
fn void Shader.unload(&self) {
	unload_shader(*self);
}
<* Wrapper for bool Raylib::IsShaderReady(shader: ShaderRl) *>
fn bool Shader.ready(&self) {
	return is_shader_ready(*self);
}
<* Wrapper for raylib::BeginShaderMode() *>
fn void Shader.begin(&self) {
	begin_shader_mode(*self);
}
<* Wrapper for raylib::EndShaderMode() *>
fn void Shader.end(&self) {
	end_shader_mode();
}



module pleroma::raylib::shader;


<**>
fn Shader* load(String vs, String fs) {
	Shader* output = mem::new(Shader);

	*output = raylib::load_shader(vs, fs);

	return output;
}
<**>
fn Shader* from_mem(char* vs, char* fs) {
	Shader* output = mem::new(Shader);

	*output = raylib::load_shader_memory(vs, fs);

	return output;
}
