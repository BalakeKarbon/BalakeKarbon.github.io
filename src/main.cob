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
007900   CALL 'cobdom_append_child' USING 'menuDiv', 'body'.
008000*Setup language selector
008100   CALL 'cobdom_create_element' USING 'langSelector', 'span'.
008200   CALL 'cobdom_style' USING 'langSelector', 'marginLeft', 'auto'.
008300   CALL 'cobdom_create_element' USING 'langUS', 'img'.
008400   CALL 'cobdom_create_element' USING 'langES', 'img'.
008500   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
008600   CALL 'cobdom_style' USING 'langUS', 'width', '4rem'.
008700   CALL 'cobdom_style' USING 'langUS', 'height', '4rem'.
008800   CALL 'cobdom_style' USING 'langUS', 'padding', '1rem'.
008900   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
009000   CALL 'cobdom_style' USING 'langUS', 'transition', 
009100     'opacity 0.5s ease, transform 0.5s ease'.
009200   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
009300   CALL 'cobdom_style' USING 'langES', 'width', '4rem'.
009400   CALL 'cobdom_style' USING 'langES', 'height', '4rem'.
009500   CALL 'cobdom_style' USING 'langES', 'padding', '1rem'.
009600   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
009700   CALL 'cobdom_style' USING 'langES', 'transition', 
009800     'opacity 0.5s ease, transform 0.5s ease'.
009900   CALL 'cobdom_append_child' USING 'langUS', 'langSelector'.
010000   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
010100     'SETLANGUS'.
010200   CALL 'cobdom_append_child' USING 'langES', 'langSelector'.
010300   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
010400     'SETLANGES'.
010500   CALL 'cobdom_append_child' USING 'langSelector', 'menuDiv'.
010600   CONTINUE.
010700 SET-ACTIVE-FLAG.
010800   IF WS-LANG = 'us' THEN
010900     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
011000     CALL 'cobdom_style' USING 'langUS', 'transform', 
011100       'translate(6rem, 0rem)'
011200*    CALL 'cobdom_style' USING 'langES', 'display', 'none'
011300   ELSE
011400     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
011500     CALL 'cobdom_style' USING 'langUS', 'transform', 
011600       'translate(6rem, 0rem)'
011700*    CALL 'cobdom_style' USING 'langUS', 'display', 'none'
011800   END-IF.
011900   CONTINUE.
012000 LANG-CHECK.
012100   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
012200     'lang'.
012300   IF WS-LANG = WS-NULL-BYTE THEN
012400     CALL 'cobdom_set_cookie' USING 'us', 'lang'
012500     MOVE 'us' TO WS-LANG
012600   END-IF.
012700   PERFORM SET-ACTIVE-FLAG.
012800   CONTINUE.
012900 COOKIE-ASK.
013000   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
013100   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
013200   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
013300   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
013400   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
013500   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
013600     '#00ff00'.
013700   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
013800     'center'.
013900   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
014000-'llow cookies to store your preferences such as language?&nbsp;'.
014100   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
014200   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
014300   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes&nbsp;'.
014400   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
014500   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
014600   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
014700   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
014800     'COOKIEACCEPT'.
014900   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
015000     'COOKIEDENY'.
015100   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
015200   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
015300   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
015400*Note this must be called after the elements are added to the
015500*document because it must search for them.
015600   CALL 'cobdom_class_style' USING 'cookieButton', 
015700     'backgroundColor', '#ff0000'.
015800   CONTINUE.
015900 WINDOWCHANGE SECTION.
016000 ENTRY 'WINDOWCHANGE'.
016100   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
016200   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
016300     '300'.
016400*Optimize this buffer time to not have a noticeable delay but also
016500*not call to often.
016600   GOBACK.
016700 SHAPEPAGE SECTION.
016800 ENTRY 'SHAPEPAGE'.
016900*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
017000*  DISPLAY 'Rendering! ' CENTISECS.
017100   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
017200     'window.innerWidth'.
017300   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
017400   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
017500     'window.innerHeight'.
017600   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
017700   GOBACK.
017800 COOKIEACCEPT SECTION.
017900 ENTRY 'COOKIEACCEPT'.
018000   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
018100   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
018200   MOVE 'y' TO WS-COOKIE-ALLOWED.
018300   GOBACK.
018400 COOKIEDENY SECTION.
018500 ENTRY 'COOKIEDENY'.
018600   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
018700   MOVE 'n' TO WS-COOKIE-ALLOWED.
018800   GOBACK.
018900 SETPERCENTCOBOL SECTION.
019000 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
019100   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
019200   CALL 'cobdom_inner_html' USING 'percentCobol',
019300     WS-PERCENT-COBOL.
019400   DISPLAY 'Currently this website is written in ' 
019500     WS-PERCENT-COBOL '% COBOL.'.
019600   GOBACK.
019700 SETLANG SECTION.
019800 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
019900   if WS-LANG-SELECT-TOGGLE = 0 THEN
020000     MOVE 1 TO WS-LANG-SELECT-TOGGLE
020100     IF WS-LANG = 'us' THEN
020200       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
020300       CALL 'cobdom_style' USING 'langUS', 'transform', 
020400         'translate(0rem, 0rem)'
020500*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
020600     ELSE
020700       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
020800       CALL 'cobdom_style' USING 'langUS', 'transform', 
020900         'translate(0rem, 0rem)'
021000*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
021100     END-IF
021200   ELSE
021300     MOVE 0 TO WS-LANG-SELECT-TOGGLE
021400     IF WS-COOKIE-ALLOWED = 'y' THEN
021500       IF LS-LANG-CHOICE = 'us' THEN
021600         CALL 'cobdom_set_cookie' USING 'us', 'lang'
021700         MOVE 'us' TO WS-LANG
021800       ELSE
021900         CALL 'cobdom_set_cookie' USING 'es', 'lang'
022000         MOVE 'es' TO WS-LANG
022100       END-IF
022200       PERFORM SET-ACTIVE-FLAG
022300     ELSE
022400       MOVE LS-LANG-CHOICE TO WS-LANG
022500       PERFORM SET-ACTIVE-FLAG 
022600     END-IF
022700   END-IF.
022800   GOBACK.
022900 SETLANGUS SECTION.
023000 ENTRY 'SETLANGUS'.
023100   CALL 'SETLANG' USING 'us'.
023200   GOBACK.
023300 SETLANGES SECTION.
023400 ENTRY 'SETLANGES'.
023500   CALL 'SETLANG' USING 'es'.
023600   GOBACK.
