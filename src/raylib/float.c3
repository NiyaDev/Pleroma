
module pleroma::raylib;


<* Returns true when two floats are close to each by a factor of input amount *>
fn bool close(float f1, float f2, float amount = 0.1) @export("float_close") {
  return ((f1 + amount) > f2 && (f1 - amount) < f2);
}

