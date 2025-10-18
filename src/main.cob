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
009400*  CALL 'cobdom_inner_html' USING 'termArea', 'TERM'.
009500   CALL 'cobdom_append_child' USING 'termArea', 'mainArea'.
009600*Set up storageArea
009700   CALL 'cobdom_create_element' USING 'storageArea', 'img'.
009800   CALL 'cobdom_src' USING 'storageArea', 'res/img/storage.svg'.
009900   CALL 'cobdom_style' USING 'storageArea', 'pointerEvents', 
010000     'none'.
010100   CALL 'cobdom_style' USING 'storageArea', 'position', 
010200     'absolute'.
010300   CALL 'cobdom_style' USING 'storageArea', 'backgroundColor', 
010400     '#755217'
010500   CALL 'cobdom_inner_html' USING 'storageArea', 'STORAGE'.
010600   CALL 'cobdom_append_child' USING 'storageArea', 'mainArea'.
010700   IF WS-COOKIE-ALLOWED = 'y' THEN
010800     PERFORM LANG-CHECK
010900   ELSE
011000     PERFORM COOKIE-ASK
011100     MOVE 'us' TO WS-LANG
011200     PERFORM SET-ACTIVE-FLAG
011300   END-IF.
011400*Set up readerArea
011500   CALL 'cobdom_create_element' USING 'readerArea', 'img'.
011600   CALL 'cobdom_src' USING 'readerArea', 'res/img/reader.svg'.
011700   CALL 'cobdom_style' USING 'readerArea', 'pointerEvents', 
011800     'none'.
011900   CALL 'cobdom_style' USING 'readerArea', 'overflow', 'visible'.
012000   CALL 'cobdom_style' USING 'readerArea', 'position', 'absolute'.
012100   CALL 'cobdom_style' USING 'readerArea', 'backgroundColor',
012200     '#4c4c4c'.
012300   CALL 'cobdom_inner_html' USING 'readerArea', 'READER'.
012400   CALL 'cobdom_append_child' USING 'readerArea', 'mainArea'.
012500*Render
012600   CALL 'SHAPEPAGE'.
012700   GOBACK.
012800 SET-ACTIVE-FLAG.
012900   IF WS-LANG = 'us' THEN
013000     CALL 'cobdom_style' USING 'langES', 'display', 'none'
013100   ELSE
013200     CALL 'cobdom_style' USING 'langUS', 'display', 'none'
013300   END-IF.
013400   CONTINUE.
013500 LANG-CHECK.
013600   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
013700     'lang'.
013800   IF WS-LANG = WS-NULL-BYTE THEN
013900     CALL 'cobdom_set_cookie' USING 'us', 'lang'
014000     MOVE 'us' TO WS-LANG
014100   END-IF.
014200   PERFORM SET-ACTIVE-FLAG.
014300   CONTINUE.
014400 COOKIE-ASK.
014500   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
014600   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
014700   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
014800   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
014900   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
015000   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
015100     '#00ff00'.
015200   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
015300     'center'.
015400   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
015500-'llow cookies to store your preferences such as language?&nbsp;'.
015600   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
015700   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
015800   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes&nbsp;'.
015900   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
016000   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
016100   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
016200   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
016300     'COOKIEACCEPT'.
016400   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
016500     'COOKIEDENY'.
016600   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
016700   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
016800   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
016900*Note this must be called after the elements are added to the
017000*document because it must search for them.
017100   CALL 'cobdom_class_style' USING 'cookieButton', 
017200     'backgroundColor', '#ff0000'.
017300   CONTINUE.
017400 WINDOWCHANGE SECTION.
017500 ENTRY 'WINDOWCHANGE'.
017600   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
017700   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
017800     '300'.
017900*Optimize this buffer time to not have a noticeable delay but also
018000*not call to often.
018100   GOBACK.
018200 SHAPEPAGE SECTION.
018300 ENTRY 'SHAPEPAGE'.
018400*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
018500*  DISPLAY 'Rendering! ' CENTISECS.
018600   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
018700     'window.innerWidth'.
018800   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
018900   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
019000     'window.innerHeight'.
019100   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
019200   IF (WIDTH OF WS-WINDOW / 2) < HEIGHT OF WS-WINDOW THEN
019300*Horizontal render area
019400     MOVE 'h' TO ORIENTATION OF MAIN OF WS-AREAS
019500*Get dimensions of main area
019600     MOVE WIDTH OF WS-WINDOW TO WIDTH OF MAIN OF WS-AREAS
019700     COMPUTE HEIGHT OF MAIN OF WS-AREAS = 
019800       (WIDTH OF MAIN OF WS-AREAS / 4) * 5
019900*Get dimensions of term area
020000     MOVE WIDTH OF WS-WINDOW TO WIDTH OF TERM OF WS-AREAS
020100     COMPUTE HEIGHT OF TERM OF WS-AREAS =
020200       (WIDTH OF TERM OF WS-AREAS / 4) * 3
020300*Get dimensions and reader
020400     COMPUTE WIDTH OF READER OF WS-AREAS =
020500       WIDTH OF TERM OF WS-AREAS / 2
020600     COMPUTE HEIGHT OF READER OF WS-AREAS =
020700       HEIGHT OF TERM OF WS-AREAS / 3
020800*Get dimensions of storage
020900     MOVE WIDTH OF READER OF WS-AREAS TO
021000       WIDTH OF STORAGE OF WS-AREAS
021100     COMPUTE HEIGHT OF STORAGE OF WS-AREAS =
021200       HEIGHT OF READER OF WS-AREAS * 2
021300*Get offsets of reader
021400     MOVE 0 TO OFFSET-X OF READER OF WS-AREAS
021500     COMPUTE OFFSET-Y OF READER OF WS-AREAS =
021600       HEIGHT OF TERM OF WS-AREAS
021700*Get offsets of storage
021800     MOVE WIDTH OF READER OF WS-AREAS TO 
021900       OFFSET-X OF STORAGE OF WS-AREAS
022000     MOVE OFFSET-Y OF READER OF WS-AREAS TO 
022100       OFFSET-Y OF STORAGE OF WS-AREAS
022200   ELSE
022300*Vertical render area
022400     MOVE 'v' TO ORIENTATION OF MAIN OF WS-AREAS
022500*Get dimensions of main area
022600     MOVE HEIGHT OF WS-WINDOW TO HEIGHT OF MAIN OF WS-AREAS
022700     COMPUTE WIDTH OF MAIN OF WS-AREAS =
022800       HEIGHT OF MAIN OF WS-AREAS * 2
022900*Get dimensions of term area
023000     MOVE HEIGHT OF WS-WINDOW TO HEIGHT OF TERM OF WS-AREAS
023100     COMPUTE WIDTH OF TERM OF WS-AREAS =
023200       (HEIGHT OF MAIN OF WS-AREAS / 3) * 4
023300*Get dimensions and reader
023400     COMPUTE WIDTH OF READER OF WS-AREAS =
023500       WIDTH OF TERM OF WS-AREAS / 2
023600     COMPUTE HEIGHT OF READER OF WS-AREAS =
023700       HEIGHT OF TERM OF WS-AREAS / 3
023800*Get dimensions of storage
023900     MOVE WIDTH OF READER OF WS-AREAS TO
024000       WIDTH OF STORAGE OF WS-AREAS
024100     COMPUTE HEIGHT OF STORAGE OF WS-AREAS =
024200       HEIGHT OF READER OF WS-AREAS * 2
024300*Get offsets of reader
024400     MOVE WIDTH OF TERM OF WS-AREAS TO
024500       OFFSET-X OF READER OF WS-AREAS
024600     MOVE 0 TO OFFSET-Y OF READER OF WS-AREAS
024700*Get offsets of storage
024800     MOVE WIDTH OF TERM OF WS-AREAS TO
024900       OFFSET-X OF STORAGE OF WS-AREAS
025000     MOVE HEIGHT OF READER OF WS-AREAS TO
025100       OFFSET-Y OF STORAGE OF WS-AREAS
025200   END-IF.
025300*Size main area
025400   MOVE WIDTH OF MAIN OF WS-AREAS TO NUM OF PX OF WS-TMP.
025500   CALL 'cobdom_style' USING 'mainArea', 'width', PX OF WS-TMP.
025600   MOVE HEIGHT OF MAIN OF WS-AREAS TO NUM OF PX OF WS-TMP.
025700   CALL 'cobdom_style' USING 'mainArea', 'height', PX OF WS-TMP.
025800*Size term area
025900   MOVE WIDTH OF TERM OF WS-AREAS TO NUM OF PX OF WS-TMP.
026000   CALL 'cobdom_style' USING 'termArea', 'width', PX OF WS-TMP.
026100   MOVE HEIGHT OF TERM OF WS-AREAS TO NUM OF PX OF WS-TMP.
026200   CALL 'cobdom_style' USING 'termArea', 'height', PX OF WS-TMP.
026300*Size and position reader area
026400   MOVE WIDTH OF READER OF WS-AREAS TO NUM OF PX OF WS-TMP.
026500   CALL 'cobdom_style' USING 'readerArea', 'width', PX OF WS-TMP.
026600   MOVE HEIGHT OF READER OF WS-AREAS TO NUM OF PX OF WS-TMP.
026700   CALL 'cobdom_style' USING 'readerArea', 'height', PX OF WS-TMP.
026800   MOVE OFFSET-X OF READER OF WS-AREAS TO NUM OF PX OF WS-TMP.
026900   CALL 'cobdom_style' USING 'readerArea', 'left', PX OF WS-TMP.
027000   MOVE OFFSET-Y OF READER OF WS-AREAS TO NUM OF PX OF WS-TMP.
027100   CALL 'cobdom_style' USING 'readerArea', 'bottom', PX OF WS-TMP.
027200*Size and position storage area
027300   MOVE WIDTH OF STORAGE OF WS-AREAS TO NUM OF PX OF WS-TMP.
027400   CALL 'cobdom_style' USING 'storageArea', 'width', PX OF WS-TMP.
027500   MOVE HEIGHT OF STORAGE OF WS-AREAS TO NUM OF PX OF WS-TMP.
027600   CALL 'cobdom_style' USING 'storageArea', 'height', 
027700     PX OF WS-TMP.
027800   MOVE OFFSET-X OF STORAGE OF WS-AREAS TO NUM OF PX OF WS-TMP.
027900   CALL 'cobdom_style' USING 'storageArea', 'left', PX OF WS-TMP.
028000   MOVE OFFSET-Y OF STORAGE OF WS-AREAS TO NUM OF PX OF WS-TMP.
028100   CALL 'cobdom_style' USING 'storageArea', 'bottom', 
028200     PX OF WS-TMP.
028300   GOBACK.
028400 COOKIEACCEPT SECTION.
028500 ENTRY 'COOKIEACCEPT'.
028600   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
028700   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
028800   MOVE 'y' TO WS-COOKIE-ALLOWED.
028900   GOBACK.
029000 COOKIEDENY SECTION.
029100 ENTRY 'COOKIEDENY'.
029200   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
029300   MOVE 'n' TO WS-COOKIE-ALLOWED.
029400   GOBACK.
029500 SETPERCENTCOBOL SECTION.
029600 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
029700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
029800   CALL 'cobdom_inner_html' USING 'percentCobol',
029900     WS-PERCENT-COBOL.
030000   DISPLAY 'Currently this website is written in ' 
030100     WS-PERCENT-COBOL '% COBOL.'.
030200   GOBACK.
030300 SETLANG SECTION.
030400 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
030500   if WS-LANG-SELECT-TOGGLE = 0 THEN
030600     MOVE 1 TO WS-LANG-SELECT-TOGGLE
030700     IF WS-LANG = 'us' THEN
030800       CALL 'cobdom_style' USING 'langES', 'display', 'inline'
030900     ELSE
031000       CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
031100     END-IF
031200   ELSE
031300     MOVE 0 TO WS-LANG-SELECT-TOGGLE
031400     IF WS-COOKIE-ALLOWED = 'y' THEN
031500       IF LS-LANG-CHOICE = 'us' THEN
031600         CALL 'cobdom_set_cookie' USING 'us', 'lang'
031700         MOVE 'us' TO WS-LANG
031800       ELSE
031900         CALL 'cobdom_set_cookie' USING 'es', 'lang'
032000         MOVE 'es' TO WS-LANG
032100       END-IF
032200       PERFORM SET-ACTIVE-FLAG
032300     ELSE
032400       MOVE LS-LANG-CHOICE TO WS-LANG
032500       PERFORM SET-ACTIVE-FLAG 
032600     END-IF
032700   END-IF.
032800   GOBACK.
032900 SETLANGUS SECTION.
033000 ENTRY 'SETLANGUS'.
033100   CALL 'SETLANG' USING 'us'.
033200   GOBACK.
033300 SETLANGES SECTION.
033400 ENTRY 'SETLANGES'.
033500   CALL 'SETLANG' USING 'es'.
033600   GOBACK.
033700*BUILD-MENUBAR.
033800*  CALL 'cobdom_create_element' USING 'menuDiv', 'div'.
033900*  CALL 'cobdom_style' USING 'menuDiv', 'position', 'fixed'.
034000*  CALL 'cobdom_style' USING 'menuDiv', 'display', 'flex'.
034100*  CALL 'cobdom_style' USING 'menuDiv', 'justifyContent', 
034200*    'space-between'.
034300*  CALL 'cobdom_style' USING 'menuDiv', 'top', '0'.
034400*  CALL 'cobdom_style' USING 'menuDiv', 'left', '0'.
034500*  CALL 'cobdom_style' USING 'menuDiv', 'width', '100%'.
034600*  CALL 'cobdom_style' USING 'menuDiv', 'backgroundColor',
034700*    '#919191'.
034800*  CALL 'cobdom_inner_html' USING 'menuDiv', 'Menu'.
034900*  CALL 'cobdom_append_child' USING 'menuDiv', 'body'.
035000*Setup language selector
035100*  CALL 'cobdom_create_element' USING 'langSelector', 'span'.
035200*  CALL 'cobdom_style' USING 'langSelector', 'marginLeft', 'auto'.
035300*  CALL 'cobdom_create_element' USING 'langUS', 'img'.
035400*  CALL 'cobdom_create_element' USING 'langES', 'img'.
035500*  CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
035600*  CALL 'cobdom_style' USING 'langUS', 'width', '3rem'.
035700*  CALL 'cobdom_style' USING 'langUS', 'height', '3rem'.
035800*  CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
035900*  CALL 'cobdom_style' USING 'langES', 'width', '3rem'.
036000*  CALL 'cobdom_style' USING 'langES', 'height', '3rem'.
036100*  CALL 'cobdom_append_child' USING 'langUS', 'langSelector'.
036200*  CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
036300*    'SETLANGUS'.
036400*  CALL 'cobdom_append_child' USING 'langES', 'langSelector'.
036500*  CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
036600*    'SETLANGES'.
036700*  CALL 'cobdom_append_child' USING 'langSelector', 'menuDiv'.
036800*  CONTINUE.
036900 
