000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. EXAMPLE-WEBSITE.
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
001600 01 WS-PERCENT-COBOL PIC X(5).
001700 01 WS-SVG-US PIC X(650).
001800 01 WS-SVG-ES PIC X(82149).
001900 01 WS-LANG-SELECT-TOGGLE PIC 9 VALUE 0.
002000 01 WS-WINDOW.
002100   05 WIDTH PIC 9(5).
002200   05 HEIGHT PIC 9(5).
002300 01 WS-TMP.
002400   05 CENTISECS PIC 9999.
002500   05 PX.
002600     10 NUM PIC -(4)9.
002700     10 TAIL PIC XX VALUE 'px'.
002800     10 NB PIC X(1) VALUE X'00'.
002900 01 WS-BLOB PIC X(100000).
003000 01 WS-BLOB-SIZE PIC 9(10).
003100*This has to be pic 10 as that is what is returned from
003200*the library.
003300 LINKAGE SECTION.
003400 01 LS-BLOB PIC X(100000).
003500 01 LS-BLOB-SIZE PIC 9(10).
003600 01 LS-LANG-CHOICE PIC XX.
003700 PROCEDURE DIVISION.
003800 MAIN SECTION.
003900 ENTRY 'MAIN'.
004000   CALL 'cobdom_style' USING 'body', 'margin', '0'.
004100   CALL 'cobdom_style' USING 'body', 'fontSize', '4rem'.
004200*  CALL 'cobdom_style' USING 'body', 'display', 'flex'.
004300*  CALL 'cobdom_style' USING 'body', 'alignItems', 'center'.
004400*  CALL 'cobdom_style' USING 'body', 'justifyContent', 'center'.
004500   CALL 'cobdom_add_event_listener' USING 'window', 'resize', 
004600     'WINDOWCHANGE'.
004700   CALL 'cobdom_add_event_listener' USING 'window', 
004800     'orientationchange', 'WINDOWCHANGE'.
004900   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
005000     'allowCookies'.
005100   CALL 'cobdom_create_element' USING 'percentCobol', 'span'.
005200   CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
005300     '/res/percent.txt', 'GET', WS-NULL-BYTE.
005400*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
005500*Build page structure
005600   PERFORM BUILD-MENUBAR.
005700*Check for cookies
005800   IF WS-COOKIE-ALLOWED = 'y' THEN
005900     PERFORM LANG-CHECK
006000   ELSE
006100     PERFORM COOKIE-ASK
006200     MOVE 'us' TO WS-LANG
006300     PERFORM SET-ACTIVE-FLAG
006400   END-IF.
006500*Render
006600   CALL 'SHAPEPAGE'.
006700   GOBACK.
006800 BUILD-MENUBAR.
006900   CALL 'cobdom_create_element' USING 'menuDiv', 'div'.
007000   CALL 'cobdom_style' USING 'menuDiv', 'position', 'fixed'.
007100   CALL 'cobdom_style' USING 'menuDiv', 'display', 'flex'.
007200   CALL 'cobdom_style' USING 'menuDiv', 'justifyContent', 
007300     'space-between'.
007400   CALL 'cobdom_style' USING 'menuDiv', 'top', '0'.
007500   CALL 'cobdom_style' USING 'menuDiv', 'left', '0'.
007600   CALL 'cobdom_style' USING 'menuDiv', 'width', '100%'.
007700   CALL 'cobdom_style' USING 'menuDiv', 'backgroundColor',
007800     '#919191'.
007900   CALL 'cobdom_inner_html' USING 'menuDiv', 'Menu'.
008000   CALL 'cobdom_append_child' USING 'menuDiv', 'body'.
008100*Setup language selector
008200   CALL 'cobdom_create_element' USING 'langSelector', 'span'.
008300   CALL 'cobdom_style' USING 'langSelector', 'marginLeft', 'auto'.
008400   CALL 'cobdom_create_element' USING 'langUS', 'img'.
008500   CALL 'cobdom_create_element' USING 'langES', 'img'.
008600   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
008700   CALL 'cobdom_style' USING 'langUS', 'width', '3rem'.
008800   CALL 'cobdom_style' USING 'langUS', 'height', '3rem'.
009000   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
009000   CALL 'cobdom_style' USING 'langES', 'width', '3rem'.
009100   CALL 'cobdom_style' USING 'langES', 'height', '3rem'.
009200   CALL 'cobdom_append_child' USING 'langUS', 'langSelector'.
009300   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
009400     'SETLANGUS'.
009500   CALL 'cobdom_append_child' USING 'langES', 'langSelector'.
009600   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
009700     'SETLANGES'.
009800   CALL 'cobdom_append_child' USING 'langSelector', 'menuDiv'.
009900   CONTINUE.
010000 SET-ACTIVE-FLAG.
010100   IF WS-LANG = 'us' THEN
010200     CALL 'cobdom_style' USING 'langES', 'display', 'none'
010300   ELSE
010400     CALL 'cobdom_style' USING 'langUS', 'display', 'none'
010500   END-IF.
010600   CONTINUE.
010700 LANG-CHECK.
010800   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
010900     'lang'.
011000   IF WS-LANG = WS-NULL-BYTE THEN
011100     CALL 'cobdom_set_cookie' USING 'us', 'lang'
011200     MOVE 'us' TO WS-LANG
011300   END-IF.
011400   PERFORM SET-ACTIVE-FLAG.
011500   CONTINUE.
011600 COOKIE-ASK.
011700   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
011800   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
011900   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
012000   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
012100   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
012200   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
012300     '#00ff00'.
012400   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
012500     'center'.
012600   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
012700-'llow cookies to store your preferences such as language?&nbsp;'.
012800   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
012900   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
013000   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes&nbsp;'.
013100   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
013200   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
013300   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
013400   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
013500     'COOKIEACCEPT'.
013600   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
013700     'COOKIEDENY'.
013800   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
013900   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
014000   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
014100*Note this must be called after the elements are added to the
014200*document because it must search for them.
014300   CALL 'cobdom_class_style' USING 'cookieButton', 
014400     'backgroundColor', '#ff0000'.
014500   CONTINUE.
014600 WINDOWCHANGE SECTION.
014700 ENTRY 'WINDOWCHANGE'.
014800   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
014900   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
015000     '300'.
015100*Optimize this buffer time to not have a noticeable delay but also
015200*not call to often.
015300   GOBACK.
015400 SHAPEPAGE SECTION.
015500 ENTRY 'SHAPEPAGE'.
015600*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
015700*  DISPLAY 'Rendering! ' CENTISECS.
015800   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
015900     'window.innerWidth'.
016000   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
016100   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
016200     'window.innerHeight'.
016300   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
016400   GOBACK.
016500 COOKIEACCEPT SECTION.
016600 ENTRY 'COOKIEACCEPT'.
016700   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
016800   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
016900   MOVE 'y' TO WS-COOKIE-ALLOWED.
017000   GOBACK.
017100 COOKIEDENY SECTION.
017200 ENTRY 'COOKIEDENY'.
017300   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
017400   MOVE 'n' TO WS-COOKIE-ALLOWED.
017500   GOBACK.
017600 SETPERCENTCOBOL SECTION.
017700 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
017800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
017900   CALL 'cobdom_inner_html' USING 'percentCobol',
018000     WS-PERCENT-COBOL.
018100   DISPLAY 'Currently this website is written in ' 
018200     WS-PERCENT-COBOL '% COBOL.'.
018300   GOBACK.
018400 SETLANG SECTION.
018500 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
018600   if WS-LANG-SELECT-TOGGLE = 0 THEN
018700     MOVE 1 TO WS-LANG-SELECT-TOGGLE
018800     IF WS-LANG = 'us' THEN
018900       CALL 'cobdom_style' USING 'langES', 'display', 'inline'
019000     ELSE
019100       CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
019200     END-IF
019300   ELSE
019400     MOVE 0 TO WS-LANG-SELECT-TOGGLE
019500     IF WS-COOKIE-ALLOWED = 'y' THEN
019600       IF LS-LANG-CHOICE = 'us' THEN
019700         CALL 'cobdom_set_cookie' USING 'us', 'lang'
019800         MOVE 'us' TO WS-LANG
019900       ELSE
020000         CALL 'cobdom_set_cookie' USING 'es', 'lang'
020100         MOVE 'es' TO WS-LANG
020200       END-IF
020300       PERFORM SET-ACTIVE-FLAG
020400     ELSE
020500       MOVE LS-LANG-CHOICE TO WS-LANG
020600       PERFORM SET-ACTIVE-FLAG 
020700     END-IF
020800   END-IF.
020900   GOBACK.
021000 SETLANGUS SECTION.
021100 ENTRY 'SETLANGUS'.
021200   CALL 'SETLANG' USING 'us'.
021300   GOBACK.
021400 SETLANGES SECTION.
021500 ENTRY 'SETLANGES'.
021600   CALL 'SETLANG' USING 'es'.
021700   GOBACK.
