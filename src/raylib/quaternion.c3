
module pleroma::raylib;
import std::math;


const float EPSILON = 1.1920929E-7;

<* Quaternion *>
distinct Quaternion = Vector4;

<* Axis and Angle tuple *>
struct AxisAngle {
	Vector3 axis;
	float angle;
}

<* Computes the length of a quaternion *>
fn float Quaternion.length(&self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2));
}
<* Calculate two quaternions dot product *>
fn float Quaternion.dot_product(&self, Quaternion v2) {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z + self.w * v2.w;
}
<* Normalize provided quaternion *>
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
<* Invert provided quaternion *>
fn Quaternion Quaternion.invert(&self) {
	return {
		.x = 1 / self.x,
		.y = 1 / self.y,
		.z = 1 / self.z,
		.w = 1 / self.w,
	};
}
<* Calculate linear interpolation between two quaternions *>
fn Quaternion Quaternion.lerp(&self, Quaternion target, float amount) {
	return {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
		.w = self.w + amount * (target.w - self.w),
	};
}
<* Calculate slerp-optimized interpolation between two quaternions *>
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
<* Calculates spherical linear interpolation between two quaternions *>
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
<* Get the rotation angle and axis for a given quaternion *>
fn AxisAngle Quaternion.to_axis_angle(&self) {
	Quaternion new_quat = *self;

	if (math::abs(self.w) > 1) {
		float len = self.length();
		if (len == 0) { len = 1; }
		float ilen = 1 / len;

		new_quat.x = self.x * ilen;
		new_quat.y = self.y * ilen;
		new_quat.z = self.z * ilen;
		new_quat.w = self.w * ilen;
	}

	Vector3 res_axis = {};
	float res_angle = 2 * math::acos(self.w);
	float den = (1 - math::sqrt(self.w.pow(2)));

	if (den > EPSILON) {
		res_axis.x = self.x / den;
		res_axis.y = self.y / den;
		res_axis.z = self.z / den;
	} else {
		res_axis.x = 1.0;
	}

	return { .axis = res_axis, .angle = res_angle };
}
<* Get the Euler angles equivalent to quaternion (roll, pitch, yaw) *>
fn Vector3 Quaternion.to_euler(&self) {
	float pitch;
	float yaw;
	float roll;

	//* Roll
	float x0 = 2 * (self.w * self.x + self.y * self.z);
	float x1 = 1 - (2 * (self.x.pow(2) + self.y.pow(2)));
	roll = math::atan2(x0, x1);

	//* Pitch
	float y0 = 2 * (self.w * self.y - self.z * self.x);
	if (y0 >  1) { y0 =  1; }
	if (y0 < -1) { y0 = -1; }
	pitch = math::asin(y0);

	//* Yaw
	float z0 = 2 * (self.w * self.z + self.x * self.y);
	float z1 = 1 - 2 * (self.y.pow(2) + self.z.pow(2));
	yaw = math::atan2(z0, z1);

	return { .x = pitch, .y = yaw, .z = roll };
}
<* Transform a quaternion given a transformation matrix *>
fn Quaternion Quaternion.transform(&self, Matrix mat) {
	return {
		.x = mat.m0 * self.x + mat.m4 * self.y + mat.m8  * self.z + mat.m12 * self.w,
		.y = mat.m1 * self.x + mat.m5 * self.y + mat.m9  * self.z + mat.m13 * self.w,
		.z = mat.m2 * self.x + mat.m6 * self.y + mat.m10 * self.z + mat.m14 * self.w,
		.w = mat.m3 * self.x + mat.m7 * self.y + mat.m11 * self.z + mat.m15 * self.w,
	};
}

module pleroma::raylib::quaternion;
import std::math;

<* Calculate quaternion based on the rotation from one vector to another *>
fn raylib::Quaternion from_v3_to_v3(Vector3 from, Vector3 to) {
	raylib::Quaternion result;

	float cos2_theta = from.dot_product(to);
	Vector3 cross = from.cross_product(to);

	result = {
		.x = cross.x,
		.y = cross.y,
		.z = cross.z,
		.w = 1 + cos2_theta,
	};

	float len = result.length();
	if (len == 0) { len = 1; }
	float ilen = 1 / len;

	return {
		.x = result.x * ilen,
		.y = result.y * ilen,
		.z = result.z * ilen,
		.w = result.w * ilen,
	};
}
<* Get rotation quaternion for an angle and axis *>
fn raylib::Quaternion quaternion_from_axis_angle(Vector3 axis, float angle) {
	raylib::Quaternion result;

	float axis_len = axis.length();

	if (axis_len != 0) {
		float new_angle = angle * 0.5;

		float len = axis_len;
		if (len == 0) { len = 1; }
		float ilen = 1 / len;

		Vector3 new_axis = {
			.x = axis.x * ilen,
			.y = axis.y * ilen,
			.z = axis.z * ilen,
		};

		float sinres = math::sin(new_angle);
		float cosres = math::cos(new_angle);

		result.x = new_axis.x * sinres;
		result.y = new_axis.y * sinres;
		result.z = new_axis.z * sinres;
		result.w = cosres;

		len = result.length();
		if (len == 0) { len = 1; }
		ilen = 1 / len;

		result.x = result.x * ilen;
		result.y = result.y * ilen;
		result.z = result.z * ilen;
		result.w = result.w * ilen;
	}

	return result;
}
<* Get the quaternion equivalent to Euler angles *>
fn raylib::Quaternion from_euler(float pitch, float yaw, float roll) {
	raylib::Quaternion result;

	float x0 = math::cos((float)(pitch * 0.5));
	float x1 = math::sin((float)(pitch * 0.5));
	float y0 = math::cos((float)(yaw   * 0.5));
	float y1 = math::sin((float)(yaw   * 0.5));
	float z0 = math::cos((float)(roll  * 0.5));
	float z1 = math::sin((float)(roll  * 0.5));

	result.x = x1 * y0 * z0 - x0 * y1 * z1;
	result.y = x0 * y1 * z0 - x1 * y0 * z1;
	result.z = x0 * y0 * z1 - x1 * y1 * z0;
	result.w = x0 * y0 * z0 - x1 * y1 * z1;

	return result;
}

