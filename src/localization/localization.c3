
module pleroma::localization;
import std::collections;
import pleroma::yaml;


enum Language {
  ENGLISH,
  FRENCH,
  GERMAN,
  SPANISH,
  POLISH,
  CHINESE_T,
  CHINESE_S,
  ARABIC,
  JAPANESE,
}

alias Local = HashMap{Language, String};
alias Localization = HashMap{String, Local};


<* Go through each member of a TypedValue object and copy into a Local *>
fn Local new(TypedValue obj) @export("local_new") {
  assert(obj.type == OBJECT, "Tried to convert a non-object to a localization.");

  Local local;

  yaml::Object o = *((yaml::Object*)obj.value);
  o.@each(; String key, TypedValue val) {
    assert(val.type == STRING, "Localization isn't string.");

    local.set(key.to_language(), val.v_string);
  };

  return local;
}

<* Convert the data in a Yaml file to a localization map *>
fn Localization Yaml.localization(&self) @export("local_localization") {
  Localization localization;

  self.@each(; String key, TypedValue val) {
    Local local = new(val);
    localization.set(key, local);
  };

  return localization;
}

<* Add all yaml data into alrerady existing localization *>
fn void Localization.add(&self, Yaml yaml) @export("local_add") {
  yaml.@each(; String key, TypedValue val) {
    Local local = new(val);
    self.set(key, local);
  };
}

<* Converts a language to a string *>
fn String Language.to_string(self) @export("local_tostring") {
  switch (self) {
    case ENGLISH:   return "English";
    case FRENCH:    return "French";
    case GERMAN:    return "German";
    case SPANISH:   return "Spanish";
    case POLISH:    return "Polish";
    case CHINESE_T: return "Traditional Chinese";
    case CHINESE_S: return "Simplified Chinese";
    case ARABIC:    return "Arabic";
    case JAPANESE:  return "Japanese";
  }
}
<* Converts a string to language *>
fn Language String.to_language(self) @export("local_tolanguage") {
  switch (self) {
    case "English":   return ENGLISH;
    case "French":    return FRENCH;
    case "German":    return GERMAN;
    case "Spanish":   return SPANISH;
    case "Polish":    return POLISH;
    case "Traditional Chinese": return CHINESE_T;
    case "Simplified Chinese": return CHINESE_S;
    case "Arabic":    return ARABIC;
    case "Japanese":  return JAPANESE;
  }
  return ENGLISH;
}
<**>
fn uint Language.hash(&self) @export("local_hash") {
  return self.to_string().hash();
}
