
import yaml;

fn void yaml_test() @test {
  Yaml* yml = yaml::load("yaml.c3l/tests/test.yml")!!;
  assert(yml != null, "Loading failed");
}
