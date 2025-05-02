
module pleroma::raylib;
import std::math;


<* Vector4 *>
struct Vector4 {
	float x, y, z, w;
}
<* Equals *>
fn bool Vector4.equals(self, Vector4 rhs) @operator(==) @export("vector4_equals") {
	return (self.x == rhs.x && self.y == rhs.y && self.z == rhs.z && self.w == rhs.w);
}
<* Addition *>
fn Vector4 Vector4.add(self, Vector4 rhs) @operator(+) @export("vector4_add") {
	return {
		self.x + rhs.x,
		self.y + rhs.y,
		self.z + rhs.z,
		self.w + rhs.w,
	};
}
<* Subtraction *>
fn Vector4 Vector4.sub(self, Vector4 rhs) @operator(-) @export("vector4_sub") {
	return {
		self.x - rhs.x,
		self.y - rhs.y,
		self.z - rhs.z,
		self.w - rhs.w,
	};
}
<* Multiplication *>
fn Vector4 Vector4.mul(self, Vector4 rhs) @operator(*) @export("vector4_mul") {
	return {
		self.x * rhs.x,
		self.y * rhs.y,
		self.z * rhs.z,
		self.w * rhs.w,
	};
}
<* Division *>
fn Vector4 Vector4.div(self, Vector4 rhs) @operator(/) @export("vector4_div") {
	return {
		self.x / rhs.x,
		self.y / rhs.y,
		self.z / rhs.z,
		self.w / rhs.w,
	};
}
<* Add and assign *>
fn void Vector4.add_assign(&self, Vector4 rhs) @operator(+=) @export("vector4_addassign") {
	self.x += rhs.x;
	self.y += rhs.y;
	self.z += rhs.z;
	self.w += rhs.w;
}
<* Subtract and assign *>
fn void Vector4.sub_assign(&self, Vector4 rhs) @operator(-=) @export("vector4_subassign") {
	self.x -= rhs.x;
	self.y -= rhs.y;
	self.z -= rhs.z;
	self.w -= rhs.w;
}
<* Multiply and assign *>
fn void Vector4.mul_assign(&self, Vector4 rhs) @operator(*=) @export("vector4_mulassign") {
	self.x *= rhs.x;
	self.y *= rhs.y;
	self.z *= rhs.z;
	self.w *= rhs.w;
}
<* Divide and assign *>
fn void Vector4.div_assign(&self, Vector4 rhs) @operator(/=) @export("vector4_divassign") {
	self.x /= rhs.x;
	self.y /= rhs.y;
	self.z /= rhs.z;
	self.w /= rhs.w;
}
<* Add to with float *>
fn Vector4 Vector4.pos_offset(self, float rhs) @operator_s(+) @export("vector4_posoffset") {
	return {
		self.x + rhs,
		self.y + rhs,
		self.z + rhs,
		self.w + rhs,
	};
}
<* Subtract from with float *>
fn Vector4 Vector4.neg_offset(self, float rhs) @operator_s(-) @export("vector4_negoffset") {
	return {
		self.x - rhs,
		self.y - rhs,
		self.z - rhs,
		self.w - rhs,
	};
}
<* Multiply by float *>
fn Vector4 Vector4.scale(self, float rhs) @operator_s(*) @export("vector4_scale") {
	return {
		self.x * rhs,
		self.y * rhs,
		self.z * rhs,
		self.w * rhs,
	};
}
<* Divide by float *>
fn Vector4 Vector4.inverse(self, float rhs) @operator_s(/) @export("vector4_inverse") {
	return {
		self.x / rhs,
		self.y / rhs,
		self.z / rhs,
		self.w / rhs,
	};
}
<* Calculate vector length *>
fn float Vector4.length(self) @export("vector4_length") {
	return math::sqrt(self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2));
}
<* Calculate vector square length *>
fn float Vector4.length_sqr(self) @export("vector4_lengthsqr") {
	return self.x.pow(2) + self.y.pow(2) + self.z.pow(2) + self.w.pow(2);
}
<* Calculate two vectors dot product *>
fn float Vector4.dot_product(self, Vector4 v2) @export("vector4_dotproduct") {
	return self.x * v2.x + self.y * v2.y + self.z * v2.z + self.w * v2.w;
}
<* Calculate distance between two vectors *>
fn float Vector4.distance(self, Vector4 v2) @export("vector4_distance") {
	return math::sqrt((self.x - v2.x).pow(2) + (self.y - v2.y).pow(2) + (self.z - v2.z).pow(2) + (self.w - v2.w).pow(2));
}
<* Calculate square distance between two vectors *>
fn float Vector4.distance_sqr(self, Vector4 v2) @export("vector4_distancesqr") {
	return (self.x - v2.x).pow(2) + (self.y - v2.y).pow(2) + (self.z - v2.z).pow(2) + (self.w - v2.w).pow(2);
}
<* Normalize provided vector *>
fn Vector4 Vector4.normalize(self) @export("vector4_normalize") {
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
<* Get min value for each pair of components *>
fn Vector4 Vector4.min(self, Vector4 v2) @export("vector4_min") {
	return {
		.x = math::min(self.x, v2.x),
		.y = math::min(self.y, v2.y),
		.z = math::min(self.z, v2.z),
		.w = math::min(self.w, v2.w),
	};
}
<* Get max value for each pair of components *>
fn Vector4 Vector4.max(self, Vector4 v2) @export("vector4_max") {
	return {
		.x = math::max(self.x, v2.x),
		.y = math::max(self.y, v2.y),
		.z = math::max(self.z, v2.z),
		.w = math::max(self.w, v2.w),
	};
}
<* Calculate linear interpolation between two vectors *>
fn Vector4 Vector4.lerp(self, Vector4 target, float amount) @export("vector4_lerp") {
	return {
		.x = self.x + amount * (target.x - self.x),
		.y = self.y + amount * (target.y - self.y),
		.z = self.z + amount * (target.z - self.z),
		.w = self.w + amount * (target.w - self.w),
	};
}
<* Move Vector towards target *>
fn Vector4 Vector4.move_towards(self, Vector4 target, float max_distance) @export("vector4_movetowards") {
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
<* Invert the given vector *>
fn Vector4 Vector4.invert(self) @export("vector4_invert") {
	return {
		.x = 1 / self.x,
		.y = 1 / self.y,
		.z = 1 / self.z,
		.w = 1 / self.w,
	};
}
<* Converts normaized Vector4 into a color. *>
fn Color Vector4.to_color(self) @export("vector4_tocolor") {
	return {
		.r = (char)(self.x * 255),
		.g = (char)(self.y * 255),
		.b = (char)(self.z * 255),
		.a = (char)(self.w * 255),
	};
}

