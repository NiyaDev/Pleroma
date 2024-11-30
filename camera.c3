
module pleroma::camera;
import std::io;
import raylib;


Camera main;


/** Combined camera structure for both 2D and 3D
 **/
struct Camera {
	CameraMode mode;

	//* Cameras
	Camera2D cam2d;
	Camera3D cam3d;
}
/** Current camera mode
 **/
enum CameraMode {
	CAMERA2D,
	CAMERA3D,
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
	switch (self.mode) {
		case CAMERA2D: raylib::begin_2d_mode(self.cam2d);
		case CAMERA3D: raylib::begin_3d_mode(self.cam3d);
	}
}
/** Exit rendering mode
 **/
fn void Camera.end(&self) {
	switch (self.mode) {
		case CAMERA2D: raylib::end_2d_mode();
		case CAMERA3D: raylib::end_3d_mode();
	}
}

/** Move camera a set distance depending on type
 @param movement "Distance moved in space"
 **/
fn void move(Vector3 movement) {
	switch (main.mode) {
		case CAMERA2D:
			main.cam2d.target.x += movement.x;
			main.cam2d.target.y += movement.y;
		case CAMERA3D:
			main.cam3d.position.x += movement.x;
			main.cam3d.position.y += movement.y;
			main.cam3d.position.z += movement.z;
	}
}
/** Set camera position
 @param position "Position in space"
 **/
fn void set_position(Vector3 position) {
	switch (main.mode) {
		case CAMERA2D:
			main.cam2d.target.x = position.x;
			main.cam2d.target.y = position.y;
		case CAMERA3D:
			main.cam3d.position.x = position.x;
			main.cam3d.position.y = position.y;
			main.cam3d.position.z = position.z;
	}
}

/** Get current position
 @return "Vector3 of current position"
 **/
fn Vector3 get_position() {
	switch (main.mode) {
		case CAMERA2D:
			return {main.cam2d.target.x, main.cam2d.target.y, 0};
		case CAMERA3D:
			return main.cam3d.position;
	}
}
/** Sets current camera mode
 @param mode "Mode to set to"
 @return "Self"
 **/
fn void set_mode(CameraMode mode) {
	main.mode = mode;
}
/** Prints camera data to console
 **/
fn void Camera.print(&self) {
	io::printf("Camera Mode:%s\n", self.mode);
	switch (self.mode) {
		case CAMERA2D: io::printfn("\tOffset: %d,%d\n\tTarget: %d,%d\n\tRotation: %d\n\tZoom: %d", self.cam2d.offset.x, self.cam2d.offset.y, self.cam2d.target.x, self.cam2d.target.y, self.cam2d.rotation, self.cam2d.zoom);
		case CAMERA3D: 
	}
}