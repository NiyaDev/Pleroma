
module pleroma::yaml;


<* Counts the number of spaces set at the beginning of a string *>
fn int String.count_spaces(self, int tab_spaces = 4) {
  int spaces = 0;
  for (int i; i < self.len; i++) {
    if (self[i] == ' ') {
      spaces++;
    } else if (self[i] == '\t') {
      spaces += tab_spaces;
    } else {
      return spaces;
    } 
  }
  return spaces;
}
<**>
fn int String.count_spaces_after_char(self, char c) {
  int count;
  char last = '\0';
  for (int i; i < self.len; i++) {
    if (self[i] != ' ') last = self[i];
    if (last == c && self[i] == ' ') count++;
  }
  return count;
}
/*
<**>
fn int String.count_spaces(&self) {
  int spaces;

  for (int i; i < self.len -1; i++) {
    if (self[i] == ' ' || self[i] == '\t') spaces++;
  }

  return spaces;
}
*/
