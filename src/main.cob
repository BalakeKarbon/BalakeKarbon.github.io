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
002100   05 HEIGHT PIC 9(5).
002200   05 WIDTH PIC 9(5).
002300*READ: Do I do this complicated layout stuff or should I always
002400*just render it stacked...? I think id like to fill the page
002500*better.
002600*01 WS-AREAS.
002700*  05 TERM.
002800*    10 OFFSET-Y
002900*  05 READER.
003000*    10 OFFSET-Y
003100*  05 STORAGE.
003200*    10 OFFSET-Y
003300 01 WS-TMP.
003400   05 CENTISECS PIC 9999.
003500   05 PX.
003600     10 NUM PIC -(4)9.
003700     10 TAIL PIC XX VALUE 'px'.
003800     10 NB PIC X(1) VALUE X'00'.
003900 01 WS-BLOB PIC X(100000).
004000 01 WS-BLOB-SIZE PIC 9(10).
004100*This has to be pic 10 as that is what is returned from
004200*the library.
004300 LINKAGE SECTION.
004400 01 LS-BLOB PIC X(100000).
004500 01 LS-BLOB-SIZE PIC 9(10).
004600 01 LS-LANG-CHOICE PIC XX.
004700 PROCEDURE DIVISION.
004800 EXAMPLE SECTION.
004900 ENTRY 'MAIN'.
005000   CALL 'cobdom_style' USING 'body', 'margin', '0'.
005100   CALL 'cobdom_add_event_listener' USING 'window', 'resize', 
005200     'WINDOWCHANGE'.
005300   CALL 'cobdom_add_event_listener' USING 'window', 
005400     'orientationchange', 'WINDOWCHANGE'.
005500   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
005600     'allowCookies'.
005700   IF WS-COOKIE-ALLOWED = 'y' THEN
005800     PERFORM LANG-CHECK
005900   ELSE
006000     PERFORM COOKIE-ASK
006100     MOVE 'us' TO WS-LANG
006200     PERFORM SET-ACTIVE-FLAG
006300   END-IF.
006400   CALL 'cobdom_create_element' USING 'percentCobol', 'span'.
006500   CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
006600     '/res/percent.txt', 'GET', WS-NULL-BYTE.
006700   CALL 'cobdom_style' USING 'body', 'fontSize', '4rem'.
006800   CALL 'cobdom_create_element' USING 'contentDiv', 'div'.
006900   CALL 'cobdom_style' USING 'contentDiv', 'paddingTop', '4rem'.
007000*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
007100   CALL 'cobdom_append_child' USING 'contentDiv', 'body'.
007200   CALL 'RENDERPAGE'.
007300   GOBACK.
007400 SET-ACTIVE-FLAG.
007500   IF WS-LANG = 'us' THEN
007600     CALL 'cobdom_style' USING 'langES', 'display', 'none'
007700   ELSE
007800     CALL 'cobdom_style' USING 'langUS', 'display', 'none'
007900   END-IF.
008000   CONTINUE.
008100 LANG-CHECK.
008200   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
008300     'lang'.
008400   IF WS-LANG = WS-NULL-BYTE THEN
008500     CALL 'cobdom_set_cookie' USING 'us', 'lang'
008600     MOVE 'us' TO WS-LANG
008700   END-IF.
008800   PERFORM SET-ACTIVE-FLAG.
008900   CONTINUE.
009000 COOKIE-ASK.
009100   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
009200   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
009300   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
009400   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
009500   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
009600   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
009700     '#00ff00'.
009800   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
009900     'center'.
010000   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
010100-'llow cookies to store your preferences such as language?&nbsp;'.
010200   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
010300   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
010400   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes&nbsp;'.
010500   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
010600   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
010700   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
010800   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
010900     'COOKIEACCEPT'.
011000   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
011100     'COOKIEDENY'.
011200   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
011300   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
011400   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
011500*Note this must be called after the elements are added to the
011600*document because it must search for them.
011700   CALL 'cobdom_class_style' USING 'cookieButton', 
011800     'backgroundColor', '#ff0000'.
011900   CONTINUE.
012000 WINDOWCHANGE SECTION.
012100 ENTRY 'WINDOWCHANGE'.
012200   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
012300   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'RENDERPAGE'
012400     '300'.
012500*Optimize this buffer time to not have a noticeable delay but also
012600*not call to often.
012700   GOBACK.
012800 RENDERPAGE SECTION.
012900 ENTRY 'RENDERPAGE'.
013000*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
013100*  DISPLAY 'Rendering! ' CENTISECS.
013200   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
013300     'window.innerWidth'.
013400   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
013500   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
013600     'window.innerHeight'.
013700   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
013800   DISPLAY WIDTH OF WS-WINDOW 'x' HEIGHT OF WS-WINDOW.
013900   GOBACK.
014000 COOKIEACCEPT SECTION.
014100 ENTRY 'COOKIEACCEPT'.
014200   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
014300   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
014400   MOVE 'y' TO WS-COOKIE-ALLOWED.
014500   GOBACK.
014600 COOKIEDENY SECTION.
014700 ENTRY 'COOKIEDENY'.
014800   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
014900   MOVE 'n' TO WS-COOKIE-ALLOWED.
015000   GOBACK.
015100 SETPERCENTCOBOL SECTION.
015200 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
015300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
015400   CALL 'cobdom_inner_html' USING 'percentCobol',
015500     WS-PERCENT-COBOL.
015600   DISPLAY 'Currently this website is written in ' 
015700     WS-PERCENT-COBOL '% COBOL.'.
015800   GOBACK.
015900 SETLANG SECTION.
016000 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
016100   if WS-LANG-SELECT-TOGGLE = 0 THEN
016200     MOVE 1 TO WS-LANG-SELECT-TOGGLE
016300     IF WS-LANG = 'us' THEN
016400       CALL 'cobdom_style' USING 'langES', 'display', 'inline'
016500     ELSE
016600       CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
016700     END-IF
016800   ELSE
016900     MOVE 0 TO WS-LANG-SELECT-TOGGLE
017000     IF WS-COOKIE-ALLOWED = 'y' THEN
017100       IF LS-LANG-CHOICE = 'us' THEN
017200         CALL 'cobdom_set_cookie' USING 'us', 'lang'
017300         MOVE 'us' TO WS-LANG
017400       ELSE
017500         CALL 'cobdom_set_cookie' USING 'es', 'lang'
017600         MOVE 'es' TO WS-LANG
017700       END-IF
017800       PERFORM SET-ACTIVE-FLAG
017900     ELSE
018000       MOVE LS-LANG-CHOICE TO WS-LANG
018100       PERFORM SET-ACTIVE-FLAG 
018200     END-IF
018300   END-IF.
018400   GOBACK.
018500 SETLANGUS SECTION.
018600 ENTRY 'SETLANGUS'.
018700   CALL 'SETLANG' USING 'us'.
018800   GOBACK.
018900 SETLANGES SECTION.
019000 ENTRY 'SETLANGES'.
019100   CALL 'SETLANG' USING 'es'.
019200   GOBACK.
019300*BUILD-MENUBAR.
019400*  CALL 'cobdom_create_element' USING 'menuDiv', 'div'.
019500*  CALL 'cobdom_style' USING 'menuDiv', 'position', 'fixed'.
019600*  CALL 'cobdom_style' USING 'menuDiv', 'display', 'flex'.
019700*  CALL 'cobdom_style' USING 'menuDiv', 'justifyContent', 
019800*    'space-between'.
019900*  CALL 'cobdom_style' USING 'menuDiv', 'top', '0'.
020000*  CALL 'cobdom_style' USING 'menuDiv', 'left', '0'.
020100*  CALL 'cobdom_style' USING 'menuDiv', 'width', '100%'.
020200*  CALL 'cobdom_style' USING 'menuDiv', 'backgroundColor',
020300*    '#919191'.
020400*  CALL 'cobdom_inner_html' USING 'menuDiv', 'Menu'.
020500*  CALL 'cobdom_append_child' USING 'menuDiv', 'body'.
020600*Setup language selector
020700*  CALL 'cobdom_create_element' USING 'langSelector', 'span'.
020800*  CALL 'cobdom_style' USING 'langSelector', 'marginLeft', 'auto'.
020900*  CALL 'cobdom_create_element' USING 'langUS', 'img'.
021000*  CALL 'cobdom_create_element' USING 'langES', 'img'.
021100*  CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
021200*  CALL 'cobdom_style' USING 'langUS', 'width', '3rem'.
021300*  CALL 'cobdom_style' USING 'langUS', 'height', '3rem'.
021400*  CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
021500*  CALL 'cobdom_style' USING 'langES', 'width', '3rem'.
021600*  CALL 'cobdom_style' USING 'langES', 'height', '3rem'.
021700*  CALL 'cobdom_append_child' USING 'langUS', 'langSelector'.
021800*  CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
021900*    'SETLANGUS'.
022000*  CALL 'cobdom_append_child' USING 'langES', 'langSelector'.
022100*  CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
022200*    'SETLANGES'.
022300*  CALL 'cobdom_append_child' USING 'langSelector', 'menuDiv'.
022400*  CONTINUE.
022500 
