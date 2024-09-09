module pleroma;


import std::math;


//= Vector2
struct Vector2 {
	float x;
	float y;
}

//= Vector3
struct Vector3 {
	float x;
	float y;
	float z;
}

//= Vector4
struct Vector4 {
	float x;
	float y;
	float z;
	float w;
}

//= Quaternion
distinct Quaternion = Vector4;


//= Vector2 methods
/// Calculate vector length
fn float Vector2.length(&self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2));
}
/// Calculate vector square length
fn float Vector2.length_sqr(&self) {
	return self.x.pow(2) + self.y.pow(2);
}
/// Calculate two vectors dot product
fn float Vector2.dot_product(&self, Vector2 v2) {
	return (self.x * v2.x) + (self.y * v2.y);
}
/// Calculate distance between two vectors
fn float Vector2.distance(&self, Vector2 v2) {
	return math::sqrt((self.x - v2.x).pow(2) + (self.y - v2.y).pow(2));
}
/// Calculate square distance between two vectors
fn float Vector2.distance_sr(&self, Vector2 v2) {
	return (self.x - v2.x).pow(2) + (self.y - v2.y).pow(2);
}
/// Calculate angle between two vectors
fn float Vector2.angle(&self, Vector2 v2) {
	float dot = self.dot_product(v2);
	float det = (self.x * v2.x) - (self.y * v2.y);
	
	return math::atan2(dot,det);
}
/// Calculate angle defined by a two vectors line
fn float Vector2.angle_line(&self, Vector2 end) {
	return -math::atan2(end.y - self.y,end.x - self.x);
}
/// Normalize provided vector
fn Vector2 Vector2.normalize(&self) {
	float length = self.length();
	
	if (length > 0.0) {
		float ilength = 1.0 / length;
		return {.x = self.x * ilength, .y = self.y * ilength};
	}
	
	return *self;
}
// TODO Matrix
/// Transforms a Vector2 by a given Matrix
//fn Vector2 Vector2.transform(&self, Matrix mat) {
//	float x = self.x;
//	float y = self.y;
//	float z = 0;
//	
//	return {
//		.x = (mat.m0 * x) + (mat.m4 * y) + (mat.m8 * z) + mat.m12,
//		.y = (mat.m1 * x) + (mat.m5 * y) + (mat.m9 * z) + mat.m13,
//	};
//}
/// Calculate linear interpolation between two vectors
fn Vector2 Vector2.lerp(&self, Vector2 v2, float amount) {
	return {
		.x = self.x + (amount * (v2.x - self.x)),
		.y = self.y + (amount * (v2.y - self.y)),
	};
}
/// Calculate reflected vector to normal
fn Vector2 Vector2.reflect(&self, Vector2 normal) {
	float dot = self.dot_product(normal);
	
	return {
		.x = self.x - (2 * normal.x) * dot,
		.y = self.y - (2 * normal.y) * dot,
	};
}
/// Rotate vector by angle
fn Vector2 Vector2.rotate(&self, float angle) {
	float cosres = math::cos(angle);
	float sinres = math::sin(angle);
	
	return {
		.x = (self.x * cosres) - (self.y * sinres),
		.y = (self.x * sinres) + (self.y * cosres),
	};
}
/// Move Vector towards target
fn Vector2 Vector2.move_towards(&self, Vector2 target, float max_distance) {
	float dx = target.x - self.x;
	float dy = target.y - self.y;
	float value = dx.pow(2) + dy.pow(2);
	
	if (value == 0 || (max_distance >= 0 && value <= max_distance.pow(2))) { return target; }
	float dist = math::sqrt(value);
	
	return {
		.x = self.x + (dx / dist) * max_distance,
		.y = self.y + (dy / dist) * max_distance,
	};
}
/// Invert the given vector
fn Vector2 Vector2.invert(&self) {
	return {
		.x = 1 / self.x,
		.y = 1 / self.y,
	};
}
/// Clamp the components of the vector between
/// 
/// min and max values specified by the given vectors
fn Vector2 Vector2.clamp(&self, Vector2 min, Vector2 max) {
	return {
		.x = math::clamp(self.x, min.x, max.x),
		.y = math::clamp(self.y, min.y, max.y),
	};
}
/// Clamp the magnitude of the vector between two min and max values
fn Vector2 Vector2.clamp_mag(&self, float min, float max) {
	float length = self.length();
	
	if (length > 0) {
		length = math::sqrt(length);
		
		float scale = 1;
		if (length < min) {
			scale = min / length;
		} else if (length > max) {
			scale = max / length;
		}
		
		return {
			.x = self.x * scale,
			.y = self.y * scale,
		};
	}
	
	return {
		.x = self.x,
		.y = self.y,
	};
}


