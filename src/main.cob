000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. BLAKE-KARBON-PORTFOLIO.
000300 ENVIRONMENT DIVISION.
000400 CONFIGURATION SECTION.
000500 SOURCE-COMPUTER. UNIX-LINUX.
000600 OBJECT-COMPUTER. WASM.
000700 INPUT-OUTPUT SECTION.
000800 FILE-CONTROL.
000900 DATA DIVISION.
001000 FILE SECTION.
001100 WORKING-STORAGE SECTION.
001200 01 WS-NULL-BYTE PIC X(1) VALUE X'00'.
001300 01 WS-RETURN PIC S9.
001400 01 WS-COOKIE-ALLOWED PIC X.
001500 01 WS-LANG PIC XX.
001600 01 WS-COPYRIGHT.
001700   05 SYM PIC X(2) VALUE X"C2A9".
001800   05 TXT VALUE ' Blake Karbon. All rights reserved.'.
001900 LINKAGE SECTION.
002000 PROCEDURE DIVISION.
002100 EXAMPLE SECTION.
002200 ENTRY 'MAIN'.
002300   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
002400     'allowCookies' RETURNING WS-RETURN.
002500   IF WS-COOKIE-ALLOWED = 'y' THEN
002600     PERFORM LANG-CHECK
002700   ELSE
002800     PERFORM COOKIE-ASK
002900     MOVE 'en' TO WS-LANG
003000   END-IF.
003100   PERFORM BUILD-MENUBAR.
003200   CALL 'cobdom_create_element' USING 'contentDiv', 'div'
003300     RETURNING WS-RETURN.
003400   CALL 'cobdom_style' USING 'contentDiv', 'paddingTop', '1rem'
003500     RETURNING WS-RETURN.
003600   CALL 'cobdom_inner_html' USING 'contentDiv', 'Demo Content'
003700     RETURNING WS-RETURN.
003800   CALL 'cobdom_append_child' USING 'contentDiv', 'body'
003900     RETURNING WS-RETURN.
004000   CALL 'cobdom_create_element' USING 'copyrightDiv', 'div'
004100     RETURNING WS-RETURN.
004200   CALL 'cobdom_inner_html' USING 'copyrightDiv', WS-COPYRIGHT
004300     RETURNING WS-RETURN.
004400   CALL 'cobdom_append_child' USING 'copyrightDiv', 'body'
004500     RETURNING WS-RETURN.
004600 GOBACK.
004700 BUILD-MENUBAR.
004800   CALL 'cobdom_create_element' USING 'menuDiv', 'div'
004900     RETURNING WS-RETURN.
005000   CALL 'cobdom_style' USING 'menuDiv', 'position', 'fixed'
005100     RETURNING WS-RETURN.
005200   CALL 'cobdom_style' USING 'menuDiv', 'top', '0'
005300     RETURNING WS-RETURN.
005400   CALL 'cobdom_style' USING 'menuDiv', 'left', '0'
005500     RETURNING WS-RETURN.
005600   CALL 'cobdom_style' USING 'menuDiv', 'width', '100%'
005700     RETURNING WS-RETURN.
005800   CALL 'cobdom_style' USING 'menuDiv', 'backgroundColor',
005900     '#919191' RETURNING WS-RETURN.
006000   CALL 'cobdom_inner_html' USING 'menuDiv', 'Menu'
006100     RETURNING WS-RETURN.
006200   CALL 'cobdom_append_child' USING 'menuDiv', 'body'
006300     RETURNING WS-RETURN.
006400   CONTINUE.
006500 LANG-CHECK.
006600   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
006700     'lang' RETURNING WS-RETURN.
006800   IF WS-LANG = WS-NULL-BYTE THEN
006900     CALL 'cobdom_set_cookie' USING 'en', 'lang'
007000       RETURNING WS-RETURN
007100     MOVE 'em' TO WS-LANG
007200   END-IF.
007300   CONTINUE.
007400 COOKIE-ASK.
007500   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'
007600     RETURNING WS-RETURN.
007700   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'
007800     RETURNING WS-RETURN.
007900   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'
008000     RETURNING WS-RETURN.
008100   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'
008200     RETURNING WS-RETURN.
008300   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'
008400     RETURNING WS-RETURN.
008500   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
008600     '#00ff00' RETURNING WS-RETURN.
008700   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
008800     'center' RETURNING WS-RETURN.
008900   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
009000-'llow cookies to store your preferences such as language?&nbsp;'
009100     RETURNING WS-RETURN.
009200   CALL 'cobdom_create_element' USING 'cookieYes', 'span'
009300     RETURNING WS-RETURN.
009400   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'
009500     RETURNING WS-RETURN.
009600   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes&nbsp;'
009700     RETURNING WS-RETURN.
009800   CALL 'cobdom_create_element' USING 'cookieNo', 'span'
009900     RETURNING WS-RETURN.
010000   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'
010100     RETURNING WS-RETURN.
010200   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'
010300     RETURNING WS-RETURN.
010400   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
010500     'COOKIEACCEPT' RETURNING WS-RETURN.
010600   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
010700     'COOKIEDENY' RETURNING WS-RETURN.
010800   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'
010900     RETURNING WS-RETURN.
011000   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'
011100     RETURNING WS-RETURN.
011200   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'
011300     RETURNING WS-RETURN.
011400*Note this must be called after the elements are added to the
011500*document because it must search for them.
011600   CALL 'cobdom_class_style' USING 'cookieButton', 
011700     'backgroundColor', '#ff0000' RETURNING WS-RETURN.
011800   CONTINUE.
011900 COOKIEACCEPT SECTION.
012000 ENTRY 'COOKIEACCEPT'.
012100   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'
012200     RETURNING WS-RETURN.
012300   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' 
012400     RETURNING WS-RETURN.
012500   MOVE 'y' TO WS-COOKIE-ALLOWED.
012600   GOBACK.
012700 COOKIEDENY SECTION.
012800 ENTRY 'COOKIEDENY'.
012900   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'
013000     RETURNING WS-RETURN.
013100   MOVE 'n' TO WS-COOKIE-ALLOWED.
013200   GOBACK.
