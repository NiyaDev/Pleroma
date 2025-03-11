
module pleroma::raylib;


<* Bounding box *>
struct BoundingBox {
  Vector3 min, max;
}

<* Draws the bounding box *>
fn void BoundingBox.draw(self, Color color) {
  draw_bounds(self, color);
}

