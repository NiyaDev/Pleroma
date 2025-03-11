
module pleroma::raylib;


<* Ray *>
struct Ray {
  Vector3 position, direction;
}
<* Ray Collision *>
struct RayCollision {
  bool hit;
  float distance;
  Vector3 point, normal;
}

