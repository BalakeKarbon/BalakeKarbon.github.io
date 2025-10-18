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
005500 01 WS-STACKS.
005600   05 STACK OCCURS 8 TIMES.
005700*Where the stack is stored.
005800     10 OFFSET-X PIC 9(5).
005900     10 OFFSET-Y PIC 9(5).
006000 01 WS-READER.
006100   05 CURRENT-TAPE PIC 99.
006200   05 STATE PIC X.
006300   05 CARD-IN.
006400     10 OFFSET-Y PIC 9(5).
006500     10 OFFSET-X PIC 9(5).
006600   05 CARD-OUT.
006700     10 OFFSET-Y PIC 9(5).
006800     10 OFFSET-X PIC 9(5).
006900 01 WS-BLOB PIC X(100000).
007000 01 WS-BLOB-SIZE PIC 9(10).
007100*This has to be pic 10 as that is what is returned from
007200*the library.
007300 LINKAGE SECTION.
007400 01 LS-BLOB PIC X(100000).
007500 01 LS-BLOB-SIZE PIC 9(10).
007600 01 LS-LANG-CHOICE PIC XX.
007700 PROCEDURE DIVISION.
007800 EXAMPLE SECTION.
007900 ENTRY 'MAIN'.
008000   CALL 'cobdom_style' USING 'body', 'margin', '0'.
008100   CALL 'cobdom_style' USING 'body', 'fontSize', '4rem'.
008200   CALL 'cobdom_style' USING 'body', 'display', 'flex'.
008300   CALL 'cobdom_style' USING 'body', 'alignItems', 'center'.
008400   CALL 'cobdom_style' USING 'body', 'justifyContent', 'center'.
008500   CALL 'cobdom_add_event_listener' USING 'window', 'resize', 
008600     'WINDOWCHANGE'.
008700   CALL 'cobdom_add_event_listener' USING 'window', 
008800     'orientationchange', 'WINDOWCHANGE'.
008900   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
009000     'allowCookies'.
009100   CALL 'cobdom_create_element' USING 'percentCobol', 'span'.
009200   CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
009300     '/res/percent.txt', 'GET', WS-NULL-BYTE.
009400*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
009500*Set main area (container)
009600   CALL 'cobdom_create_element' USING 'mainArea', 'div'.
009700   CALL 'cobdom_style' USING 'mainArea', 'position', 'relative'.
009800   CALL 'cobdom_style' USING 'mainArea', 'backgroundColor', 
009900     '#0000ff'.
010000   CALL 'cobdom_append_child' USING 'mainArea', 'body'.
010100*Set up termArea
010200   CALL 'cobdom_create_element' USING 'termArea', 'div'.
010300   CALL 'cobdom_style' USING 'termArea', 'position', 'absolute'.
010400   CALL 'cobdom_style' USING 'termArea', 'bottom', '0'.
010500   CALL 'cobdom_style' USING 'termArea', 'left', '0'.
010600   CALL 'cobdom_style' USING 'termArea', 'backgroundColor',
010700     '#008e0e'.
010800*  CALL 'cobdom_inner_html' USING 'termArea', 'TERM'.
010900   CALL 'cobdom_append_child' USING 'termArea', 'mainArea'.
011000*Set up storageArea
011100   CALL 'cobdom_create_element' USING 'storageArea', 'img'.
011200   CALL 'cobdom_src' USING 'storageArea', 'res/img/storage.svg'.
011300   CALL 'cobdom_style' USING 'storageArea', 'pointerEvents', 
011400     'none'.
011500   CALL 'cobdom_style' USING 'storageArea', 'position', 
011600     'absolute'.
011700   CALL 'cobdom_style' USING 'storageArea', 'backgroundColor', 
011800     '#755217'
011900   CALL 'cobdom_inner_html' USING 'storageArea', 'STORAGE'.
012000   CALL 'cobdom_append_child' USING 'storageArea', 'mainArea'.
012100*Set up readerArea
012200   CALL 'cobdom_create_element' USING 'readerArea', 'img'.
012300   CALL 'cobdom_src' USING 'readerArea', 'res/img/reader.svg'.
012400   CALL 'cobdom_style' USING 'readerArea', 'pointerEvents', 
012500     'none'.
012600   CALL 'cobdom_style' USING 'readerArea', 'overflow', 'visible'.
012700   CALL 'cobdom_style' USING 'readerArea', 'position', 'absolute'.
012800   CALL 'cobdom_style' USING 'readerArea', 'backgroundColor',
012900     '#4c4c4c'.
013000   CALL 'cobdom_inner_html' USING 'readerArea', 'READER'.
013100   CALL 'cobdom_append_child' USING 'readerArea', 'mainArea'.
013200*Check for cookies
013300   IF WS-COOKIE-ALLOWED = 'y' THEN
013400     PERFORM LANG-CHECK
013500   ELSE
013600     PERFORM COOKIE-ASK
013700     MOVE 'us' TO WS-LANG
013800     PERFORM SET-ACTIVE-FLAG
013900   END-IF.
014200*Render
014100   CALL 'SHAPEPAGE'.
014200   GOBACK.
014300 SET-ACTIVE-FLAG.
014400   IF WS-LANG = 'us' THEN
014500     CALL 'cobdom_style' USING 'langES', 'display', 'none'
014600   ELSE
014700     CALL 'cobdom_style' USING 'langUS', 'display', 'none'
014800   END-IF.
014900   CONTINUE.
015000 LANG-CHECK.
015100   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
015200     'lang'.
015300   IF WS-LANG = WS-NULL-BYTE THEN
015400     CALL 'cobdom_set_cookie' USING 'us', 'lang'
015500     MOVE 'us' TO WS-LANG
015600   END-IF.
015700   PERFORM SET-ACTIVE-FLAG.
015800   CONTINUE.
015900 COOKIE-ASK.
016000   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
016100   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
016200   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
016300   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
016400   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
016500   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
016600     '#00ff00'.
016700   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
016800     'center'.
016900   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
017000-'llow cookies to store your preferences such as language?&nbsp;'.
017100   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
017200   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
017300   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes&nbsp;'.
017400   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
017500   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
017600   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
017700   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
017800     'COOKIEACCEPT'.
017900   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
018000     'COOKIEDENY'.
018100   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
018200   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
018300   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
018400*Note this must be called after the elements are added to the
018500*document because it must search for them.
018600   CALL 'cobdom_class_style' USING 'cookieButton', 
018700     'backgroundColor', '#ff0000'.
018800   CONTINUE.
018900 WINDOWCHANGE SECTION.
019000 ENTRY 'WINDOWCHANGE'.
019100   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
019200   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
019300     '300'.
019400*Optimize this buffer time to not have a noticeable delay but also
019500*not call to often.
019600   GOBACK.
019700 SHAPEPAGE SECTION.
019800 ENTRY 'SHAPEPAGE'.
019900*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
020000*  DISPLAY 'Rendering! ' CENTISECS.
020100   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
020200     'window.innerWidth'.
020300   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
020400   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
020500     'window.innerHeight'.
020600   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
020700   IF (WIDTH OF WS-WINDOW / 2) < HEIGHT OF WS-WINDOW THEN
020800*Horizontal render area
020900     MOVE 'h' TO ORIENTATION OF MAIN OF WS-AREAS
021000*Get dimensions of main area
021100     MOVE WIDTH OF WS-WINDOW TO WIDTH OF MAIN OF WS-AREAS
021200     COMPUTE HEIGHT OF MAIN OF WS-AREAS = 
021300       (WIDTH OF MAIN OF WS-AREAS / 4) * 5
021400*Get dimensions of term area
021500     MOVE WIDTH OF WS-WINDOW TO WIDTH OF TERM OF WS-AREAS
021600     COMPUTE HEIGHT OF TERM OF WS-AREAS =
021700       (WIDTH OF TERM OF WS-AREAS / 4) * 3
021800*Get dimensions and reader
021900     COMPUTE WIDTH OF READER OF WS-AREAS =
022000       WIDTH OF TERM OF WS-AREAS / 2
022100     COMPUTE HEIGHT OF READER OF WS-AREAS =
022200       HEIGHT OF TERM OF WS-AREAS / 3
022300*Get dimensions of storage
022400     MOVE WIDTH OF READER OF WS-AREAS TO
022500       WIDTH OF STORAGE OF WS-AREAS
022600     COMPUTE HEIGHT OF STORAGE OF WS-AREAS =
022700       HEIGHT OF READER OF WS-AREAS * 2
022800*Get offsets of reader
022900     MOVE 0 TO OFFSET-X OF READER OF WS-AREAS
023000     COMPUTE OFFSET-Y OF READER OF WS-AREAS =
023100       HEIGHT OF TERM OF WS-AREAS
023200*Get offsets of storage
023300     MOVE WIDTH OF READER OF WS-AREAS TO 
023400       OFFSET-X OF STORAGE OF WS-AREAS
023500     MOVE OFFSET-Y OF READER OF WS-AREAS TO 
023600       OFFSET-Y OF STORAGE OF WS-AREAS
023700   ELSE
023800*Vertical render area
023900     MOVE 'v' TO ORIENTATION OF MAIN OF WS-AREAS
024000*Get dimensions of main area
024100     MOVE HEIGHT OF WS-WINDOW TO HEIGHT OF MAIN OF WS-AREAS
024200     COMPUTE WIDTH OF MAIN OF WS-AREAS =
024300       HEIGHT OF MAIN OF WS-AREAS * 2
024400*Get dimensions of term area
024500     MOVE HEIGHT OF WS-WINDOW TO HEIGHT OF TERM OF WS-AREAS
024600     COMPUTE WIDTH OF TERM OF WS-AREAS =
024700       (HEIGHT OF MAIN OF WS-AREAS / 3) * 4
024800*Get dimensions and reader
024900     COMPUTE WIDTH OF READER OF WS-AREAS =
025000       WIDTH OF TERM OF WS-AREAS / 2
025100     COMPUTE HEIGHT OF READER OF WS-AREAS =
025200       HEIGHT OF TERM OF WS-AREAS / 3
025300*Get dimensions of storage
025400     MOVE WIDTH OF READER OF WS-AREAS TO
025500       WIDTH OF STORAGE OF WS-AREAS
025600     COMPUTE HEIGHT OF STORAGE OF WS-AREAS =
025700       HEIGHT OF READER OF WS-AREAS * 2
025800*Get offsets of reader
025900     MOVE WIDTH OF TERM OF WS-AREAS TO
026000       OFFSET-X OF READER OF WS-AREAS
026100     MOVE 0 TO OFFSET-Y OF READER OF WS-AREAS
026200*Get offsets of storage
026300     MOVE WIDTH OF TERM OF WS-AREAS TO
026400       OFFSET-X OF STORAGE OF WS-AREAS
026500     MOVE HEIGHT OF READER OF WS-AREAS TO
026600       OFFSET-Y OF STORAGE OF WS-AREAS
026700   END-IF.
026800*Size main area
026900   MOVE WIDTH OF MAIN OF WS-AREAS TO NUM OF PX OF WS-TMP.
027000   CALL 'cobdom_style' USING 'mainArea', 'width', PX OF WS-TMP.
027100   MOVE HEIGHT OF MAIN OF WS-AREAS TO NUM OF PX OF WS-TMP.
027200   CALL 'cobdom_style' USING 'mainArea', 'height', PX OF WS-TMP.
027300*Size term area
027400   MOVE WIDTH OF TERM OF WS-AREAS TO NUM OF PX OF WS-TMP.
027500   CALL 'cobdom_style' USING 'termArea', 'width', PX OF WS-TMP.
027600   MOVE HEIGHT OF TERM OF WS-AREAS TO NUM OF PX OF WS-TMP.
027700   CALL 'cobdom_style' USING 'termArea', 'height', PX OF WS-TMP.
027800*Size and position reader area
027900   MOVE WIDTH OF READER OF WS-AREAS TO NUM OF PX OF WS-TMP.
028000   CALL 'cobdom_style' USING 'readerArea', 'width', PX OF WS-TMP.
028100   MOVE HEIGHT OF READER OF WS-AREAS TO NUM OF PX OF WS-TMP.
028200   CALL 'cobdom_style' USING 'readerArea', 'height', PX OF WS-TMP.
028300   MOVE OFFSET-X OF READER OF WS-AREAS TO NUM OF PX OF WS-TMP.
028400   CALL 'cobdom_style' USING 'readerArea', 'left', PX OF WS-TMP.
028500   MOVE OFFSET-Y OF READER OF WS-AREAS TO NUM OF PX OF WS-TMP.
028600   CALL 'cobdom_style' USING 'readerArea', 'bottom', PX OF WS-TMP.
028700*Size and position storage area
028800   MOVE WIDTH OF STORAGE OF WS-AREAS TO NUM OF PX OF WS-TMP.
028900   CALL 'cobdom_style' USING 'storageArea', 'width', PX OF WS-TMP.
029000   MOVE HEIGHT OF STORAGE OF WS-AREAS TO NUM OF PX OF WS-TMP.
029100   CALL 'cobdom_style' USING 'storageArea', 'height', 
029200     PX OF WS-TMP.
029300   MOVE OFFSET-X OF STORAGE OF WS-AREAS TO NUM OF PX OF WS-TMP.
029400   CALL 'cobdom_style' USING 'storageArea', 'left', PX OF WS-TMP.
029500   MOVE OFFSET-Y OF STORAGE OF WS-AREAS TO NUM OF PX OF WS-TMP.
029600   CALL 'cobdom_style' USING 'storageArea', 'bottom', 
029700     PX OF WS-TMP.
029800   GOBACK.
029900 COOKIEACCEPT SECTION.
030000 ENTRY 'COOKIEACCEPT'.
030100   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
030200   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
030300   MOVE 'y' TO WS-COOKIE-ALLOWED.
030400   GOBACK.
030500 COOKIEDENY SECTION.
030600 ENTRY 'COOKIEDENY'.
030700   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
030800   MOVE 'n' TO WS-COOKIE-ALLOWED.
030900   GOBACK.
031000 SETPERCENTCOBOL SECTION.
031100 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
031200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
031300   CALL 'cobdom_inner_html' USING 'percentCobol',
031400     WS-PERCENT-COBOL.
031500   DISPLAY 'Currently this website is written in ' 
031600     WS-PERCENT-COBOL '% COBOL.'.
031700   GOBACK.
031800 SETLANG SECTION.
031900 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
032000   if WS-LANG-SELECT-TOGGLE = 0 THEN
032100     MOVE 1 TO WS-LANG-SELECT-TOGGLE
032200     IF WS-LANG = 'us' THEN
032300       CALL 'cobdom_style' USING 'langES', 'display', 'inline'
032400     ELSE
032500       CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
032600     END-IF
032700   ELSE
032800     MOVE 0 TO WS-LANG-SELECT-TOGGLE
032900     IF WS-COOKIE-ALLOWED = 'y' THEN
033000       IF LS-LANG-CHOICE = 'us' THEN
033100         CALL 'cobdom_set_cookie' USING 'us', 'lang'
033200         MOVE 'us' TO WS-LANG
033300       ELSE
033400         CALL 'cobdom_set_cookie' USING 'es', 'lang'
033500         MOVE 'es' TO WS-LANG
033600       END-IF
033700       PERFORM SET-ACTIVE-FLAG
033800     ELSE
033900       MOVE LS-LANG-CHOICE TO WS-LANG
034000       PERFORM SET-ACTIVE-FLAG 
034100     END-IF
034200   END-IF.
034300   GOBACK.
034400 SETLANGUS SECTION.
034500 ENTRY 'SETLANGUS'.
034600   CALL 'SETLANG' USING 'us'.
034700   GOBACK.
034800 SETLANGES SECTION.
034900 ENTRY 'SETLANGES'.
035000   CALL 'SETLANG' USING 'es'.
035100   GOBACK.
035200*BUILD-MENUBAR.
035300*  CALL 'cobdom_create_element' USING 'menuDiv', 'div'.
035400*  CALL 'cobdom_style' USING 'menuDiv', 'position', 'fixed'.
035500*  CALL 'cobdom_style' USING 'menuDiv', 'display', 'flex'.
035600*  CALL 'cobdom_style' USING 'menuDiv', 'justifyContent', 
035700*    'space-between'.
035800*  CALL 'cobdom_style' USING 'menuDiv', 'top', '0'.
035900*  CALL 'cobdom_style' USING 'menuDiv', 'left', '0'.
036000*  CALL 'cobdom_style' USING 'menuDiv', 'width', '100%'.
036100*  CALL 'cobdom_style' USING 'menuDiv', 'backgroundColor',
036200*    '#919191'.
036300*  CALL 'cobdom_inner_html' USING 'menuDiv', 'Menu'.
036400*  CALL 'cobdom_append_child' USING 'menuDiv', 'body'.
036500*Setup language selector
036600*  CALL 'cobdom_create_element' USING 'langSelector', 'span'.
036700*  CALL 'cobdom_style' USING 'langSelector', 'marginLeft', 'auto'.
036800*  CALL 'cobdom_create_element' USING 'langUS', 'img'.
036900*  CALL 'cobdom_create_element' USING 'langES', 'img'.
037000*  CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
037100*  CALL 'cobdom_style' USING 'langUS', 'width', '3rem'.
037200*  CALL 'cobdom_style' USING 'langUS', 'height', '3rem'.
037300*  CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
037400*  CALL 'cobdom_style' USING 'langES', 'width', '3rem'.
037500*  CALL 'cobdom_style' USING 'langES', 'height', '3rem'.
037600*  CALL 'cobdom_append_child' USING 'langUS', 'langSelector'.
037700*  CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
037800*    'SETLANGUS'.
037900*  CALL 'cobdom_append_child' USING 'langES', 'langSelector'.
038000*  CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
038100*    'SETLANGES'.
038200*  CALL 'cobdom_append_child' USING 'langSelector', 'menuDiv'.
038300*  CONTINUE.
038400 
