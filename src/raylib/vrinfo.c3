
module pleroma::raylib;


<* VR stuff *>
struct VrDeviceInfo {
	int h_resolution, v_resolution;
	float h_screen_size, v_screen_size;
	float eye_to_screen_distance;
	float lens_seperation_distance;
	float interpupillary_distance;
	float[4] lens_distortion_values;
	float[4] chroma_aberration_correction;
}
struct VrStereoConfig {
	Matrix[2] projection, view_offset;
	float[2] left_lens_center, right_lens_center;
	float[2] left_screen_center, right_screen_center;
	float[2] scale, scale_in;
}
