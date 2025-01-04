
module bulk;
import std::collections;


const char MAJOR = 1;
const char MINOR = 0;
const char PATCH = 0;


<* Core structure of Bulk *>
struct Bulk {
  String name;
  String path;

  char major, minor, patch;

  HashMap(<String, BulkValue>) entries;
}

<* Value storage *>
struct BulkValue {
  any value;
}

<* Bulk faults *>
fault BulkFault {
  PATH_NAME_EMPTY,
  PATH_PATH_EMPTY,

  FILE_NOT_FOUND,
  FILE_ZERO_LENGTH,
  FILE_FAILED_BUFFER,
  FILE_CANNOT_WRITE,
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
  //* Read version
  //output.major = 
  
  return output;
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
