
import std::io;
import pleroma::bulk;



fn void bulk_new() @test {
  Bulk new_bulk = bulk::new("TEST");
  defer new_bulk.free();

  //* Name and path
  assert(new_bulk.name == "TEST", "Name is incorrect");
  assert(new_bulk.path == "resources/", "Path is incorrect");

  String path = new_bulk.save_path();
  defer path.free(allocator::heap());
  assert(path == "resources/TEST", "Full path is incorrect");

  //* Version
  assert(new_bulk.major == bulk::MAJOR, "Major incorrect");
  assert(new_bulk.minor == bulk::MINOR, "Minor incorrect");
  assert(new_bulk.patch == bulk::PATCH, "Patch incorrect");

  String version = new_bulk.version();
  defer version.free(allocator::heap());
  assert(version == "1.1.0", "Version string incorrect");
}

fn void bulk_save() @test {
  Bulk new_bulk = bulk::new("Test");
  defer new_bulk.free();

  String test_str = "Testing this shit my duderino.";
  new_bulk.add("test", (char[])test_str);
  new_bulk.save();

  Bulk bulk_2 = bulk::load("resources/Test");
  defer bulk_2.free();

  char[] ent = bulk_2.get("test");
  assert(ent == test_str, "Loading failed");
  free(ent);
}

