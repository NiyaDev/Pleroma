
module settings;
import std::collections;


def Settings = HashMap(<String, SettingsOption>);
Settings data;

struct SettingsOption {
  typeid type;
  any val;
}

fault SettingsFault {
  ALREADY_EXISTS,
}

<**>
fn void! set_value(String name, any d) {
  if (data.has_key(name)) return SettingsFault.ALREADY_EXISTS?;

  SettingsOption op = {
    d.type,
    d,
  };

  data.set(name, op);
}
