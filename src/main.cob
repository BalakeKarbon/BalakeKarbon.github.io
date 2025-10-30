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
004300   CALL 'cobdom_style' USING 'body', 'display', 'flex'.
004400   CALL 'cobdom_style' USING 'body', 'alignItems', 'center'.
004500   CALL 'cobdom_style' USING 'body', 'justifyContent', 'center'.
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
007100*Load texts
007200   PERFORM LOAD-TEXTS.
007300*Terminal
007400   CALL 'cobdom_create_element' USING 'terminalDiv', 'div'.
007500   CALL 'cobdom_append_child' USING 'terminalDiv', 'contentDiv'.
007600   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB,
007700     '(function() {    window["term"] = new Terminal();    window[
007800-'"term"].open(window["terminalDiv"]);    window["term"].write("He
007900-'llorld");   term.onData(data => {     Module.ccall("TERMINPUT", 
008000-'null, ["string"], [data]);   });   return "";  })()'.
008100*Render
008200   CALL 'SHAPEPAGE'.
008300   GOBACK.
008500 RELOAD-TEXT.
008500   CONTINUE.
008600 BUILD-MENUBAR.
008700   CALL 'cobdom_create_element' USING 'menuDiv', 'div'.
008800   CALL 'cobdom_style' USING 'menuDiv', 'position', 'fixed'.
008900   CALL 'cobdom_style' USING 'menuDiv', 'display', 'flex'.
009000   CALL 'cobdom_style' USING 'menuDiv', 'justifyContent', 
009100     'space-between'.
009200   CALL 'cobdom_style' USING 'menuDiv', 'top', '0'.
009300   CALL 'cobdom_style' USING 'menuDiv', 'left', '0'.
009400   CALL 'cobdom_style' USING 'menuDiv', 'width', '100%'.
009500*  CALL 'cobdom_style' USING 'menuDiv', 'backgroundColor',
009600*    '#919191'.
009700*  CALL 'cobdom_style' USING 'menuDiv', 'boxShadow', 
009800*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
009900*  CALL 'cobdom_style' USING 'menuDiv', 'borderBottomLeftRadius',
010000*    '1rem'.
010100*  CALL 'cobdom_style' USING 'menuDiv',
010200*    'borderBottomRightRadius','1rem'.
010300   CALL 'cobdom_append_child' USING 'menuDiv', 'body'.
010400*Setup ID area
010500*  CALL 'cobdom_create_element' USING 'idDiv', 'div'.
010600*  CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
010700*  CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
010800*  CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '4rem'.
010900*  CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
011000*  CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
011100*  CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
011200*  CALL 'cobdom_inner_html' USING 'taglineDiv', 
011300*    'A guy that knows a guy.'.
011400*  CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
011500*  CALL 'cobdom_append_child' USING 'idDiv', 'menuDiv'.
011600*Setup nav bar
011700   CALL 'cobdom_create_element' USING 'menuArea', 'span'.
011800   CALL 'cobdom_style' USING 'menuArea', 'marginLeft', 'auto'.
011900   CALL 'cobdom_append_child' USING 'menuArea', 'menuDiv'.
012000*Setup language selector
012100   CALL 'cobdom_create_element' USING 'langUS', 'img'.
012200   CALL 'cobdom_create_element' USING 'langES', 'img'.
012300   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
012400   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
012500   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
012600   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
012700   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
012800   CALL 'cobdom_style' USING 'langUS', 'transition', 
012900     'opacity 0.5s ease, transform 0.5s ease'.
013000   CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
013100     '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
013200   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
013300   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
013400   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
013500   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
013600   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
013700   CALL 'cobdom_style' USING 'langES', 'transition', 
013800     'opacity 0.5s ease, transform 0.5s ease'.
013900   CALL 'cobdom_style' USING 'langES', 'boxShadow', 
014000     '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
014100   CALL 'cobdom_append_child' USING 'langUS', 'menuArea'.
014200   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
014300     'SETLANGUS'.
014400   CALL 'cobdom_append_child' USING 'langES', 'menuArea'.
014500   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
014600     'SETLANGES'.
014700*Setup content div
014800   CALL 'cobdom_create_element' USING 'contentDiv', 'div'.
014900*  CALL 'cobdom_style' USING 'contentDiv', 'marginTop', '10rem'.
015000*  CALL 'cobdom_inner_html' USING 'contentDiv', 'TEST CONTENT'.
015100*  CALL 'cobdom_style' USING 'contentDiv', 'maxWidth', '80rem'.
015200*  CALL 'cobdom_style' USING 'contentDiv', 'width', '100%'.
015300*  CALL 'cobdom_style' USING 'contendDiv', 'display', 'flex'.
015400*  CALL 'cobdom_style' USING 'contendDiv', 'flexDirection',
015500*    'column'.
015600*  CALL 'cobdom_style' USING 'contendDiv', 'alignItems',
015700*    'flex-start'.
015800*  CALL 'cobdom_style' USING 'contentDiv', 'backgroundColor',
015900*    '#ff0000'.
016000   CALL 'cobdom_append_child' USING 'contentDiv', 'body'.
016100   CONTINUE.
016200 SET-ACTIVE-FLAG.
016300   IF WS-LANG = 'us' THEN
016400     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
016500     CALL 'cobdom_style' USING 'langUS', 'transform', 
016600       'translate(9rem, 0rem)'
016700     PERFORM UPDATE-TEXT
016800   ELSE
016900     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
017000     CALL 'cobdom_style' USING 'langUS', 'transform', 
017100       'translate(9rem, 0rem)'
017200     PERFORM UPDATE-TEXT
017300   END-IF.
017400   CONTINUE.
017500 LOAD-TEXTS.
017600   CONTINUE.
017700 UPDATE-TEXT.
017800   CONTINUE.
017900 LANG-CHECK.
018000   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
018100     'lang'.
018200   IF WS-LANG = WS-NULL-BYTE THEN
018300     CALL 'cobdom_set_cookie' USING 'us', 'lang'
018400     MOVE 'us' TO WS-LANG
018500   END-IF.
018600   PERFORM SET-ACTIVE-FLAG.
018700   CONTINUE.
018800 COOKIE-ASK.
018900   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
019000   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
019100   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
019200   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
019300   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
019400   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
019500     '#00ff00'.
019600   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
019700     'center'.
019800   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
019900-'llow cookies to store your preferences such as language?&nbsp;'.
020000   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
020100   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
020200   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
020300   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
020400   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
020500   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
020600   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
020700   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
020800   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
020900   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
021000   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
021100   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
021200   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
021300     'COOKIEACCEPT'.
021400   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
021500     'COOKIEDENY'.
021600   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
021700   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
021800   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
021900*Note this must be called after the elements are added to the
022000*document because it must search for them.
022100   CALL 'cobdom_class_style' USING 'cookieButton', 
022200     'backgroundColor', '#ff0000'.
022300   CONTINUE.
022400 FONTLOADED SECTION.
022500 ENTRY 'FONTLOADED'.
022600   CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'.
022700   GOBACK.
022800 WINDOWCHANGE SECTION.
022900 ENTRY 'WINDOWCHANGE'.
023000   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
023100   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
023200     '300'.
023300*Optimize this buffer time to not have a noticeable delay but also
023400*not call to often.
023500   GOBACK.
023600 SHAPEPAGE SECTION.
023700 ENTRY 'SHAPEPAGE'.
023800*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
023900*  DISPLAY 'Rendering! ' CENTISECS.
024000   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
024100     'window.innerWidth'.
024200   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
024300   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
024400     'window.innerHeight'.
024500   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
024600   GOBACK.
024700 COOKIEACCEPT SECTION.
024800 ENTRY 'COOKIEACCEPT'.
024900   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
025000   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
025100   MOVE 'y' TO WS-COOKIE-ALLOWED.
025200   GOBACK.
025300 COOKIEDENY SECTION.
025400 ENTRY 'COOKIEDENY'.
025500   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
025600   MOVE 'n' TO WS-COOKIE-ALLOWED.
025700   GOBACK.
025800 SETPERCENTCOBOL SECTION.
025900 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
026000   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
026100   CALL 'cobdom_inner_html' USING 'percentCobol',
026200     WS-PERCENT-COBOL.
026300   DISPLAY 'Currently this website is written in ' 
026400     WS-PERCENT-COBOL '% COBOL.'.
026500   GOBACK.
026600 SETLANG SECTION.
026700 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
026800   if WS-LANG-SELECT-TOGGLE = 0 THEN
026900     MOVE 1 TO WS-LANG-SELECT-TOGGLE
027000     IF WS-LANG = 'us' THEN
027100       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
027200       CALL 'cobdom_style' USING 'langUS', 'transform', 
027300         'translate(0rem, 0rem)'
027400*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
027500     ELSE
027600       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
027700       CALL 'cobdom_style' USING 'langUS', 'transform', 
027800         'translate(0rem, 0rem)'
027900*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
028000     END-IF
028100   ELSE
028200     MOVE 0 TO WS-LANG-SELECT-TOGGLE
028300     IF WS-COOKIE-ALLOWED = 'y' THEN
028400       IF LS-LANG-CHOICE = 'us' THEN
028500         CALL 'cobdom_set_cookie' USING 'us', 'lang'
028600         MOVE 'us' TO WS-LANG
028700       ELSE
028800         CALL 'cobdom_set_cookie' USING 'es', 'lang'
028900         MOVE 'es' TO WS-LANG
029000       END-IF
029100       PERFORM SET-ACTIVE-FLAG
029200     ELSE
029300       MOVE LS-LANG-CHOICE TO WS-LANG
029400       PERFORM SET-ACTIVE-FLAG 
029500     END-IF
029600   END-IF.
029700   GOBACK.
029800 SETLANGUS SECTION.
029900 ENTRY 'SETLANGUS'.
030000   CALL 'SETLANG' USING 'us'.
030100   GOBACK.
030200 SETLANGES SECTION.
030300 ENTRY 'SETLANGES'.
030400   CALL 'SETLANG' USING 'es'.
030500   GOBACK.
030600 TERMINPUT SECTION.
030700 ENTRY 'TERMINPUT' USING LS-TERM-IN.
030800   DISPLAY LS-TERM-IN.
030900   GOBACK.
