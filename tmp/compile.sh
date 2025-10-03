#!/bin/bash
cobc -x -C mainprog.cob -K SUBPROG
cobc -C subprog.cob
find . -type f -name '*.c' -exec sed -i '/module->module_cancel\.funcptr =/ s/^/\/\//' {} +
#emcc -g \
#  -s ASSERTIONS=2 \
#  -s EXPORTED_FUNCTIONS="['_SUBPROG', '_cob_stop_run', '_cob_init']" \
#  -s STANDALONE_WASM=1 \
#  -o prog.js mainprog.c subprog.c -lgmp -lcob -s STANDALONE_WASM=1
emcc -o prog.js mainprog.c subprog.c -lgmp -lcob -s STANDALONE_WASM=1
#emcc -O0 -g4 -o prog.html mainprog.c subprog.c -lgmp -lcob
#emcc -o prog.html mainprog.c subprog.c -lgmp -lcob
#emcc -o prog.js mainprog.c subprog.c -lgmp -lcob -s STANDALONE_WASM=1 -Wbad-function-cast -Wcast-function-type
#emcc -o prog.js mainprog.c subprog.c -lgmp -lcob -s STANDALONE_WASM=1 -Wbad-function-cast -Wcast-function-type -s WASM=1 -g4 -s ASSERTIONS=2 -s SAFE_HEAP=1 -s STACK_OVERFLOW_CHECK=1
#emcc -o prog.js mainprog.c subprog.c -lgmp -lcob \
#  -s EXPORTED_FUNCTIONS='["_main", "_SUBPROG"]' \
#  -s LINKABLE=1 -s EXPORT_ALL=1
node prog.js
