
import settings;


fn void settings_add() @test {
  assert(settings::data.len() == 0, "Settings has members when nothing has been added.");

  int ival = 20;
  float fval = 1.268;
  String strval = "fug";

  settings::set_value("int", &ival)!;
  settings::set_value("float", &fval)!;
  settings::set_value("string", &strval)!;

  assert(*settings::get_value("int")! == 20, "Failed to get int value from settings.");
  assert(*settings::get_value("float")! == 1.268, "Failed to get float value from settings.");
  assert(*settings::get_value("int")! == "fug", "Failed to get string value from settings."); 
}
