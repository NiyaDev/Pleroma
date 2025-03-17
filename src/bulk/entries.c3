
module pleroma::bulk;


<* Inserting a new entry into bulk *>
fn void Bulk.add(&self, String name, char[] data) @export("bulk_add") {
  assert(!self.entries.has_key(name), "Entry already exists.");
  
  //* Duplicate data
  char[] new_data = mem::new_array(char, data.len);
  for (int i; i < data.len; i++) new_data[i] = data[i];

  self.entries.set(name, {new_data});
}
<* Get a general value from bulk *>
fn char[] Bulk.get(&self, String name) @export("bulk_get") {
  assert(self.entries.has_key(name), "Entry doesn't exist.");

  //* Duplicate data
  char[] data = self.entries[name]!!.value;
  char[] new_data = mem::new_array(char, data.len);
  for (int i; i < data.len; i++) new_data[i] = data[i];

  return new_data;
}
