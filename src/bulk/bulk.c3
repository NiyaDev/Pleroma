
module pleroma::bulk;
import std::collections;
import std::io;


const char MAJOR = 1;
const char MINOR = 0;
const char PATCH = 0;


<* Core structure of Bulk *>
struct Bulk {
  String name;
  String path;

  char major, minor, patch;

  HashMap(<String, BulkEntry>) entries;
}

<* Compression method *>
enum Compression {
  NONE,
  DEFLATE,
}

<* Create a new Bulk for saving data
  @param name "Name of file"
  @param path "Path to where file is saved"
 *>
fn Bulk new(String name, String path = "resources/") @export("bulk_new") {
  Bulk output = {
    .name = name.copy(),
    .path = path.copy(),
    .major = MAJOR,
    .minor = MINOR,
    .patch = PATCH,
  };
  output.entries.new_init();

  return output;
}
<* Frees up Bulk *>
fn void Bulk.free(&self) @export("bulk_free") {
  //* Free strings
  self.name.free();
  self.path.free();
  
  //* Free entries
  self.entries.@each(; String key, BulkEntry val) { val.free(); };
  self.entries.free();
}
<* Load a Bulk from file
  @param filename "Name of file to load"
 *>
fn Bulk load(String filename, Compression comp = NONE) @export("bulk_load") {
  //* Grab name of file
  String[] path_split = filename.split("/");
  String name = path_split[path_split.len-1];
  String path = filename.trim(name);

  //* Create Bulk
  Bulk output = new(name, path);

  //* Create File
  BulkFile file = file::load(filename, comp);

  //* Read Version
  output.major = file.read_8();
  output.minor = file.read_8();
  output.patch = file.read_8();

  switch (output.major) {
    case 1: output.load_v1(&file);
    default: unreachable(); 
  }

  file.free();

  return output;
}
<* Loading algorithm Ver 1
  @param file "File to load data from"
  @require file != null
 *>
fn void Bulk.load_v1(&self, BulkFile* file) {
  //* Get number of entries
  char number_of_entries = file.read_8();
  usz offset = 4;

  //* Load each entry from file
  for (int i; i < number_of_entries; i++) {
    usz data_len = file.read_64();
    String entry_name = file.read_string();

    //* Create entry
    BulkEntry entry = { file.read_array(data_len) };
    self.entries.set(entry_name, entry);
  }
}

<* Save Bulk to file *>
fn void Bulk.save(&self, Compression comp = NONE) @export("bulk_save") {
  switch (self.major) {
    case 1: self.save_v1(comp);
  }
}
<* Saving algorithm Ver 1 *>
fn void Bulk.save_v1(&self, Compression comp = NONE) {
  //* Calculate size
  usz size = 4;
  self.entries.@each(; String key, BulkEntry entry) {
    size += 8;                // Length
    size += key.len + 1;      // String
    size += entry.value.len;  // Length of data
  };

  //* Save to file
  BulkFile file = file::new(size, comp);

  file.write_8(self.major);
  file.write_8(self.minor);
  file.write_8(self.patch);
  file.write_8((char)self.entries.len());

  self.entries.@each(; String key, BulkEntry entry) {
    file.write_64(entry.value.len);
    file.write_string(key);
    file.write_array(entry.value);
  };

  file.save(self.save_path());
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

  return self.path.concat(self.name);
}
<* Returns bulk version as string *>
fn String Bulk.version(&self) @export("bulk_version") {
  return string::format("%d.%d.%d", self.major, self.minor, self.patch, allocator: allocator::heap());
}

