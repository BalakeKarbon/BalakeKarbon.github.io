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
002300*80x24 term res
002400*4/3 term ratio. other areas are half width with the reader
002500*1/3 the height and the storage 2/3 of the height.
002600*This means the parallel width to height is 6/3 or 2/1
002700*or the stacked would be 4/5.
002800*READ: Do I do this complicated layout stuff or should I always
002900*just render it stacked...? I think id like to fill the page
003000*better.
003100 01 WS-AREAS.
003200   05 MAIN.
003300     10 ORIENTATION PIC X.
003400     10 WIDTH PIC 9(5).
003500     10 HEIGHT PIC 9(5).   
003600   05 TERM.
003700     10 WIDTH PIC 9(5).
003800     10 HEIGHT PIC 9(5).
003900   05 READER.
004000     10 WIDTH PIC 9(5).
004100     10 HEIGHT PIC 9(5).
004200     10 OFFSET-Y PIC 9(5).
004300     10 OFFSET-X PIC 9(5).
004400   05 STORAGE.
004500     10 WIDTH PIC 9(5).
004600     10 HEIGHT PIC 9(5).
004700     10 OFFSET-Y PIC 9(5).
004800     10 OFFSET-X PIC 9(5).
004900 01 WS-TMP.
005000   05 CENTISECS PIC 9999.
005100   05 PX.
005200     10 NUM PIC -(4)9.
005300     10 TAIL PIC XX VALUE 'px'.
005400     10 NB PIC X(1) VALUE X'00'.
005500 01 WS-BLOB PIC X(100000).
005600 01 WS-BLOB-SIZE PIC 9(10).
005700*This has to be pic 10 as that is what is returned from
005800*the library.
005900 LINKAGE SECTION.
006000 01 LS-BLOB PIC X(100000).
006100 01 LS-BLOB-SIZE PIC 9(10).
006200 01 LS-LANG-CHOICE PIC XX.
006300 PROCEDURE DIVISION.
006400 EXAMPLE SECTION.
006500 ENTRY 'MAIN'.
006600   CALL 'cobdom_style' USING 'body', 'margin', '0'.
006700   CALL 'cobdom_style' USING 'body', 'fontSize', '4rem'.
006800   CALL 'cobdom_style' USING 'body', 'display', 'flex'.
006900   CALL 'cobdom_style' USING 'body', 'alignItems', 'center'.
007000   CALL 'cobdom_style' USING 'body', 'justifyContent', 'center'.
007100   CALL 'cobdom_add_event_listener' USING 'window', 'resize', 
007200     'WINDOWCHANGE'.
007300   CALL 'cobdom_add_event_listener' USING 'window', 
007400     'orientationchange', 'WINDOWCHANGE'.
007500   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
007600     'allowCookies'.
007700   CALL 'cobdom_create_element' USING 'percentCobol', 'span'.
007800   CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
007900     '/res/percent.txt', 'GET', WS-NULL-BYTE.
008000*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
008100*Set main area (container)
008200   CALL 'cobdom_create_element' USING 'mainArea', 'div'.
008300   CALL 'cobdom_style' USING 'mainArea', 'position', 'relative'.
008400   CALL 'cobdom_style' USING 'mainArea', 'backgroundColor', 
008500     '#0000ff'.
008600   CALL 'cobdom_append_child' USING 'mainArea', 'body'.
008700*Set up termArea
008800   CALL 'cobdom_create_element' USING 'termArea', 'div'.
008900   CALL 'cobdom_style' USING 'termArea', 'position', 'absolute'.
009000   CALL 'cobdom_style' USING 'termArea', 'bottom', '0'.
009100   CALL 'cobdom_style' USING 'termArea', 'left', '0'.
009200   CALL 'cobdom_style' USING 'termArea', 'backgroundColor',
009300     '#008e0e'.
009400   CALL 'cobdom_inner_html' USING 'termArea', 'TERM'.
009500   CALL 'cobdom_append_child' USING 'termArea', 'mainArea'.
009600*Set up readerArea
009700   CALL 'cobdom_create_element' USING 'readerArea', 'div'.
009800   CALL 'cobdom_style' USING 'readerArea', 'position', 'absolute'.
009900   CALL 'cobdom_style' USING 'readerArea', 'backgroundColor',
010000     '#4c4c4c'.
010100   CALL 'cobdom_inner_html' USING 'readerArea', 'READER'.
010200   CALL 'cobdom_append_child' USING 'readerArea', 'mainArea'.
010300*Set up storageArea
010400   CALL 'cobdom_create_element' USING 'storageArea', 'div'.
010500   CALL 'cobdom_style' USING 'storageArea', 'position', 
010600     'absolute'.
010700   CALL 'cobdom_style' USING 'storageArea', 'backgroundColor', 
010800     '#755217'
010900   CALL 'cobdom_inner_html' USING 'storageArea', 'STORAGE'.
011000   CALL 'cobdom_append_child' USING 'storageArea', 'mainArea'.
011100   IF WS-COOKIE-ALLOWED = 'y' THEN
011200     PERFORM LANG-CHECK
011300   ELSE
011400     PERFORM COOKIE-ASK
011500     MOVE 'us' TO WS-LANG
011600     PERFORM SET-ACTIVE-FLAG
011700   END-IF.
011800*Render
011900   CALL 'SHAPEPAGE'.
012000   GOBACK.
012100 SET-ACTIVE-FLAG.
012200   IF WS-LANG = 'us' THEN
012300     CALL 'cobdom_style' USING 'langES', 'display', 'none'
012400   ELSE
012500     CALL 'cobdom_style' USING 'langUS', 'display', 'none'
012600   END-IF.
012700   CONTINUE.
012800 LANG-CHECK.
012900   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
013000     'lang'.
013100   IF WS-LANG = WS-NULL-BYTE THEN
013200     CALL 'cobdom_set_cookie' USING 'us', 'lang'
013300     MOVE 'us' TO WS-LANG
013400   END-IF.
013500   PERFORM SET-ACTIVE-FLAG.
013600   CONTINUE.
013700 COOKIE-ASK.
013800   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
013900   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
014000   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
014100   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
014200   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
014300   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
014400     '#00ff00'.
014500   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
014600     'center'.
014700   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
014800-'llow cookies to store your preferences such as language?&nbsp;'.
014900   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
015000   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
015100   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes&nbsp;'.
015200   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
015300   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
015400   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
015500   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
015600     'COOKIEACCEPT'.
015700   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
015800     'COOKIEDENY'.
015900   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
016000   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
016100   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
016200*Note this must be called after the elements are added to the
016300*document because it must search for them.
016400   CALL 'cobdom_class_style' USING 'cookieButton', 
016500     'backgroundColor', '#ff0000'.
016600   CONTINUE.
016700 WINDOWCHANGE SECTION.
016800 ENTRY 'WINDOWCHANGE'.
016900   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
017000   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
017100     '300'.
017200*Optimize this buffer time to not have a noticeable delay but also
017300*not call to often.
017400   GOBACK.
017500 SHAPEPAGE SECTION.
017600 ENTRY 'SHAPEPAGE'.
017700*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
017800*  DISPLAY 'Rendering! ' CENTISECS.
017900   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
018000     'window.innerWidth'.
018100   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
018200   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
018300     'window.innerHeight'.
018400   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
018500   IF (WIDTH OF WS-WINDOW / 2) < HEIGHT OF WS-WINDOW THEN
018600*Horizontal render area
018700     MOVE 'h' TO ORIENTATION OF MAIN OF WS-AREAS
018800*Get dimensions of main area
018900     MOVE WIDTH OF WS-WINDOW TO WIDTH OF MAIN OF WS-AREAS
019000     COMPUTE HEIGHT OF MAIN OF WS-AREAS = 
019100       (WIDTH OF MAIN OF WS-AREAS / 4) * 5
019200*Get dimensions of term area
019300     MOVE WIDTH OF WS-WINDOW TO WIDTH OF TERM OF WS-AREAS
019400     COMPUTE HEIGHT OF TERM OF WS-AREAS =
019500       (WIDTH OF TERM OF WS-AREAS / 4) * 3
019600*Get dimensions and reader
019700     COMPUTE WIDTH OF READER OF WS-AREAS =
019800       WIDTH OF TERM OF WS-AREAS / 2
019900     COMPUTE HEIGHT OF READER OF WS-AREAS =
020000       HEIGHT OF TERM OF WS-AREAS / 3
020100*Get dimensions of storage
020200     MOVE WIDTH OF READER OF WS-AREAS TO
020300       WIDTH OF STORAGE OF WS-AREAS
020400     COMPUTE HEIGHT OF STORAGE OF WS-AREAS =
020500       HEIGHT OF READER OF WS-AREAS * 2
020600*Get offsets of reader
020700     MOVE 0 TO OFFSET-X OF READER OF WS-AREAS
020800     COMPUTE OFFSET-Y OF READER OF WS-AREAS =
020900       HEIGHT OF TERM OF WS-AREAS
021000*Get offsets of storage
021100     MOVE WIDTH OF READER OF WS-AREAS TO 
021200       OFFSET-X OF STORAGE OF WS-AREAS
021300     MOVE OFFSET-Y OF READER OF WS-AREAS TO 
021400       OFFSET-Y OF STORAGE OF WS-AREAS
021500   ELSE
021600*Vertical render area
021700     MOVE 'v' TO ORIENTATION OF MAIN OF WS-AREAS
021800*Get dimensions of main area
021900     MOVE HEIGHT OF WS-WINDOW TO HEIGHT OF MAIN OF WS-AREAS
022000     COMPUTE WIDTH OF MAIN OF WS-AREAS =
022100       HEIGHT OF MAIN OF WS-AREAS * 2
022200*Get dimensions of term area
022300     MOVE HEIGHT OF WS-WINDOW TO HEIGHT OF TERM OF WS-AREAS
022400     COMPUTE WIDTH OF TERM OF WS-AREAS =
022500       (HEIGHT OF MAIN OF WS-AREAS / 3) * 4
022600*Get dimensions and reader
022700     COMPUTE WIDTH OF READER OF WS-AREAS =
022800       WIDTH OF TERM OF WS-AREAS / 2
022900     COMPUTE HEIGHT OF READER OF WS-AREAS =
023000       HEIGHT OF TERM OF WS-AREAS / 3
023100*Get dimensions of storage
023200     MOVE WIDTH OF READER OF WS-AREAS TO
023300       WIDTH OF STORAGE OF WS-AREAS
023400     COMPUTE HEIGHT OF STORAGE OF WS-AREAS =
023500       HEIGHT OF READER OF WS-AREAS * 2
023600*Get offsets of reader
023700     MOVE WIDTH OF TERM OF WS-AREAS TO
023800       OFFSET-X OF READER OF WS-AREAS
023900     MOVE 0 TO OFFSET-Y OF READER OF WS-AREAS
024000*Get offsets of storage
024100     MOVE WIDTH OF TERM OF WS-AREAS TO
024200       OFFSET-X OF STORAGE OF WS-AREAS
024300     MOVE HEIGHT OF READER OF WS-AREAS TO
024400       OFFSET-Y OF STORAGE OF WS-AREAS
024500   END-IF.
024600*Size main area
024700   MOVE WIDTH OF MAIN OF WS-AREAS TO NUM OF PX OF WS-TMP.
024800   CALL 'cobdom_style' USING 'mainArea', 'width', PX OF WS-TMP.
024900   MOVE HEIGHT OF MAIN OF WS-AREAS TO NUM OF PX OF WS-TMP.
025000   CALL 'cobdom_style' USING 'mainArea', 'height', PX OF WS-TMP.
025100*Size term area
025200   MOVE WIDTH OF TERM OF WS-AREAS TO NUM OF PX OF WS-TMP.
025300   CALL 'cobdom_style' USING 'termArea', 'width', PX OF WS-TMP.
025400   MOVE HEIGHT OF TERM OF WS-AREAS TO NUM OF PX OF WS-TMP.
025500   CALL 'cobdom_style' USING 'termArea', 'height', PX OF WS-TMP.
025600*Size and position reader area
025700   MOVE WIDTH OF READER OF WS-AREAS TO NUM OF PX OF WS-TMP.
025800   CALL 'cobdom_style' USING 'readerArea', 'width', PX OF WS-TMP.
025900   MOVE HEIGHT OF READER OF WS-AREAS TO NUM OF PX OF WS-TMP.
026000   CALL 'cobdom_style' USING 'readerArea', 'height', PX OF WS-TMP.
026100   MOVE OFFSET-X OF READER OF WS-AREAS TO NUM OF PX OF WS-TMP.
026200   CALL 'cobdom_style' USING 'readerArea', 'left', PX OF WS-TMP.
026300   MOVE OFFSET-Y OF READER OF WS-AREAS TO NUM OF PX OF WS-TMP.
026400   CALL 'cobdom_style' USING 'readerArea', 'bottom', PX OF WS-TMP.
026500*Size and position storage area
026600   MOVE WIDTH OF STORAGE OF WS-AREAS TO NUM OF PX OF WS-TMP.
026700   CALL 'cobdom_style' USING 'storageArea', 'width', PX OF WS-TMP.
026800   MOVE HEIGHT OF STORAGE OF WS-AREAS TO NUM OF PX OF WS-TMP.
026900   CALL 'cobdom_style' USING 'storageArea', 'height', 
027000     PX OF WS-TMP.
027100   MOVE OFFSET-X OF STORAGE OF WS-AREAS TO NUM OF PX OF WS-TMP.
027200   CALL 'cobdom_style' USING 'storageArea', 'left', PX OF WS-TMP.
027300   MOVE OFFSET-Y OF STORAGE OF WS-AREAS TO NUM OF PX OF WS-TMP.
027400   CALL 'cobdom_style' USING 'storageArea', 'bottom', 
027500     PX OF WS-TMP.
027600   GOBACK.
027700 COOKIEACCEPT SECTION.
027800 ENTRY 'COOKIEACCEPT'.
027900   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
028000   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
028100   MOVE 'y' TO WS-COOKIE-ALLOWED.
028200   GOBACK.
028300 COOKIEDENY SECTION.
028400 ENTRY 'COOKIEDENY'.
028500   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
028600   MOVE 'n' TO WS-COOKIE-ALLOWED.
028700   GOBACK.
028800 SETPERCENTCOBOL SECTION.
028900 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
029000   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
029100   CALL 'cobdom_inner_html' USING 'percentCobol',
029200     WS-PERCENT-COBOL.
029300   DISPLAY 'Currently this website is written in ' 
029400     WS-PERCENT-COBOL '% COBOL.'.
029500   GOBACK.
029600 SETLANG SECTION.
029700 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
029800   if WS-LANG-SELECT-TOGGLE = 0 THEN
029900     MOVE 1 TO WS-LANG-SELECT-TOGGLE
030000     IF WS-LANG = 'us' THEN
030100       CALL 'cobdom_style' USING 'langES', 'display', 'inline'
030200     ELSE
030300       CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
030400     END-IF
030500   ELSE
030600     MOVE 0 TO WS-LANG-SELECT-TOGGLE
030700     IF WS-COOKIE-ALLOWED = 'y' THEN
030800       IF LS-LANG-CHOICE = 'us' THEN
030900         CALL 'cobdom_set_cookie' USING 'us', 'lang'
031000         MOVE 'us' TO WS-LANG
031100       ELSE
031200         CALL 'cobdom_set_cookie' USING 'es', 'lang'
031300         MOVE 'es' TO WS-LANG
031400       END-IF
031500       PERFORM SET-ACTIVE-FLAG
031600     ELSE
031700       MOVE LS-LANG-CHOICE TO WS-LANG
031800       PERFORM SET-ACTIVE-FLAG 
031900     END-IF
032000   END-IF.
032100   GOBACK.
032200 SETLANGUS SECTION.
032300 ENTRY 'SETLANGUS'.
032400   CALL 'SETLANG' USING 'us'.
032500   GOBACK.
032600 SETLANGES SECTION.
032700 ENTRY 'SETLANGES'.
032800   CALL 'SETLANG' USING 'es'.
032900   GOBACK.
033000*BUILD-MENUBAR.
033100*  CALL 'cobdom_create_element' USING 'menuDiv', 'div'.
033200*  CALL 'cobdom_style' USING 'menuDiv', 'position', 'fixed'.
033300*  CALL 'cobdom_style' USING 'menuDiv', 'display', 'flex'.
033400*  CALL 'cobdom_style' USING 'menuDiv', 'justifyContent', 
033500*    'space-between'.
033600*  CALL 'cobdom_style' USING 'menuDiv', 'top', '0'.
033700*  CALL 'cobdom_style' USING 'menuDiv', 'left', '0'.
033800*  CALL 'cobdom_style' USING 'menuDiv', 'width', '100%'.
033900*  CALL 'cobdom_style' USING 'menuDiv', 'backgroundColor',
034000*    '#919191'.
034100*  CALL 'cobdom_inner_html' USING 'menuDiv', 'Menu'.
034200*  CALL 'cobdom_append_child' USING 'menuDiv', 'body'.
034300*Setup language selector
034400*  CALL 'cobdom_create_element' USING 'langSelector', 'span'.
034500*  CALL 'cobdom_style' USING 'langSelector', 'marginLeft', 'auto'.
034600*  CALL 'cobdom_create_element' USING 'langUS', 'img'.
034700*  CALL 'cobdom_create_element' USING 'langES', 'img'.
034800*  CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
034900*  CALL 'cobdom_style' USING 'langUS', 'width', '3rem'.
035000*  CALL 'cobdom_style' USING 'langUS', 'height', '3rem'.
035100*  CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
035200*  CALL 'cobdom_style' USING 'langES', 'width', '3rem'.
035300*  CALL 'cobdom_style' USING 'langES', 'height', '3rem'.
035400*  CALL 'cobdom_append_child' USING 'langUS', 'langSelector'.
035500*  CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
035600*    'SETLANGUS'.
035700*  CALL 'cobdom_append_child' USING 'langES', 'langSelector'.
035800*  CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
035900*    'SETLANGES'.
036000*  CALL 'cobdom_append_child' USING 'langSelector', 'menuDiv'.
036100*  CONTINUE.
036200 
