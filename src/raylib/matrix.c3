
module pleroma::raylib;
import std::io;


<* Matrix *>
struct Matrix {
	float m0, m4, m8,  m12;
	float m1, m5, m9,  m13;
	float m2, m6, m10, m14;
	float m3, m7, m11, m15;
}

<* Equals *>
fn bool Matrix.equals(self, Matrix rhs) @operator(==) @export("matrix_equals") {
	return (
		self.m0  == rhs.m0 &&
	  self.m1  == rhs.m1 &&
	  self.m2  == rhs.m2 &&
	  self.m3  == rhs.m3 &&
	  self.m4  == rhs.m4 &&
	  self.m5  == rhs.m5 &&
	  self.m6  == rhs.m6 &&
	  self.m7  == rhs.m7 &&
	  self.m8  == rhs.m8 &&
	  self.m9  == rhs.m9 &&
	  self.m10 == rhs.m10 &&
	  self.m11 == rhs.m11 &&
	  self.m12 == rhs.m12 &&
	  self.m13 == rhs.m13 &&
	  self.m14 == rhs.m14 &&
	  self.m15 == rhs.m15
	);
}
<* Addition *>
fn Matrix Matrix.add(self, Matrix rhs) @operator(+) @export("matrix_add") {
	return {
		self.m0  + rhs.m0,
	  self.m1  + rhs.m1,
	  self.m2  + rhs.m2,
	  self.m3  + rhs.m3,
	  self.m4  + rhs.m4,
	  self.m5  + rhs.m5,
	  self.m6  + rhs.m6,
	  self.m7  + rhs.m7,
	  self.m8  + rhs.m8,
	  self.m9  + rhs.m9,
	  self.m10 + rhs.m10,
	  self.m11 + rhs.m11,
	  self.m12 + rhs.m12,
	  self.m13 + rhs.m13,
	  self.m14 + rhs.m14,
	  self.m15 + rhs.m15,
	};
}
<* Subtraction *>
fn Matrix Matrix.sub(self, Matrix rhs) @operator(-) @export("matrix_sub") {
	return {
		self.m0  - rhs.m0,
	  self.m1  - rhs.m1,
	  self.m2  - rhs.m2,
	  self.m3  - rhs.m3,
	  self.m4  - rhs.m4,
	  self.m5  - rhs.m5,
	  self.m6  - rhs.m6,
	  self.m7  - rhs.m7,
	  self.m8  - rhs.m8,
	  self.m9  - rhs.m9,
	  self.m10 - rhs.m10,
	  self.m11 - rhs.m11,
	  self.m12 - rhs.m12,
	  self.m13 - rhs.m13,
	  self.m14 - rhs.m14,
	  self.m15 - rhs.m15,
	};
}
<* Multiplication *>
fn Matrix Matrix.mul(self, Matrix rhs) @operator(*) @export("matrix_mul") {
	return {
		self.m0  * rhs.m0 + self.m1  * rhs.m4 + self.m2  * rhs.m8  + self.m3  * rhs.m12,
		self.m0  * rhs.m1 + self.m1  * rhs.m5 + self.m2  * rhs.m9  + self.m3  * rhs.m13,
		self.m0  * rhs.m2 + self.m1  * rhs.m6 + self.m2  * rhs.m10 + self.m3  * rhs.m14,
		self.m0  * rhs.m3 + self.m1  * rhs.m7 + self.m2  * rhs.m11 + self.m3  * rhs.m15,
	  self.m4  * rhs.m0 + self.m5  * rhs.m4 + self.m6  * rhs.m8  + self.m7  * rhs.m12,
		self.m4  * rhs.m1 + self.m5  * rhs.m5 + self.m6  * rhs.m9  + self.m7  * rhs.m13,
	  self.m4  * rhs.m2 + self.m5  * rhs.m6 + self.m6  * rhs.m10 + self.m7  * rhs.m14,
	  self.m4  * rhs.m3 + self.m5  * rhs.m7 + self.m6  * rhs.m11 + self.m7  * rhs.m15,
		self.m8  * rhs.m0 + self.m9  * rhs.m4 + self.m10 * rhs.m8  + self.m11 * rhs.m12,
		self.m8  * rhs.m1 + self.m9  * rhs.m5 + self.m10 * rhs.m9  + self.m11 * rhs.m13,
		self.m8  * rhs.m2 + self.m9  * rhs.m6 + self.m10 * rhs.m10 + self.m11 * rhs.m14,
		self.m8  * rhs.m3 + self.m9  * rhs.m7 + self.m10 * rhs.m11 + self.m11 * rhs.m15,
		self.m12 * rhs.m0 + self.m13 * rhs.m4 + self.m14 * rhs.m8  + self.m15 * rhs.m12,
		self.m12 * rhs.m1 + self.m13 * rhs.m5 + self.m14 * rhs.m9  + self.m15 * rhs.m13,
		self.m12 * rhs.m2 + self.m13 * rhs.m6 + self.m14 * rhs.m10 + self.m15 * rhs.m14,
		self.m12 * rhs.m3 + self.m13 * rhs.m7 + self.m14 * rhs.m11 + self.m15 * rhs.m15,
	};
}
<* Compute matrix determinant *>
fn float Matrix.determinant(self) @export("matrix_determinant") {
	return self.m12 * self.m9 * self.m6*self.m3 - self.m8 * self.m13 * self.m6 * self.m3 - self.m12 * self.m5 * self.m10 * self.m3 + self.m4 * self.m13 * self.m10 * self.m3 +
		self.m8  * self.m5 * self.m14 * self.m3  - self.m4 * self.m9  * self.m14 * self.m3  - self.m12 * self.m9 * self.m2  * self.m7  + self.m8 * self.m13 * self.m2  * self.m7  +
		self.m12 * self.m1 * self.m10 * self.m7  - self.m0 * self.m13 * self.m10 * self.m7  - self.m8  * self.m1 * self.m14 * self.m7  + self.m0 * self.m9  * self.m14 * self.m7  +
		self.m12 * self.m5 * self.m2  * self.m11 - self.m4 * self.m13 * self.m2  * self.m11 - self.m12 * self.m1 * self.m6  * self.m11 + self.m0 * self.m13 * self.m6  * self.m11 +
		self.m4  * self.m1 * self.m14 * self.m11 - self.m0 * self.m5  * self.m14 * self.m11 - self.m8  * self.m5 * self.m2  * self.m15 + self.m4 * self.m9  * self.m2  * self.m15 +
		self.m8  * self.m1 * self.m6  * self.m15 - self.m0 * self.m9  * self.m6  * self.m15 - self.m4  * self.m1 * self.m10 * self.m15 + self.m0 * self.m5  * self.m10 * self.m15;
}
<* Get the trace of the matrix (Sum of the values along the diagonal) *>
fn float Matrix.trace(self) @export("matrix_trace") {
	return self.m0 + self.m5 + self.m10 + self.m15;
}
<* Tansposes provided matrix *>
fn Matrix Matrix.transpose(self) @export("matrix_transpose") {
	Matrix result;
	result.m0  = self.m0;
	result.m1  = self.m4;
	result.m2  = self.m8;
	result.m3  = self.m12;
	result.m4  = self.m1;
	result.m5  = self.m5;
	result.m6  = self.m9;
	result.m7  = self.m13;
	result.m8  = self.m2;
	result.m9  = self.m6;
	result.m10 = self.m10;
	result.m11 = self.m14;
	result.m12 = self.m3;
	result.m13 = self.m7;
	result.m14 = self.m11;
	result.m15 = self.m15;

	return result;
}
<* Invert provided matrix *>
fn Matrix Matrix.invert(self) @export("matrix_invert") {
	Matrix result;

	//* Cache the matrix values (speed optimization)
	float a00 = self.m0;
	float a01 = self.m1;
	float a02 = self.m2;
	float a03 = self.m3;
	float a10 = self.m4;
	float a11 = self.m5;
	float a12 = self.m6;
	float a13 = self.m7;
	float a20 = self.m8;
	float a21 = self.m9;
	float a22 = self.m10;
	float a23 = self.m11;
	float a30 = self.m12;
	float a31 = self.m13;
	float a32 = self.m14;
	float a33 = self.m15;

	float b00 = a00 * a11 - a01 * a10;
	float b01 = a00 * a12 - a02 * a10;
	float b02 = a00 * a13 - a03 * a10;
	float b03 = a01 * a12 - a02 * a11;
	float b04 = a01 * a13 - a03 * a11;
	float b05 = a02 * a13 - a03 * a12;
	float b06 = a20 * a31 - a21 * a30;
	float b07 = a20 * a32 - a22 * a30;
	float b08 = a20 * a33 - a23 * a30;
	float b09 = a21 * a32 - a22 * a31;
	float b10 = a21 * a33 - a23 * a31;
	float b11 = a22 * a33 - a23 * a32;

	//* Calculate the invert determinant (inlined to avoid double-caching)
	float inv_det = 1 / (b00 * b11 - b01 * b10 + b02 * b09 + b03 * b08 - b04 * b07 + b05 * b06);

	result.m0  = ( a11 * b11 - a12 * b10 + a13 * b09) * inv_det;
	result.m1  = (-a01 * b11 + a02 * b10 - a03 * b09) * inv_det;
	result.m2  = ( a31 * b05 - a32 * b04 + a33 * b03) * inv_det;
	result.m3  = (-a21 * b05 + a22 * b04 - a23 * b03) * inv_det;
	result.m4  = (-a10 * b11 + a12 * b08 - a13 * b07) * inv_det;
	result.m5  = ( a00 * b11 - a02 * b08 + a03 * b07) * inv_det;
	result.m6  = (-a30 * b05 + a32 * b02 - a33 * b01) * inv_det;
	result.m7  = ( a20 * b05 - a22 * b02 + a23 * b01) * inv_det;
	result.m8  = ( a10 * b10 - a11 * b08 + a13 * b06) * inv_det;
	result.m9  = (-a00 * b10 + a01 * b08 - a03 * b06) * inv_det;
	result.m10 = ( a30 * b04 - a31 * b02 + a33 * b00) * inv_det;
	result.m11 = (-a20 * b04 + a21 * b02 - a23 * b00) * inv_det;
	result.m12 = (-a10 * b09 + a11 * b07 - a12 * b06) * inv_det;
	result.m13 = ( a00 * b09 - a01 * b07 + a02 * b06) * inv_det;
	result.m14 = (-a30 * b03 + a31 * b01 - a32 * b00) * inv_det;
	result.m15 = ( a20 * b03 - a21 * b01 + a22 * b00) * inv_det;

	return result;
}
<* Transform a quaternion given a transformation matrix *>
fn Vector4 Matrix.quaternion_transform(self, Quaternion q) @export("matrix_quaterniontransform") {
	return {
		.x = self.m0 * q.x + self.m4 * q.y + self.m8  * q.z + self.m12 * q.w,
		.y = self.m1 * q.x + self.m5 * q.y + self.m9  * q.z + self.m13 * q.w,
		.z = self.m2 * q.x + self.m6 * q.y + self.m10 * q.z + self.m14 * q.w,
		.w = self.m3 * q.x + self.m7 * q.y + self.m11 * q.z + self.m15 * q.w,
	};
}
<* Prints matrix to console *>
fn void Matrix.print(&self) @export("matrix_print") {
	io::printfn("[\n\t%d, %d, %d, %d,\n\t%d, %d, %d, %d,\n\t%d, %d, %d, %d,\n\t%d, %d, %d, %d,\n]",
		self.m0, self.m4, self.m8,  self.m12,
		self.m1, self.m5, self.m9,  self.m13,
		self.m2, self.m6, self.m10, self.m14,
		self.m3, self.m7, self.m11, self.m15,
	);
}



