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
002000 01 WS-SVG-US PIC X(650).
002100 01 WS-SVG-ES PIC X(82149).
002200 LINKAGE SECTION.
002300 01 LS-BLOB PIC X(100000).
002400 01 LS-BLOB-SIZE PIC 9(10).
002500 PROCEDURE DIVISION.
002600 EXAMPLE SECTION.
002700 ENTRY 'MAIN'.
002800   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
002900     'allowCookies' RETURNING WS-RETURN.
003000   IF WS-COOKIE-ALLOWED = 'y' THEN
003100     PERFORM LANG-CHECK
003200   ELSE
003300     PERFORM COOKIE-ASK
003400     MOVE 'us' TO WS-LANG
003500   END-IF.
003600   CALL 'cobdom_create_element' USING 'percentCobol', 'span'
003700     RETURNING WS-RETURN.
003800   CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
003900     '/res/percent.txt', 'GET', WS-NULL-BYTE RETURNING WS-RETURN.
004000   PERFORM BUILD-MENUBAR.
004100   CALL 'cobdom_style' USING 'body', 'fontSize', '4rem'
004200     RETURNING WS-RETURN.
004300   CALL 'cobdom_create_element' USING 'contentDiv', 'div'
004400     RETURNING WS-RETURN.
004500   CALL 'cobdom_style' USING 'contentDiv', 'paddingTop', '4rem'
004600     RETURNING WS-RETURN.
004700*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
004800*    RETURNING WS-RETURN.
004900   CALL 'cobdom_append_child' USING 'contentDiv', 'body'
005000     RETURNING WS-RETURN.
005100   CALL 'cobdom_create_element' USING 'copyrightDiv', 'div'
005200     RETURNING WS-RETURN.
005300   CALL 'cobdom_inner_html' USING 'copyrightDiv', WS-COPYRIGHT
005400     RETURNING WS-RETURN.
005500   CALL 'cobdom_append_child' USING 'copyrightDiv', 'body'
005600     RETURNING WS-RETURN.
005700 GOBACK.
005800 BUILD-MENUBAR.
005900   CALL 'cobdom_create_element' USING 'menuDiv', 'div'
006000     RETURNING WS-RETURN.
006100   CALL 'cobdom_style' USING 'menuDiv', 'position', 'fixed'
006200     RETURNING WS-RETURN.
006300   CALL 'cobdom_style' USING 'menuDiv', 'top', '0'
006400     RETURNING WS-RETURN.
006500   CALL 'cobdom_style' USING 'menuDiv', 'left', '0'
006600     RETURNING WS-RETURN.
006700   CALL 'cobdom_style' USING 'menuDiv', 'width', '100%'
006800     RETURNING WS-RETURN.
006900   CALL 'cobdom_style' USING 'menuDiv', 'backgroundColor',
007000     '#919191' RETURNING WS-RETURN.
007100   CALL 'cobdom_inner_html' USING 'menuDiv', 'Menu'
007200     RETURNING WS-RETURN.
007300   CALL 'cobdom_append_child' USING 'menuDiv', 'body'
007400     RETURNING WS-RETURN.
007500*Setup language selector
007600   CALL 'cobdom_create_element' USING 'langSelector', 'div'
007700     RETURNING WS-RETURN.
007800   CALL 'cobdom_create_element' USING 'langUS', 'img'
007900     RETURNING WS-RETURN.
008000   CALL 'cobdom_create_element' USING 'langES', 'img'
008100     RETURNING WS-RETURN.
008200   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'
008300     RETURNING WS-RETURN.
008400   CALL 'cobdom_style' USING 'langUS', 'width', '2rem'
008500     RETURNING WS-RETURN.
008600   CALL 'cobdom_style' USING 'langUS', 'height', '2rem'
008700     RETURNING WS-RETURN. 
008800   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'
008900     RETURNING WS-RETURN.
009000   CALL 'cobdom_style' USING 'langES', 'width', '2rem'
009100     RETURNING WS-RETURN.
009200   CALL 'cobdom_style' USING 'langES', 'height', '2rem'
009300     RETURNING WS-RETURN. 
009400*  CALL 'cobdom_fetch' USING 'LOADSVGUS',
009500*    '/res/icons/us.svg', 'GET', WS-NULL-BYTE
009600*     RETURNING WS-RETURN.
009700*  CALL 'cobdom_fetch' USING 'LOADSVGES',
009800*    '/res/icons/es.svg', 'GET', WS-NULL-BYTE
009900*    RETURNING WS-RETURN.
010000   CALL 'cobdom_append_child' USING 'langUS', 'langSelector'
010100     RETURNING WS-RETURN.
010200   CALL 'cobdom_append_child' USING 'langES', 'langSelector'
010300     RETURNING WS-RETURN.
010400   CALL 'cobdom_append_child' USING 'langSelector', 'menuDiv'
010500     RETURNING WS-RETURN.
010600   CONTINUE.
010700 LANG-CHECK.
010800   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
010900     'lang' RETURNING WS-RETURN.
011000   IF WS-LANG = WS-NULL-BYTE THEN
011100     CALL 'cobdom_set_cookie' USING 'us', 'lang'
011200       RETURNING WS-RETURN
011300     MOVE 'em' TO WS-LANG
011400   END-IF.
011500   CONTINUE.
011600 COOKIE-ASK.
011700   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'
011800     RETURNING WS-RETURN.
011900   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'
012000     RETURNING WS-RETURN.
012100   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'
012200     RETURNING WS-RETURN.
012300   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'
012400     RETURNING WS-RETURN.
012500   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'
012600     RETURNING WS-RETURN.
012700   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
012800     '#00ff00' RETURNING WS-RETURN.
012900   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
013000     'center' RETURNING WS-RETURN.
013100   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
013200-'llow cookies to store your preferences such as language?&nbsp;'
013300     RETURNING WS-RETURN.
013400   CALL 'cobdom_create_element' USING 'cookieYes', 'span'
013500     RETURNING WS-RETURN.
013600   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'
013700     RETURNING WS-RETURN.
013800   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes&nbsp;'
013900     RETURNING WS-RETURN.
014000   CALL 'cobdom_create_element' USING 'cookieNo', 'span'
014100     RETURNING WS-RETURN.
014200   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'
014300     RETURNING WS-RETURN.
014400   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'
014500     RETURNING WS-RETURN.
014600   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
014700     'COOKIEACCEPT' RETURNING WS-RETURN.
014800   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
014900     'COOKIEDENY' RETURNING WS-RETURN.
015000   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'
015100     RETURNING WS-RETURN.
015200   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'
015300     RETURNING WS-RETURN.
015400   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'
015500     RETURNING WS-RETURN.
015600*Note this must be called after the elements are added to the
015700*document because it must search for them.
015800   CALL 'cobdom_class_style' USING 'cookieButton', 
015900     'backgroundColor', '#ff0000' RETURNING WS-RETURN.
016000   CONTINUE.
016100 COOKIEACCEPT SECTION.
016200 ENTRY 'COOKIEACCEPT'.
016300   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'
016400     RETURNING WS-RETURN.
016500   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' 
016600     RETURNING WS-RETURN.
016700   MOVE 'y' TO WS-COOKIE-ALLOWED.
016800   GOBACK.
016900 COOKIEDENY SECTION.
017000 ENTRY 'COOKIEDENY'.
017100   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'
017200     RETURNING WS-RETURN.
017300   MOVE 'n' TO WS-COOKIE-ALLOWED.
017400   GOBACK.
017500 SETPERCENTCOBOL SECTION.
017600 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
017700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
017800   CALL 'cobdom_inner_html' USING 'percentCobol', WS-PERCENT-COBOL
017900     RETURNING WS-RETURN.
018000   DISPLAY 'Currently this website is written in ' 
018100     WS-PERCENT-COBOL '% COBOL.'.
018200   GOBACK.
018300*LOADSVGUS SECTION.
018400*ENTRY 'LOADSVGUS' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
018500*  MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-SVG-US.
018600*  CALL 'cobdom_inner_html' USING 'langUS', WS-SVG-US
018700*    RETURNING WS-RETURN.
018800*  CALL 'cobdom_style' USING 'langUS', 'width', '20px'
018900*    RETURNING WS-RETURN.
019000*  CALL 'cobdom_style' USING 'langUS', 'height', '20px'
019100*    RETURNING WS-RETURN.
019200*  GOBACK.
019300*LOADSVGES SECTION.
019400*ENTRY 'LOADSVGES' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
019500*  MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-SVG-ES.
019600*  CALL 'cobdom_inner_html' USING 'langES', WS-SVG-ES
019700*    RETURNING WS-RETURN.
019800*  CALL 'cobdom_style' USING 'langES', 'width', '20px'
019900*    RETURNING WS-RETURN.
020000*  CALL 'cobdom_style' USING 'langES', 'height', '20px'
020100*    RETURNING WS-RETURN. 
020200*  GOBACK.
