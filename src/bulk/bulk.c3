
module pleroma::bulk;
import std::collections;
import std::io;
import pleroma::logos;


const char MAJOR = 1;
const char MINOR = 1;
const char PATCH = 0;


<* Core structure of Bulk *>
struct Bulk {
  String name;
  String path;

  char major, minor, patch;

  HashMap{String, BulkEntry} entries;
}


<* Create a new Bulk for saving data
  @param name "Name of file"
  @param path "Path to where file is saved"
 *>
fn Bulk new(String name, String path = "resources/") @export("bulk_new") => @pool() {
  Bulk output = {
    .name = name.copy(allocator::heap()),
    .path = path.copy(allocator::heap()),
    .major = MAJOR,
    .minor = MINOR,
    .patch = PATCH,
  };

  return output;
}
<* Frees up Bulk *>
fn void Bulk.free(&self) @export("bulk_free") {
  //* Free strings
  self.name.free(allocator::heap());
  self.path.free(allocator::heap());
  
  //* Free entries
  self.entries.@each(; String key, BulkEntry val) { val.free(); };
  self.entries.free();
}
<* Load a Bulk from file
  @param filename "Name of file to load"
 *>
fn Bulk load(String filename, Compression comp = NONE) @export("bulk_load") {
  //* Grab name of file
  String[] path_split = filename.split(allocator::heap(), "/");
  defer free(path_split);
  String name = path_split[path_split.len-1];
  String path = filename.trim(name);

  //* Create Bulk
  Bulk output = new(name, path);

  //* Create File
  Logos file = logos::file(filename, comp);

  //* Read Version
  output.major = file.read(CHAR).as_char;
  output.minor = file.read(CHAR).as_char;
  output.patch = file.read(CHAR).as_char;

  switch (output.major) {
    case 1: output.load_v11(&file);
    default: unreachable(); 
  }

  file.free();

  return output;
}
<* Loading algorithm Ver 1.0.x *>
fn void Bulk.load_v10(&self, void* file) @deprecated => unreachable();
<* Loading algorithm Ver 1.1.x
  @param file "File to load data from"
  @require file != null
 *>
fn void Bulk.load_v11(&self, Logos* file) {
  //* Get number of entries
  char number_of_entries = file.read(CHAR).as_char;
  usz offset = 4;

  //* Load each entry from file
  for (int i; i < number_of_entries; i++) {
    LogosData entry_name = file.read(STRING);
    defer entry_name.free();

    //* Create entry
    BulkEntry entry = { file.read(CHAR_ARRAY).as_char_array };
    self.entries.set(entry_name.as_string, entry);
  }
}

<* Save Bulk to file *>
fn void Bulk.save(&self, Compression comp = NONE) @export("bulk_save") {
  switch (self.major) {
    case 1: self.save_v11(comp);
  }
}
<* Saving algorithm Ver 1.0.x *>
fn void Bulk.save_v10(&self, Compression comp = NONE) @deprecated => unreachable();
<* Saving algorithm Ver 1.1.x *>
fn void Bulk.save_v11(&self, Compression comp = NONE) {
  //* Calculate size
  usz size = 4;
  self.entries.@each(; String key, BulkEntry entry) {
    size += 8;                // Length
    size += key.len + 1;      // String
    size += entry.value.len;  // Length of data
  };

  //* Save to file
  Logos file = logos::new(comp:comp);

  file.write({.type=CHAR,.as_char=self.major});
  file.write({.type=CHAR,.as_char=self.minor});
  file.write({.type=CHAR,.as_char=self.patch});
  file.write({.type=CHAR,.as_char=(char)self.entries.len()});

  self.entries.@each(; String key, BulkEntry entry) {
    file.write({.type=STRING,.as_string=key});
    file.write({.type=CHAR_ARRAY,.as_char_array=entry.value});
  };
  
  String path = self.save_path();
  defer path.free(allocator::heap());

  file.save(path);
  file.free();
}

<* Prints info on bulk *>
fn void Bulk.print(&self) @export("bulk_print") {
  io::printfn("\nBulk - [%s]-[%s%s.bulk] %s {", self.name, self.path, self.name, self.version());

  self.entries.@each(; String key, BulkEntry ent) {
    io::printfn("\t%s - %sb", key, ent.value.len);
  };

  io::printn("}");
}
<* Returns the full save path of bulk *>
fn String Bulk.save_path(&self) @export("bulk_path") {
  assert(self.name != "", "Bulk name empty.");
  assert(self.path != "", "Bulk path empty.");

  return self.path.concat(allocator::heap(), self.name);
}
<* Returns bulk version as string *>
fn String Bulk.version(&self) @export("bulk_version") {
  return string::format(allocator::heap(), "%d.%d.%d", self.major, self.minor, self.patch);
}

