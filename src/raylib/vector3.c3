
module pleroma::raylib;
import std::math;
import std::io;


<* Vector3 *>
struct Vector3 {
	float x;
	float y;
	float z;
}

<* Equals *>
fn bool Vector3.equals(self, Vector3 rhs) @export("vector3_equals") {
	return ((self.x == rhs.x) && (self.y == rhs.y) && (self.z == rhs.z));
}
<* Add two Vector3s *>
fn Vector3 Vector3.add(&self, Vector3 rhs) @export("vector3_add") {
	self.x += rhs.x;
	self.y += rhs.y;
	self.z += rhs.z;

	return *self;
}
<* Subtract two Vector3s *>
fn Vector3 Vector3.sub(&self, Vector3 rhs) @export("vector3_sub") {
	self.x -= rhs.x;
	self.y -= rhs.y;
	self.z -= rhs.z;

	return *self;
}
<* Multiply two Vector3s *>
fn Vector3 Vector3.mul(&self, Vector3 rhs) @export("vector3_mul") {
	self.x *= rhs.x;
	self.y *= rhs.y;
	self.z *= rhs.z;

	return *self;
}
<* Multiply Vector3 by float *>
fn Vector3 Vector3.mul_f(&self, float rhs) @export("vector3_mulf") {
	self.x *= rhs;
	self.y *= rhs;
	self.z *= rhs;

	return *self;
}
<* Divide two Vector3s *>
fn Vector3 Vector3.div(&self, Vector3 rhs) @export("vector3_div") {
	self.x = self.x / rhs.x;
	self.y = self.y / rhs.y;
	self.z = self.z / rhs.z;

	return *self;
}
<**>
fn float[] Vector3.to_array(self) @export("vector3_toarray") {
	float[] output = mem::new_array(float, 3);
	output[0] = self.x;
	output[1] = self.y;
	output[2] = self.z;
	return output;
}
fn int[3] Vector3.to_int_array(self) @export("vector3.tointarray") {
	//int[] output = mem::new_array(int, 3);
	//output[0] = (int)self.x;
	//output[1] = (int)self.y;
	//output[2] = (int)self.z;
	return {(int)self.x, (int)self.y, (int)self.z};
}
<* Calculate two vectors cross product *>
fn Vector3 Vector3.cross_product(self, Vector3 v2) @export("vector3_crossproduct") {
	return {
		.x = self.y * v2.z - self.z * v2.y,
		.y = self.z * v2.x - self.x * v2.z,
		.z = self.x * v2.y - self.y * v2.x,
	};
}
<* Calculate one vector perpendicular vector *>
fn Vector3 Vector3.perpendicular(self) @export("vector3_perpendicular") {
	float min = math::abs(self.x);
	Vector3 cardinal_axis = {.x = 1, .y = 0, .z = 0};

	if (math::abs(self.y) < min) {
		min = math::abs(self.y);
		cardinal_axis = {.x = 0, .y = 1, .z = 0};
	}
	if (math::abs(self.z) < min) {
		cardinal_axis = {.x = 0, .y = 1, .z = 0};
	}

	return self.cross_product(cardinal_axis);
}
<* Calculate vector length *>
fn float Vector3.length(self) @export("vector3_length") {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2));
}
<* Calculate vector square length *>
fn float Vector3.length_sqr(self) @export("vector3_lengthsqr") {
	return self.x.pow(2) + self.y.pow(2) + self.z.pow(2);
}
<* Calculate two vectors dot product *>
fn float Vector3.dot_product(self, Vector3 v2) @export("vector3_dotproduct") {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z;
}
<* Calculate distance between two vectors *>
fn float Vector3.distance(self, Vector3 v2) @export("vector3_distance") {
	Vector3 sub = {
		v2.x - self.x,
		v2.y - self.y,
		v2.z - self.z,
	};
	return sub.length();
}
<* Calculate square distance between two vectors *>
fn float Vector3.distance_sqr(self, Vector3 v2) @export("vector3_distancesqr") {
	Vector3 sub = {
		v2.x - self.x,
		v2.y - self.y,
		v2.z - self.z,
	};
	return sub.length_sqr();
}
<* Calculate angle between two vectors *>
fn float Vector3.angle(self, Vector3 v2) @export("vector3_angle") {
	Vector3 cross = self.cross_product(v2);
	float len = cross.length();
	float dot = self.dot_product(v2);

	return math::atan2(len, dot);
}
<* Normalize provided vector *>
fn Vector3 Vector3.normalize(self) @export("vector3_normalize") {
	float len = self.length();
	if (len != 0) {
		float ilen = self.length();

		return {
			.x = self.x * ilen,
			.y = self.y * ilen,
			.z = self.z * ilen,
		};
	} else { return self; }
}
<* Calculate the projection of the vector v1 on to v2 *>
fn Vector3 Vector3.project(self, Vector3 v2) @export("vector3_project") {
	float v1dv2 = self.x*v2.x + self.y*v2.y + self.z*v2.z;
	float v2dv2 = v2.length_sqr();

	float mag = v1dv2 / v2dv2;

	return {
		.x = v2.x * mag,
		.y = v2.y * mag,
		.z = v2.z * mag,
	};
}
<* Calculate the rejection of the vector v1 on to v2 *>
fn Vector3 Vector3.reject(self, Vector3 v2) @export("vector3_reject") {
	float v1dv2 = self.x*v2.x + self.y*v2.y + self.z*v2.z;
	float v2dv2 = v2.length_sqr();

	float mag = v1dv2 / v2dv2;

	return {
		self.x - (v2.x * mag),
		self.y - (v2.y * mag),
		self.z - (v2.z * mag),
	};
}
<* Orthonormalize provided vectors. Makes vectors normalized and orthogonal to each other. Gram-Schmidt function implementation *>
fn void Vector3.orthinormalize(&self, Vector3* v2) @export("vector3_ortinormalize") {
	float len;
	float ilen;

	//* Normalize self
	len = self.length();
	if (len == 0) len = 1;
	ilen = 1 / len;
	self.x *= ilen;
	self.y *= ilen;
	self.z *= ilen;

	//* Cross product
	Vector3 vn1 = self.cross_product(*v2);

	//* Normalize
	len = vn1.length();
	if (len == 0) len = 1;
	ilen = 1.0 / len;
	vn1.x *= ilen;
	vn1.y *= ilen;
	vn1.z *= ilen;

	//* Cross product
	Vector3 vn2 = vn1.cross_product(*self);

	v2.x = vn2.x;
	v2.y = vn2.y;
	v2.z = vn2.z;
}
<* Transforms a Vector3 by a given Matrix *>
fn Vector3 Vector3.transform(self, Matrix mat) @export("vector3_transform") {
	return {
		mat.m0 * self.x + mat.m4 * self.y + mat.m8  * self.z + mat.m12,
		mat.m1 * self.x + mat.m5 * self.y + mat.m9  * self.z + mat.m13,
		mat.m2 * self.x + mat.m6 * self.y + mat.m10 * self.z + mat.m14,
	};
}
<* Transform a vector by quaternion rotation *>
fn Vector3 Vector3.rotate_quaternion(self, Quaternion q) @export("vector3_rotatequaternion") {
	return {
		.x = self.x * (double)(q.x.pow(2) + q.w.pow(2) - q.y.pow(2) - q.z.pow(2)) + self.y * (2.0 * q.x * q.y - 2.0 * q.w * q.z) + self.z * (2.0 * q.x * q.z + 2.0 * q.w * q.y),
		.y = self.x * (2.0 * q.w * q.z + 2.0 * q.x * q.y) + self.y * (double)(q.w.pow(2) - q.x.pow(2) + q.y.pow(2) - q.z.pow(2)) + self.z * (-2.0 * q.w * q.x + 2.0 * q.y * q.z),
		.z = self.x * (-2.0 * q.w * q.y + 2.0 * q.x * q.z) + self.y * (2.0 * q.w * q.x + 2.0 * q.y * q.z) + self.z * (double)(q.w.pow(2) - q.x.pow(2) - q.y.pow(2) + q.z.pow(2)),
	};
}
<* Returns point rotated at input distance from self
	@param dist
	@param rot
	@return "Point"
 *>
