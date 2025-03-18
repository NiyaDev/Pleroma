
module pleroma::localization;
import std::collections;


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

<* Converts a language to string *>
fn String Language.to_string(self) {
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
fn Language String.to_language(self) {
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


def Localization = HashMap(<String, String>);

<* Create new localiztion struct *>
fn Localization new() @export("local_new") {
  Localization output;
  output.new_init();
  return output;
}
<* Add string to localization *>
fn void Localization.add(&self, Language lang, String str) @export("local_add") {
  self.set(lang.to_string(), str);
}

