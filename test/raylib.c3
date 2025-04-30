

import pleroma::raylib;


fn void vector2() @test {
  Vector2 v1 = {1,1};
  Vector2 v2 = {2,4};
  Vector2 v3 = {10,20};
  float f1 = 5.0;

  // Self operators
  assert(v1 == v1, "Operator == failed");
  assert(v1 != v2, "Operator != failed");
  assert((v1 + v2) == {3,5}, "Operator + failed");
  assert((v1 - v2) == {-1,-3}, "Operator - failed");
  assert((v3 * v2) == {20,80}, "Operator * failed");
  assert((v3 / v2) == {5,5}, "Operator / failed");

  // Real operators
  assert((v2 + f1) == {7,9}, "Operator_r + failed");
  assert((v2 - f1) == {-3,-1}, "Operator_r - failed");
  assert((v2 * f1) == {10,20}, "Operator_r * failed");
  assert((v3 / f1) == {2,4}, "Operator_r / failed");
}

fn void vector3() @test {
  Vector3 v1 = {1,1,1};
  Vector3 v2 = {2,4,6};
  Vector3 v3 = {10,20,30};
  float f1 = 5.0;

  // Self operators
  assert(v1 == v1, "Operator == failed");
  assert(v1 != v2, "Operator != failed");
  assert((v1 + v2) == {3,5,7}, "Operator + failed");
  assert((v1 - v2) == {-1,-3,-5}, "Operator - failed");
  assert((v3 * v2) == {20,80,180}, "Operator * failed");
  assert((v3 / v2) == {5,5,5}, "Operator / failed");

  // Real operators
  assert((v2 + f1) == {7,9,11}, "Operator_r + failed");
  assert((v2 - f1) == {-3,-1,1}, "Operator_r - failed");
  assert((v2 * f1) == {10,20,30}, "Operator_r * failed");
  assert((v3 / f1) == {2,4,6}, "Operator_r / failed");
}

fn void vector4() @test {
  Vector4 v1 = {1,1,1,1};
  Vector4 v2 = {2,4,6,8};
  Vector4 v3 = {10,20,30,40};
  float f1 = 5.0;

  // Self operators
  assert(v1 == v1, "Operator == failed");
  assert(v1 != v2, "Operator != failed");
  assert((v1 + v2) == {3,5,7,9}, "Operator + failed");
  assert((v1 - v2) == {-1,-3,-5,-7}, "Operator - failed");
  assert((v3 * v2) == {20,80,180,320}, "Operator * failed");
  assert((v3 / v2) == {5,5,5,5}, "Operator / failed");

  // Real operators
  assert((v2 + f1) == {7,9,11,13}, "Operator_r + failed");
  assert((v2 - f1) == {-3,-1,1,3}, "Operator_r - failed");
  assert((v2 * f1) == {10,20,30,40}, "Operator_r * failed");
  assert((v3 / f1) == {2,4,6,8}, "Operator_r / failed");
}

