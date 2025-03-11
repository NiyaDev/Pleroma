
module pleroma::raylib;


<* Mesh *>
struct Mesh {
	int vertexCount;			  // Number of vertices stored in arrays
	int triangleCount;			// Number of triangles stored (indexed or not)

	//* Vertex attributes data
	float* vertices;			  // Vertex position (XYZ - 3 components per vertex) (shader-location = 0)
	float* texcoords;		  	// Vertex texture coordinates (UV - 2 components per vertex) (shader-location = 1)
	float* texcoords2;			// Vertex texture second coordinates (UV - 2 components per vertex) (shader-location = 5)
	float* normals;				  // Vertex normals (XYZ - 3 components per vertex) (shader-location = 2)
	float* tangents;			  // Vertex tangents (XYZW - 4 components per vertex) (shader-location = 4)
	char* colors;				    // Vertex colors (RGBA - 4 components per vertex) (shader-location = 3)
	ushort* indices;			  // Vertex indices (in case vertex data comes indexed)

	//* Animation vertex data
	float* animVertices;		// Animated vertex positions (after bones transformations)
	float* animNormals;			// Animated normals (after bones transformations)
	char* boneIds;				  // Vertex bone ids, max 255 bone ids, up to 4 bones influence by vertex (skinning) (shader-location = 6)
	float* boneWeights;			// Vertex bone weight, up to 4 bones influence by vertex (skinning) (shader-location = 7)
	Matrix* boneMatrices;		// Bones animated transformation matrices
	int boneCount;				  // Number of bones

	//* OpenGL identifiers
	uint vaoId;					    // OpenGL Vertex Array Object id
	uint *vboId;				    // OpenGL Vertex Buffer Objects id (default vertex data)
}

<* Model *>
struct Model {
	Matrix transform;			  // Local transform matrix

	int meshCount;				  // Number of meshes
	int materialCount;			// Number of materials
	Mesh* meshes;			    	// Meshes array
	Material* materials;		// Materials array
	int* meshMaterial;			// Mesh material number

	//* Animation data
	int boneCount;				  // Number of bones
	BoneInfo* bones;			  // Bones information (skeleton)
	Transform* bindPose;		// Bones base transformation (pose)
}
<* Model Fault *>
fault ModelFault {
	FAILED_FIND_FILE,
}

<* Is model ready *>
fn bool Model.ready(&self) {
	return raylib::is_model_valid(*self);
}
<* Unload model *>
fn void Model.unload(&self) {
	raylib::unload_model(*self);
	free(self);
}
<* Get bounds *>
fn BoundingBox Model.bounds(&self) {
	return raylib::get_model_bounds(*self);
}
<* Set material *>
fn void Model.set_material(&self, Material* mat) {
	self.materials[0] = *mat;
}

<* Draw model *>
fn void Model.draw(&self, Vector3 position, float scale, Color tint) {
	raylib::draw_model(*self, position, scale, tint);
}
<* Draw model with extra options *>
fn void Model.draw_ex(&self, Vector3 position, Vector3 rotation_axis, float rotation_angle, Vector3 scale, Color tint) {
	raylib::draw_model_ex(*self, position, rotation_axis, rotation_angle, scale, tint);
}
<* Draw model as wireframe *>
fn void Model.draw_wires(&self, Vector3 position, float scale, Color tint) {
	raylib::draw_model_wires(*self, position, scale, tint);
}
<* Draw model as wireframe with extra options *>
fn void Model.draw_wires_ex(&self, Vector3 position, Vector3 rotation_axis, float rotation_angle, Vector3 scale, Color tint) {
	raylib::draw_model_wires_ex(*self, position, rotation_axis, rotation_angle, scale, tint);
}
<* Draw model as points *>
fn Model* Model.draw_points(&self, Vector3 position, float scale, Color tint) {
	raylib::draw_model_points(*self, position, scale, tint);

	return self;
}
<* Draw model as points with extra options *>
fn void Model.draw_points_ex(&self, Vector3 position, Vector3 rotation_axis, float rotation_angle, Vector3 scale, Color tint) {
	raylib::draw_model_points_ex(*self, position, rotation_axis, rotation_angle, scale, tint);
}


<* Transform *>
struct Transform {
	Vector3 translation;		// Translation
	Quaternion rotation;		// Rotation
	Vector3 scale;			  	// Scale
}

<* Bone info *>
struct BoneInfo {
	char[32] name;				// Bone name
	int parent;					// Bone parent
}

