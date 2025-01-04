
import std::io;
import bulk;



fn void bulk_new() @test {
  Bulk* new_bulk = bulk::new("TEST")!!;
  defer new_bulk.free()!!;

  //* Name and path
  assert(new_bulk.name == "TEST", "");
  assert(new_bulk.path == "resources/");
  assert(new_bulk.save_path()!! == "resources/TEST.bulk");
  //* Version
  assert(new_bulk.major == bulk::MAJOR);
  assert(new_bulk.minor == bulk::MINOR);
  assert(new_bulk.patch == bulk::PATCH);
  assert(new_bulk.version() == "1.0.0");
}

fn void file_new() @test {
  BulkFile* new = bulk::new_file()!!;

  assert(new != null, "Returned null");
  assert(new.compression == NONE, "Inited wrong compression");
  assert(new.head == 0, "Head inited wrong");
  assert(new.data.len == 1, "Array defauled wrong");

  new.free()!;
  
  new = bulk::new_file(192)!!;
  
  assert(new.data.len == 192, "Array length wrong");

  new.write_8(1);
  new.write_16(2);
  new.write_32(3);
  new.write_64(4);
  new.write_float(0.5);
  new.write_array({10,11,12,13,14});

  new.head = 0;
  assert(new.read_8() == 1, "read_8");
  assert(new.read_16() == 2, "read_16");
  assert(new.read_32() == 3, "read_32");
  assert(new.read_64() == 4, "read_64");
  assert(new.read_float() == 0.5, "read_float");
  assert(new.read_array(5) == {10,11,12,13,14}, "read_array");

  new.free()!;
}

fn void file_writing() @test {
  
}