fn Vector3 Vector3.rotate(self, Vector3 dist, float rot) @export("vector3_rotate") {
	Vector3 position;

	position.x = dist.x * (float)math::cos(rot / 57.3) - dist.z * (float)math::sin(rot / 57.3);
	position.z = dist.x * (float)math::sin(rot / 57.3) + dist.z * (float)math::cos(rot / 57.3);

	position.x += self.x;
	position.y  = self.y + dist.y;
	position.z += self.z;

	return position;
}
<* Rotates a vector around an axis Using Euler-Rodrigues Formula *>
fn Vector3 Vector3.rotate_axis(self, Vector3 axis, float angle) @export("vector3_rotateaxis") {
	//* normalize
	float len = axis.length();
	if (len == 0) len = 1;
	float ilen = 1 / len;
	Vector3 new_axis = {
		.x = axis.x * ilen,
		.y = axis.y * ilen,
		.z = axis.z * ilen,
	};
	float new_angle = angle / 2;
	float a = math::sin(new_angle);
	float b = new_axis.x * a;
	float c = new_axis.y * a;
	float d = new_axis.z * a;
	a = math::cos(angle);
	Vector3 w = {.x = b, .y = c, .z = d };

	//* Cross product
	Vector3 wv = w.cross_product(self);
	Vector3 wwv = w.cross_product(wv);

	//* Scale
	a *= 2;
	wv = {
		.x = wv.x * a,
		.y = wv.y * a,
		.z = wv.z * a,
	};
	wv = {
		.x = wv.x * 2,
		.y = wv.y * 2,
		.z = wv.z * 2,
	};

	return {
		.x = self.x + wv.x + wwv.x,
		.y = self.y + wv.y + wwv.y,
		.z = self.z + wv.z + wwv.z,
	};
}
<* Move Vector towards target *>
fn Vector3 Vector3.move_towards(self, Vector3 target, float max_distance) @export("vector3_movetowards") {
	float dx = target.x - self.x;
	float dy = target.y - self.y;
	float dz = target.z - self.z;
	float value = dx.pow(2) + dy.pow(2) + dz.pow(2);

	if (value == 0.0 || (max_distance >= 0.0 && value <= max_distance.pow(2))) { return {}; }

	float dist = math::sqrt(value);

	return {
		.x = self.x + dx / dist * max_distance,
		.y = self.y + dy / dist * max_distance,
		.z = self.z + dz / dist * max_distance,
	};
}
<* Calculate linear interpolation between two vectors *>
fn Vector3 Vector3.lerp(self, Vector3 target, float amount) @export("vector3_lerp") {
	return {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
	};
}
<* Calculate reflected vector to normal *>
fn Vector3 Vector3.reflect(self, Vector3 normal) @export("vector3_reflect") {
	float dot = self.dot_product(normal);

	return {
		.x = self.x - (2.0 * normal.x) * dot,
		.y = self.y - (2.0 * normal.y) * dot,
		.z = self.z - (2.0 * normal.z) * dot,
	};
}
<* Get min value for each pair of components *>
fn Vector3 Vector3.min(self, Vector3 v2) @export("vector3_min") {
	return {
		.x = math::min(self.x, v2.x),
		.y = math::min(self.y, v2.y),
		.z = math::min(self.z, v2.z),
	};
}
<* Get max value for each pair of components *>
fn Vector3 Vector3.max(self, Vector3 v2) @export("vector3_max") {
	return {
		.x = math::max(self.x, v2.x),
		.y = math::max(self.y, v2.y),
		.z = math::max(self.z, v2.z),
	};
}
<* Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c) *>
fn Vector3 Vector3.barycenter(self, Vector3 a, Vector3 b, Vector3 c) @export("vector3_barycenter") {
	Vector3 v0 = {
		.x = b.x - a.x,
		.y = b.y - a.y,
		.z = b.z - a.z,
	};
	Vector3 v1 = {
		.x = c.x - a.x,
		.y = c.y - a.y,
		.z = c.z - a.z,
	};
	Vector3 v2 = {
		.x = self.x - a.x,
		.y = self.y - a.y,
		.z = self.z - a.z,
	};
	float d00 = v0.dot_product(v0);
	float d01 = v0.dot_product(v1);
	float d11 = v1.dot_product(v1);
	float d20 = v2.dot_product(v0);
	float d21 = v2.dot_product(v1);

	float denom = d00 * d11 - d01.pow(2);

	float z = (d00 * d21 - d01 * d20) / denom;
	float y = (d11 * d20 - d01 * d21) / denom;

	return {
		.x = 1.0 - (double)(z + y),
		.y = y,
		.z = z,
	};
}
<* Projects a Vector3 from screen space into object space *>
fn Vector3 Vector3.unproject(self, Matrix projection, Matrix view) @export("vector3_unproject") {
	//* Calculate unprojected matrix (multiply view matrix by projection matrix) and invert it
	Matrix mat_view_proj = {
		.m0  = view.m0  * projection.m0 + view.m1  * projection.m4 + view.m2  * projection.m8  + view.m3  * projection.m12,
		.m1  = view.m0  * projection.m1 + view.m1  * projection.m5 + view.m2  * projection.m9  + view.m3  * projection.m13,
		.m2  = view.m0  * projection.m2 + view.m1  * projection.m6 + view.m2  * projection.m10 + view.m3  * projection.m14,
		.m3  = view.m0  * projection.m3 + view.m1  * projection.m7 + view.m2  * projection.m11 + view.m3  * projection.m15,
		.m4  = view.m4  * projection.m0 + view.m5  * projection.m4 + view.m6  * projection.m8  + view.m7  * projection.m12,
		.m5  = view.m4  * projection.m1 + view.m5  * projection.m5 + view.m6  * projection.m9  + view.m7  * projection.m13,
		.m6  = view.m4  * projection.m2 + view.m5  * projection.m6 + view.m6  * projection.m10 + view.m7  * projection.m14,
		.m7  = view.m4  * projection.m3 + view.m5  * projection.m7 + view.m6  * projection.m11 + view.m7  * projection.m15,
		.m8  = view.m8  * projection.m0 + view.m9  * projection.m4 + view.m10 * projection.m8  + view.m11 * projection.m12,
		.m9  = view.m8  * projection.m1 + view.m9  * projection.m5 + view.m10 * projection.m9  + view.m11 * projection.m13,
		.m10 = view.m8  * projection.m2 + view.m9  * projection.m6 + view.m10 * projection.m10 + view.m11 * projection.m14,
		.m11 = view.m8  * projection.m3 + view.m9  * projection.m7 + view.m10 * projection.m11 + view.m11 * projection.m15,
		.m12 = view.m12 * projection.m0 + view.m13 * projection.m4 + view.m14 * projection.m8  + view.m15 * projection.m12,
		.m13 = view.m12 * projection.m1 + view.m13 * projection.m5 + view.m14 * projection.m9  + view.m15 * projection.m13,
		.m14 = view.m12 * projection.m2 + view.m13 * projection.m6 + view.m14 * projection.m10 + view.m15 * projection.m14,
		.m15 = view.m12 * projection.m3 + view.m13 * projection.m7 + view.m14 * projection.m11 + view.m15 * projection.m1,
	};

	//* Calculate inverted matrix -> MatrixInvert(matViewProj)
	float b00 = mat_view_proj.m0  * mat_view_proj.m5  - mat_view_proj.m1  * mat_view_proj.m4;
	float b01 = mat_view_proj.m0  * mat_view_proj.m6  - mat_view_proj.m2  * mat_view_proj.m4;
	float b02 = mat_view_proj.m0  * mat_view_proj.m7  - mat_view_proj.m3  * mat_view_proj.m4;
	float b03 = mat_view_proj.m1  * mat_view_proj.m6  - mat_view_proj.m2  * mat_view_proj.m5;
	float b04 = mat_view_proj.m1  * mat_view_proj.m7  - mat_view_proj.m3  * mat_view_proj.m5;
	float b05 = mat_view_proj.m2  * mat_view_proj.m7  - mat_view_proj.m3  * mat_view_proj.m6;
	float b06 = mat_view_proj.m8  * mat_view_proj.m13 - mat_view_proj.m9  * mat_view_proj.m12;
	float b07 = mat_view_proj.m8  * mat_view_proj.m14 - mat_view_proj.m10 * mat_view_proj.m12;
	float b08 = mat_view_proj.m8  * mat_view_proj.m15 - mat_view_proj.m11 * mat_view_proj.m12;
	float b09 = mat_view_proj.m9  * mat_view_proj.m14 - mat_view_proj.m10 * mat_view_proj.m13;
	float b10 = mat_view_proj.m9  * mat_view_proj.m15 - mat_view_proj.m11 * mat_view_proj.m13;
	float b11 = mat_view_proj.m10 * mat_view_proj.m15 - mat_view_proj.m11 * mat_view_proj.m14;

	//* Calculate the invert determinant (inlined to avoid double-caching)
	float inv_det = 1 / ((b00 * b11) - (b01 * b10) + (b02 * b09) + (b03 * b08) - (b04 * b07) + (b05 * b06));

	Matrix mat_view_proj_inv = {
		.m0  = (( mat_view_proj.m5  * b11) - (mat_view_proj.m6  * b10) + (mat_view_proj.m7  * b09)) * inv_det,
		.m1  = ((-mat_view_proj.m1  * b11) - (mat_view_proj.m2  * b10) + (mat_view_proj.m3  * b09)) * inv_det,
		.m2  = (( mat_view_proj.m13 * b05) - (mat_view_proj.m14 * b04) + (mat_view_proj.m15 * b03)) * inv_det,
		.m3  = ((-mat_view_proj.m9  * b05) + (mat_view_proj.m10 * b04) - (mat_view_proj.m11 * b03)) * inv_det,
		.m4  = ((-mat_view_proj.m4  * b11) + (mat_view_proj.m6  * b08) - (mat_view_proj.m7  * b07)) * inv_det,
		.m5  = (( mat_view_proj.m0  * b11) - (mat_view_proj.m2  * b08) + (mat_view_proj.m3  * b07)) * inv_det,
		.m6  = ((-mat_view_proj.m12 * b05) + (mat_view_proj.m14 * b02) - (mat_view_proj.m15 * b01)) * inv_det,
		.m7  = (( mat_view_proj.m8  * b05) - (mat_view_proj.m10 * b02) + (mat_view_proj.m11 * b01)) * inv_det,
		.m8  = (( mat_view_proj.m4  * b10) - (mat_view_proj.m5  * b08) + (mat_view_proj.m7  * b06)) * inv_det,
		.m9  = ((-mat_view_proj.m0  * b10) + (mat_view_proj.m1  * b08) - (mat_view_proj.m3  * b06)) * inv_det,
		.m10 = (( mat_view_proj.m12 * b04) - (mat_view_proj.m13 * b02) + (mat_view_proj.m15 * b00)) * inv_det,
		.m11 = ((-mat_view_proj.m8  * b04) + (mat_view_proj.m9  * b02) - (mat_view_proj.m11 * b00)) * inv_det,
		.m12 = ((-mat_view_proj.m4  * b09) + (mat_view_proj.m5  * b07) - (mat_view_proj.m6  * b06)) * inv_det,
		.m13 = (( mat_view_proj.m0  * b09) - (mat_view_proj.m1  * b07) + (mat_view_proj.m2  * b06)) * inv_det,
		.m14 = ((-mat_view_proj.m12 * b03) + (mat_view_proj.m13 * b01) - (mat_view_proj.m14 * b00)) * inv_det,
		.m15 = (( mat_view_proj.m8  * b03) - (mat_view_proj.m9  * b01) + (mat_view_proj.m10 * b00)) * inv_det,
	};

	//* Create quaternion from source point
	Quaternion quat = { .x = self.x, .y = self.y, .z = self.z, .w = 1 };

	//* Multiply quat point by unprojected matrix
	Vector4 q_tranformed = mat_view_proj_inv.quaternion_transform(quat);

	//* Normalized world points in vectors
	return {
		.x = q_tranformed.x / q_tranformed.w,
		.y = q_tranformed.y / q_tranformed.w,
		.z = q_tranformed.z / q_tranformed.w,
	};
}
<* Invert the given vector *>
fn Vector3 Vector3.invert(self) @export("vector3_invert") {
	return {.x = 1 / self.x, .y = 1 / self.y, .z = 1 / self.z };
}
<* Clamp the components of the vector between min and max values specified by the given vectors *>
fn Vector3 Vector3.clamp(self, Vector3 min, Vector3 max) @export("vector3_clamp") {
	return {
		.x = math::min(max.x, math::max(min.x, self.x)),
		.y = math::min(max.y, math::max(min.y, self.y)),
		.z = math::min(max.z, math::max(min.z, self.z)),
	};
}
<* Clamp the magnitude of the vector between two values *>
fn Vector3 Vector3.clamp_value(self, float min, float max) @export("vector3_clampvalue") {
	Vector3 result = self;

	float len = self.length_sqr();
	if (len > 0) {
		len = math::sqrt(len);

		float scale;
		if (len < min) { scale = min / len; }
		else if (len > max) { scale = max / len; }
		else { scale = 1; };

		result = {
			.x = self.x * scale,
			.y = self.y * scale,
			.z = self.z * scale,
		};
	}

	return {
		.x = result.x,
		.y = result.y,
		.z = result.z,
	};
}
<* Compute the direction of a refracted ray *>
fn Vector3 Vector3.refract(Vector3 v, Vector3 n, float r) @export("vector3_refract") {
	Vector3 result = {};

	float dot = v.dot_product(n);
	float d = 1 - r.pow(2) * (1 - dot.pow(2));

	if (d >= 0) {
		d = math::sqrt(d);

		result = {
			.x = r * v.x - (r * dot + d) * n.x,
			.y = r * v.y - (r * dot + d) * n.y,
			.z = r * v.z - (r * dot + d) * n.z,
		};
	}

	return result;
}
<* Converts input HSV into  it's equivalent color *>
fn Color Vector3.to_color(self) @export("vector3_tocolor") {
	Color result = {
		.r = 0,
		.g = 0,
		.b = 0,
		.a = 255,
	};

	//* Red channel
	float k = (5 + self.x / 60) % 6;
	float t = 4 - k;
	if (t < k) { k = t; } else { k = k; };
	if (k < 1) { k = k; } else { k = 1; };
	if (k > 0) { k = k; } else { k = 0; };
	result.r = (char)((self.z - self.z * self.y * k) * 255);

	//* Green channel
	k = (3 + self.x / 60) % 6;
	t = 4 - k;
	if (t < k) { k = t; } else { k = k; };
	if (k < 1) { k = k; } else { k = 1; };
	if (k > 0) { k = k; } else { k = 0; };
	result.g = (char)((self.z - self.z * self.y * k) * 255);

	//* Blue channel
	k = (1 + self.x / 60) % 6;
	t = 4 - k;
	if (t < k) { k = t; } else { k = k; };
	if (k < 1) { k = k; } else { k = 1; };
	if (k > 0) { k = k; } else { k = 0; };
	result.b = (char)((self.z - self.z * self.y * k) * 255);

	return result;
}
<* Prints vector3 *>
fn void Vector3.print(self) @export("vector3_print") {
	io::printfn("[%f,%f,%f]", self.x, self.y, self.z);
}

