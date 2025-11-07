000100 IDENTIFICATION DIVISION.
000200 PROGRAM-ID. BLAKE-KARBON-WEB-PORTFOLIO.
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
003300 01 WS-TEXTS.
003400   05 EN.
003500     10 TAB PIC X(12) VALUE '&nbsp;&nbsp;'.
003600     10 ABOUT-ME PIC X(1000).
003700     10 NB PIC X(1) VALUE X'00'.
003800   05 ES.
003900     10 TAB PIC X(12) VALUE '&nbsp;&nbsp;'.
004000     10 ABOUT-ME PIC X(1000).
004100     10 NB PIC X(1) VALUE X'00'.
004200*This has to be pic 10 as that is what is returned from
004300*the library.
004400 LINKAGE SECTION.
004500 01 LS-BLOB PIC X(100000).
004600 01 LS-BLOB-SIZE PIC 9(10).
004700 01 LS-LANG-CHOICE PIC XX.
004800 01 LS-TERM-IN PIC X(10).
004900 PROCEDURE DIVISION.
005000 MAIN SECTION.
005100 ENTRY 'MAIN'.
005200   CALL 'cobdom_style' USING 'body', 'margin', '0'.
005300*  CALL 'cobdom_style' USING 'body', 'color', '#ffffff'.
005400   CALL 'cobdom_style' USING 'body', 'fontSize', '1.5rem'.
005500   CALL 'cobdom_style' USING 'body', 'display', 'flex'.
005600   CALL 'cobdom_style' USING 'body', 'alignItems', 'center'.
005700   CALL 'cobdom_style' USING 'body', 'justifyContent', 'center'.
005800   CALL 'cobdom_add_event_listener' USING 'window', 'resize', 
005900     'WINDOWCHANGE'.
006000   CALL 'cobdom_add_event_listener' USING 'window', 
006100     'orientationchange', 'WINDOWCHANGE'.
006200   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
006300     'allowCookies'.
006400   CALL 'cobdom_create_element' USING 'percentCobol', 'span'.
006500*  CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
006600*    '/res/percent.txt', 'GET', WS-NULL-BYTE.
006700*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
006800*Setup content div
006900   CALL 'cobdom_create_element' USING 'contentDiv', 'div'.
007000   CALL 'cobdom_style' USING 'contentDiv', 'marginTop', '10rem'.
007100*  CALL 'cobdom_inner_html' USING 'contentDiv', 
007200*    'ALL KINDS OF TEST CONTENT HERE WOO HOO I WONER WHAT THIS WIL
007300*'L ALL LOOK LIKE MUAHAHAHAHAHAHAHAHAHHAHA'.
007400   CALL 'cobdom_style' USING 'contentDiv', 'maxWidth', '80rem'.
007500   CALL 'cobdom_style' USING 'contentDiv', 'backgroundColor',
007600     'brown'.
007700   CALL 'cobdom_style' USING 'contentDiv', 'width', '100%'.
007800*  CALL 'cobdom_style' USING 'contentDiv', 'height', '100vh'.
007900   CALL 'cobdom_style' USING 'contentDiv', 'display', 'flex'.
008000   CALL 'cobdom_style' USING 'contentDiv', 'flexDirection',
008100     'column'.
008200   CALL 'cobdom_style' USING 'contentDiv', 'alignItems',
008300     'flex-start'.
008400   CALL 'cobdom_append_child' USING 'contentDiv', 'body'.
008500*Set up blink style
008600   CALL 'cobdom_create_element' USING 'blinkStyle', 'style'.
008700   CALL 'cobdom_inner_html' USING 'blinkStyle', 
008800 '.blink { animation: blink 1s step-start infinite; } @keyframes b
008900-'link { 50% { opacity: 0; } }'.
009000   PERFORM BUILD-MENUBAR.
009100   PERFORM BUILD-CONTENT.
009200*Load and set fonts
009300   CALL 'cobdom_font_face' USING 'mainFont',
009400     'url("/res/fonts/1971-ibm-3278/3270-Regular.ttf")',
009500*    'url("/res/fonts/Proggy/ProggyVector-Regular.otf")',
009600     'FONTLOADED'.
009700   CALL 'cobdom_font_face' USING 'ibmpc',
009800*    'url("/res/fonts/1977-commodore-pet/PetMe.ttf")',
009900     'url("/res/fonts/1985-ibm-pc-vga/PxPlus_IBM_VGA8.ttf")',
010000     'FONTLOADED'.
010100*Load texts
010200   PERFORM LOAD-TEXTS.
010300*Terminal
010400*  CALL 'cobdom_create_element' USING 'terminalDiv', 'div'.
010500*  CALL 'cobdom_append_child' USING 'terminalDiv', 'contentDiv'.
010600*  CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB,
010700*    '(function() { window["term"] = new Terminal(); window["term"
010800*'].open(window["terminalDiv"]); term.onData(data => { Module.ccal
010900*'l("TERMINPUT", null, ["string"], [data]); }); return ""; })()'.
011000*Check for cookies
011100   IF WS-COOKIE-ALLOWED = 'y' THEN
011200     PERFORM LANG-CHECK
011300*GET LAST LOGIN
011400   ELSE
011500     PERFORM COOKIE-ASK
011600     MOVE 'us' TO WS-LANG
011700     PERFORM SET-ACTIVE-FLAG
011800   END-IF.
011900*Render
012000   CALL 'SHAPEPAGE'.
012100   GOBACK.
012200 RELOAD-TEXT.
012300   CONTINUE.
012400 BUILD-CONTENT.
012500*  CALL 'cobdom_create_element' USING 'profilePic', 'img'.
012600*  CALL 'cobdom_src' USING 'profilePic', '/res/img/me.png'.
012700*  CALL 'cobdom_style' USING 'profilePic', 'width', '20rem'.
012800*  CALL 'cobdom_style' USING 'profilePic', 'height', '20rem'.
012900*  CALL 'cobdom_style' USING 'profilePic', 'borderRadius', '50%'.
013000*  CALL 'cobdom_style' USING 'profilePic', 'objectFit', 'cover'.
013100*  CALL 'cobdom_style' USING 'profilePic', 'objectPosition',
013200*    '50% 0%'.
013300*  CALL 'cobdom_style' USING 'profilePic', 'height', '20rem'.
013400* 
013500*  CALL 'cobdom_append_child' USING 'profilePic', 'introContent'.
013600*About section
013700   CALL 'cobdom_create_element' USING 'aboutSection', 'div'.
013800   CALL 'cobdom_style' USING 'aboutSection', 'width', '100%'.
013900   CALL 'cobdom_create_element' USING 'aboutHeader', 'div'.
014000   CALL 'cobdom_set_class' USING 'aboutHeader',
014100     'contentHeadersClass'.
014200   CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me:'.
014300   CALL 'cobdom_create_element' USING 'aboutContent', 'div'.
014400   CALL 'cobdom_append_child' USING 'aboutSection',
014500     'contentDiv'.
014600   CALL 'cobdom_append_child' USING 'aboutHeader',
014700     'aboutSection'.
014800   CALL 'cobdom_append_child' USING 'aboutContent',
014900     'aboutSection'.
015000*Contact section / Links / Socials
015100*Email,
015200*GitHub, LinkedIN
015300*Youtube, TikTok, Instagram,
015400   CALL 'cobdom_create_element' USING 'contactSection', 'div'.
015500   CALL 'cobdom_style' USING 'contactSection', 'width', '100%'.
015600   CALL 'cobdom_create_element' USING 'contactHeader', 'div'.
015700   CALL 'cobdom_set_class' USING 'contactHeader',
015800     'contentHeadersClass'.
015900   CALL 'cobdom_inner_html' USING 'contactHeader',
016000     'Contact Information:'.
016100   CALL 'cobdom_create_element' USING 'contactContent', 'div'.
016200   CALL 'cobdom_style' USING 'contactContent', 'width', '100%'.
016300   CALL 'cobdom_style' USING 'contactContent', 'textAlign',
016400     'center'.
016500   CALL 'cobdom_append_child' USING 'contactSection',
016600     'contentDiv'.
016700   CALL 'cobdom_append_child' USING 'contactHeader',
016800     'contactSection'.
016900   CALL 'cobdom_append_child' USING 'contactContent',
017000     'contactSection'.
017100   CALL 'cobdom_create_element' USING 'emailDiv', 'div'.
017200   CALL 'cobdom_inner_html' USING 'emailDiv',
017300     'karboncodes@gmail.com'.
017400   CALL 'cobdom_create_element' USING 'linksDiv', 'div'.
017500   CALL 'cobdom_style' USING 'linksDiv', 'display', 'flex'.
017600   CALL 'cobdom_style' USING 'linksDiv', 'width', '100%'.
017700   CALL 'cobdom_style' USING 'linksDiv', 'justifyContent',
017800     'center'.
017900*The following section could be done with a loop but it is not
018000*which is horrid
018100*GitHub
018200   CALL 'cobdom_create_element' USING 'ghContainer', 'span'.
018300   CALL 'cobdom_set_class' USING 'ghContainer',
018400     'contactContainer'.
018500   CALL 'cobdom_create_element' USING 'ghImage', 'img'.
018600   CALL 'cobdom_src' USING 'ghImage', 
018700     '/res/icons/tabler-icons/icons/outline/brand-github.svg'.
018800   CALL 'cobdom_style' USING 'ghImage', 'width', '6rem'.
018900   CALL 'cobdom_style' USING 'ghImage', 'height', '6rem'.
019000   CALL 'cobdom_create_element' USING 'ghText', 'div'.
019100   CALL 'cobdom_inner_html' USING 'ghText', 'GitHub'.
019200   CALL 'cobdom_append_child' USING 'ghImage', 'ghContainer'.
019300   CALL 'cobdom_append_child' USING 'ghText', 'ghContainer'.
019400   CALL 'cobdom_append_child' USING 'ghContainer', 'linksDiv'.
019500*LinkedIn
019600   CALL 'cobdom_create_element' USING 'liContainer', 'span'.
019700   CALL 'cobdom_set_class' USING 'liContainer',
019800     'contactContainer'.
019900   CALL 'cobdom_create_element' USING 'liImage', 'img'.
020000   CALL 'cobdom_src' USING 'liImage', 
020100     '/res/icons/tabler-icons/icons/outline/brand-linkedin.svg'.
020200   CALL 'cobdom_style' USING 'liImage', 'width', '6rem'.
020300   CALL 'cobdom_style' USING 'liImage', 'height', '6rem'.
020400   CALL 'cobdom_create_element' USING 'liText', 'div'.
020500   CALL 'cobdom_inner_html' USING 'liText', 'Linkedin'.
020600   CALL 'cobdom_append_child' USING 'liImage', 'liContainer'.
020700   CALL 'cobdom_append_child' USING 'liText', 'liContainer'.
020800   CALL 'cobdom_append_child' USING 'liContainer', 'linksDiv'.
020900*Youtube
021000   CALL 'cobdom_create_element' USING 'ytContainer', 'span'.
021100   CALL 'cobdom_set_class' USING 'ytContainer',
021200     'contactContainer'.
021300   CALL 'cobdom_create_element' USING 'ytImage', 'img'.
021400   CALL 'cobdom_src' USING 'ytImage', 
021500     '/res/icons/tabler-icons/icons/outline/brand-youtube.svg'.
021600   CALL 'cobdom_style' USING 'ytImage', 'width', '6rem'.
021700   CALL 'cobdom_style' USING 'ytImage', 'height', '6rem'.
021800   CALL 'cobdom_create_element' USING 'ytText', 'div'.
021900   CALL 'cobdom_inner_html' USING 'ytText', 'Youtube'.
022000   CALL 'cobdom_append_child' USING 'ytImage', 'ytContainer'.
022100   CALL 'cobdom_append_child' USING 'ytText', 'ytContainer'.
022200   CALL 'cobdom_append_child' USING 'ytContainer', 'linksDiv'.
022300*TikTok
022400   CALL 'cobdom_create_element' USING 'ttContainer', 'span'.
022500   CALL 'cobdom_set_class' USING 'ttContainer',
022600     'contactContainer'.
022700   CALL 'cobdom_create_element' USING 'ttImage', 'img'.
022800   CALL 'cobdom_src' USING 'ttImage', 
022900     '/res/icons/tabler-icons/icons/outline/brand-tiktok.svg'.
023000   CALL 'cobdom_style' USING 'ttImage', 'width', '6rem'.
023100   CALL 'cobdom_style' USING 'ttImage', 'height', '6rem'.
023200   CALL 'cobdom_create_element' USING 'ttText', 'div'.
023300   CALL 'cobdom_inner_html' USING 'ttText', 'TikTok'.
023400   CALL 'cobdom_append_child' USING 'ttImage', 'ttContainer'.
023500   CALL 'cobdom_append_child' USING 'ttText', 'ttContainer'.
023600   CALL 'cobdom_append_child' USING 'ttContainer', 'linksDiv'.
023700*Instagram
023800   CALL 'cobdom_create_element' USING 'igContainer', 'span'.
023900   CALL 'cobdom_set_class' USING 'igContainer',
024000     'contactContainer'.
024100   CALL 'cobdom_create_element' USING 'igImage', 'img'.
024200   CALL 'cobdom_src' USING 'igImage', 
024300     '/res/icons/tabler-icons/icons/outline/brand-instagram.svg'.
024400   CALL 'cobdom_style' USING 'igImage', 'width', '6rem'.
024500   CALL 'cobdom_style' USING 'igImage', 'height', '6rem'.
024600   CALL 'cobdom_create_element' USING 'igText', 'div'.
024700   CALL 'cobdom_inner_html' USING 'igText', 'Instagram'.
024800   CALL 'cobdom_append_child' USING 'igImage', 'igContainer'.
024900   CALL 'cobdom_append_child' USING 'igText', 'igContainer'.
025000   CALL 'cobdom_append_child' USING 'igContainer', 'linksDiv'.
025100 
025200   CALL 'cobdom_append_child' USING 'emailDiv', 'contactContent'.
025300   CALL 'cobdom_append_child' USING 'linksDiv', 'contactContent'.
025400*Skills section
025500   CALL 'cobdom_create_element' USING 'skillsSection', 'div'.
025600   CALL 'cobdom_style' USING 'skillsSection', 'width', '100%'.
025700   CALL 'cobdom_create_element' USING 'skillsHeader', 'div'.
025800   CALL 'cobdom_set_class' USING 'skillsHeader',
025900     'contentHeadersClass'.
026000   CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills:'.
026100   CALL 'cobdom_create_element' USING 'skillsContent', 'div'.
026200   CALL 'cobdom_append_child' USING 'skillsSection',
026300     'contentDiv'.
026400   CALL 'cobdom_append_child' USING 'skillsHeader',
026500     'skillsSection'.
026600   CALL 'cobdom_append_child' USING 'skillsContent',
026700     'skillsSection'.
026800*Project section
026900   CALL 'cobdom_create_element' USING 'projectSection', 'div'.
027000   CALL 'cobdom_style' USING 'projectSection', 'width', '100%'.
027100   CALL 'cobdom_create_element' USING 'projectHeader', 'div'.
027200   CALL 'cobdom_set_class' USING 'projectHeader',
027300     'contentHeadersClass'.
027400   CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects:'.
027500   CALL 'cobdom_create_element' USING 'projectContent', 'div'.
027600   CALL 'cobdom_append_child' USING 'projectSection', 
027700     'contentDiv'.
027800   CALL 'cobdom_append_child' USING 'projectHeader', 
027900     'projectSection'.
028000   CALL 'cobdom_append_child' USING 'projectContent', 
028100     'projectSection'.
028200*Cobol section
028300   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
028400   CALL 'cobdom_style' USING 'cobolSection', 'width', '100%'.
028500   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
028600   CALL 'cobdom_set_class' USING 'cobolHeader',
028700     'contentHeadersClass'.
028800   CALL 'cobdom_inner_html' USING 'cobolHeader', 'COBOL'.
028900   CALL 'cobdom_create_element' USING 'cobolContent', 'div'.
029000   CALL 'cobdom_append_child' USING 'cobolSection',
029100     'contentDiv'.
029200   CALL 'cobdom_append_child' USING 'cobolHeader', 
029300     'cobolSection'.
029400   CALL 'cobdom_append_child' USING 'cobolContent', 
029500     'cobolSection'.
029600*Set contentHeadersClass class styles. Must be called after elements
029700*exist as this uses getElementsByClassName. A safer option would
029800*be to make a new style element but for the sake of demnostrating
029900*this part of the library I will use this here.
030000   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
030100     'fontSize', '2.5rem'.
030200   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
030300     'width', '100%'.
030400   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
030500     'textAlign', 'center'.
030600   CALL 'cobdom_class_style' USING 'contentHeadersClass',
030700     'fontWeight', 'bold'.
030800   CALL 'cobdom_class_style' USING 'contactContainer', 'margin',
030900     '1rem'.
031000  CALL 'cobdom_class_style' USING 'contactContainer', 'display',
031100     'flex'. 
031200   CALL 'cobdom_class_style' USING 'contactContainer',
031300     'flexDirection', 'column'.
031400   CALL 'cobdom_class_style' USING 'contactContainer',
031500     'alignItems', 'center'.
031600   CONTINUE.
031700 BUILD-MENUBAR.
031800   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
031900   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
032000   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
032100   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
032200     'space-between'.
032300   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
032400   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
032500   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
032600   CALL 'cobdom_style' USING 'headerDiv', 'backgroundColor',
032700     '#c0c0c0'.
032800*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
032900*    'blur(5px)'.
033000*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
033100*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
033200*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
033300*    '1rem'.
033400*  CALL 'cobdom_style' USING 'headerDiv',
033500*    'borderBottomRightRadius','1rem'.
033600   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
033700*Setup menu
033800   CALL 'cobdom_create_element' USING 'navArea', 'div'.
033900*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
034000   CALL 'cobdom_create_element' USING 'navButton', 'img'.
034100   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
034200   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
034300   CALL 'cobdom_src' USING 'navButton', 
034400     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
034500   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
034600     '#D9D4C7'.
034700*  CALL 'cobdom_style' USING 'navButton', 'filter', 
034800*    'invert(100%)'.
034900   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
035000   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
035100   CALL 'cobdom_style' USING 'navButton', 'padding', '.25rem'.
035200   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
035300   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
035400   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
035500   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
035600*Setup menu selectors
035700*About Me
035800   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
035900   CALL 'cobdom_style' USING 'navAbout', 'position', 'absolute'.
036000   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
036100     '#c0c0c0'.
036200*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
036300*    'blur(5px)'.
036400   CALL 'cobdom_style' USING 'navAbout', 
036500     'borderBottomRightRadius', '0.5rem'.
036600   CALL 'cobdom_style' USING 'navAbout', 
036700     'borderTopRightRadius', '0.5rem'.
036800   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
036900   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
037000   CALL 'cobdom_style' USING 'navAbout', 'top', '9rem'.
037100   CALL 'cobdom_style' USING 'navAbout', 'left', '-15rem'.
037200   CALL 'cobdom_style' USING 'navAbout', 'transition', 
037300     'transform 0.5s ease 0.1s'.
037400   CALL 'cobdom_append_child' USING 'navAbout', 'headerDiv'.
037500*Contact Me
037600   CALL 'cobdom_create_element' USING 'navContact', 'div'.
037700   CALL 'cobdom_style' USING 'navContact', 'position', 'absolute'.
037800   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
037900     '#c0c0c0'.
038000*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
038100*    'blur(5px)'.
038200   CALL 'cobdom_style' USING 'navContact', 
038300     'borderBottomRightRadius', '0.5rem'.
038400   CALL 'cobdom_style' USING 'navContact', 
038500     'borderTopRightRadius', '0.5rem'.
038600   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
038700   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
038800   CALL 'cobdom_style' USING 'navContact', 'top', '11rem'.
038900   CALL 'cobdom_style' USING 'navContact', 'left', '-15rem'.
039000   CALL 'cobdom_style' USING 'navContact', 'transition', 
039100     'transform 0.5s ease 0.2s'.
039200   CALL 'cobdom_append_child' USING 'navContact', 'headerDiv'.
039300*Skills
039400   CALL 'cobdom_create_element' USING 'navSkills', 'div'.
039500   CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
039600   CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
039700     '#c0c0c0'.
039800*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
039900*    'blur(5px)'.
040000   CALL 'cobdom_style' USING 'navSkills', 
040100     'borderBottomRightRadius', '0.5rem'.
040200   CALL 'cobdom_style' USING 'navSkills', 
040300     'borderTopRightRadius', '0.5rem'.
040400   CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
040500   CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
040600   CALL 'cobdom_style' USING 'navSkills', 'top', '13rem'.
040700   CALL 'cobdom_style' USING 'navSkills', 'left', '-15rem'.
040800   CALL 'cobdom_style' USING 'navSkills', 'transition', 
040900     'transform 0.5s ease 0.3s'.
041000   CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
041100*Projects
041200   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
041300   CALL 'cobdom_style' USING 'navProjects', 'position', 
041400     'absolute'.
041500   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
041600     '#c0c0c0'.
041700*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
041800*    'blur(5px)'.
041900   CALL 'cobdom_style' USING 'navProjects', 
042000     'borderBottomRightRadius', '0.5rem'.
042100   CALL 'cobdom_style' USING 'navProjects', 
042200     'borderTopRightRadius', '0.5rem'.
042300   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
042400   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
042500   CALL 'cobdom_style' USING 'navProjects', 'top', '15rem'.
042600   CALL 'cobdom_style' USING 'navProjects', 'left', '-15rem'.
042700   CALL 'cobdom_style' USING 'navProjects', 'transition', 
042800     'transform 0.5s ease 0.4s'.
042900   CALL 'cobdom_append_child' USING 'navProjects', 'headerDiv'.
043000*Cobol?
043100   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
043200   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
043300   CALL 'cobdom_style' USING 'navCobol', 'position', 
043400     'absolute'.
043500   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
043600     '#000000'.
043700*    '#c0c0c0'.
043800*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
043900*    'blur(5px)'.
044000   CALL 'cobdom_style' USING 'navCobol', 'color', 
044100     '#00ff00'.
044200   CALL 'cobdom_style' USING 'navCobol', 
044300     'borderBottomRightRadius', '0.5rem'.
044400   CALL 'cobdom_style' USING 'navCobol', 
044500     'borderTopRightRadius', '0.5rem'.
044600   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
044700   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
044800   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
044900   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
045000   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
045100   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
045200   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
045300   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
045400   CALL 'cobdom_style' USING 'navCobol', 'top', '17rem'.
045500   CALL 'cobdom_style' USING 'navCobol', 'left', '-15rem'.
045600   CALL 'cobdom_style' USING 'navCobol', 'transition', 
045700     'transform 0.5s ease 0.5s'.
045800   CALL 'cobdom_append_child' USING 'navCobol', 'headerDiv'.
045900*Add main menu button
046000   CALL 'cobdom_append_child' USING 'navArea', 'headerDiv'.
046100   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
046200     'MENUTOGGLE'.
046300*Setup ID area
046400   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
046500   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
046600   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
046700   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
046800   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '4rem'.
046900   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
047000   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
047100   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
047200   CALL 'cobdom_inner_html' USING 'taglineDiv', 
047300     'A guy that knows a guy.'.
047400   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
047500   CALL 'cobdom_append_child' USING 'idDiv', 'headerDiv'.
047600*Setup lang area
047700   CALL 'cobdom_create_element' USING 'langArea', 'span'.
047800   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
047900   CALL 'cobdom_append_child' USING 'langArea', 'headerDiv'.
048000*Setup language selector
048100   CALL 'cobdom_create_element' USING 'langUS', 'img'.
048200   CALL 'cobdom_create_element' USING 'langES', 'img'.
048300   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
048400   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
048500   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
048600   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
048700   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
048800   CALL 'cobdom_style' USING 'langUS', 'transition', 
048900     'opacity 0.5s ease, transform 0.5s ease'.
049000*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
049100*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
049200   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
049300   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
049400   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
049500   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
049600   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
049700   CALL 'cobdom_style' USING 'langES', 'transition', 
049800     'opacity 0.5s ease, transform 0.5s ease'.
049900*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
050000*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
050100   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
050200   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
050300     'SETLANGUS'.
050400   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
050500   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
050600     'SETLANGES'.
050700   CONTINUE.
050800 SET-ACTIVE-FLAG.
050900   IF WS-LANG = 'us' THEN
051000     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
051100     CALL 'cobdom_style' USING 'langUS', 'transform', 
051200       'translate(9rem, 0rem)'
051300     PERFORM UPDATE-TEXT
051400   ELSE
051500     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
051600     CALL 'cobdom_style' USING 'langUS', 'transform', 
051700       'translate(9rem, 0rem)'
051800     PERFORM UPDATE-TEXT
051900   END-IF.
052000   CONTINUE.
052100 LOAD-TEXTS.
052200   CALL 'cobdom_fetch' USING 'LOADENAM',
052300     '/res/text/en/aboutme.txt', 'GET', WS-NULL-BYTE.
052400   CALL 'cobdom_fetch' USING 'LOADESAM',
052500     '/res/text/es/aboutme.txt', 'GET', WS-NULL-BYTE.
052600   CONTINUE.
052700 UPDATE-TEXT.
052800   IF WS-LANG = 'us' THEN
052900     CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me'
053000     CALL 'cobdom_inner_html' USING 'contactHeader',
053100       'Contact Information'
053200     CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills'
053300     CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects'
053400     CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'
053500     CALL 'cobdom_inner_html' USING 'navContact', 'Contact'
053600     CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'
053700     CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'
053800     CALL 'cobdom_inner_html' USING 'aboutContent',
053900       TAB OF EN OF WS-TEXTS
054000   ELSE
054100     CALL 'cobdom_inner_html' USING 'aboutHeader', 'Sobre Mi'
054200     CALL 'cobdom_inner_html' USING 'contactHeader',
054300       'Informacion de Contacto'
054400     CALL 'cobdom_inner_html' USING 'skillsHeader', 'Habilidades'
054500     CALL 'cobdom_inner_html' USING 'projectHeader', 'Proyectos'
054600     CALL 'cobdom_inner_html' USING 'navAbout', 'Sobre Mi'
054700     CALL 'cobdom_inner_html' USING 'navContact', 'Contacto'
054800     CALL 'cobdom_inner_html' USING 'navSkills', 'Habilidades'
054900     CALL 'cobdom_inner_html' USING 'navProjects', 'Proyectos'
055000     CALL 'cobdom_inner_html' USING 'aboutContent',
055100       TAB OF ES OF WS-TEXTS
055200   END-IF.
055300   CONTINUE.
055400 LANG-CHECK.
055500   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
055600     'lang'.
055700   IF WS-LANG = WS-NULL-BYTE THEN
055800     CALL 'cobdom_set_cookie' USING 'us', 'lang'
055900     MOVE 'us' TO WS-LANG
056000   END-IF.
056100   PERFORM SET-ACTIVE-FLAG.
056200   CONTINUE.
056300 COOKIE-ASK.
056400   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
056500   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
056600   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
056700   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
056800   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
056900   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
057000     '#00ff00'.
057100   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
057200     'center'.
057300   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
057400-'llow cookies to store your preferences such as language?&nbsp;'.
057500   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
057600   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
057700   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
057800   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
057900   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
058000   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
058100   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
058200   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
058300   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
058400   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
058500   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
058600   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
058700   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
058800     'COOKIEACCEPT'.
058900   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
059000     'COOKIEDENY'.
059100   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
059200   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
059300   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
059400*Note this must be called after the elements are added to the
059500*document because it must search for them.
059600   CALL 'cobdom_class_style' USING 'cookieButton', 
059700     'backgroundColor', '#ff0000'.
059800   CONTINUE.
059900 LOADENAM SECTION.
060000 ENTRY 'LOADENAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
060100   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF EN OF WS-TEXTS.
060200*  DISPLAY ABOUT-ME OF EN OF WS-TEXTS.
060300   PERFORM UPDATE-TEXT.
060400   GOBACK.
060500 LOADESAM SECTION.
060600 ENTRY 'LOADESAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
060700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF ES OF WS-TEXTS.
060800*  DISPLAY ABOUT-ME OF ES OF WS-TEXTS.
060900   PERFORM UPDATE-TEXT.
061000   GOBACK.
061100 MENUTOGGLE SECTION.
061200 ENTRY 'MENUTOGGLE'.
061300   IF WS-MENU-TOGGLE = 0 THEN
061400     MOVE 1 TO WS-MENU-TOGGLE
061500     CALL 'cobdom_style' USING 'navButton', 'transform', 
061600       'scale(0.85)'
061700     CALL 'cobdom_src' USING 'navButton', 
061800       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
061900     CALL 'cobdom_style' USING 'navAbout', 'transform', 
062000       'translate(15rem, 0rem)' 
062100     CALL 'cobdom_style' USING 'navContact', 'transform', 
062200       'translate(15rem, 0rem)' 
062300     CALL 'cobdom_style' USING 'navSkills', 'transform', 
062400       'translate(15rem, 0rem)'
062500    CALL 'cobdom_style' USING 'navProjects', 'transform', 
062600       'translate(15rem, 0rem)'
062700    CALL 'cobdom_style' USING 'navCobol', 'transform', 
062800       'translate(15rem, 0rem)'
062900   ELSE
063000     MOVE 0 TO WS-MENU-TOGGLE
063100     CALL 'cobdom_style' USING 'navButton', 'transform', 
063200       'scale(1.0)'
063300     CALL 'cobdom_src' USING 'navButton', 
063400       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
063500     CALL 'cobdom_style' USING 'navAbout', 'transform', 
063600       'translate(0rem, 0rem)' 
063700     CALL 'cobdom_style' USING 'navContact', 'transform', 
063800       'translate(0rem, 0rem)' 
063900     CALL 'cobdom_style' USING 'navSkills', 'transform', 
064000       'translate(0rem, 0rem)'
064100    CALL 'cobdom_style' USING 'navProjects', 'transform', 
064200       'translate(0rem, 0rem)'
064300    CALL 'cobdom_style' USING 'navCobol', 'transform', 
064400       'translate(0rem, 0rem)'
064500   END-IF.
064600   GOBACK.
064700*TO-DO: Add a timer in case some fonts do never load
064800 FONTLOADED SECTION.
064900 ENTRY 'FONTLOADED'.
065000   ADD 1 TO WS-FONTS-LOADED.
065100   IF WS-FONTS-LOADED = 2 THEN
065200     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
065300     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
065400     CALL 'cobdom_style' USING 'cobolHeader', 'fontFamily',
065500       'ibmpc'
065600     CALL 'cobdom_style' USING 'cobolContent', 'fontFamily',
065700       'ibmpc'
065800   END-IF.
065900   GOBACK.
066000 WINDOWCHANGE SECTION.
066100 ENTRY 'WINDOWCHANGE'.
066200   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
066300   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
066400     '300'.
066500*Optimize this buffer time to not have a noticeable delay but also
066600*not call to often.
066700   GOBACK.
066800 SHAPEPAGE SECTION.
066900 ENTRY 'SHAPEPAGE'.
067000*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
067100*  DISPLAY 'Rendering! ' CENTISECS.
067200   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
067300     'window.innerWidth'.
067400   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
067500   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
067600     'window.innerHeight'.
067700   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
067800   GOBACK.
067900 COOKIEACCEPT SECTION.
068000 ENTRY 'COOKIEACCEPT'.
068100   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
068200   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
068300   MOVE 'y' TO WS-COOKIE-ALLOWED.
068400   IF WS-LANG = 'us' THEN
068500     CALL 'cobdom_set_cookie' USING 'us', 'lang'
068600   ELSE
068700     CALL 'cobdom_set_cookie' USING 'en', 'lang'
068800   END-IF.
068900   GOBACK.
069000 COOKIEDENY SECTION.
069100 ENTRY 'COOKIEDENY'.
069200   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
069300   MOVE 'n' TO WS-COOKIE-ALLOWED.
069400   GOBACK.
069500 SETPERCENTCOBOL SECTION.
069600 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
069700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
069800   CALL 'cobdom_inner_html' USING 'percentCobol',
069900     WS-PERCENT-COBOL.
070000   DISPLAY 'Currently this website is written in ' 
070100     WS-PERCENT-COBOL '% COBOL.'.
070200   GOBACK.
070300 SETLANG SECTION.
070400 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
070500   if WS-LANG-SELECT-TOGGLE = 0 THEN
070600     MOVE 1 TO WS-LANG-SELECT-TOGGLE
070700     IF WS-LANG = 'us' THEN
070800       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
070900       CALL 'cobdom_style' USING 'langUS', 'transform', 
071000         'translate(0rem, 0rem)'
071100*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
071200     ELSE
071300       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
071400       CALL 'cobdom_style' USING 'langUS', 'transform', 
071500         'translate(0rem, 0rem)'
071600*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
071700     END-IF
071800   ELSE
071900     MOVE 0 TO WS-LANG-SELECT-TOGGLE
072000     IF WS-COOKIE-ALLOWED = 'y' THEN
072100       IF LS-LANG-CHOICE = 'us' THEN
072200         CALL 'cobdom_set_cookie' USING 'us', 'lang'
072300         MOVE 'us' TO WS-LANG
072400       ELSE
072500         CALL 'cobdom_set_cookie' USING 'es', 'lang'
072600         MOVE 'es' TO WS-LANG
072700       END-IF
072800       PERFORM SET-ACTIVE-FLAG
072900     ELSE
073000       MOVE LS-LANG-CHOICE TO WS-LANG
073100       PERFORM SET-ACTIVE-FLAG 
073200     END-IF
073300   END-IF.
073400   GOBACK.
073500 SETLANGUS SECTION.
073600 ENTRY 'SETLANGUS'.
073700   CALL 'SETLANG' USING 'us'.
073800   GOBACK.
073900 SETLANGES SECTION.
074000 ENTRY 'SETLANGES'.
074100   CALL 'SETLANG' USING 'es'.
074200   GOBACK.
074300*TERMINPUT SECTION.
074400*ENTRY 'TERMINPUT' USING LS-TERM-IN.
074500*  DISPLAY LS-TERM-IN.
074600*  GOBACK.
