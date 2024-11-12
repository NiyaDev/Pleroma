
module pleroma::camera;
import std::io;
import raylib;


Camera main;


/** Combined camera structure for both 2D and 3D
 **/
struct Camera {
	CameraType type;

	//* Cameras
	Camera2D cam2d;
	Camera3D cam3d;
}
/** Current camera mode
 **/
enum CameraType {
	CAMERA3D,
	CAMERA2D,
}

/** Checks if input Rectngle representing a texture should be rendered
 @param rec "Dimensions of texture"
 @return "Is rendered"
 **/
fn bool Camera.texture_rendered(&self, Rectangle rec) {
	bool left	= (float)(rec.x + rec.width)	> (self.cam2d.target.x - (self.cam2d.offset.x));
	bool right	= (float)(rec.x)				< (self.cam2d.target.x + (self.cam2d.offset.x));
	bool top	= (float)(rec.y + rec.height)	> (self.cam2d.target.y - (self.cam2d.offset.y));
	bool bottom	= (float)(rec.y)				< (self.cam2d.target.y + (self.cam2d.offset.y));

	return !(left && right && top && bottom);
}

/** Start using camera to render
 **/
fn void Camera.start(&self) {
	switch (self.type) {
		case CAMERA2D: raylib::begin_2d_mode(self.cam2d);
		case CAMERA3D: raylib::begin_3d_mode(self.cam3d);
	}
}
/** Exit rendering mode
 **/
fn void Camera.end(&self) {
	switch (self.type) {
		case CAMERA2D: raylib::end_2d_mode();
		case CAMERA3D: raylib::end_3d_mode();
	}
}

/** Move camera a set distance depending on type
 @param movement "Distance moved in space"
 **/
fn void Camera.move(&self, Vector3 movement) {
	switch (self.type) {
		case CAMERA2D:
			self.cam2d.target.x += movement.x;
			self.cam2d.target.y += movement.y;
		case CAMERA3D:
			self.cam3d.position.x += movement.x;
			self.cam3d.position.y += movement.y;
			self.cam3d.position.z += movement.z;
	}
}
/** Set camera position
 @param position "Position in space"
 **/
fn void Camera.set(&self, Vector3 position) {
	switch (self.type) {
		case CAMERA2D:
			self.cam2d.offset.x = position.x;
			self.cam2d.offset.y = position.y;
		case CAMERA3D:
			self.cam3d.position.x = position.x;
			self.cam3d.position.y = position.y;
			self.cam3d.position.z = position.z;
	}
}

/** Prints camera data to console
 **/
fn void Camera.print(&self) {
	io::printf("Camera Mode:%s\n", self.type);
	switch (self.type) {
		case CAMERA2D: io::printfn("\tOffset: %d,%d\n\tTarget: %d,%d\n\tRotation: %d\n\tZoom: %d", self.cam2d.offset.x, self.cam2d.offset.y, self.cam2d.target.x, self.cam2d.target.y, self.cam2d.rotation, self.cam2d.zoom);
		case CAMERA3D: 
	}
}