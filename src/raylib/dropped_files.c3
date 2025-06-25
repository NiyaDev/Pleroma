
module pleroma::raylib;
import std::collections;



struct FilePathListRL {
  uint capacity, count;
  char** paths;
}

alias FilePathList = List{String};
faultdef NOTHING_DROPPED;

<* Wrapper for raylib::load_dropped_files() *>
fn FilePathList load_dropped_dir() @export("fpl_load") {
  FilePathListRL fpl = load_dropped_files();
  FilePathList output;

  for (int i; i < fpl.count; i++) {
    usz str_len;
    for (int j; fpl.paths[i][j] != '\0'; j++) str_len++;

    String str = (String)mem::new_array(char, str_len);
    mem::copy((char*)str, fpl.paths[i], str_len);

    output.push(str);
  }
  unload_dropped_files(fpl);

  return output;
}
<* Both checks for dropped file and loads it *>
fn FilePathList? check_for_drop() @export("fpl_check") {
  if (is_file_dropped()) {
    return load_dropped_dir();
  }
  return NOTHING_DROPPED?;
}
<* Cleans up FilePathList *>
fn void FilePathList.clean(&self) @export("fpl_clean") {
  for (int i; i < self.len(); i++) {
    free(self.get(i));
  }
  self.free();
}

extern fn bool is_file_dropped() @extern("IsFileDropped");
extern fn FilePathListRL load_dropped_files() @extern("LoadDroppedFiles");
extern fn void unload_dropped_files(FilePathListRL) @extern("UnloadDroppedFiles");

