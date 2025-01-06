
module bulk;
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

<* Value storage *>
struct BulkEntry {
  char[] value;
}

<* Bulk faults *>
fault BulkFault {
  PATH_NAME_EMPTY,
  PATH_PATH_EMPTY,

  FILE_NOT_FOUND,
  FILE_ZERO_LENGTH,
  FILE_FAILED_BUFFER,
  FILE_CANNOT_WRITE,

  BULK_OVERWRITE,
}


<* Creates new Bulk
  @param name "Name of file"
  @return "Pointer to bulk"
 *>
fn Bulk*! new(String name) {
  Bulk* output = mem::new(Bulk);
  *output = {
    .name = name.copy(),
    .path = "resources/",
    .major = MAJOR,
    .minor = MINOR,
    .patch = PATCH,
  };
  output.entries.new_init();

  return output;
}
<* Frees Bulk data
  @return "Error freeing data"
 *>
fn void! Bulk.free(&self) {
  self.name.free();

  // TODO: Free up data inside HashMap
  self.entries.free();

  mem::free(self);
}
<* Load builk from file
  @param filename "Name of bulk to load"
  @return "Loaded bulk"
 *>
fn Bulk*! load(String filename) {
  //* Grab name of file
  String[] path_split = filename.split("/");
  String name = path_split[0].trim(".bulk");
  
  //* Create Bulk
  Bulk* output = new(name)!;

  //* Create file
  BulkFile* file = load_file(filename)!!;

  //* Read version
  output.major = file.read_8();
  output.minor = file.read_8();
  output.patch = file.read_8();

  switch (true) {
    case output.major == 1:
      //* Get number of entries
      char number_of_entries = file.read_8();
      usz offset = 4;

      //* Load each entry from file
      for (int i; i < number_of_entries; i++) {
        usz data_len = file.read_64();
        String entry_name = file.read_string();

        //* Create entry
        BulkEntry entry = {file.read_array(data_len)};
        output.entries.set(entry_name, entry);
      }
  }
  file.free()!!;
  
  return output;
}
<* Saves Bulk to file *>
fn void! Bulk.save(&self, Compression compression = NONE) {
  switch (true) {
    case self.major == 1:
      //* Calculate size
      usz size = 4;
      self.entries.@each(; String key, BulkEntry entry) {
        size += 8; // Length
        size += key.len + 1; // String length
        size += entry.value.len; // Length of data
      };

      //* Save to file
      BulkFile* file = new_file(size, compression)!!;

      file.write_8(self.major);
      file.write_8(self.minor);
      file.write_8(self.patch);
      file.write_8((char)self.entries.len());

      self.entries.@each(; String key, BulkEntry entry) {
        file.write_64(entry.value.len); //Length of data
        file.write_string(key);
        file.write_array(entry.value);
      };

      file.save(self.save_path())!!;
      file.free()!!;
  }
}
<* Inserting a base value *>
fn void! Bulk.add(&self, String name, char[] data) {
  if (self.entries.has_key(name)) {
    io::printf("ERROR - Attempted to overwrite entry");
    return BulkFault.BULK_OVERWRITE?;
  }

  self.entries.set(name, {data});
}

<* Returns full path that bulk will be saved as
  @return "File path as a string"
 *>
fn String! Bulk.save_path(&self) {
  if (self.name == "") return BulkFault.PATH_NAME_EMPTY?;
  if (self.path == "") return BulkFault.PATH_PATH_EMPTY?;

  return self.path.concat(self.name).concat(".bulk");
}
<* Returns Version as a string
  @return "Version number as string"
 *>
fn String Bulk.version(&self) {
  return string::tformat("%d.%d.%d", self.major, self.minor, self.patch);
}
