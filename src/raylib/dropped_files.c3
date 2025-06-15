
module pleroma::raylib;
import std::collections;



struct FilePathListRL {
  uint capacity, count;
  char** paths;
}

alias FilePathList = List{String};

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

  return output;
}
<* Cleans up FilePathList *>
fn void FilePathList.clean(&self) {
  for (int i; i < self.len(); i++) {
    free(self.get(i));
  }
  self.free();
}

extern fn bool is_file_dropped() @extern("IsFileDropped");
extern fn FilePathListRL load_dropped_files() @extern("LoadDroppedFiles");

