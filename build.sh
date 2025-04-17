#! /bin/bash

clear

c3c build

cp build/libpleroma.a pleroma.c3l/linux-x64/libpleroma.a
#cp build/libpleroma.so pleroma.c3l/linux-x64/libpleroma.so
cp src/raylib/raylib.c3 pleroma.c3l/raylib_raw.c3


