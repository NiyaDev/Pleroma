
module pleroma::options;
import std::io;
import std::collections;
import pleroma::logos;


alias Options = HashMap{String, Option};
alias Option = LogosData;

<* Creates Options map from char array *>
fn Options load(char[] data) @export("options_load") {
  Logos file = data.to_logos();
  
  Options output;

  long number_of_entries = file.read(LONG).as_long;
  for (int i; i < number_of_entries; i++) {
    Option opt;

    LogosData key = file.read(STRING);
    defer key.free();
    opt.type = LogosType.from_ordinal(file.read(CHAR).as_char);
    
    LogosData dat = file.read(opt.type);

    output.set(key.as_string, dat);
  }
  return output;
}
<* Saves Options map to a char array *>
fn char[] Options.save(&self) @export("options_save") {
  Logos file = logos::new();

  file.write({.type=LONG,.as_long=(long)self.len()});

  self.@each(; String key, Option opt) {
    file.write({.type=STRING,.as_string=key});
    file.write({.type=CHAR,.as_char=opt.type.ordinal});
    file.write(opt);
  };
  
  return file.data;
}
<* Frees all data in options *>
fn void Options.clean(&self) {
  self.@each(; String key, Option opt) {
    opt.free();
  };
  self.free();
}

