
module pleroma::raylib;
import std::math;


<* Vector2 *>
struct Vector2 {
	float x;
	float y;
}
<* Calculate vector length *>
fn float Vector2.length(&self) {
	return math::sqrt(self.x.pow(2) + self.y.pow(2));
}
<* Calculate vector square length *>
fn float Vector2.length_sqr(&self) {
	return self.x.pow(2) + self.y.pow(2);
}
<* Calculate the dot product of two vectors *>
fn float Vector2.dot_product(&self, Vector2 v2) {
	return (self.x * v2.x) + (self.y * v2.y);
}
<* Calculate distance between two vectors *>
fn float Vector2.distance(&self, Vector2 v2) {
	return math::sqrt((self.x - v2.x).pow(2) + (self.y - v2.y).pow(2));
}
<* Calculate square distance between two vectors *>
fn float Vector2.distance_sr(&self, Vector2 v2) {
	return (self.x - v2.x).pow(2) + (self.y - v2.y).pow(2);
}
<* Calculate angle between two vectors *>
fn float Vector2.angle(&self, Vector2 v2) {
	float dot = self.dot_product(v2);
	float det = (self.x * v2.x) - (self.y * v2.y);

	return math::atan2(dot,det);
}
<* Calculate angle defined by a line made by two vectors *>
fn float Vector2.angle_line(&self, Vector2 end) {
	return -math::atan2(end.y - self.y,end.x - self.x);
}
<* Normalize provided vector *>
fn Vector2 Vector2.normalize(&self) {
	float length = self.length();

	if (length > 0.0) {
		float ilength = 1.0 / length;
		return {.x = self.x * ilength, .y = self.y * ilength};
	}

	return *self;
}
<* Transform a Vector2 by a given Matrix *>
fn Vector2 Vector2.transform(&self, Matrix mat) {
	float x = self.x;
	float y = self.y;
	float z = 0;

	return {
		.x = (mat.m0 * x) + (mat.m4 * y) + (mat.m8 * z) + mat.m12,
		.y = (mat.m1 * x) + (mat.m5 * y) + (mat.m9 * z) + mat.m13,
	};
}
<* Calculate linear interpolation between two vectors *>
fn Vector2 Vector2.lerp(&self, Vector2 v2, float amount) {
	return {
		.x = self.x + (amount * (v2.x - self.x)),
		.y = self.y + (amount * (v2.y - self.y)),
	};
}
<* Calculate reflected vector to normal *>
fn Vector2 Vector2.reflect(&self, Vector2 normal) {
	float dot = self.dot_product(normal);

	return {
		.x = self.x - (2 * normal.x) * dot,
		.y = self.y - (2 * normal.y) * dot,
	};
}
<* Rotate vecotr by angle *>
fn Vector2 Vector2.rotate(&self, float angle) {
	float cosres = math::cos(angle);
	float sinres = math::sin(angle);

	return {
		.x = (self.x * cosres) - (self.y * sinres),
		.y = (self.x * sinres) + (self.y * cosres),
	};
}
<* Move vector towards target *>
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
<* Invert given vector *>
fn Vector2 Vector2.invert(&self) {
	return {
		.x = 1 / self.x,
		.y = 1 / self.y,
	};
}
<* Clamp the components of the vector between min and max values specified byt the given vectors *>
fn Vector2 Vector2.clamp(&self, Vector2 min, Vector2 max) {
	return {
		.x = math::clamp(self.x, min.x, max.x),
		.y = math::clamp(self.y, min.y, max.y),
	};
}
<* Clamp the magnitude of the vector between two min ans max values
  @require min < max
 *>
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

