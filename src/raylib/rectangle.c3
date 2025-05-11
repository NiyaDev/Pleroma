
module pleroma::raylib;

<* Rectangle *>
struct Rectangle {
  float x, y, width, height;
}

<* Equals *>
fn bool Rectangle.equals(self, Rectangle rhs) @operator(==) @export("rectangle_equals") {
	return (self.x == rhs.x && self.y == rhs.y && self.width == rhs.width && self.height == rhs.height);
}
<* Addition *>
fn Rectangle Rectangle.add(self, Rectangle rhs) @operator(+) @export("rectangle_add") {
	return {
		self.x + rhs.x,
		self.y + rhs.y,
		self.width + rhs.width,
		self.height + rhs.height,
	};
}
<* Subtraction *>
fn Rectangle Rectangle.sub(self, Rectangle rhs) @operator(-) @export("rectangle_sub") {
	return {
		self.x - rhs.x,
		self.x - rhs.y,
		self.width - rhs.width,
		self.height - rhs.height,
	};
}
<* Multiplication *>
fn Rectangle Rectangle.mul(self, Rectangle rhs) @operator(*) @export("rectangle_mul") {
	return {
		self.x * rhs.x,
		self.y * rhs.y,
		self.width * rhs.width,
		self.height * rhs.height,
	};
}
<* Division *>
fn Rectangle Rectangle.div(self, Rectangle rhs) @operator(/) @export("rectangle_div") {
	return {
		self.x / rhs.x,
		self.y / rhs.y,
		self.width / rhs.width,
		self.height / rhs.height,
	};
}
<* Add and assign *>
fn void Rectangle.add_assign(&self, Rectangle rhs) @operator(+=) @export("rectangle_addassign") {
	self.x += rhs.x;
	self.y += rhs.y;
	self.width += rhs.width;
	self.height += rhs.height;
}
<* Subtract and assign *>
fn void Rectangle.sub_assign(&self, Rectangle rhs) @operator(-=) @export("rectangle_subassign") {
	self.x -= rhs.x;
	self.y -= rhs.y;
	self.width -= rhs.width;
	self.height -= rhs.height;
}
<* Multiply and assign *>
fn void Rectangle.mul_assign(&self, Rectangle rhs) @operator(*=) @export("rectangle_mulassign") {
	self.x *= rhs.x;
	self.y *= rhs.y;
	self.width *= rhs.width;
	self.height *= rhs.height;
}
<* Divide and assign *>
fn void Rectangle.div_assign(&self, Rectangle rhs) @operator(/=) @export("rectangle_divassign") {
	self.x /= rhs.x;
	self.y /= rhs.y;
	self.width /= rhs.width;
	self.height /= rhs.height;
}

