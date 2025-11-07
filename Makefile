SRC_DIR := ./src
BUILD_DIR := ./build
COB_EXPORT_FLAGS = -K cobdom_add_event_listener -K cobdom_append_child -K cobdom_class_style -K cobdom_clear_interval -K cobdom_clear_timeout -K cobdom_create_element -K cobdom_eval -K cobdom_fetch -K cobdom_font_face -K cobdom_get_cookie -K cobdom_href -K cobdom_inner_html -K cobdom_remove_child -K cobdom_remove_event_listener -K cobdom_scroll_into_view -K cobdom_set_class -K cobdom_set_cookie -K cobdom_set_interval -K cobdom_set_timeout -K cobdom_src -K cobdom_string -K cobdom_style -K cobdom_test_string -K cobdom_open_tab
#These are all the functions your main program wants to call. Right now it is set to every function defined by CobDOMinate.

all: $(BUILD_DIR)/web/main.js $(BUILD_DIR)/web
	rm res/percent.txt
	@./percent.sh
	#cp $(SRC_DIR)/index.html $(BUILD_DIR)/web/index.html

$(BUILD_DIR):
	mkdir -p $(BUILD_DIR)

$(BUILD_DIR)/web: $(BUILD_DIR)
	mkdir -p $(BUILD_DIR)/web

$(BUILD_DIR)/main.c: $(BUILD_DIR)
	cobc -C -o $@ $(SRC_DIR)/main.cob $(COB_EXPORT_FLAGS) -K COOKIEACCEPT -K COOKIEDENY -K SETPERCENTCOBOL -K SETLANG -K SETLANGUS -K SETLANGES -K WINDOWCHANGE -K SHAPEPAGE -K FONTLOADED -K MENUTOGGLE -K LOADENAM -K LOADESAM -K LOADENCOBA -K LOADENCOBB -K LOADESCOBA -K LOADESCOBB -K NAVABOUT -K NAVCONTACT -K NAVPROJECTS -K NAVCOBOL -K OPENCOBOLSOURCE -K OPENGH -K OPENLI -K OPENYT -K OPENTT -K OPENIG -K UPDATETEXT

$(BUILD_DIR)/web/main.js: $(BUILD_DIR)/main.c $(BUILD_DIR)/web
	emcc -o $@ $< -lgmp -lcob -lcobdom -s EXPORTED_FUNCTIONS=_malloc,_free,_cob_init,_MAIN,_COOKIEACCEPT,_COOKIEDENY,_SETPERCENTCOBOL,_SETLANG,_SETLANGUS,_SETLANGES,_WINDOWCHANGE,_SHAPEPAGE,_FONTLOADED,_MENUTOGGLE,_LOADENAM,_LOADESAM,_LOADENCOBA,_LOADENCOBB,_LOADESCOBA,_LOADESCOBB,_NAVABOUT,_NAVCONTACT,_NAVPROJECTS,_NAVCOBOL,_OPENCOBOLSOURCE,_OPENGH,_OPENLI,_OPENYT,_OPENTT,_OPENIG,_UPDATETEXT -s EXPORTED_RUNTIME_METHODS=ccall,cwrap,HEAP8 -Wno-deprecated-non-prototype

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all clean
