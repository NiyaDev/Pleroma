
module yaml;
import std::io;
import std::collections;


struct Yaml {
  String version;
  Collection data;
}
enum DataType {
  STRING,
  INT,
  FLOAT,
  BOOL,
  OBJECT,
  COLLECTION
}
struct Data {
  DataType type;
  union {
    String str;
    int i;
    float f;
    bool b;
    Object* obj;
    Collection* col;
  }
}

struct Object {
  HashMap(<String, Data>) data;
}
struct Collection {
  Data[] data;
}

fault YamlFault {
  FILE_NOT_FOUND,
}


<*  *>
fn Yaml*! load(String filename) {
  File! file = file::open(filename, "r");
  if (catch file) {
    io::printfn("Failed to open file [%s]", filename);
    return YamlFault.FILE_NOT_FOUND?;
  }

  char[] data = mem::new_array(char, file::get_size(filename))!!;
  file.read(data)!!;
  //io::printfn("\n%s",(String)data);

  Yaml* output = mem::new(Yaml);
  
  String[] lines = ((String)data).tsplit("\n");

  //* Version
  String[] firstline = lines[0].tsplit(" ");
  output.version = firstline[1];
  free(firstline);

  io::printfn("Ver: %s",output.version);
  //output.version = 

  return null;
}