module pleroma::raylib::matrix;
import std::math;

<* Identity Matrix *>
const Matrix IDENTITY = {
	1.0, 0.0, 0.0, 0.0,
	0.0, 1.0, 0.0, 0.0,
	0.0, 0.0, 1.0, 0.0,
	0.0, 0.0, 0.0, 1.0,
};

<* Create translation matrix *>
fn Matrix translate(Vector3 v) @export("matrix_translate") {
	return {
		1.0, 0.0, 0.0, v.x,
		0.0, 1.0, 0.0, v.y,
		0.0, 0.0, 1.0, v.z,
		0.0, 0.0, 0.0, 1.0,
	};
}
<* Create rotation matrix from axis and angle *>
fn Matrix rotate(Vector3 axis, float angle) @export("matrix_rotate") {
	Matrix result;
	float x = axis.x;
	float y = axis.y;
	float z = axis.z;

	float length_squared = x*x + y*y + z*z;
	if (length_squared != 1.0 && (length_squared != 0.0)) {
	    float ilength = 1.0 / math::sqrt(length_squared);
	    x *= ilength;
	    y *= ilength;
	    z *= ilength;
	}

	float sinres = math::sin(angle);
	float cosres = math::cos(angle);
	float t = 1 - cosres;

	result.m0 = x*x*t + cosres;
	result.m1 = y*x*t + z*sinres;
	result.m2 = z*x*t - y*sinres;
	result.m3 = 0;

	result.m4 = x*y*t - z*sinres;
	result.m5 = y*y*t + cosres;
	result.m6 = z*y*t + x*sinres;
	result.m7 = 0;

	result.m8 = x*z*t + y*sinres;
	result.m9 = y*z*t - x*sinres;
	result.m10 = z*z*t + cosres;
	result.m11 = 0;

	result.m12 = 0;
	result.m13 = 0;
	result.m14 = 0;
	result.m15 = 1;

	return result;
}
<* Get x-rotation matrix *>
fn Matrix rotate_x(float angle) @export("matrix_rotatex") {
	Matrix result;
	float cosres = math::cos(angle);
	float sinres = math::sin(angle);

	result.m5  =  cosres;
	result.m6  =  sinres;
	result.m9  = -sinres;
	result.m10 =  cosres;

	return result;
}
<* Get y-rotation matrix *>
fn Matrix rotate_y(float angle) @export("matrix_rotatey") {
	Matrix result;
	float cosres = math::cos(angle);
	float sinres = math::sin(angle);

	result.m0  =  cosres;
	result.m2  = -sinres;
	result.m8  =  sinres;
	result.m10 =  cosres;

	return result;
}
<* Get z-rotation matrix *>
fn Matrix rotate_z(float angle) @export("matrix_rotatez") {
	Matrix result;
	float cosres = math::cos(angle);
	float sinres = math::sin(angle);

	result.m0 =  cosres;
	result.m1 =  sinres;
	result.m4 = -sinres;
	result.m5 =  cosres;

	return result;
}
<* Get xyz-rotation matrix *>
fn Matrix rotate_xyz(Vector3 angle) @export("matrix_rotatexyz") {
	Matrix result;
	float cosz = math::cos(-angle.z);
	float sinz = math::sin(-angle.z);
	float cosy = math::cos(-angle.y);
	float siny = math::sin(-angle.y);
	float cosx = math::cos(-angle.x);
	float sinx = math::sin(-angle.x);

	result.m0 =  cosz * cosy;
	result.m1 = (cosz * siny * sinx) - (sinz * cosx);
	result.m2 = (cosz * siny * cosx) + (sinz * sinx);

	result.m4 =  sinz * cosy;
	result.m5 = (sinz * siny * sinx) + (cosz * cosx);
	result.m6 = (sinz * siny * cosx) - (cosz * sinx);

	result.m8 = -siny;
	result.m9 =  cosy * sinx;
	result.m10=  cosy * cosx;

	return result;
}
<* Get xyz-rotation matrix *>
fn Matrix rotate_zyx(Vector3 angle) @export("matrix_rotatezyx") {
	Matrix result;
	float cz = math::cos(angle.z);
	float sz = math::sin(angle.z);
	float cy = math::cos(angle.y);
	float sy = math::sin(angle.y);
	float cx = math::cos(angle.x);
	float sx = math::sin(angle.x);

	result.m0  = cz * cy;
	result.m4  = cz * sy * sx - cx * sz;
	result.m8  = sz * sx + cz * cx * sy;
	result.m12 = 0;

	result.m1  = cy * sz;
	result.m5  = cz * cx + sz * sy * sx;
	result.m9  = cx * sz * sy - cz * sx;
	result.m13 = 0;

	result.m2  = -sy;
	result.m6  =  cy * sx;
	result.m10 =  cy * cx;
	result.m14 =  0;

	result.m3  = 0;
	result.m7  = 0;
	result.m11 = 0;
	result.m15 = 1;

	return result;
}
<* Get scaling matrix *>
fn Matrix scale(Vector3 scale) @export("matrix_scale") {
	return {
		scale.x,     0.0,     0.0, 0.0,
		    0.0, scale.y,     0.0, 0.0,
		    0.0,     0.0, scale.z, 0.0,
		    0.0,     0.0,     0.0, 1.0,
	};
}
<* Get perspective projection matrix *>
fn Matrix frustum(double left, double right, double bottom, double top, double near, double far) @export("matrix_frustum") {
	Matrix result;
	float rl  = (float)(right - left);
	float tb  = (float)(top - bottom);
	float f_n = (float)(far - near);

	result.m0 = (float)(near * 2) / rl;
	result.m1 = 0;
	result.m2 = 0;
	result.m3 = 0;

	result.m4 = 0;
	result.m5 = (float)(near * 2) / tb;
	result.m6 = 0;
	result.m7 = 0;

	result.m8  =  (float)(right + left) / rl;
	result.m9  =  (float)(top + bottom) / tb;
	result.m10 = -(float)(far + near) / f_n;
	result.m11 = -1;

	result.m12 = 0;
	result.m13 = 0;
	result.m14 = -(float)(far * near * 2.0) / f_n;
	result.m15 = 0;

	return result;
}
<* Get perspective projection matrix *>
fn Matrix perspective(double fov_y, double aspect, double near_plane, double far_plane) @export("matrix_perspective") {
	Matrix result;
	double top    =  near_plane * math::tan((fov_y * 0.5));
	double bottom = -top;
	double right  =  top * aspect;
	double left   = -right;

	//* MatrixFrustum(-right, right, -top, top, near, far);
	float rl  = (float)(right - left);
	float tb  = (float)(top - bottom);
	float f_n = (float)(far_plane - near_plane);

	result.m0  =  ((float)near_plane * 2.0) / rl;
	result.m5  =  ((float)near_plane * 2.0) / tb;
	result.m8  =  (float)(right + left) / rl;
	result.m9  =  (float)(top + bottom) / tb;
	result.m10 = -(float)(far_plane + near_plane) / f_n;
	result.m11 = -1;
	result.m14 = -(float)(far_plane * near_plane * 2) / f_n;

	return result;
}
<* Get orthographic projection matrix *>
fn Matrix ortho(double left, double right, double bottom, double top, double near_plane, double far_plane) @export("matrix_ortho") {
	Matrix result;
	float rl  = (float)(right - left);
	float tb  = (float)(top - bottom);
	float f_n = (float)(far_plane - near_plane);

	result.m0  =  2 / rl;
	result.m1  =  0;
	result.m2  =  0;
	result.m3  =  0;
	result.m4  =  0;
	result.m5  =  2 / tb;
	result.m6  =  0;
	result.m7  =  0;
	result.m8  =  0;
	result.m9  =  0;
	result.m10 = -2 / f_n;
	result.m11 =  0;
	result.m12 = -(float)(left + right) / rl;
	result.m13 = -(float)(top + bottom) / tb;
	result.m14 = -(float)(far_plane + near_plane) / f_n;
	result.m15 =  1;

	return result;
}
<* Get camera look-at matrix (view matrix) *>
fn Matrix look_at(Vector3 eye, Vector3 target, Vector3 up) @export("matrix_lookat") {
	Matrix result;
	float length;
	float ilength;

	Vector3 vz = eye.sub(target);

	//* Vector3Normalize(vz)
	Vector3 v = vz;
	length = v.length();
	if (length == 0) { length = 1; }
	ilength = 1 / length;
	vz.x *= ilength;
	vz.y *= ilength;
	vz.z *= ilength;

	//* Vector3CrossProduct(up, vz)
	Vector3 vx = up.cross_product(vz);

	//* Vector3Normalize(x)
	v = vx;
	length = v.length();
	if (length == 0) { length = 1; }
	ilength = 1 / length;
	vx.x *= ilength;
	vx.y *= ilength;
	vx.z *= ilength;

	//* Vector3CrossProduct(vz, vx)
	Vector3 vy = vz.cross_product(vx);

	result.m0  =  vx.x;
	result.m1  =  vy.x;
	result.m2  =  vz.x;
	result.m3  =     0;
	result.m4  =  vx.y;
	result.m5  =  vy.y;
	result.m6  =  vz.y;
	result.m7  =     0;
	result.m8  =  vx.z;
	result.m9  =  vy.z;
	result.m10 =  vz.z;
	result.m11 =     0;
	result.m12 = -(vx.x * eye.x + vx.y * eye.y + vx.z * eye.z);   //* Vector3DotProduct(vx, eye)
	result.m13 = -(vy.x * eye.x + vy.y * eye.y + vy.z * eye.z);   //* Vector3DotProduct(vy, eye)
	result.m14 = -(vz.x * eye.x + vz.y * eye.y + vz.z * eye.z);   //* Vector3DotProduct(vz, eye)
	result.m15 =    1;

	return result;
}

