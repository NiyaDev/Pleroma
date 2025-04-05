
module pleroma::options;
import std::collections;


alias Options = HashMap{String, Option};

struct Option {
  OptionType type;
  union {
    short as_short;
    int as_int;
    long as_long;
    float as_float;
    double as_double;
    int[] as_array;
  }
}

enum OptionType {
  SHORT,
  INT,
  LONG,
  FLOAT,
  DOUBLE,
  ARRAY,
}

faultdef INVALID_ENTRY;

<* Creates an option *>
fn Option? new(any value) {
  Option output;
  switch (value.type) {
    case short:
      output.type = SHORT;
      output.as_short = *(short*)value;
    case int:
      output.type = INT;
      output.as_int = *(int*)value;
    case long:
      output.type = LONG;
      output.as_long = *(long*)value;
    case float:
      output.type = FLOAT;
      output.as_float = *(float*)value;
    case double:
      output.type = DOUBLE;
      output.as_double = *(double*)value;
    case int[]:
      output.type = ARRAY;
      output.as_array = *(int[]*)value;
    default: return INVALID_ENTRY?;
  }
  return output;
}
