#! /bin/bash

clear

c3c build -l raylib -q

cp build/libpleroma.a pleroma.c3l/linux-x64/libpleroma.a
cp src/raylib/raylib.c3 pleroma.c3l/raylib_raw.c3


