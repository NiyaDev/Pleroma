module pleroma::camera;


import std::io;
import raylib;


Camera main;


/**
 * Combined camera structure for both 2D and 3D
 **/
struct Camera {
	CameraType type;

	//* Cameras
	Camera2D cam2d;
	Camera3D cam3d;
}

/**
 * Current camera mode
 **/
enum CameraType {
	CAMERA3D,
	CAMERA2D,
}

/**
 *
 **/
fn void Camera.start(&self) {
	switch (self.type) {
		case CAMERA2D: raylib::begin_2d_mode(self.cam2d);
		case CAMERA3D: raylib::begin_3d_mode(self.cam3d);
	}
}
/**
 *
 **/
fn void Camera.end(&self) {
	switch (self.type) {
		case CAMERA2D: raylib::end_2d_mode();
		case CAMERA3D: raylib::end_3d_mode();
	}
}

/**
 * Move camera a set distance depending on type
 * @param movement "Distance moved in space"
 **/
fn void Camera.move(&self, Vector3 movement) {
	switch (self.type) {
		case CAMERA2D:
			self.cam2d.offset.x += movement.x;
			self.cam2d.offset.y += movement.y;
		case CAMERA3D:
	}
}

/**
 * Prints camera data to console
 **/
fn void Camera.print(&self) {
	io::printf("Camera Mode:%s\n", self.type);
	switch (self.type) {
		case CAMERA2D: io::printfn("\tOffset: %d,%d\n\tTarget: %d,%d\n\tRotation: %d\n\tZoom: %d", self.cam2d.offset.x, self.cam2d.offset.y, self.cam2d.target.x, self.cam2d.target.y, self.cam2d.rotation, self.cam2d.zoom);
		case CAMERA3D: 
	}
}