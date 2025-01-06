
module raylib;


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