<* Model Animation
  TODO:  
 *>
struct ModelAnimation {
	int n;
}



module pleroma::raylib::mesh;


<* Generate polygonal mesh
  @param sides
  @param radius
 *>
fn Mesh* gen_poly(int sides, float radius) {
	Mesh* output = mem::new(Mesh);
	*output = raylib::gen_mesh_poly(sides, radius);

	return output;
}
<* Generate plane mesh
  @param width
  @param length
  @param res_x
  @param res_z
 *>
fn Mesh* gen_plane(float width, float length, int res_x, int res_z) {
	Mesh* output = mem::new(Mesh);
	*output = raylib::gen_mesh_plane(width, length, res_x, res_z);

	return output;
}
<* Generate cube mesh
  @param width
  @param height
  @param length
 *>
fn Mesh* gen_cube(float width, float height, float length) {
	Mesh* output = mem::new(Mesh);
	*output = raylib::gen_mesh_cube(width, height, length);

	return output;
}
<* Generate sphere meshv
  @param radius
  @param rings
  @param slices
 *>
fn Mesh* gen_sphere(float radius, int rings, int slices) {
	Mesh* output = mem::new(Mesh);
	*output = raylib::gen_mesh_sphere(radius, rings, slices);

	return output;
}
<* Generate hemisphere mesh
  @param radius 
  @param rings
  @param slices
 *>
fn Mesh* gen_hemisphere(float radius, int rings, int slices) {
	Mesh* output = mem::new(Mesh);
	*output = raylib::gen_mesh_hemi(radius, rings, slices);

	return output;
}
<* Generate cylinder mesh
  @param radius
  @param height
  @param slices
 *>
fn Mesh* gen_cylinder(float radius, float height, int slices) {
	Mesh* output = mem::new(Mesh);
	*output = raylib::gen_mesh_cylinder(radius, height, slices);

	return output;
}
<* Generate cone mesh
  @param radius
  @param height
  @param slices
 *>
fn Mesh* gen_cone(float radius, float height, int slices) {
	Mesh* output = mem::new(Mesh);
	*output = raylib::gen_mesh_cone(radius, height, slices);

	return output;
}
<* Generate torus mesh
  @param radius
  @param size
  @param rad_seg
  @param sides
 *>
fn Mesh* gen_torus(float radius, float size, int rad_seg, int sides) {
	Mesh* output = mem::new(Mesh);
	*output = raylib::gen_mesh_torus(radius, size, rad_seg, sides);

	return output;
}
<* Generate knot mesh
  @param radius
  @param size
  @param rad_seg
  @param sides
 *>
fn Mesh* gen_knot(float radius, float size, int rad_seg, int sides) {
	Mesh* output = mem::new(Mesh);
	*output = raylib::gen_mesh_knot(radius, size, rad_seg, sides);

	return output;
}
<* Generate heightmap mesh
  @param heightmap
  @param size
 *>
fn Mesh* gen_heightmap(Image heightmap, Vector3 size) {
	Mesh* output = mem::new(Mesh);
	*output = raylib::gen_mesh_heightmap(heightmap, size);

	return output;
}
<* Generate cubicmap mesh
  @param cubicmap
  @param cube_size
 *>
fn Mesh* gen_cubicmap(Image cubicmap, Vector3 cube_size) {
	Mesh* output = mem::new(Mesh);
	*output = raylib::gen_mesh_heightmap(cubicmap, cube_size);

	return output;
}



module pleroma::raylib::model;
import std::io;


<* Loads model from file
  @param filename "Name of file to be loaded"
  @return "Pointer to loaded Model"
 *>
fn Model*! load(String filename) {
	if (!file::is_file(filename)) {
		io::printfn("ERROR - Failed to load model {%s}", filename);
		return ModelFault.FAILED_FIND_FILE?;
	}

	Model* output = mem::new(Model);
	*output = raylib::load_model(filename);

	return output;
}
<* Load model from Mesh
  @return "Model pointer"
 *>
fn Model* Mesh.model(&self) {
	Model* output = mem::new(Model);
	*output = raylib::load_model_from_mesh(*self);

	return output;
}

<* Draw mesh *>
fn void Mesh.draw(self, Material material, Matrix transform) {
	raylib::draw_mesh(self, material, transform);
}
<* Draw mesh instanced *>
fn void Mesh.instanced(self, Material material, Matrix* transforms, int instances) {
	raylib::draw_mesh_instanced(self, material, transforms, instances);
}
