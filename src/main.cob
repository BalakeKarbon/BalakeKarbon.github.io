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
002000 01 WS-MENU-TOGGLE PIC 9 VALUE 0.
002100 01 WS-WINDOW.
002200   05 WIDTH PIC 9(5).
002300   05 HEIGHT PIC 9(5).
002400 01 WS-TMP.
002500   05 CENTISECS PIC 9999.
002600   05 PX.
002700     10 NUM PIC -(4)9.
002800     10 TAIL PIC XX VALUE 'px'.
002900     10 NB PIC X(1) VALUE X'00'.
003000 01 WS-BLOB PIC X(100000).
003100 01 WS-BLOB-SIZE PIC 9(10).
003200 01 WS-FONTS-LOADED PIC 9 VALUE 0.
003300*This has to be pic 10 as that is what is returned from
003400*the library.
003500 LINKAGE SECTION.
003600 01 LS-BLOB PIC X(100000).
003700 01 LS-BLOB-SIZE PIC 9(10).
003800 01 LS-LANG-CHOICE PIC XX.
003900 01 LS-TERM-IN PIC X(10).
004000 PROCEDURE DIVISION.
004100 MAIN SECTION.
004200 ENTRY 'MAIN'.
004300   CALL 'cobdom_style' USING 'body', 'margin', '0'.
004400   CALL 'cobdom_style' USING 'body', 'fontSize', '2rem'.
004500   CALL 'cobdom_style' USING 'body', 'display', 'flex'.
004600   CALL 'cobdom_style' USING 'body', 'alignItems', 'center'.
004700   CALL 'cobdom_style' USING 'body', 'justifyContent', 'center'.
004800   CALL 'cobdom_add_event_listener' USING 'window', 'resize', 
004900     'WINDOWCHANGE'.
005000   CALL 'cobdom_add_event_listener' USING 'window', 
005100     'orientationchange', 'WINDOWCHANGE'.
005200   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
005300     'allowCookies'.
005400   CALL 'cobdom_create_element' USING 'percentCobol', 'span'.
005500*  CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
005600*    '/res/percent.txt', 'GET', WS-NULL-BYTE.
005700*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
005800*Setup content div
005900   CALL 'cobdom_create_element' USING 'contentDiv', 'div'.
006000   CALL 'cobdom_style' USING 'contentDiv', 'marginTop', '15rem'.
006100*  CALL 'cobdom_inner_html' USING 'contentDiv', 'TEST CONTENT'.
006200   CALL 'cobdom_style' USING 'contentDiv', 'maxWidth', '80rem'.
006300   CALL 'cobdom_style' USING 'contentDiv', 'width', '100%'.
006400   CALL 'cobdom_style' USING 'contentDiv', 'display', 'flex'.
006500   CALL 'cobdom_style' USING 'contentDiv', 'flexDirection',
006600     'column'.
006700   CALL 'cobdom_style' USING 'contentDiv', 'alignItems',
006800     'flex-start'.
006900   CALL 'cobdom_append_child' USING 'contentDiv', 'body'.
007000*Set up blink style
007100   CALL 'cobdom_create_element' USING 'blinkStyle', 'style'.
007200   CALL 'cobdom_inner_html' USING 'blinkStyle', 
007300 '.blink { animation: blink 1s step-start infinite; } @keyframes b
007400-'link { 50% { opacity: 0; } }'.
007500   PERFORM BUILD-MENUBAR.
007600*Load and set fonts
007700   CALL 'cobdom_font_face' USING 'mainFont',
007800     'url("/res/fonts/Proggy/ProggyVector-Regular.otf")',
007900     'FONTLOADED'.
008000   CALL 'cobdom_font_face' USING 'ibmpc',
008100*    'url("/res/fonts/1977-commodore-pet/PetMe.ttf")',
008200     'url("/res/fonts/1985-ibm-pc-vga/PxPlus_IBM_VGA8.ttf")',
008300     'FONTLOADED'.
008400*Load texts
008500   PERFORM LOAD-TEXTS.
008600*Terminal
008700*  CALL 'cobdom_create_element' USING 'terminalDiv', 'div'.
008800*  CALL 'cobdom_append_child' USING 'terminalDiv', 'contentDiv'.
008900*  CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB,
009000*    '(function() { window["term"] = new Terminal(); window["term"
009100*'].open(window["terminalDiv"]); term.onData(data => { Module.ccal
009200*'l("TERMINPUT", null, ["string"], [data]); }); return ""; })()'.
009300*Check for cookies
009400   IF WS-COOKIE-ALLOWED = 'y' THEN
009500     PERFORM LANG-CHECK
009600*GET LAST LOGIN
009700   ELSE
009800     PERFORM COOKIE-ASK
009900     MOVE 'us' TO WS-LANG
010000     PERFORM SET-ACTIVE-FLAG
010100   END-IF.
010200*Render
010300   CALL 'SHAPEPAGE'.
010400   GOBACK.
010500 RELOAD-TEXT.
010600   CONTINUE.
010700 BUILD-MENUBAR.
010800   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
010900   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
011000   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
011100   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
011200     'space-between'.
011300   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
011400   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
011500   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
011600   CALL 'cobdom_style' USING 'headerDiv', 'backgroundColor',
011700     '#c0c0c0'.
011800*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
011900*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
012000*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
012100*    '1rem'.
012200*  CALL 'cobdom_style' USING 'headerDiv',
012300*    'borderBottomRightRadius','1rem'.
012400   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
012500*Setup menu
012600   CALL 'cobdom_create_element' USING 'navArea', 'div'.
012700*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
012800   CALL 'cobdom_create_element' USING 'navButton', 'img'.
012900   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
013000   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
013100   CALL 'cobdom_src' USING 'navButton', 
013200     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
013300   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
013400   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
013500   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
013600   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
013700   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
013800*Setup menu selectors
013900*Intro
014000   CALL 'cobdom_create_element' USING 'navIntro', 'div'.
014100   CALL 'cobdom_style' USING 'navIntro', 'position', 'absolute'.
014200   CALL 'cobdom_style' USING 'navIntro', 'backgroundColor', 
014300     '#c0c0c0'.
014400   CALL 'cobdom_style' USING 'navIntro', 
014500     'borderBottomRightRadius', '0.5rem'.
014600   CALL 'cobdom_style' USING 'navIntro', 
014700     'borderTopRightRadius', '0.5rem'.
014800   CALL 'cobdom_inner_html' USING 'navIntro', 'Intro'.
014900   CALL 'cobdom_style' USING 'navIntro', 'padding', '.3rem'.
015000   CALL 'cobdom_style' USING 'navIntro', 'top', '9rem'.
015100   CALL 'cobdom_style' USING 'navIntro', 'left', '-15rem'.
015200   CALL 'cobdom_style' USING 'navIntro', 'transition', 
015300     'transform 0.5s ease'.
015400   CALL 'cobdom_append_child' USING 'navIntro', 'headerDiv'.
015500*About Me
015600   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
015700   CALL 'cobdom_style' USING 'navAbout', 'position', 'absolute'.
015800   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
015900     '#c0c0c0'.
016000   CALL 'cobdom_style' USING 'navAbout', 
016100     'borderBottomRightRadius', '0.5rem'.
016200   CALL 'cobdom_style' USING 'navAbout', 
016300     'borderTopRightRadius', '0.5rem'.
016400   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
016500   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
016600   CALL 'cobdom_style' USING 'navAbout', 'top', '12rem'.
016700   CALL 'cobdom_style' USING 'navAbout', 'left', '-15rem'.
016800   CALL 'cobdom_style' USING 'navAbout', 'transition', 
016900     'transform 0.5s ease 0.1s'.
017000   CALL 'cobdom_append_child' USING 'navAbout', 'headerDiv'.
017100*Contact Me
017200   CALL 'cobdom_create_element' USING 'navContact', 'div'.
017300   CALL 'cobdom_style' USING 'navContact', 'position', 'absolute'.
017400   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
017500     '#c0c0c0'.
017600   CALL 'cobdom_style' USING 'navContact', 
017700     'borderBottomRightRadius', '0.5rem'.
017800   CALL 'cobdom_style' USING 'navContact', 
017900     'borderTopRightRadius', '0.5rem'.
018000   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
018100   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
018200   CALL 'cobdom_style' USING 'navContact', 'top', '15rem'.
018300   CALL 'cobdom_style' USING 'navContact', 'left', '-15rem'.
018400   CALL 'cobdom_style' USING 'navContact', 'transition', 
018500     'transform 0.5s ease 0.2s'.
018600   CALL 'cobdom_append_child' USING 'navContact', 'headerDiv'.
018700*Skills
018800   CALL 'cobdom_create_element' USING 'navSkills', 'div'.
018900   CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
019000   CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
019100     '#c0c0c0'.
019200   CALL 'cobdom_style' USING 'navSkills', 
019300     'borderBottomRightRadius', '0.5rem'.
019400   CALL 'cobdom_style' USING 'navSkills', 
019500     'borderTopRightRadius', '0.5rem'.
019600   CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
019700   CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
019800   CALL 'cobdom_style' USING 'navSkills', 'top', '18rem'.
019900   CALL 'cobdom_style' USING 'navSkills', 'left', '-15rem'.
020000   CALL 'cobdom_style' USING 'navSkills', 'transition', 
020100     'transform 0.5s ease 0.3s'.
020200   CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
020300*Projects
020400   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
020500   CALL 'cobdom_style' USING 'navProjects', 'position', 
020600     'absolute'.
020700   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
020800     '#c0c0c0'.
020900   CALL 'cobdom_style' USING 'navProjects', 
021000     'borderBottomRightRadius', '0.5rem'.
021100   CALL 'cobdom_style' USING 'navProjects', 
021200     'borderTopRightRadius', '0.5rem'.
021300   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
021400   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
021500   CALL 'cobdom_style' USING 'navProjects', 'top', '21rem'.
021600   CALL 'cobdom_style' USING 'navProjects', 'left', '-15rem'.
021700   CALL 'cobdom_style' USING 'navProjects', 'transition', 
021800     'transform 0.5s ease 0.4s'.
021900   CALL 'cobdom_append_child' USING 'navProjects', 'headerDiv'.
022000*Cobol?
022100 
022200   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
022300   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
022400   CALL 'cobdom_style' USING 'navCobol', 'position', 
022500     'absolute'.
022600   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
022700     '#000000'.
022800*    '#c0c0c0'.
022900   CALL 'cobdom_style' USING 'navCobol', 'color', 
023000     '#00ff00'.
023100   CALL 'cobdom_style' USING 'navCobol', 
023200     'borderBottomRightRadius', '0.5rem'.
023300   CALL 'cobdom_style' USING 'navCobol', 
023400     'borderTopRightRadius', '0.5rem'.
023500   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
023600   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
023700   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
023800   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
023900   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
024000   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
024100   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
024200   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
024300   CALL 'cobdom_style' USING 'navCobol', 'top', '24rem'.
024400   CALL 'cobdom_style' USING 'navCobol', 'left', '-15rem'.
024500   CALL 'cobdom_style' USING 'navCobol', 'transition', 
024600     'transform 0.5s ease 0.5s'.
024700   CALL 'cobdom_append_child' USING 'navCobol', 'headerDiv'.
024800*Add main menu button
024900   CALL 'cobdom_append_child' USING 'navArea', 'headerDiv'.
025000   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
025100     'MENUTOGGLE'.
025200*Setup ID area
025300   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
025400   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
025500   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
025600   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
025700   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '4rem'.
025800   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
025900   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
026000   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
026100   CALL 'cobdom_inner_html' USING 'taglineDiv', 
026200     'A guy that knows a guy.'.
026300   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
026400   CALL 'cobdom_append_child' USING 'idDiv', 'headerDiv'.
026500*Setup lang area
026600   CALL 'cobdom_create_element' USING 'langArea', 'span'.
026700   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
026800   CALL 'cobdom_append_child' USING 'langArea', 'headerDiv'.
026900*Setup language selector
027000   CALL 'cobdom_create_element' USING 'langUS', 'img'.
027100   CALL 'cobdom_create_element' USING 'langES', 'img'.
027200   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
027300   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
027400   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
027500   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
027600   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
027700   CALL 'cobdom_style' USING 'langUS', 'transition', 
027800     'opacity 0.5s ease, transform 0.5s ease'.
027900   CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
028000     '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
028100   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
028200   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
028300   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
028400   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
028500   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
028600   CALL 'cobdom_style' USING 'langES', 'transition', 
028700     'opacity 0.5s ease, transform 0.5s ease'.
028800   CALL 'cobdom_style' USING 'langES', 'boxShadow', 
028900     '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
029000   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
029100   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
029200     'SETLANGUS'.
029300   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
029400   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
029500     'SETLANGES'.
029600   CONTINUE.
029700 SET-ACTIVE-FLAG.
029800   IF WS-LANG = 'us' THEN
029900     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
030000     CALL 'cobdom_style' USING 'langUS', 'transform', 
030100       'translate(9rem, 0rem)'
030200     PERFORM UPDATE-TEXT
030300   ELSE
030400     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
030500     CALL 'cobdom_style' USING 'langUS', 'transform', 
030600       'translate(9rem, 0rem)'
030700     PERFORM UPDATE-TEXT
030800   END-IF.
030900   CONTINUE.
031000 LOAD-TEXTS.
031100   CONTINUE.
031200 UPDATE-TEXT.
031300   CONTINUE.
031400 LANG-CHECK.
031500   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
031600     'lang'.
031700   IF WS-LANG = WS-NULL-BYTE THEN
031800     CALL 'cobdom_set_cookie' USING 'us', 'lang'
031900     MOVE 'us' TO WS-LANG
032000   END-IF.
032100   PERFORM SET-ACTIVE-FLAG.
032200   CONTINUE.
032300 COOKIE-ASK.
032400   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
032500   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
032600   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
032700   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
032800   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
032900   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
033000     '#00ff00'.
033100   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
033200     'center'.
033300   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
033400-'llow cookies to store your preferences such as language?&nbsp;'.
033500   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
033600   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
033700   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
033800   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
033900   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
034000   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
034100   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
034200   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
034300   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
034400   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
034500   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
034600   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
034700   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
034800     'COOKIEACCEPT'.
034900   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
035000     'COOKIEDENY'.
035100   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
035200   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
035300   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
035400*Note this must be called after the elements are added to the
035500*document because it must search for them.
035600   CALL 'cobdom_class_style' USING 'cookieButton', 
035700     'backgroundColor', '#ff0000'.
035800   CONTINUE.
035900 MENUTOGGLE SECTION.
036000 ENTRY 'MENUTOGGLE'.
036100   IF WS-MENU-TOGGLE = 0 THEN
036200     MOVE 1 TO WS-MENU-TOGGLE
036300     CALL 'cobdom_style' USING 'navIntro', 'transform', 
036400       'translate(15rem, 0rem)'
036500     CALL 'cobdom_style' USING 'navAbout', 'transform', 
036600       'translate(15rem, 0rem)' 
036700     CALL 'cobdom_style' USING 'navContact', 'transform', 
036800       'translate(15rem, 0rem)' 
036900     CALL 'cobdom_style' USING 'navSkills', 'transform', 
037000       'translate(15rem, 0rem)'
037100    CALL 'cobdom_style' USING 'navProjects', 'transform', 
037200       'translate(15rem, 0rem)'
037300    CALL 'cobdom_style' USING 'navCobol', 'transform', 
037400       'translate(15rem, 0rem)'
037500   ELSE
037600     MOVE 0 TO WS-MENU-TOGGLE
037700     CALL 'cobdom_style' USING 'navIntro', 'transform', 
037800       'translate(0rem, 0rem)'
037900     CALL 'cobdom_style' USING 'navAbout', 'transform', 
038000       'translate(0rem, 0rem)' 
038100     CALL 'cobdom_style' USING 'navContact', 'transform', 
038200       'translate(0rem, 0rem)' 
038300     CALL 'cobdom_style' USING 'navSkills', 'transform', 
038400       'translate(0rem, 0rem)'
038500    CALL 'cobdom_style' USING 'navProjects', 'transform', 
038600       'translate(0rem, 0rem)'
038700    CALL 'cobdom_style' USING 'navCobol', 'transform', 
038800       'translate(0rem, 0rem)'
038900   END-IF.
039000   GOBACK.
039100*TO-DO: Add a timer in case some fonts do never load
039200 FONTLOADED SECTION.
039300 ENTRY 'FONTLOADED'.
039400   ADD 1 TO WS-FONTS-LOADED.
039500   IF WS-FONTS-LOADED = 2 THEN
039600     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
039700     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
039800   END-IF.
039900   GOBACK.
040000 WINDOWCHANGE SECTION.
040100 ENTRY 'WINDOWCHANGE'.
040200   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
040300   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
040400     '300'.
040500*Optimize this buffer time to not have a noticeable delay but also
040600*not call to often.
040700   GOBACK.
040800 SHAPEPAGE SECTION.
040900 ENTRY 'SHAPEPAGE'.
041000*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
041100*  DISPLAY 'Rendering! ' CENTISECS.
041200   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
041300     'window.innerWidth'.
041400   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
041500   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
041600     'window.innerHeight'.
041700   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
041800   GOBACK.
041900 COOKIEACCEPT SECTION.
042000 ENTRY 'COOKIEACCEPT'.
042100   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
042200   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
042300   MOVE 'y' TO WS-COOKIE-ALLOWED.
042400   GOBACK.
042500 COOKIEDENY SECTION.
042600 ENTRY 'COOKIEDENY'.
042700   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
042800   MOVE 'n' TO WS-COOKIE-ALLOWED.
042900   GOBACK.
043000 SETPERCENTCOBOL SECTION.
043100 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
043200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
043300   CALL 'cobdom_inner_html' USING 'percentCobol',
043400     WS-PERCENT-COBOL.
043500   DISPLAY 'Currently this website is written in ' 
043600     WS-PERCENT-COBOL '% COBOL.'.
043700   GOBACK.
043800 SETLANG SECTION.
043900 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
044000   if WS-LANG-SELECT-TOGGLE = 0 THEN
044100     MOVE 1 TO WS-LANG-SELECT-TOGGLE
044200     IF WS-LANG = 'us' THEN
044300       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
044400       CALL 'cobdom_style' USING 'langUS', 'transform', 
044500         'translate(0rem, 0rem)'
044600*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
044700     ELSE
044800       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
044900       CALL 'cobdom_style' USING 'langUS', 'transform', 
045000         'translate(0rem, 0rem)'
045100*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
045200     END-IF
045300   ELSE
045400     MOVE 0 TO WS-LANG-SELECT-TOGGLE
045500     IF WS-COOKIE-ALLOWED = 'y' THEN
045600       IF LS-LANG-CHOICE = 'us' THEN
045700         CALL 'cobdom_set_cookie' USING 'us', 'lang'
045800         MOVE 'us' TO WS-LANG
045900       ELSE
046000         CALL 'cobdom_set_cookie' USING 'es', 'lang'
046100         MOVE 'es' TO WS-LANG
046200       END-IF
046300       PERFORM SET-ACTIVE-FLAG
046400     ELSE
046500       MOVE LS-LANG-CHOICE TO WS-LANG
046600       PERFORM SET-ACTIVE-FLAG 
046700     END-IF
046800   END-IF.
046900   GOBACK.
047000 SETLANGUS SECTION.
047100 ENTRY 'SETLANGUS'.
047200   CALL 'SETLANG' USING 'us'.
047300   GOBACK.
047400 SETLANGES SECTION.
047500 ENTRY 'SETLANGES'.
047600   CALL 'SETLANG' USING 'es'.
047700   GOBACK.
047800*TERMINPUT SECTION.
047900*ENTRY 'TERMINPUT' USING LS-TERM-IN.
048000*  DISPLAY LS-TERM-IN.
048100*  GOBACK.
