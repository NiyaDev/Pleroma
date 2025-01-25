
module vstring;
import std::collections;


def VString = List(<char>);

<* Pushes an entire String into VString *>
fn void VString.push_string(&self, String str) {
  for (int i; i < str.len; i++) {
    self.push(str[i]);
  }
}
<* Converts VString into String and frees original *>
fn String VString.string(&self) {
  char[] output = mem::new_array(char, self.len());

  for (int i; i < self.len(); i++) output[i] = self.get(i);

  self.free();

  return (String)output;
}

