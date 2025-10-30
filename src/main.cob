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
004400*  CALL 'cobdom_style' USING 'body', 'color', '#ffffff'.
004500   CALL 'cobdom_style' USING 'body', 'fontSize', '2rem'.
004600   CALL 'cobdom_style' USING 'body', 'display', 'flex'.
004700   CALL 'cobdom_style' USING 'body', 'alignItems', 'center'.
004800   CALL 'cobdom_style' USING 'body', 'justifyContent', 'center'.
004900   CALL 'cobdom_add_event_listener' USING 'window', 'resize', 
005000     'WINDOWCHANGE'.
005100   CALL 'cobdom_add_event_listener' USING 'window', 
005200     'orientationchange', 'WINDOWCHANGE'.
005300   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
005400     'allowCookies'.
005500   CALL 'cobdom_create_element' USING 'percentCobol', 'span'.
005600*  CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
005700*    '/res/percent.txt', 'GET', WS-NULL-BYTE.
005800*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
005900*Setup content div
006000   CALL 'cobdom_create_element' USING 'contentDiv', 'div'.
006100   CALL 'cobdom_style' USING 'contentDiv', 'marginTop', '10rem'.
006200*  CALL 'cobdom_inner_html' USING 'contentDiv', 
006300*    'ALL KINDS OF TEST CONTENT HERE WOO HOO I WONER WHAT THIS WIL
006400*'L ALL LOOK LIKE MUAHAHAHAHAHAHAHAHAHHAHA'.
006500   CALL 'cobdom_style' USING 'contentDiv', 'maxWidth', '80rem'.
006600   CALL 'cobdom_style' USING 'contentDiv', 'backgroundColor',
006700     'brown'.
006800   CALL 'cobdom_style' USING 'contentDiv', 'width', '100%'.
006900   CALL 'cobdom_style' USING 'contentDiv', 'height', '100vh'.
007000   CALL 'cobdom_style' USING 'contentDiv', 'display', 'flex'.
007100   CALL 'cobdom_style' USING 'contentDiv', 'flexDirection',
007200     'column'.
007300   CALL 'cobdom_style' USING 'contentDiv', 'alignItems',
007400     'flex-start'.
007500   CALL 'cobdom_append_child' USING 'contentDiv', 'body'.
007600*Set up blink style
007700   CALL 'cobdom_create_element' USING 'blinkStyle', 'style'.
007800   CALL 'cobdom_inner_html' USING 'blinkStyle', 
007900 '.blink { animation: blink 1s step-start infinite; } @keyframes b
008000-'link { 50% { opacity: 0; } }'.
008100   PERFORM BUILD-MENUBAR.
008200   PERFORM BUILD-CONTENT.
008300*Load and set fonts
008400   CALL 'cobdom_font_face' USING 'mainFont',
008500     'url("/res/fonts/Proggy/ProggyVector-Regular.otf")',
008600     'FONTLOADED'.
008700   CALL 'cobdom_font_face' USING 'ibmpc',
008800*    'url("/res/fonts/1977-commodore-pet/PetMe.ttf")',
008900     'url("/res/fonts/1985-ibm-pc-vga/PxPlus_IBM_VGA8.ttf")',
009000     'FONTLOADED'.
009100*Load texts
009200   PERFORM LOAD-TEXTS.
009300*Terminal
009400*  CALL 'cobdom_create_element' USING 'terminalDiv', 'div'.
009500*  CALL 'cobdom_append_child' USING 'terminalDiv', 'contentDiv'.
009600*  CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB,
009700*    '(function() { window["term"] = new Terminal(); window["term"
009800*'].open(window["terminalDiv"]); term.onData(data => { Module.ccal
009900*'l("TERMINPUT", null, ["string"], [data]); }); return ""; })()'.
010000*Check for cookies
010100   IF WS-COOKIE-ALLOWED = 'y' THEN
010200     PERFORM LANG-CHECK
010300*GET LAST LOGIN
010400   ELSE
010500     PERFORM COOKIE-ASK
010600     MOVE 'us' TO WS-LANG
010700     PERFORM SET-ACTIVE-FLAG
010800   END-IF.
010900*Render
011000   CALL 'SHAPEPAGE'.
011100   GOBACK.
011200 RELOAD-TEXT.
011300   CONTINUE.
011400 BUILD-CONTENT.
011500   CALL 'cobdom_create_element' USING 'introSection', 'div'.
011600   CALL 'cobdom_create_element' USING 'introHeader', 'div'.
011700   CALL 'cobdom_create_element' USING 'introContent', 'div'.
011800   CALL 'cobdom_append_child' USING 'introSection',
011900     'contentDiv'.
012000   CALL 'cobdom_append_child' USING 'introHeader', 
012100     'introSection'.
012200   CALL 'cobdom_append_child' USING 'introContent',
012300     'introSection'.
012400   CALL 'cobdom_create_element' USING 'aboutSection', 'div'.
012500   CALL 'cobdom_create_element' USING 'aboutHeader', 'div'.
012600   CALL 'cobdom_create_element' USING 'aboutContent', 'div'.
012700   CALL 'cobdom_append_child' USING 'aboutSection',
012800     'contentDiv'.
012900   CALL 'cobdom_append_child' USING 'aboutHeader',
013000     'aboutSection'.
013100   CALL 'cobdom_append_child' USING 'aboutContent',
013200     'aboutSection'.
013300   CALL 'cobdom_create_element' USING 'contactSection', 'div'.
013400   CALL 'cobdom_create_element' USING 'contactHeader', 'div'.
013500   CALL 'cobdom_create_element' USING 'contactContent', 'div'.
013600   CALL 'cobdom_append_child' USING 'contactSection',
013700     'contentDiv'.
013800   CALL 'cobdom_append_child' USING 'contactHeader',
013900     'contactSection'.
014000   CALL 'cobdom_append_child' USING 'contactContent',
014100     'contactSection'.
014200   CALL 'cobdom_create_element' USING 'skillsSection', 'div'.
014300   CALL 'cobdom_create_element' USING 'skillsHeader', 'div'.
014400   CALL 'cobdom_create_element' USING 'skillsContent', 'div'.
014500   CALL 'cobdom_append_child' USING 'skillsSection',
014600     'contentDiv'.
014700   CALL 'cobdom_append_child' USING 'skillsHeader',
014800     'skillsSection'.
014900   CALL 'cobdom_append_child' USING 'skillsContent',
015000     'skillsSection'.
015100   CALL 'cobdom_create_element' USING 'projectSection', 'div'.
015200   CALL 'cobdom_create_element' USING 'projectHeader', 'div'.
015300   CALL 'cobdom_create_element' USING 'projectContent', 'div'.
015400   CALL 'cobdom_append_child' USING 'projectSection', 
015500     'contentDiv'.
015600   CALL 'cobdom_append_child' USING 'projectHeader', 
015700     'projectSection'.
015800   CALL 'cobdom_append_child' USING 'projectContent', 
015900     'projectSection'.
016000   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
016100   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
016200   CALL 'cobdom_create_element' USING 'cobolContent', 'div'.
016300   CALL 'cobdom_append_child' USING 'cobolSection',
016400     'contentDiv'.
016500   CALL 'cobdom_append_child' USING 'cobolHeader', 
016600     'cobolSection'.
016700   CALL 'cobdom_append_child' USING 'cobolContent', 
016800     'cobolSection'.
016900   CONTINUE.
017000 BUILD-MENUBAR.
017100   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
017200   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
017300   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
017400   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
017500     'space-between'.
017600   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
017700   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
017800   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
017900   CALL 'cobdom_style' USING 'headerDiv', 'backgroundColor',
018000     '#c0c0c0'.
018100*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
018200*    'blur(5px)'.
018300*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
018400*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
018500*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
018600*    '1rem'.
018700*  CALL 'cobdom_style' USING 'headerDiv',
018800*    'borderBottomRightRadius','1rem'.
018900   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
019000*Setup menu
019100   CALL 'cobdom_create_element' USING 'navArea', 'div'.
019200*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
019300   CALL 'cobdom_create_element' USING 'navButton', 'img'.
019400   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
019500   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
019600   CALL 'cobdom_src' USING 'navButton', 
019700     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
019800   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
019900     '#D9D4C7'.
020000*  CALL 'cobdom_style' USING 'navButton', 'filter', 
020100*    'invert(100%)'.
020200   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
020300   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
020400   CALL 'cobdom_style' USING 'navButton', 'padding', '.25rem'.
020500   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
020600   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
020700   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
020800   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
020900*Setup menu selectors
021000*Intro
021100   CALL 'cobdom_create_element' USING 'navIntro', 'div'.
021200   CALL 'cobdom_style' USING 'navIntro', 'position', 'absolute'.
021300   CALL 'cobdom_style' USING 'navIntro', 'backgroundColor', 
021400     '#c0c0c0'.
021500*  CALL 'cobdom_style' USING 'navIntro', 'backdropFilter',
021600*    'blur(5px)'.
021700   CALL 'cobdom_style' USING 'navIntro', 
021800     'borderBottomRightRadius', '0.5rem'.
021900   CALL 'cobdom_style' USING 'navIntro', 
022000     'borderTopRightRadius', '0.5rem'.
022100   CALL 'cobdom_inner_html' USING 'navIntro', 'Intro'.
022200   CALL 'cobdom_style' USING 'navIntro', 'padding', '.3rem'.
022300   CALL 'cobdom_style' USING 'navIntro', 'top', '9rem'.
022400   CALL 'cobdom_style' USING 'navIntro', 'left', '-15rem'.
022500   CALL 'cobdom_style' USING 'navIntro', 'transition', 
022600     'transform 0.5s ease'.
022700   CALL 'cobdom_append_child' USING 'navIntro', 'headerDiv'.
022800*About Me
022900   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
023000   CALL 'cobdom_style' USING 'navAbout', 'position', 'absolute'.
023100   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
023200     '#c0c0c0'.
023300*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
023400*    'blur(5px)'.
023500   CALL 'cobdom_style' USING 'navAbout', 
023600     'borderBottomRightRadius', '0.5rem'.
023700   CALL 'cobdom_style' USING 'navAbout', 
023800     'borderTopRightRadius', '0.5rem'.
023900   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
024000   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
024100   CALL 'cobdom_style' USING 'navAbout', 'top', '12rem'.
024200   CALL 'cobdom_style' USING 'navAbout', 'left', '-15rem'.
024300   CALL 'cobdom_style' USING 'navAbout', 'transition', 
024400     'transform 0.5s ease 0.1s'.
024500   CALL 'cobdom_append_child' USING 'navAbout', 'headerDiv'.
024600*Contact Me
024700   CALL 'cobdom_create_element' USING 'navContact', 'div'.
024800   CALL 'cobdom_style' USING 'navContact', 'position', 'absolute'.
024900   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
025000     '#c0c0c0'.
025100*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
025200*    'blur(5px)'.
025300   CALL 'cobdom_style' USING 'navContact', 
025400     'borderBottomRightRadius', '0.5rem'.
025500   CALL 'cobdom_style' USING 'navContact', 
025600     'borderTopRightRadius', '0.5rem'.
025700   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
025800   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
025900   CALL 'cobdom_style' USING 'navContact', 'top', '15rem'.
026000   CALL 'cobdom_style' USING 'navContact', 'left', '-15rem'.
026100   CALL 'cobdom_style' USING 'navContact', 'transition', 
026200     'transform 0.5s ease 0.2s'.
026300   CALL 'cobdom_append_child' USING 'navContact', 'headerDiv'.
026400*Skills
026500   CALL 'cobdom_create_element' USING 'navSkills', 'div'.
026600   CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
026700   CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
026800     '#c0c0c0'.
026900*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
027000*    'blur(5px)'.
027100   CALL 'cobdom_style' USING 'navSkills', 
027200     'borderBottomRightRadius', '0.5rem'.
027300   CALL 'cobdom_style' USING 'navSkills', 
027400     'borderTopRightRadius', '0.5rem'.
027500   CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
027600   CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
027700   CALL 'cobdom_style' USING 'navSkills', 'top', '18rem'.
027800   CALL 'cobdom_style' USING 'navSkills', 'left', '-15rem'.
027900   CALL 'cobdom_style' USING 'navSkills', 'transition', 
028000     'transform 0.5s ease 0.3s'.
028100   CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
028200*Projects
028300   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
028400   CALL 'cobdom_style' USING 'navProjects', 'position', 
028500     'absolute'.
028600   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
028700     '#c0c0c0'.
028800*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
028900*    'blur(5px)'.
029000   CALL 'cobdom_style' USING 'navProjects', 
029100     'borderBottomRightRadius', '0.5rem'.
029200   CALL 'cobdom_style' USING 'navProjects', 
029300     'borderTopRightRadius', '0.5rem'.
029400   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
029500   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
029600   CALL 'cobdom_style' USING 'navProjects', 'top', '21rem'.
029700   CALL 'cobdom_style' USING 'navProjects', 'left', '-15rem'.
029800   CALL 'cobdom_style' USING 'navProjects', 'transition', 
029900     'transform 0.5s ease 0.4s'.
030000   CALL 'cobdom_append_child' USING 'navProjects', 'headerDiv'.
030100*Cobol?
030200   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
030300   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
030400   CALL 'cobdom_style' USING 'navCobol', 'position', 
030500     'absolute'.
030600   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
030700     '#000000'.
030800*    '#c0c0c0'.
030900*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
031000*    'blur(5px)'.
031100   CALL 'cobdom_style' USING 'navCobol', 'color', 
031200     '#00ff00'.
031300   CALL 'cobdom_style' USING 'navCobol', 
031400     'borderBottomRightRadius', '0.5rem'.
031500   CALL 'cobdom_style' USING 'navCobol', 
031600     'borderTopRightRadius', '0.5rem'.
031700   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
031800   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
031900   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
032000   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
032100   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
032200   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
032300   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
032400   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
032500   CALL 'cobdom_style' USING 'navCobol', 'top', '24rem'.
032600   CALL 'cobdom_style' USING 'navCobol', 'left', '-15rem'.
032700   CALL 'cobdom_style' USING 'navCobol', 'transition', 
032800     'transform 0.5s ease 0.5s'.
032900   CALL 'cobdom_append_child' USING 'navCobol', 'headerDiv'.
033000*Add main menu button
033100   CALL 'cobdom_append_child' USING 'navArea', 'headerDiv'.
033200   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
033300     'MENUTOGGLE'.
033400*Setup ID area
033500   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
033600   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
033700   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
033800   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
033900   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '4rem'.
034000   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
034100   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
034200   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
034300   CALL 'cobdom_inner_html' USING 'taglineDiv', 
034400     'A guy that knows a guy.'.
034500   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
034600   CALL 'cobdom_append_child' USING 'idDiv', 'headerDiv'.
034700*Setup lang area
034800   CALL 'cobdom_create_element' USING 'langArea', 'span'.
034900   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
035000   CALL 'cobdom_append_child' USING 'langArea', 'headerDiv'.
035100*Setup language selector
035200   CALL 'cobdom_create_element' USING 'langUS', 'img'.
035300   CALL 'cobdom_create_element' USING 'langES', 'img'.
035400   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
035500   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
035600   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
035700   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
035800   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
035900   CALL 'cobdom_style' USING 'langUS', 'transition', 
036000     'opacity 0.5s ease, transform 0.5s ease'.
036100*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
036200*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
036300   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
036400   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
036500   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
036600   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
036700   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
036800   CALL 'cobdom_style' USING 'langES', 'transition', 
036900     'opacity 0.5s ease, transform 0.5s ease'.
037000*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
037100*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
037200   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
037300   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
037400     'SETLANGUS'.
037500   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
037600   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
037700     'SETLANGES'.
037800   CONTINUE.
037900 SET-ACTIVE-FLAG.
038000   IF WS-LANG = 'us' THEN
038100     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
038200     CALL 'cobdom_style' USING 'langUS', 'transform', 
038300       'translate(9rem, 0rem)'
038400     PERFORM UPDATE-TEXT
038500   ELSE
038600     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
038700     CALL 'cobdom_style' USING 'langUS', 'transform', 
038800       'translate(9rem, 0rem)'
038900     PERFORM UPDATE-TEXT
039000   END-IF.
039100   CONTINUE.
039200 LOAD-TEXTS.
039300   CONTINUE.
039400 UPDATE-TEXT.
039500   CONTINUE.
039600 LANG-CHECK.
039700   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
039800     'lang'.
039900   IF WS-LANG = WS-NULL-BYTE THEN
040000     CALL 'cobdom_set_cookie' USING 'us', 'lang'
040100     MOVE 'us' TO WS-LANG
040200   END-IF.
040300   PERFORM SET-ACTIVE-FLAG.
040400   CONTINUE.
040500 COOKIE-ASK.
040600   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
040700   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
040800   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
040900   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
041000   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
041100   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
041200     '#00ff00'.
041300   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
041400     'center'.
041500   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
041600-'llow cookies to store your preferences such as language?&nbsp;'.
041700   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
041800   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
041900   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
042000   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
042100   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
042200   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
042300   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
042400   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
042500   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
042600   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
042700   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
042800   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
042900   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
043000     'COOKIEACCEPT'.
043100   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
043200     'COOKIEDENY'.
043300   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
043400   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
043500   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
043600*Note this must be called after the elements are added to the
043700*document because it must search for them.
043800   CALL 'cobdom_class_style' USING 'cookieButton', 
043900     'backgroundColor', '#ff0000'.
044000   CONTINUE.
044100 MENUTOGGLE SECTION.
044200 ENTRY 'MENUTOGGLE'.
044300   IF WS-MENU-TOGGLE = 0 THEN
044400     MOVE 1 TO WS-MENU-TOGGLE
044500     CALL 'cobdom_style' USING 'navButton', 'transform', 
044600       'scale(0.85)'
044700     CALL 'cobdom_src' USING 'navButton', 
044800       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
044900     CALL 'cobdom_style' USING 'navIntro', 'transform', 
045000       'translate(15rem, 0rem)'
045100     CALL 'cobdom_style' USING 'navAbout', 'transform', 
045200       'translate(15rem, 0rem)' 
045300     CALL 'cobdom_style' USING 'navContact', 'transform', 
045400       'translate(15rem, 0rem)' 
045500     CALL 'cobdom_style' USING 'navSkills', 'transform', 
045600       'translate(15rem, 0rem)'
045700    CALL 'cobdom_style' USING 'navProjects', 'transform', 
045800       'translate(15rem, 0rem)'
045900    CALL 'cobdom_style' USING 'navCobol', 'transform', 
046000       'translate(15rem, 0rem)'
046100   ELSE
046200     MOVE 0 TO WS-MENU-TOGGLE
046300     CALL 'cobdom_style' USING 'navButton', 'transform', 
046400       'scale(1.0)'
046500     CALL 'cobdom_src' USING 'navButton', 
046600       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
046700     CALL 'cobdom_style' USING 'navIntro', 'transform', 
046800       'translate(0rem, 0rem)'
046900     CALL 'cobdom_style' USING 'navAbout', 'transform', 
047000       'translate(0rem, 0rem)' 
047100     CALL 'cobdom_style' USING 'navContact', 'transform', 
047200       'translate(0rem, 0rem)' 
047300     CALL 'cobdom_style' USING 'navSkills', 'transform', 
047400       'translate(0rem, 0rem)'
047500    CALL 'cobdom_style' USING 'navProjects', 'transform', 
047600       'translate(0rem, 0rem)'
047700    CALL 'cobdom_style' USING 'navCobol', 'transform', 
047800       'translate(0rem, 0rem)'
047900   END-IF.
048000   GOBACK.
048100*TO-DO: Add a timer in case some fonts do never load
048200 FONTLOADED SECTION.
048300 ENTRY 'FONTLOADED'.
048400   ADD 1 TO WS-FONTS-LOADED.
048500   IF WS-FONTS-LOADED = 2 THEN
048600     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
048700     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
048800   END-IF.
048900   GOBACK.
049000 WINDOWCHANGE SECTION.
049100 ENTRY 'WINDOWCHANGE'.
049200   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
049300   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
049400     '300'.
049500*Optimize this buffer time to not have a noticeable delay but also
049600*not call to often.
049700   GOBACK.
049800 SHAPEPAGE SECTION.
049900 ENTRY 'SHAPEPAGE'.
050000*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
050100*  DISPLAY 'Rendering! ' CENTISECS.
050200   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
050300     'window.innerWidth'.
050400   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
050500   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
050600     'window.innerHeight'.
050700   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
050800   GOBACK.
050900 COOKIEACCEPT SECTION.
051000 ENTRY 'COOKIEACCEPT'.
051100   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
051200   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
051300   MOVE 'y' TO WS-COOKIE-ALLOWED.
051400   GOBACK.
051500 COOKIEDENY SECTION.
051600 ENTRY 'COOKIEDENY'.
051700   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
051800   MOVE 'n' TO WS-COOKIE-ALLOWED.
051900   GOBACK.
052000 SETPERCENTCOBOL SECTION.
052100 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
052200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
052300   CALL 'cobdom_inner_html' USING 'percentCobol',
052400     WS-PERCENT-COBOL.
052500   DISPLAY 'Currently this website is written in ' 
052600     WS-PERCENT-COBOL '% COBOL.'.
052700   GOBACK.
052800 SETLANG SECTION.
052900 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
053000   if WS-LANG-SELECT-TOGGLE = 0 THEN
053100     MOVE 1 TO WS-LANG-SELECT-TOGGLE
053200     IF WS-LANG = 'us' THEN
053300       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
053400       CALL 'cobdom_style' USING 'langUS', 'transform', 
053500         'translate(0rem, 0rem)'
053600*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
053700     ELSE
053800       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
053900       CALL 'cobdom_style' USING 'langUS', 'transform', 
054000         'translate(0rem, 0rem)'
054100*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
054200     END-IF
054300   ELSE
054400     MOVE 0 TO WS-LANG-SELECT-TOGGLE
054500     IF WS-COOKIE-ALLOWED = 'y' THEN
054600       IF LS-LANG-CHOICE = 'us' THEN
054700         CALL 'cobdom_set_cookie' USING 'us', 'lang'
054800         MOVE 'us' TO WS-LANG
054900       ELSE
055000         CALL 'cobdom_set_cookie' USING 'es', 'lang'
055100         MOVE 'es' TO WS-LANG
055200       END-IF
055300       PERFORM SET-ACTIVE-FLAG
055400     ELSE
055500       MOVE LS-LANG-CHOICE TO WS-LANG
055600       PERFORM SET-ACTIVE-FLAG 
055700     END-IF
055800   END-IF.
055900   GOBACK.
056000 SETLANGUS SECTION.
056100 ENTRY 'SETLANGUS'.
056200   CALL 'SETLANG' USING 'us'.
056300   GOBACK.
056400 SETLANGES SECTION.
056500 ENTRY 'SETLANGES'.
056600   CALL 'SETLANG' USING 'es'.
056700   GOBACK.
056800*TERMINPUT SECTION.
056900*ENTRY 'TERMINPUT' USING LS-TERM-IN.
057000*  DISPLAY LS-TERM-IN.
057100*  GOBACK.
