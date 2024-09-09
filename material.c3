module pleroma;


struct Material {
	Shader shader;
	MaterialMap* maps;
	float[4] params;
}

struct MaterialMap {
	Texture texture;
	Color color;
	float value;
}





/// Material loading/unloading functions
extern fn Material* load_materials(char* filename, int* materialCount) @extern("LoadMaterials");
extern fn Material load_material_default() @extern("LoadMaterialDefault");
extern fn bool is_material_ready(Material material) @extern("IsMaterialReady");
extern fn void unlaod_material(Material material) @extern("UnloadMaterial");
extern fn void set_material_texture(Material* material, int mapType, Texture texture) @extern("SetMaterialTexture");
