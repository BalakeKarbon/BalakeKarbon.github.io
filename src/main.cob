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
003700 01 LS-TERM-IN PIC X(10).
003800 PROCEDURE DIVISION.
003900 MAIN SECTION.
004000 ENTRY 'MAIN'.
004100   CALL 'cobdom_style' USING 'body', 'margin', '0'.
004200   CALL 'cobdom_style' USING 'body', 'fontSize', '2rem'.
004300*  CALL 'cobdom_style' USING 'body', 'display', 'flex'.
004400*  CALL 'cobdom_style' USING 'body', 'alignItems', 'center'.
004500*  CALL 'cobdom_style' USING 'body', 'justifyContent', 'center'.
004600   CALL 'cobdom_add_event_listener' USING 'window', 'resize', 
004700     'WINDOWCHANGE'.
004800   CALL 'cobdom_add_event_listener' USING 'window', 
004900     'orientationchange', 'WINDOWCHANGE'.
005000   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
005100     'allowCookies'.
005200   CALL 'cobdom_create_element' USING 'percentCobol', 'span'.
005300*  CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
005400*    '/res/percent.txt', 'GET', WS-NULL-BYTE.
005500*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
005600*Build page structure
005700   PERFORM BUILD-MENUBAR.
005800*Check for cookies
005900   IF WS-COOKIE-ALLOWED = 'y' THEN
006000     PERFORM LANG-CHECK
006100   ELSE
006200     PERFORM COOKIE-ASK
006300     MOVE 'us' TO WS-LANG
006400     PERFORM SET-ACTIVE-FLAG
006500   END-IF.
006600*Load and set fonts
006700   CALL 'cobdom_font_face' USING 'mainFont',
006800     'url("/res/fonts/Proggy/ProggyVector-Regular.otf")',
006900*    'url("/res/fonts/modern-hermit/Hermit-medium.otf")',
007000     'FONTLOADED'.
007100*Terminal
007200   CALL 'cobdom_create_element' USING 'terminalDiv', 'div'.
007300   CALL 'cobdom_append_child' USING 'terminalDiv', 'contentDiv'.
007400   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB,
007500     '(function() {    window["term"] = new Terminal();    window[
007600-'"term"].open(window["terminalDiv"]);    window["term"].write("He
007700-'llorld");   term.onData(data => {     Module.ccall("TERMINPUT", 
007800-'null, ["string"], [data]);   });   return "";  })()'.
007900*Render
008000   CALL 'SHAPEPAGE'.
008100   GOBACK.
008200 RELOAD-TEXT.
008300   CONTINUE.
008400 BUILD-MENUBAR.
008500   CALL 'cobdom_create_element' USING 'menuDiv', 'div'.
008600   CALL 'cobdom_style' USING 'menuDiv', 'position', 'fixed'.
008700   CALL 'cobdom_style' USING 'menuDiv', 'display', 'flex'.
008800   CALL 'cobdom_style' USING 'menuDiv', 'justifyContent', 
008900     'space-between'.
009000   CALL 'cobdom_style' USING 'menuDiv', 'top', '0'.
009100   CALL 'cobdom_style' USING 'menuDiv', 'left', '0'.
009200   CALL 'cobdom_style' USING 'menuDiv', 'width', '100%'.
009300   CALL 'cobdom_style' USING 'menuDiv', 'backgroundColor',
009400     '#919191'.
009500   CALL 'cobdom_append_child' USING 'menuDiv', 'body'.
009600*Setup ID area
009700   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
009800   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
009900   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
010000   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '4rem'.
010100   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
010200   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
010300   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
010400*  CALL 'cobdom_inner_html' USING 'taglineDiv', 
010500*    'A guy that knows a guy.'.
010600   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
010700   CALL 'cobdom_append_child' USING 'idDiv', 'menuDiv'.
010800   CALL 'cobdom_style' USING 'menuDiv', 'borderBottomLeftRadius',
010900     '1rem'.
011000   CALL 'cobdom_style' USING 'menuDiv',
011100     'borderBottomRightRadius','1rem'.
011200*Setup nav bar
011300   CALL 'cobdom_create_element' USING 'menuArea', 'span'.
011400   CALL 'cobdom_style' USING 'menuArea', 'marginLeft', 'auto'.
011500   CALL 'cobdom_append_child' USING 'menuArea', 'menuDiv'.
011600*Setup language selector
011700   CALL 'cobdom_create_element' USING 'langUS', 'img'.
011800   CALL 'cobdom_create_element' USING 'langES', 'img'.
011900   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
012000   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
012100   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
012200   CALL 'cobdom_style' USING 'langUS', 'padding', '1rem'.
012300   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
012400   CALL 'cobdom_style' USING 'langUS', 'transition', 
012500     'opacity 0.5s ease, transform 0.5s ease'.
012600   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
012700   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
012800   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
012900   CALL 'cobdom_style' USING 'langES', 'padding', '1rem'.
013000   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
013100   CALL 'cobdom_style' USING 'langES', 'transition', 
013200     'opacity 0.5s ease, transform 0.5s ease'.
013300   CALL 'cobdom_append_child' USING 'langUS', 'menuArea'.
013400   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
013500     'SETLANGUS'.
013600   CALL 'cobdom_append_child' USING 'langES', 'menuArea'.
013700   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
013800     'SETLANGES'.
013900*Setup content div
014000   CALL 'cobdom_create_element' USING 'contentDiv', 'div'.
014100   CALL 'cobdom_style' USING 'contentDiv', 'marginTop', '10rem'.
014200   CALL 'cobdom_append_child' USING 'contentDiv', 'body'.
014300   CONTINUE.
014400 SET-ACTIVE-FLAG.
014500   IF WS-LANG = 'us' THEN
014600     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
014700     CALL 'cobdom_style' USING 'langUS', 'transform', 
014800       'translate(9rem, 0rem)'
014900*    CALL 'cobdom_style' USING 'langES', 'display', 'none'
015000   ELSE
015100     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
015200     CALL 'cobdom_style' USING 'langUS', 'transform', 
015300       'translate(9rem, 0rem)'
015400*    CALL 'cobdom_style' USING 'langUS', 'display', 'none'
015500   END-IF.
015600   CONTINUE.
015700 LANG-CHECK.
015800   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
015900     'lang'.
016000   IF WS-LANG = WS-NULL-BYTE THEN
016100     CALL 'cobdom_set_cookie' USING 'us', 'lang'
016200     MOVE 'us' TO WS-LANG
016300   END-IF.
016400   PERFORM SET-ACTIVE-FLAG.
016500   CONTINUE.
016600 COOKIE-ASK.
016700   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
016800   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
016900   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
017000   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
017100   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
017200   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
017300     '#00ff00'.
017400   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
017500     'center'.
017600   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
017700-'llow cookies to store your preferences such as language?&nbsp;'.
017800   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
017900   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
018000   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes&nbsp;'.
018100   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
018200   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
018300   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
018400   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
018500     'COOKIEACCEPT'.
018600   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
018700     'COOKIEDENY'.
018800   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
018900   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
019000   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
019100*Note this must be called after the elements are added to the
019200*document because it must search for them.
019300   CALL 'cobdom_class_style' USING 'cookieButton', 
019400     'backgroundColor', '#ff0000'.
019500   CONTINUE.
019600 FONTLOADED SECTION.
019700 ENTRY 'FONTLOADED'.
019800   CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'.
019900   GOBACK.
020000 WINDOWCHANGE SECTION.
020100 ENTRY 'WINDOWCHANGE'.
020200   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
020300   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
020400     '300'.
020500*Optimize this buffer time to not have a noticeable delay but also
020600*not call to often.
020700   GOBACK.
020800 SHAPEPAGE SECTION.
020900 ENTRY 'SHAPEPAGE'.
021000*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
021100*  DISPLAY 'Rendering! ' CENTISECS.
021200   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
021300     'window.innerWidth'.
021400   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
021500   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
021600     'window.innerHeight'.
021700   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
021800   GOBACK.
021900 COOKIEACCEPT SECTION.
022000 ENTRY 'COOKIEACCEPT'.
022100   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
022200   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
022300   MOVE 'y' TO WS-COOKIE-ALLOWED.
022400   GOBACK.
022500 COOKIEDENY SECTION.
022600 ENTRY 'COOKIEDENY'.
022700   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
022800   MOVE 'n' TO WS-COOKIE-ALLOWED.
022900   GOBACK.
023000 SETPERCENTCOBOL SECTION.
023100 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
023200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
023300   CALL 'cobdom_inner_html' USING 'percentCobol',
023400     WS-PERCENT-COBOL.
023500   DISPLAY 'Currently this website is written in ' 
023600     WS-PERCENT-COBOL '% COBOL.'.
023700   GOBACK.
023800 SETLANG SECTION.
023900 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
024000   if WS-LANG-SELECT-TOGGLE = 0 THEN
024100     MOVE 1 TO WS-LANG-SELECT-TOGGLE
024200     IF WS-LANG = 'us' THEN
024300       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
024400       CALL 'cobdom_style' USING 'langUS', 'transform', 
024500         'translate(0rem, 0rem)'
024600*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
024700     ELSE
024800       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
024900       CALL 'cobdom_style' USING 'langUS', 'transform', 
025000         'translate(0rem, 0rem)'
025100*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
025200     END-IF
025300   ELSE
025400     MOVE 0 TO WS-LANG-SELECT-TOGGLE
025500     IF WS-COOKIE-ALLOWED = 'y' THEN
025600       IF LS-LANG-CHOICE = 'us' THEN
025700         CALL 'cobdom_set_cookie' USING 'us', 'lang'
025800         MOVE 'us' TO WS-LANG
025900       ELSE
026000         CALL 'cobdom_set_cookie' USING 'es', 'lang'
026100         MOVE 'es' TO WS-LANG
026200       END-IF
026300       PERFORM SET-ACTIVE-FLAG
026400     ELSE
026500       MOVE LS-LANG-CHOICE TO WS-LANG
026600       PERFORM SET-ACTIVE-FLAG 
026700     END-IF
026800   END-IF.
026900   GOBACK.
027000 SETLANGUS SECTION.
027100 ENTRY 'SETLANGUS'.
027200   CALL 'SETLANG' USING 'us'.
027300   GOBACK.
027400 SETLANGES SECTION.
027500 ENTRY 'SETLANGES'.
027600   CALL 'SETLANG' USING 'es'.
027700   GOBACK.
027800 TERMINPUT SECTION.
027900 ENTRY 'TERMINPUT' USING LS-TERM-IN.
028000   DISPLAY LS-TERM-IN.
028100   GOBACK.
