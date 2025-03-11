
module pleroma::raylib;


<* Material *>
struct Material {
  Shader shader;
  MaterialMap* maps;
  float[4] params;
}
<* Material map *>
struct MaterialMap {
  Texture texture;
  Color color;
  float value;
}

<* Material map index *>
enum MaterialMapIndex : int {
    ALBEDO,            // Albedo material (same as: MATERIAL_MAP_DIFFUSE)
    METALNESS,         // Metalness material (same as: MATERIAL_MAP_SPECULAR)
    NORMAL,            // Normal material
    ROUGHNESS,         // Roughness material
    OCCLUSION,         // Ambient occlusion material
    EMISSION,          // Emission material
    HEIGHT,            // Heightmap material
    CUBEMAP,           // Cubemap material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    IRRADIANCE,        // Irradiance material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    PREFILTER,         // Prefilter material (NOTE: Uses GL_TEXTURE_CUBE_MAP)
    BRDF,              // Brdf material
    DEPTH0,            // New depth map index shadow for light1
    DEPTH1,            // New depth map index shadow for light2
    DEPTH2,            // New depth map index shadow for light3
    DEPTH3             // New depth map index shadow for light4
}

<* Check if material is ready to use *>
fn bool Material.ready(&self) {
  return is_material_ready(*self);
}
<* Unload material *>
fn void Material.unload(&self) {
  unload_material(*self);
  free(self);
}
<* Set texture *>
fn void Material.set_texture(&self, Texture texture, MaterialMapIndex map_type = ALBEDO) {
  set_material_texture(self, map_type.ordinal, texture);
}



module pleroma::raylib::material;


<* Load default material *>
fn Material* load_default() {
  Material* output = mem::new(Material);

  *output = raylib::load_material_default();

  return output;
}
<* Load materials from model *>
fn Material[] load_from_model(String filename) {
  int material_count = 0;
  Material* mats = raylib::load_materials(filename, &material_count);

  Material[] output = mem::new_array(Material, material_count);
  
  for (int i; i < material_count; i++) {
    output[i] = mats[i];
  }

  return output;
}
