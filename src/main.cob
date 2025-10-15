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
001900 01 WS-PERCENT-COBOL PIC X(5).
002000 LINKAGE SECTION.
002100 01 LS-BLOB PIC X(10000).
002200 01 LS-BLOB-SIZE PIC 9(10).
002300 PROCEDURE DIVISION.
002400 EXAMPLE SECTION.
002500 ENTRY 'MAIN'.
002600   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
002700     'allowCookies' RETURNING WS-RETURN.
002800   IF WS-COOKIE-ALLOWED = 'y' THEN
002900     PERFORM LANG-CHECK
003000   ELSE
003100     PERFORM COOKIE-ASK
003200     MOVE 'en' TO WS-LANG
003300   END-IF.
003400   CALL 'cobdom_create_element' USING 'percentCobol', 'span'
003500     RETURNING WS-RETURN.
003600   CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
003700     '/res/percent.txt', 'GET', WS-NULL-BYTE, RETURNING WS-RETURN.
003800   PERFORM BUILD-MENUBAR.
003900   CALL 'cobdom_style' USING 'body', 'fontSize', '4rem'
004000     RETURNING WS-RETURN.
004100   CALL 'cobdom_create_element' USING 'contentDiv', 'div'
004200     RETURNING WS-RETURN.
004300   CALL 'cobdom_style' USING 'contentDiv', 'paddingTop', '4rem'
004400     RETURNING WS-RETURN.
004500*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
004600*    RETURNING WS-RETURN.
004700   CALL 'cobdom_append_child' USING 'contentDiv', 'body'
004800     RETURNING WS-RETURN.
004900   CALL 'cobdom_create_element' USING 'copyrightDiv', 'div'
005000     RETURNING WS-RETURN.
005100   CALL 'cobdom_inner_html' USING 'copyrightDiv', WS-COPYRIGHT
005200     RETURNING WS-RETURN.
005300   CALL 'cobdom_append_child' USING 'copyrightDiv', 'body'
005400     RETURNING WS-RETURN.
005500 GOBACK.
005600 BUILD-MENUBAR.
005700   CALL 'cobdom_create_element' USING 'menuDiv', 'div'
005800     RETURNING WS-RETURN.
005900   CALL 'cobdom_style' USING 'menuDiv', 'position', 'fixed'
006000     RETURNING WS-RETURN.
006100   CALL 'cobdom_style' USING 'menuDiv', 'top', '0'
006200     RETURNING WS-RETURN.
006300   CALL 'cobdom_style' USING 'menuDiv', 'left', '0'
006400     RETURNING WS-RETURN.
006500   CALL 'cobdom_style' USING 'menuDiv', 'width', '100%'
006600     RETURNING WS-RETURN.
006700   CALL 'cobdom_style' USING 'menuDiv', 'backgroundColor',
006800     '#919191' RETURNING WS-RETURN.
006900   CALL 'cobdom_inner_html' USING 'menuDiv', 'Menu'
007000     RETURNING WS-RETURN.
007100   CALL 'cobdom_append_child' USING 'menuDiv', 'body'
007200     RETURNING WS-RETURN.
007300   CONTINUE.
007400 LANG-CHECK.
007500   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
007600     'lang' RETURNING WS-RETURN.
007700   IF WS-LANG = WS-NULL-BYTE THEN
007800     CALL 'cobdom_set_cookie' USING 'en', 'lang'
007900       RETURNING WS-RETURN
008000     MOVE 'em' TO WS-LANG
008100   END-IF.
008200   CONTINUE.
008300 COOKIE-ASK.
008400   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'
008500     RETURNING WS-RETURN.
008600   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'
008700     RETURNING WS-RETURN.
008800   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'
008900     RETURNING WS-RETURN.
009000   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'
009100     RETURNING WS-RETURN.
009200   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'
009300     RETURNING WS-RETURN.
009400   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
009500     '#00ff00' RETURNING WS-RETURN.
009600   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
009700     'center' RETURNING WS-RETURN.
009800   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
009900-'llow cookies to store your preferences such as language?&nbsp;'
010000     RETURNING WS-RETURN.
010100   CALL 'cobdom_create_element' USING 'cookieYes', 'span'
010200     RETURNING WS-RETURN.
010300   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'
010400     RETURNING WS-RETURN.
010500   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes&nbsp;'
010600     RETURNING WS-RETURN.
010700   CALL 'cobdom_create_element' USING 'cookieNo', 'span'
010800     RETURNING WS-RETURN.
010900   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'
011000     RETURNING WS-RETURN.
011100   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'
011200     RETURNING WS-RETURN.
011300   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
011400     'COOKIEACCEPT' RETURNING WS-RETURN.
011500   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
011600     'COOKIEDENY' RETURNING WS-RETURN.
011700   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'
011800     RETURNING WS-RETURN.
011900   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'
012000     RETURNING WS-RETURN.
012100   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'
012200     RETURNING WS-RETURN.
012300*Note this must be called after the elements are added to the
012400*document because it must search for them.
012500   CALL 'cobdom_class_style' USING 'cookieButton', 
012600     'backgroundColor', '#ff0000' RETURNING WS-RETURN.
012700   CONTINUE.
012800 COOKIEACCEPT SECTION.
012900 ENTRY 'COOKIEACCEPT'.
013000   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'
013100     RETURNING WS-RETURN.
013200   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' 
013300     RETURNING WS-RETURN.
013400   MOVE 'y' TO WS-COOKIE-ALLOWED.
013500   GOBACK.
013600 COOKIEDENY SECTION.
013700 ENTRY 'COOKIEDENY'.
013800   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'
013900     RETURNING WS-RETURN.
014000   MOVE 'n' TO WS-COOKIE-ALLOWED.
014100   GOBACK.
014200 SETPERCENTCOBOL SECTION.
014300 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
014400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
014500   CALL 'cobdom_inner_html' USING 'percentCobol', WS-PERCENT-COBOL
014600     RETURNING WS-RETURN.
014700   DISPLAY 'Currently this website is written in ' 
014800     WS-PERCENT-COBOL '% COBOL.'.
014900   GOBACK.
