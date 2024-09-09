module pleroma;


struct BoundingBox {
	Vector3 min;
	Vector3 max;
}


fn void BoundingBox.draw(&self, Color color) {
	draw_bounding_box(*self, color);
}


/// Model drawing functions
extern fn void draw_bounding_box(BoundingBox bounds, Color color) @extern("DrawBoundingBox");