//= Vector3 methods
/// Calculate two vectors cross product
fn Vector3 Vector3.cross_product(&self, Vector3 v2) {
	return {
		.x = self.y * v2.z - self.z * v2.y,
		.y = self.z * v2.x - self.x * v2.z,
		.z = self.x * v2.y - self.y * v2.x,
	};
}
/// Calculate one vector perpendicular vector
fn Vector3 Vector3.perpendicular(&self) {
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
/// Calculate vector length
fn float Vector3.length(&self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2));
}
/// Calculate vector square length
fn float Vector3.length_sqr(&self) {
	return self.x.pow(2) + self.y.pow(2) + self.z.pow(2);
}
/// Calculate two vectors dot product
fn float Vector3.dot_product(&self, Vector3 v2) {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z;
}
/// Calculate distance between two vectors
fn float Vector3.distance(&self, Vector3 v2) {
	return Vector3{
		.x = v2.x - self.x,
		.y = v2.y - self.y,
		.z = v2.z - self.z,
	}.length();
}
/// Calculate square distance between two vectors
fn float Vector3.distance_sqr(&self, Vector3 v2) {
	return Vector3{
		.x = v2.x - self.x,
		.y = v2.y - self.y,
		.z = v2.z - self.z,
	}.length_sqr();
}
/// Calculate angle between two vectors
fn float Vector3.angle(&self, Vector3 v2) {
	Vector3 cross = self.cross_product(v2);
	float len = cross.length();
	float dot = self.dot_product(v2);
	
	return math::atan2(len, dot);
}
/// Normalize provided vector
fn Vector3 Vector3.normalize(&self) {
	float len = self.length();
	if (len != 0) {
		float ilen = self.length();
		
		return {
			.x = self.x * ilen,
			.y = self.y * ilen,
			.z = self.z * ilen,
		};
	} else { return *self; }
}
/// Calculate the projection of the vector v1 on to v2
fn Vector3 Vector3.project(&self, Vector3 v2) {
	float v1dv2 = self.x*v2.x + self.y*v2.y + self.z*v2.z;
	float v2dv2 = v2.length_sqr();
	
	float mag = v1dv2 / v2dv2;
	
	return {
		.x = v2.x * mag,
		.y = v2.y * mag,
		.z = v2.z * mag,
	};
}
/// Calculate the rejection of the vector v1 on to v2
fn Vector3 Vector3.reject(&self, Vector3 v2) {
	float v1dv2 = self.x*v2.x + self.y*v2.y + self.z*v2.z;
	float v2dv2 = v2.length_sqr();

	float mag = v1dv2 / v2dv2;

	return Vector3{
		.x = self.x - (v2.x * mag),
		.y = self.y - (v2.y * mag),
		.z = self.z - (v2.z * mag),
	};
}
/// Orthonormalize provided vectors
/// 
/// Makes vectors normalized and orthogonal to each other
/// 
/// Gram-Schmidt function implementation
fn void Vector3.orthinormalize(&self, Vector3* v2) {
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
/// Transforms a Vector3 by a given Matrix
// TODO matrix
//fn Vector3 Vector3.transform(&self, Matrix mat) {
//	return {
//		.x = mat.m0 * self.x + mat.m4 * self.y + mat.m8  * self.z + mat.m12,
//		.y = mat.m1 * self.x + mat.m5 * self.y + mat.m9  * self.z + mat.m13,
//		.z = mat.m2 * self.x + mat.m6 * self.y + mat.m10 * self.z + mat.m14,
//	};
//}
/// Transform a vector by quaternion rotation
fn Vector3 Vector3.rotate_quaternion(&self, Quaternion q) {
	return {
		.x = self.x * (double)(q.x.pow(2) + q.w.pow(2) - q.y.pow(2) - q.z.pow(2)) + self.y * (2.0 * q.x * q.y - 2.0 * q.w * q.z) + self.z * (2.0 * q.x * q.z + 2.0 * q.w * q.y),
		.y = self.x * (2.0 * q.w * q.z + 2.0 * q.x * q.y) + self.y * (double)(q.w.pow(2) - q.x.pow(2) + q.y.pow(2) - q.z.pow(2)) + self.z * (-2.0 * q.w * q.x + 2.0 * q.y * q.z),
		.z = self.x * (-2.0 * q.w * q.y + 2.0 * q.x * q.z) + self.y * (2.0 * q.w * q.x + 2.0 * q.y * q.z) + self.z * (double)(q.w.pow(2) - q.x.pow(2) - q.y.pow(2) + q.z.pow(2)),
	};
}
/// #### rotate_axis
/// Rotates a vector around an axis
/// 
/// Using Euler-Rodrigues Formula
/// 
/// Ref.: https://en.wikipedia.org/w/index.php?title=Euler%E2%80%93Rodrigues_formula
fn Vector3 Vector3.rotate_axis(&self, Vector3 axis, float angle) {
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
	Vector3 wv = w.cross_product(*self);
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
/// Move Vector towards target
fn Vector3 Vector3.move_towards(&self, Vector3 target, float max_distance) {
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
/// Calculate linear interpolation between two vectors
fn Vector3 Vector3.lerp(&self, Vector3 target, float amount) {
	return {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
	};
}
/// Calculate reflected vector to normal
fn Vector3 Vector3.reflect(&self, Vector3 normal) {
	float dot = self.dot_product(normal);

	return {
		.x = self.x - (2.0 * normal.x) * dot,
		.y = self.y - (2.0 * normal.y) * dot,
		.z = self.z - (2.0 * normal.z) * dot,
	};
}
/// Get min value for each pair of components
fn Vector3 Vector3.min(&self, Vector3 v2) {
	return {
		.x = math::min(self.x, v2.x),
		.y = math::min(self.y, v2.y),
		.z = math::min(self.z, v2.z),
	};
}
/// Get max value for each pair of components
fn Vector3 Vector3.max(&self, Vector3 v2) {
	return {
		.x = math::max(self.x, v2.x),
		.y = math::max(self.y, v2.y),
		.z = math::max(self.z, v2.z),
	};
}
/// Compute barycenter coordinates (u, v, w) for point p with respect to triangle (a, b, c)
/// 
/// NOTE: Assumes P is on the plane of the triangle
fn Vector3 Vector3.barycenter(&self, Vector3 a, Vector3 b, Vector3 c) {
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
/// Projects a Vector3 from screen space into object space
/// 
/// NOTE: We are avoiding calling other raymath functions despite available
// TODO matrix
//fn Vector3 Vector3.unproject(&self, Matrix projections, Matrix view) {
//	//* Calculate unprojected matrix (multiply view matrix by projection matrix) and invert it
//	let mat_view_proj = Matrix {
//		m0:  view.m0 * projection.m0 + view.m1 * projection.m4 + view.m2 * projection.m8 + view.m3 * projection.m12,
//		m1:  view.m0*projection.m1 + view.m1*projection.m5 + view.m2*projection.m9 + view.m3*projection.m13,
//		m2:  view.m0*projection.m2 + view.m1*projection.m6 + view.m2*projection.m10 + view.m3*projection.m14,
//		m3:  view.m0*projection.m3 + view.m1*projection.m7 + view.m2*projection.m11 + view.m3*projection.m15,
//		m4:  view.m4*projection.m0 + view.m5*projection.m4 + view.m6*projection.m8 + view.m7*projection.m12,
//		m5:  view.m4*projection.m1 + view.m5*projection.m5 + view.m6*projection.m9 + view.m7*projection.m13,
//		m6:  view.m4*projection.m2 + view.m5*projection.m6 + view.m6*projection.m10 + view.m7*projection.m14,
//		m7:  view.m4*projection.m3 + view.m5*projection.m7 + view.m6*projection.m11 + view.m7*projection.m15,
//		m8:  view.m8*projection.m0 + view.m9*projection.m4 + view.m10*projection.m8 + view.m11*projection.m12,
//		m9:  view.m8*projection.m1 + view.m9*projection.m5 + view.m10*projection.m9 + view.m11*projection.m13,
//		m10: view.m8*projection.m2 + view.m9*projection.m6 + view.m10*projection.m10 + view.m11*projection.m14,
//		m11: view.m8*projection.m3 + view.m9*projection.m7 + view.m10*projection.m11 + view.m11*projection.m15,
//		m12: view.m12*projection.m0 + view.m13*projection.m4 + view.m14*projection.m8 + view.m15*projection.m12,
//		m13: view.m12*projection.m1 + view.m13*projection.m5 + view.m14*projection.m9 + view.m15*projection.m13,
//		m14: view.m12*projection.m2 + view.m13*projection.m6 + view.m14*projection.m10 + view.m15*projection.m14,
//		m15: view.m12*projection.m3 + view.m13*projection.m7 + view.m14*projection.m11 + view.m15*projection.m1,
//	};
//
//	//* Calculate inverted matrix -> MatrixInvert(matViewProj)
//	let b00 = mat_view_proj.m0  * mat_view_proj.m5  - mat_view_proj.m1  * mat_view_proj.m4;
//	let b01 = mat_view_proj.m0  * mat_view_proj.m6  - mat_view_proj.m2  * mat_view_proj.m4;
//	let b02 = mat_view_proj.m0  * mat_view_proj.m7  - mat_view_proj.m3  * mat_view_proj.m4;
//	let b03 = mat_view_proj.m1  * mat_view_proj.m6  - mat_view_proj.m2  * mat_view_proj.m5;
//	let b04 = mat_view_proj.m1  * mat_view_proj.m7  - mat_view_proj.m3  * mat_view_proj.m5;
//	let b05 = mat_view_proj.m2  * mat_view_proj.m7  - mat_view_proj.m3  * mat_view_proj.m6;
//	let b06 = mat_view_proj.m8  * mat_view_proj.m13 - mat_view_proj.m9  * mat_view_proj.m12;
//	let b07 = mat_view_proj.m8  * mat_view_proj.m14 - mat_view_proj.m10 * mat_view_proj.m12;
//	let b08 = mat_view_proj.m8  * mat_view_proj.m15 - mat_view_proj.m11 * mat_view_proj.m12;
//	let b09 = mat_view_proj.m9  * mat_view_proj.m14 - mat_view_proj.m10 * mat_view_proj.m13;
//	let b10 = mat_view_proj.m9  * mat_view_proj.m15 - mat_view_proj.m11 * mat_view_proj.m13;
//	let b11 = mat_view_proj.m10 * mat_view_proj.m15 - mat_view_proj.m11 * mat_view_proj.m14;
//
//	//* Calculate the invert determinant (inlined to avoid double-caching)
//	let inv_det = 1.0 / ((b00 * b11) - (b01 * b10) + (b02 * b09) + (b03 * b08) - (b04 * b07) + (b05 * b06));
//
//	let mat_view_proj_inv = Matrix{
//		m0:  (( mat_view_proj.m5  * b11) - (mat_view_proj.m6  * b10) + (mat_view_proj.m7  * b09)) * inv_det,
//		m1:  ((-mat_view_proj.m1  * b11) - (mat_view_proj.m2  * b10) + (mat_view_proj.m3  * b09)) * inv_det,
//		m2:  (( mat_view_proj.m13 * b05) - (mat_view_proj.m14 * b04) + (mat_view_proj.m15 * b03)) * inv_det,
//		m3:  ((-mat_view_proj.m9  * b05) + (mat_view_proj.m10 * b04) - (mat_view_proj.m11 * b03)) * inv_det,
//		m4:  ((-mat_view_proj.m4  * b11) + (mat_view_proj.m6  * b08) - (mat_view_proj.m7  * b07)) * inv_det,
//		m5:  (( mat_view_proj.m0  * b11) - (mat_view_proj.m2  * b08) + (mat_view_proj.m3  * b07)) * inv_det,
//		m6:  ((-mat_view_proj.m12 * b05) + (mat_view_proj.m14 * b02) - (mat_view_proj.m15 * b01)) * inv_det,
//		m7:  (( mat_view_proj.m8  * b05) - (mat_view_proj.m10 * b02) + (mat_view_proj.m11 * b01)) * inv_det,
//		m8:  (( mat_view_proj.m4  * b10) - (mat_view_proj.m5  * b08) + (mat_view_proj.m7  * b06)) * inv_det,
//		m9:  ((-mat_view_proj.m0  * b10) + (mat_view_proj.m1  * b08) - (mat_view_proj.m3  * b06)) * inv_det,
//		m10: (( mat_view_proj.m12 * b04) - (mat_view_proj.m13 * b02) + (mat_view_proj.m15 * b00)) * inv_det,
//		m11: ((-mat_view_proj.m8  * b04) + (mat_view_proj.m9  * b02) - (mat_view_proj.m11 * b00)) * inv_det,
//		m12: ((-mat_view_proj.m4  * b09) + (mat_view_proj.m5  * b07) - (mat_view_proj.m6  * b06)) * inv_det,
//		m13: (( mat_view_proj.m0  * b09) - (mat_view_proj.m1  * b07) + (mat_view_proj.m2  * b06)) * inv_det,
//		m14: ((-mat_view_proj.m12 * b03) + (mat_view_proj.m13 * b01) - (mat_view_proj.m14 * b00)) * inv_det,
//		m15: (( mat_view_proj.m8  * b03) - (mat_view_proj.m9  * b01) + (mat_view_proj.m10 * b00)) * inv_det,
//	};
//
//	//* Create quaternion from source point
//	let quat = Quaternion{ x: self.x, y: self.y, z: self.z, w: 1.0 };
//
//	//* Multiply quat point by unprojected matrix
//	let q_tranformed = mat_view_proj_inv.quaternion_transform(quat);
//
//	//* Normalized world points in vectors
//	Self {
//		x: q_tranformed.x / q_tranformed.w,
//		y: q_tranformed.y / q_tranformed.w,
//		z: q_tranformed.z / q_tranformed.w,
//	}
//}
/// Invert the given vector
fn Vector3 Vector3.invert(&self) {
	return {.x = 1 / self.x, .y = 1 / self.y, .z = 1 / self.z };
}
/// Clamp the components of the vector between
/// 
/// min and max values specified by the given vectors
fn Vector3 Vector3.clamp(&self, Vector3 min, Vector3 max) {
	return {
		.x = math::min(max.x, math::max(min.x, self.x)),
		.y = math::min(max.y, math::max(min.y, self.y)),
		.z = math::min(max.z, math::max(min.z, self.z)),
	};
}
/// Clamp the magnitude of the vector between two values
fn Vector3 Vector3.clamp_value(&self, float min, float max) {
	Vector3 result = *self;

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
/// Compute the direction of a refracted ray
/// 
/// v: normalized direction of the incoming ray
/// 
/// n: normalized normal vector of the interface of two optical media
/// 
/// r: ratio of the refractive index of the medium from where the ray comes to the refractive index of the medium on the other side of the surface
fn Vector3 Vector3.refract(Vector3 v, Vector3 n, float r) {
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
/// Converts input HSV into  it's equivalent color
fn Color Vector3.to_color(&self) {
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


//= Vector4 methods
/// Calculate vector length
fn float Vector4.length(&self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2));
}
/// Calculate vector square length
fn float Vector4.length_square(&self) {
	return self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2);
}
/// Calculate two vectors dot product
fn float Vector4.dot_product(&self, Vector4 v2) {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z + self.w * v2.w;
}
/// Calculate distance between two vectors
fn float Vector4.distance(&self, Vector4 v2) {
	return math::sqrt((self.x - v2.x).pow(2) + (self.y - v2.y).pow(2) + (self.z - v2.z).pow(2) + (self.w - v2.w).pow(2));
}
/// Calculate square distance between two vectors
fn float Vector4.distance_square(&self, Vector4 v2) {
	return (self.x - v2.x).pow(2) + (self.y - v2.y).pow(2) + (self.z - v2.z).pow(2) + (self.w - v2.w).pow(2);
}
/// Normalize provided vector
fn Vector4 Vector4.normalize(&self) {
	Vector4 result = {};
	
	float len = self.length();
	if (len > 0) {
		float ilen = 1 / len;
		result = {
			.x = self.x * ilen,
			.y = self.y * ilen,
			.z = self.z * ilen,
			.w = self.w * ilen,
		};
	}
	
	return result;
}
/// Get min value for each pair of components
fn Vector4 Vector4.min(&self, Vector4 v2) {
	return {
		.x = math::min(self.x, v2.x),
		.y = math::min(self.y, v2.y),
		.z = math::min(self.z, v2.z),
		.w = math::min(self.w, v2.w),
	};
}
/// Get max value for each pair of components
fn Vector4 Vector4.max(&self, Vector4 v2) {
	return {
		.x = math::max(self.x, v2.x),
		.y = math::max(self.y, v2.y),
		.z = math::max(self.z, v2.z),
		.w = math::max(self.w, v2.w),
	};
}
/// Calculate linear interpolation between two vectors
fn Vector4 Vector4.lerp(&self, Vector4 target, float amount) {
	return {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
		.w = self.w + amount * (target.w - self.w),
	};
}
/// Move Vector towards target
fn Vector4 Vector4.move_towards(&self, Vector4 target, float max_distance) {
	float dx = target.x - self.x;
	float dy = target.y - self.y;
	float dz = target.z - self.z;
	float dw = target.w - self.w;
	float value = dx.pow(2) + dy.pow(2) + dz.pow(2) + dw.pow(2);

	if (value == 0.0 || (max_distance >= 0.0 && value <= max_distance.pow(2))) { return {}; }

	float dist = math::sqrt(value);

	return {
		.x = self.x + dx / dist * max_distance,
		.y = self.y + dy / dist * max_distance,
		.z = self.z + dz / dist * max_distance,
		.w = self.w + dw / dist * max_distance,
	};
}
/// Invert the given vector
fn Vector4 Vector4.invert(&self) {
	return {
		.x = 1 / self.x,
		.y = 1 / self.y,
		.z = 1 / self.z,
		.w = 1 / self.w,
	};
}
/// Converts normaized Vector4 into a color.
fn Color Vector4.to_color(&self) {
	return {
		.r = (char)(self.x * 255),
		.g = (char)(self.y * 255),
		.b = (char)(self.z * 255),
		.a = (char)(self.w * 255),
	};
}


//= Quaternion methods
/// Computes the length of a quaternion
fn float Quaternion.length(&self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2));
}
/// Calculate two quaternions dot product
fn float Quaternion.dot_product(&self, Quaternion v2) {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z + self.w * v2.w;
}
/// Normalize provided quaternion
fn Quaternion Quaternion.normalize(&self) {
	Quaternion result = {};

	float len = self.length();
	if (len > 0) {
		float ilen = 1 / len;
		result = {
			.x = self.x * ilen,
			.y = self.y * ilen,
			.z = self.z * ilen,
			.w = self.w * ilen,
		};
	}

	return result;
}
/// Invert provided quaternion
fn Quaternion Quaternion.invert(&self) {
	return {
		.x = 1 / self.x,
		.y = 1 / self.y,
		.z = 1 / self.z,
		.w = 1 / self.w,
	};
}
/// Calculate linear interpolation between two quaternions
fn Quaternion Quaternion.lerp(&self, Quaternion target, float amount) {
	return {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
		.w = self.w + amount * (target.w - self.w),
	};
}
/// Calculate slerp-optimized interpolation between two quaternions
fn Quaternion Quaternion.n_lerp(&self, Quaternion target, float amount) {
	Quaternion result = {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
		.w = self.w + amount * (target.w - self.w),
	};

	float len = result.length();
	if (len == 0) { len = 1; };
	float ilen = 1 / len;

	return {
		.x = result.x * ilen,
		.y = result.y * ilen,
		.z = result.z * ilen,
		.w = result.w * ilen,
	};
}
/// Calculates spherical linear interpolation between two quaternions
fn Quaternion Quaternion.slerp(&self, Quaternion target, float amount) {
	Quaternion result = {};

	float cos_half_theta = self.dot_product(target);
	Quaternion new_target = target;
	if (cos_half_theta < 0) {
		new_target.x = -target.x;
		new_target.y = -target.y;
		new_target.z = -target.z;
		new_target.w = -target.w;
		cos_half_theta = -cos_half_theta;
	}

	if (math::abs(cos_half_theta) >= 1) { result = *self; }
	else if (cos_half_theta > 0.95) { result = self.n_lerp(target, amount); }
	else {
		float half_theta = math::acos(cos_half_theta);
		float sin_half_theta = math::sqrt(1 - cos_half_theta.pow(2));

		if (math::abs(sin_half_theta) < math::E) {
			result = {
				.x = (self.x * 0.5 + target.x * 0.5),
				.y = (self.y * 0.5 + target.y * 0.5),
				.z = (self.z * 0.5 + target.z * 0.5),
				.w = (self.w * 0.5 + target.w * 0.5),
			};
		} else {
			float ratio_a = math::sin((1 - amount) * half_theta) / sin_half_theta;
			float ratio_b = math::sin(amount * half_theta) / sin_half_theta;

			result = {
				.x = (self.x * ratio_a + target.x * ratio_b),
				.y = (self.y * ratio_a + target.y * ratio_b),
				.z = (self.z * ratio_a + target.z * ratio_b),
				.w = (self.w * ratio_a + target.w * ratio_b),
			};
		}
	}

	return result;
}
/// Calculate quaternion based on the rotation from one vector to another
// TODO check if this is necesary
//fn Quaternion Quaternion.from_v3_to_v3(Vector3 from, Vector3 to) {
//	Quaternion result;
//
//	float cos2_theta = from.dot_product(to);
//	float cross = from.cross_product(to);
//
//	result = {
//		.x = cross.x,
//		.y = cross.y,
//		.z = cross.z,
//		.w = 1 + cos2_theta,
//	};
//
//	float len = result.length();
//	if (len == 0) { len = 1; }
//	float ilen = 1 / len;
//
//	return {
//		.x = result.x * ilen,
//		.y = result.y * ilen,
//		.z = result.z * ilen,
//		.w = result.w * ilen,
//	};
//}
/// Get rotation quaternion for an angle and axis
/// 
/// NOTE: Angle must be provided in radians
// TODO check if this is necesary
//fn Quaternion quaternion_from_axis_angle(Vector3 axis, float angle) {
//	Matrix result = Matrix.identity();
//
//	float axis_len = axis.length();
//
//	if (axis_len != 0) {
//		float new_angle = angle * 0.5;
//
//		float len = axis_len;
//		if (len == 0) { len = 1; }
//		float ilen = 1 / len;
//
//		Vector3 new_axis = {
//			.x = axis.x * ilen,
//			.y = axis.y * ilen,
//			.z = axis.z * ilen,
//		};
//		
//		float sinres = math::sin(new_angle);
//		float cosres = math::cos(new_angle);
//
//		result.x = new_axis.x * sinres;
//		result.y = new_axis.y * sinres;
//		result.z = new_axis.z * sinres;
//		result.w = cosres;
//
//		len = result.length();
//		if (len == 0) { len = 1; }
//		ilen = 1 / len;
//
//		result.x = result.x * ilen;
//		result.y = result.y * ilen;
//		result.z = result.z * ilen;
//		result.w = result.w * ilen;
//	}
//
//	return result;
//}
/// Get the rotation angle and axis for a given quaternion
//fn {Vector3, float} Quaternion.to_axis_angle(&self) {}
//fn Quaternion Quaternion.(&self) {}

/*
	/// #### to_axis_angle
	/// Get the rotation angle and axis for a given quaternion
	pub fn to_axis_angle(&self) -> (Vector3, f32) {
		let mut new_quat = *self;

		if self.w.abs() > 1.0 {
			let mut len = self.length();
			len = if len == 0.0 { 1.0 } else { len };
			let ilen = 1.0 / len;

			new_quat.x = self.x * ilen;
			new_quat.y = self.y * ilen;
			new_quat.z = self.z * ilen;
			new_quat.w = self.w * ilen;
		}

		let mut res_axis = ZERO_3;
		let res_angle = 2.0 * self.w.acos();
		let den = (1.0 - self.w.powi(2)).sqrt();

		if den > EPSILON {
			res_axis.x = self.x / den;
			res_axis.y = self.y / den;
			res_axis.z = self.z / den;
		} else {
			res_axis.x = 1.0;
		}

		(res_axis, res_angle)
	}
	/// #### from_euler
	/// Get the quaternion equivalent to Euler angles
	/// 
	/// NOTE: Rotation order is ZYX
	pub fn from_euler(pitch: f32, yaw: f32, roll: f32) -> Self {
		let mut result = ZERO_Q;

		let x0 = (pitch * 0.5).cos();
		let x1 = (pitch * 0.5).sin();
		let y0 = (yaw   * 0.5).cos();
		let y1 = (yaw   * 0.5).sin();
		let z0 = (roll  * 0.5).cos();
		let z1 = (roll  * 0.5).sin();

		result.x = x1 * y0 * z0 - x0 * y1 * z1;
		result.y = x0 * y1 * z0 - x1 * y0 * z1;
		result.z = x0 * y0 * z1 - x1 * y1 * z0;
		result.w = x0 * y0 * z0 - x1 * y1 * z1;

		result
	}
	/// #### to_euler
	/// Get the Euler angles equivalent to quaternion (roll, pitch, yaw)
	/// 
	/// NOTE: Angles are returned in a Vector3 struct in radians
	pub fn to_euler(&self) -> (f32, f32, f32) {
		let pitch;
		let yaw;
		let roll;

		//* Roll
		let x0 = 2.0 * (self.w * self.x + self.y * self.z);
		let x1 = 1.0 - (2.0 * (self.x.powi(2) + self.y.powi(2)));
		roll = x0.atan2(x1);

		//* Pitch
		let mut y0 = 2.0 * (self.w * self.y - self.z * self.x);
		y0 = if y0 > 1.0 { 1.0 } else { y0 };
		y0 = if y0 < -1.0 { -1.0 } else { y0 };
		pitch = y0.asin();

		//* Yaw
		let z0 = 2.0 * (self.w * self.z + self.x * self.y);
		let z1 = 1.0 - 2.0 * (self.y.powi(2) + self.z.powi(2));
		yaw = z0.atan2(z1);

		(pitch, yaw, roll)
	}
	/// #### transform
	/// Transform a quaternion given a transformation matrix
	pub fn transform(&self, mat: Matrix) -> Self {
		Self {
			x: mat.m0 * self.x + mat.m4 * self.y + mat.m8  * self.z + mat.m12 * self.w,
			y: mat.m1 * self.x + mat.m5 * self.y + mat.m9  * self.z + mat.m13 * self.w,
			z: mat.m2 * self.x + mat.m6 * self.y + mat.m10 * self.z + mat.m14 * self.w,
			w: mat.m3 * self.x + mat.m7 * self.y + mat.m11 * self.z + mat.m15 * self.w,
		}
	}
*/