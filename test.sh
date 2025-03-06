#! /bin/bash

clear

c3c compile-test bulk.c3l/*.c3 bulk.c3l/tests/*.c3 \
  keybind.c3l/*.c3 keybind.c3l/tests/*.c3 \
  raylib.c3l/*.c3 raylib.c3l/tests/*.c3 \
  yaml.c3l/*.c3 yaml.c3l/tests/*.c3 \
  localization.c3l/*.c3 localization.c3l/tests/*.c3 \
  settings.c3l/*.c3 settings.c3l/tests/*c3 \
  -l raylib
