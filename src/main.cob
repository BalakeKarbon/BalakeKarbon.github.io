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
006900*  CALL 'cobdom_style' USING 'contentDiv', 'height', '100vh'.
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
011500*Intro section
011600   CALL 'cobdom_create_element' USING 'introSection', 'div'.
011700   CALL 'cobdom_style' USING 'introSection', 'width', '100%'.
011800   CALL 'cobdom_create_element' USING 'introHeader', 'div'.
011900*  CALL 'cobdom_set_class' USING 'introHeader',
012000*    'contentHeaders'.
012100*  CALL 'cobdom_inner_html' USING 'introHeader', 'Intro:'.
012200   CALL 'cobdom_create_element' USING 'introContent', 'div'.
012300   CALL 'cobdom_style' USING 'introContent', 'width', '100%'.
012400   CALL 'cobdom_style' USING 'introContent', 'justifyContent',
012500     'center'.
012600   CALL 'cobdom_style' USING 'introContent', 'textAlign',
012700     'center'.
012800   CALL 'cobdom_append_child' USING 'introSection',
012900     'contentDiv'.
013000   CALL 'cobdom_append_child' USING 'introHeader', 
013100     'introSection'.
013200   CALL 'cobdom_append_child' USING 'introContent',
013300     'introSection'.
013400   CALL 'cobdom_create_element' USING 'profilePic', 'img'.
013500   CALL 'cobdom_src' USING 'profilePic', '/res/img/me.png'.
013600   CALL 'cobdom_style' USING 'profilePic', 'width', '20rem'.
013700   CALL 'cobdom_style' USING 'profilePic', 'height', '20rem'.
013800   CALL 'cobdom_style' USING 'profilePic', 'borderRadius', '50%'.
013900   CALL 'cobdom_style' USING 'profilePic', 'objectFit', 'cover'.
014000   CALL 'cobdom_style' USING 'profilePic', 'objectPosition',
014100     '50% 0%'.
014200   CALL 'cobdom_style' USING 'profilePic', 'height', '20rem'.
014300  
014400   CALL 'cobdom_append_child' USING 'profilePic', 'introContent'.
014500*About section
014600   CALL 'cobdom_create_element' USING 'aboutSection', 'div'.
014700   CALL 'cobdom_create_element' USING 'aboutHeader', 'div'.
014800   CALL 'cobdom_set_class' USING 'aboutHeader',
014900     'contentHeaders'.
015000   CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me:'.
015100   CALL 'cobdom_create_element' USING 'aboutContent', 'div'.
015200   CALL 'cobdom_append_child' USING 'aboutSection',
015300     'contentDiv'.
015400   CALL 'cobdom_append_child' USING 'aboutHeader',
015500     'aboutSection'.
015600   CALL 'cobdom_append_child' USING 'aboutContent',
015700     'aboutSection'.
015800*Contact section
015900   CALL 'cobdom_create_element' USING 'contactSection', 'div'.
016000   CALL 'cobdom_create_element' USING 'contactHeader', 'div'.
016100   CALL 'cobdom_set_class' USING 'contactHeader',
016200     'contentHeaders'.
016300   CALL 'cobdom_inner_html' USING 'contactHeader',
016400     'Contact Information:'.
016500   CALL 'cobdom_create_element' USING 'contactContent', 'div'.
016600   CALL 'cobdom_append_child' USING 'contactSection',
016700     'contentDiv'.
016800   CALL 'cobdom_append_child' USING 'contactHeader',
016900     'contactSection'.
017000   CALL 'cobdom_append_child' USING 'contactContent',
017100     'contactSection'.
017200*Skills section
017300   CALL 'cobdom_create_element' USING 'skillsSection', 'div'.
017400   CALL 'cobdom_create_element' USING 'skillsHeader', 'div'.
017500   CALL 'cobdom_set_class' USING 'skillsHeader',
017600     'contentHeaders'.
017700   CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills:'.
017800   CALL 'cobdom_create_element' USING 'skillsContent', 'div'.
017900   CALL 'cobdom_append_child' USING 'skillsSection',
018000     'contentDiv'.
018100   CALL 'cobdom_append_child' USING 'skillsHeader',
018200     'skillsSection'.
018300   CALL 'cobdom_append_child' USING 'skillsContent',
018400     'skillsSection'.
018500*Project section
018600   CALL 'cobdom_create_element' USING 'projectSection', 'div'.
018700   CALL 'cobdom_create_element' USING 'projectHeader', 'div'.
018800   CALL 'cobdom_set_class' USING 'projectHeader',
018900     'contentHeaders'.
019000   CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects:'.
019100   CALL 'cobdom_create_element' USING 'projectContent', 'div'.
019200   CALL 'cobdom_append_child' USING 'projectSection', 
019300     'contentDiv'.
019400   CALL 'cobdom_append_child' USING 'projectHeader', 
019500     'projectSection'.
019600   CALL 'cobdom_append_child' USING 'projectContent', 
019700     'projectSection'.
019800*Cobol section
019900   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
020000   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
020100   CALL 'cobdom_set_class' USING 'cobolHeader',
020200     'contentHeaders'.
020300   CALL 'cobdom_inner_html' USING 'cobolHeader', 'COBOL:'.
020400   CALL 'cobdom_create_element' USING 'cobolContent', 'div'.
020500   CALL 'cobdom_append_child' USING 'cobolSection',
020600     'contentDiv'.
020700   CALL 'cobdom_append_child' USING 'cobolHeader', 
020800     'cobolSection'.
020900   CALL 'cobdom_append_child' USING 'cobolContent', 
021000     'cobolSection'.
021100   CONTINUE.
021200 BUILD-MENUBAR.
021300   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
021400   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
021500   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
021600   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
021700     'space-between'.
021800   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
021900   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
022000   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
022100   CALL 'cobdom_style' USING 'headerDiv', 'backgroundColor',
022200     '#c0c0c0'.
022300*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
022400*    'blur(5px)'.
022500*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
022600*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
022700*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
022800*    '1rem'.
022900*  CALL 'cobdom_style' USING 'headerDiv',
023000*    'borderBottomRightRadius','1rem'.
023100   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
023200*Setup menu
023300   CALL 'cobdom_create_element' USING 'navArea', 'div'.
023400*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
023500   CALL 'cobdom_create_element' USING 'navButton', 'img'.
023600   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
023700   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
023800   CALL 'cobdom_src' USING 'navButton', 
023900     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
024000   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
024100     '#D9D4C7'.
024200*  CALL 'cobdom_style' USING 'navButton', 'filter', 
024300*    'invert(100%)'.
024400   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
024500   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
024600   CALL 'cobdom_style' USING 'navButton', 'padding', '.25rem'.
024700   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
024800   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
024900   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
025000   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
025100*Setup menu selectors
025200*Intro
025300   CALL 'cobdom_create_element' USING 'navIntro', 'div'.
025400   CALL 'cobdom_style' USING 'navIntro', 'position', 'absolute'.
025500   CALL 'cobdom_style' USING 'navIntro', 'backgroundColor', 
025600     '#c0c0c0'.
025700*  CALL 'cobdom_style' USING 'navIntro', 'backdropFilter',
025800*    'blur(5px)'.
025900   CALL 'cobdom_style' USING 'navIntro', 
026000     'borderBottomRightRadius', '0.5rem'.
026100   CALL 'cobdom_style' USING 'navIntro', 
026200     'borderTopRightRadius', '0.5rem'.
026300   CALL 'cobdom_inner_html' USING 'navIntro', 'Intro'.
026400   CALL 'cobdom_style' USING 'navIntro', 'padding', '.3rem'.
026500   CALL 'cobdom_style' USING 'navIntro', 'top', '9rem'.
026600   CALL 'cobdom_style' USING 'navIntro', 'left', '-15rem'.
026700   CALL 'cobdom_style' USING 'navIntro', 'transition', 
026800     'transform 0.5s ease'.
026900   CALL 'cobdom_append_child' USING 'navIntro', 'headerDiv'.
027000*About Me
027100   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
027200   CALL 'cobdom_style' USING 'navAbout', 'position', 'absolute'.
027300   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
027400     '#c0c0c0'.
027500*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
027600*    'blur(5px)'.
027700   CALL 'cobdom_style' USING 'navAbout', 
027800     'borderBottomRightRadius', '0.5rem'.
027900   CALL 'cobdom_style' USING 'navAbout', 
028000     'borderTopRightRadius', '0.5rem'.
028100   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
028200   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
028300   CALL 'cobdom_style' USING 'navAbout', 'top', '12rem'.
028400   CALL 'cobdom_style' USING 'navAbout', 'left', '-15rem'.
028500   CALL 'cobdom_style' USING 'navAbout', 'transition', 
028600     'transform 0.5s ease 0.1s'.
028700   CALL 'cobdom_append_child' USING 'navAbout', 'headerDiv'.
028800*Contact Me
028900   CALL 'cobdom_create_element' USING 'navContact', 'div'.
029000   CALL 'cobdom_style' USING 'navContact', 'position', 'absolute'.
029100   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
029200     '#c0c0c0'.
029300*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
029400*    'blur(5px)'.
029500   CALL 'cobdom_style' USING 'navContact', 
029600     'borderBottomRightRadius', '0.5rem'.
029700   CALL 'cobdom_style' USING 'navContact', 
029800     'borderTopRightRadius', '0.5rem'.
029900   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
030000   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
030100   CALL 'cobdom_style' USING 'navContact', 'top', '15rem'.
030200   CALL 'cobdom_style' USING 'navContact', 'left', '-15rem'.
030300   CALL 'cobdom_style' USING 'navContact', 'transition', 
030400     'transform 0.5s ease 0.2s'.
030500   CALL 'cobdom_append_child' USING 'navContact', 'headerDiv'.
030600*Skills
030700   CALL 'cobdom_create_element' USING 'navSkills', 'div'.
030800   CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
030900   CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
031000     '#c0c0c0'.
031100*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
031200*    'blur(5px)'.
031300   CALL 'cobdom_style' USING 'navSkills', 
031400     'borderBottomRightRadius', '0.5rem'.
031500   CALL 'cobdom_style' USING 'navSkills', 
031600     'borderTopRightRadius', '0.5rem'.
031700   CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
031800   CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
031900   CALL 'cobdom_style' USING 'navSkills', 'top', '18rem'.
032000   CALL 'cobdom_style' USING 'navSkills', 'left', '-15rem'.
032100   CALL 'cobdom_style' USING 'navSkills', 'transition', 
032200     'transform 0.5s ease 0.3s'.
032300   CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
032400*Projects
032500   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
032600   CALL 'cobdom_style' USING 'navProjects', 'position', 
032700     'absolute'.
032800   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
032900     '#c0c0c0'.
033000*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
033100*    'blur(5px)'.
033200   CALL 'cobdom_style' USING 'navProjects', 
033300     'borderBottomRightRadius', '0.5rem'.
033400   CALL 'cobdom_style' USING 'navProjects', 
033500     'borderTopRightRadius', '0.5rem'.
033600   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
033700   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
033800   CALL 'cobdom_style' USING 'navProjects', 'top', '21rem'.
033900   CALL 'cobdom_style' USING 'navProjects', 'left', '-15rem'.
034000   CALL 'cobdom_style' USING 'navProjects', 'transition', 
034100     'transform 0.5s ease 0.4s'.
034200   CALL 'cobdom_append_child' USING 'navProjects', 'headerDiv'.
034300*Cobol?
034400   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
034500   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
034600   CALL 'cobdom_style' USING 'navCobol', 'position', 
034700     'absolute'.
034800   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
034900     '#000000'.
035000*    '#c0c0c0'.
035100*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
035200*    'blur(5px)'.
035300   CALL 'cobdom_style' USING 'navCobol', 'color', 
035400     '#00ff00'.
035500   CALL 'cobdom_style' USING 'navCobol', 
035600     'borderBottomRightRadius', '0.5rem'.
035700   CALL 'cobdom_style' USING 'navCobol', 
035800     'borderTopRightRadius', '0.5rem'.
035900   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
036000   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
036100   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
036200   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
036300   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
036400   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
036500   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
036600   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
036700   CALL 'cobdom_style' USING 'navCobol', 'top', '24rem'.
036800   CALL 'cobdom_style' USING 'navCobol', 'left', '-15rem'.
036900   CALL 'cobdom_style' USING 'navCobol', 'transition', 
037000     'transform 0.5s ease 0.5s'.
037100   CALL 'cobdom_append_child' USING 'navCobol', 'headerDiv'.
037200*Add main menu button
037300   CALL 'cobdom_append_child' USING 'navArea', 'headerDiv'.
037400   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
037500     'MENUTOGGLE'.
037600*Setup ID area
037700   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
037800   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
037900   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
038000   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
038100   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '4rem'.
038200   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
038300   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
038400   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
038500   CALL 'cobdom_inner_html' USING 'taglineDiv', 
038600     'A guy that knows a guy.'.
038700   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
038800   CALL 'cobdom_append_child' USING 'idDiv', 'headerDiv'.
038900*Setup lang area
039000   CALL 'cobdom_create_element' USING 'langArea', 'span'.
039100   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
039200   CALL 'cobdom_append_child' USING 'langArea', 'headerDiv'.
039300*Setup language selector
039400   CALL 'cobdom_create_element' USING 'langUS', 'img'.
039500   CALL 'cobdom_create_element' USING 'langES', 'img'.
039600   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
039700   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
039800   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
039900   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
040000   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
040100   CALL 'cobdom_style' USING 'langUS', 'transition', 
040200     'opacity 0.5s ease, transform 0.5s ease'.
040300*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
040400*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
040500   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
040600   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
040700   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
040800   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
040900   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
041000   CALL 'cobdom_style' USING 'langES', 'transition', 
041100     'opacity 0.5s ease, transform 0.5s ease'.
041200*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
041300*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
041400   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
041500   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
041600     'SETLANGUS'.
041700   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
041800   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
041900     'SETLANGES'.
042000   CONTINUE.
042100 SET-ACTIVE-FLAG.
042200   IF WS-LANG = 'us' THEN
042300     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
042400     CALL 'cobdom_style' USING 'langUS', 'transform', 
042500       'translate(9rem, 0rem)'
042600     PERFORM UPDATE-TEXT
042700   ELSE
042800     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
042900     CALL 'cobdom_style' USING 'langUS', 'transform', 
043000       'translate(9rem, 0rem)'
043100     PERFORM UPDATE-TEXT
043200   END-IF.
043300   CONTINUE.
043400 LOAD-TEXTS.
043500   CONTINUE.
043600 UPDATE-TEXT.
043700   CONTINUE.
043800 LANG-CHECK.
043900   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
044000     'lang'.
044100   IF WS-LANG = WS-NULL-BYTE THEN
044200     CALL 'cobdom_set_cookie' USING 'us', 'lang'
044300     MOVE 'us' TO WS-LANG
044400   END-IF.
044500   PERFORM SET-ACTIVE-FLAG.
044600   CONTINUE.
044700 COOKIE-ASK.
044800   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
044900   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
045000   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
045100   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
045200   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
045300   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
045400     '#00ff00'.
045500   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
045600     'center'.
045700   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
045800-'llow cookies to store your preferences such as language?&nbsp;'.
045900   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
046000   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
046100   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
046200   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
046300   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
046400   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
046500   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
046600   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
046700   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
046800   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
046900   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
047000   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
047100   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
047200     'COOKIEACCEPT'.
047300   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
047400     'COOKIEDENY'.
047500   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
047600   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
047700   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
047800*Note this must be called after the elements are added to the
047900*document because it must search for them.
048000   CALL 'cobdom_class_style' USING 'cookieButton', 
048100     'backgroundColor', '#ff0000'.
048200   CONTINUE.
048300 MENUTOGGLE SECTION.
048400 ENTRY 'MENUTOGGLE'.
048500   IF WS-MENU-TOGGLE = 0 THEN
048600     MOVE 1 TO WS-MENU-TOGGLE
048700     CALL 'cobdom_style' USING 'navButton', 'transform', 
048800       'scale(0.85)'
048900     CALL 'cobdom_src' USING 'navButton', 
049000       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
049100     CALL 'cobdom_style' USING 'navIntro', 'transform', 
049200       'translate(15rem, 0rem)'
049300     CALL 'cobdom_style' USING 'navAbout', 'transform', 
049400       'translate(15rem, 0rem)' 
049500     CALL 'cobdom_style' USING 'navContact', 'transform', 
049600       'translate(15rem, 0rem)' 
049700     CALL 'cobdom_style' USING 'navSkills', 'transform', 
049800       'translate(15rem, 0rem)'
049900    CALL 'cobdom_style' USING 'navProjects', 'transform', 
050000       'translate(15rem, 0rem)'
050100    CALL 'cobdom_style' USING 'navCobol', 'transform', 
050200       'translate(15rem, 0rem)'
050300   ELSE
050400     MOVE 0 TO WS-MENU-TOGGLE
050500     CALL 'cobdom_style' USING 'navButton', 'transform', 
050600       'scale(1.0)'
050700     CALL 'cobdom_src' USING 'navButton', 
050800       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
050900     CALL 'cobdom_style' USING 'navIntro', 'transform', 
051000       'translate(0rem, 0rem)'
051100     CALL 'cobdom_style' USING 'navAbout', 'transform', 
051200       'translate(0rem, 0rem)' 
051300     CALL 'cobdom_style' USING 'navContact', 'transform', 
051400       'translate(0rem, 0rem)' 
051500     CALL 'cobdom_style' USING 'navSkills', 'transform', 
051600       'translate(0rem, 0rem)'
051700    CALL 'cobdom_style' USING 'navProjects', 'transform', 
051800       'translate(0rem, 0rem)'
051900    CALL 'cobdom_style' USING 'navCobol', 'transform', 
052000       'translate(0rem, 0rem)'
052100   END-IF.
052200   GOBACK.
052300*TO-DO: Add a timer in case some fonts do never load
052400 FONTLOADED SECTION.
052500 ENTRY 'FONTLOADED'.
052600   ADD 1 TO WS-FONTS-LOADED.
052700   IF WS-FONTS-LOADED = 2 THEN
052800     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
052900     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
053000     CALL 'cobdom_style' USING 'cobolHeader', 'fontFamily',
053100       'ibmpc'
053200     CALL 'cobdom_style' USING 'cobolContent', 'fontFamily',
053300       'ibmpc'
053400   END-IF.
053500   GOBACK.
053600 WINDOWCHANGE SECTION.
053700 ENTRY 'WINDOWCHANGE'.
053800   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
053900   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
054000     '300'.
054100*Optimize this buffer time to not have a noticeable delay but also
054200*not call to often.
054300   GOBACK.
054400 SHAPEPAGE SECTION.
054500 ENTRY 'SHAPEPAGE'.
054600*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
054700*  DISPLAY 'Rendering! ' CENTISECS.
054800   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
054900     'window.innerWidth'.
055000   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
055100   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
055200     'window.innerHeight'.
055300   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
055400   GOBACK.
055500 COOKIEACCEPT SECTION.
055600 ENTRY 'COOKIEACCEPT'.
055700   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
055800   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
055900   MOVE 'y' TO WS-COOKIE-ALLOWED.
056000   GOBACK.
056100 COOKIEDENY SECTION.
056200 ENTRY 'COOKIEDENY'.
056300   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
056400   MOVE 'n' TO WS-COOKIE-ALLOWED.
056500   GOBACK.
056600 SETPERCENTCOBOL SECTION.
056700 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
056800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
056900   CALL 'cobdom_inner_html' USING 'percentCobol',
057000     WS-PERCENT-COBOL.
057100   DISPLAY 'Currently this website is written in ' 
057200     WS-PERCENT-COBOL '% COBOL.'.
057300   GOBACK.
057400 SETLANG SECTION.
057500 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
057600   if WS-LANG-SELECT-TOGGLE = 0 THEN
057700     MOVE 1 TO WS-LANG-SELECT-TOGGLE
057800     IF WS-LANG = 'us' THEN
057900       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
058000       CALL 'cobdom_style' USING 'langUS', 'transform', 
058100         'translate(0rem, 0rem)'
058200*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
058300     ELSE
058400       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
058500       CALL 'cobdom_style' USING 'langUS', 'transform', 
058600         'translate(0rem, 0rem)'
058700*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
058800     END-IF
058900   ELSE
059000     MOVE 0 TO WS-LANG-SELECT-TOGGLE
059100     IF WS-COOKIE-ALLOWED = 'y' THEN
059200       IF LS-LANG-CHOICE = 'us' THEN
059300         CALL 'cobdom_set_cookie' USING 'us', 'lang'
059400         MOVE 'us' TO WS-LANG
059500       ELSE
059600         CALL 'cobdom_set_cookie' USING 'es', 'lang'
059700         MOVE 'es' TO WS-LANG
059800       END-IF
059900       PERFORM SET-ACTIVE-FLAG
060000     ELSE
060100       MOVE LS-LANG-CHOICE TO WS-LANG
060200       PERFORM SET-ACTIVE-FLAG 
060300     END-IF
060400   END-IF.
060500   GOBACK.
060600 SETLANGUS SECTION.
060700 ENTRY 'SETLANGUS'.
060800   CALL 'SETLANG' USING 'us'.
060900   GOBACK.
061000 SETLANGES SECTION.
061100 ENTRY 'SETLANGES'.
061200   CALL 'SETLANG' USING 'es'.
061300   GOBACK.
061400*TERMINPUT SECTION.
061500*ENTRY 'TERMINPUT' USING LS-TERM-IN.
061600*  DISPLAY LS-TERM-IN.
061700*  GOBACK.
