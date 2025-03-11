
module pleroma::raylib;


<* 2D Camera *>
struct Camera2D {
  Vector2 offset, target;
  float rotation, zoom;
}

<* 3D Camera *>
struct Camera3D {
  Vector3 position, target, up;
  float fovy;
  CameraProjection projection;
}

<* Camera projection *>
enum CameraProjection {
  PERSPECTIVE,
  ORTHOGRAPHIC,
}
