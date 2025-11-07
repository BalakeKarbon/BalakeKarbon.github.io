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
003800     10 TAB-COB PIC X(12) VALUE '&nbsp;&nbsp;'.
003900     10 COBOL-A PIC X(1000).
004000     10 PERCENT PIC X(5).
004100     10 COBOL-B PIC X(1000).
004200     10 NB PIC X(1) VALUE X'00'.
004300   05 ES.
004400     10 TAB PIC X(12) VALUE '&nbsp;&nbsp;'.
004500     10 ABOUT-ME PIC X(1000).
004600     10 NB PIC X(1) VALUE X'00'.
004700     10 TAB-COB PIC X(12) VALUE '&nbsp;&nbsp;'.
004800     10 COBOL-A PIC X(1000).
004900     10 PERCENT PIC X(5).
005000     10 COBOL-B PIC X(1000).
005100     10 NB PIC X(1) VALUE X'00'.
005200*This has to be pic 10 as that is what is returned from
005300*the library.
005400 LINKAGE SECTION.
005500 01 LS-BLOB PIC X(100000).
005600 01 LS-BLOB-SIZE PIC 9(10).
005700 01 LS-LANG-CHOICE PIC XX.
005800 01 LS-TERM-IN PIC X(10).
005900 PROCEDURE DIVISION.
006000 MAIN SECTION.
006100 ENTRY 'MAIN'.
006200   CALL 'cobdom_style' USING 'body', 'margin', '0'.
006300*  CALL 'cobdom_style' USING 'body', 'color', '#ffffff'.
006400   CALL 'cobdom_style' USING 'body', 'fontSize', '1.5rem'.
006500   CALL 'cobdom_style' USING 'body', 'display', 'flex'.
006600   CALL 'cobdom_style' USING 'body', 'alignItems', 'center'.
006700   CALL 'cobdom_style' USING 'body', 'justifyContent', 'center'.
006800   CALL 'cobdom_add_event_listener' USING 'window', 'resize', 
006900     'WINDOWCHANGE'.
007000   CALL 'cobdom_add_event_listener' USING 'window', 
007100     'orientationchange', 'WINDOWCHANGE'.
007200   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
007300     'allowCookies'.
007400   CALL 'cobdom_create_element' USING 'percentCobol', 'span'.
007500   CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
007600     '/res/percent.txt', 'GET', WS-NULL-BYTE.
007700*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
007800*Setup content div
007900   CALL 'cobdom_create_element' USING 'contentDiv', 'div'.
008000   CALL 'cobdom_style' USING 'contentDiv', 'marginTop', '10rem'.
008100   CALL 'cobdom_style' USING 'contentDiv', 'marginBottom', 
008200     '10rem'.
008300*  CALL 'cobdom_inner_html' USING 'contentDiv', 
008400*  CALL 'cobdom_style' USING 'contentDiv', 'maxWidth', '80rem'.
008500   CALL 'cobdom_style' USING 'contentDiv', 'backgroundColor',
008600     'brown'.
008700*  CALL 'cobdom_style' USING 'contentDiv', 'width', '100%'.
008800   CALL 'cobdom_style' USING 'contentDiv', 'width', '80%'.
008900*  CALL 'cobdom_style' USING 'contentDiv', 'height', '100vh'.
009000   CALL 'cobdom_style' USING 'contentDiv', 'display', 'flex'.
009100   CALL 'cobdom_style' USING 'contentDiv', 'flexDirection',
009200     'column'.
009300   CALL 'cobdom_style' USING 'contentDiv', 'alignItems',
009400     'flex-start'.
009500   CALL 'cobdom_append_child' USING 'contentDiv', 'body'.
009600*Set up blink style
009700   CALL 'cobdom_create_element' USING 'blinkStyle', 'style'.
009800   CALL 'cobdom_inner_html' USING 'blinkStyle', 
009900 '.blink { animation: blink 1s step-start infinite; } @keyframes b
010000-'link { 50% { opacity: 0; } }'.
010100   PERFORM BUILD-MENUBAR.
010200   PERFORM BUILD-CONTENT.
010300*Load and set fonts
010400   CALL 'cobdom_font_face' USING 'mainFont',
010500     'url("/res/fonts/1971-ibm-3278/3270-Regular.ttf")',
010600*    'url("/res/fonts/Proggy/ProggyVector-Regular.otf")',
010700     'FONTLOADED'.
010800   CALL 'cobdom_font_face' USING 'ibmpc',
010900*    'url("/res/fonts/1977-commodore-pet/PetMe.ttf")',
011000     'url("/res/fonts/1985-ibm-pc-vga/PxPlus_IBM_VGA8.ttf")',
011100     'FONTLOADED'.
011200*Load texts
011300   PERFORM LOAD-TEXTS.
011400*Terminal
011500*  CALL 'cobdom_create_element' USING 'terminalDiv', 'div'.
011600*  CALL 'cobdom_append_child' USING 'terminalDiv', 'contentDiv'.
011700*  CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB,
011800*    '(function() { window["term"] = new Terminal(); window["term"
011900*'].open(window["terminalDiv"]); term.onData(data => { Module.ccal
012000*'l("TERMINPUT", null, ["string"], [data]); }); return ""; })()'.
012100*Check for cookies
012200   IF WS-COOKIE-ALLOWED = 'y' THEN
012300     PERFORM LANG-CHECK
012400*GET LAST LOGIN
012500   ELSE
012600     PERFORM COOKIE-ASK
012700     MOVE 'us' TO WS-LANG
012800     PERFORM SET-ACTIVE-FLAG
012900   END-IF.
013000*Render
013100   CALL 'SHAPEPAGE'.
013200   GOBACK.
013300 RELOAD-TEXT.
013400   CONTINUE.
013500 BUILD-CONTENT.
013600*  CALL 'cobdom_create_element' USING 'profilePic', 'img'.
013700*  CALL 'cobdom_src' USING 'profilePic', '/res/img/me.png'.
013800*  CALL 'cobdom_style' USING 'profilePic', 'width', '20rem'.
013900*  CALL 'cobdom_style' USING 'profilePic', 'height', '20rem'.
014000*  CALL 'cobdom_style' USING 'profilePic', 'borderRadius', '50%'.
014100*  CALL 'cobdom_style' USING 'profilePic', 'objectFit', 'cover'.
014200*  CALL 'cobdom_style' USING 'profilePic', 'objectPosition',
014300*    '50% 0%'.
014400*  CALL 'cobdom_style' USING 'profilePic', 'height', '20rem'.
014500* 
014600*  CALL 'cobdom_append_child' USING 'profilePic', 'introContent'.
014700*About section
014800   CALL 'cobdom_create_element' USING 'aboutSection', 'div'.
014900   CALL 'cobdom_style' USING 'aboutSection', 'width', '100%'.
015000*  CALL 'cobdom_style' USING 'aboutSection', 'margin', '2rem'.
015100   CALL 'cobdom_create_element' USING 'aboutHeader', 'div'.
015200   CALL 'cobdom_set_class' USING 'aboutHeader',
015300     'contentHeadersClass'.
015400   CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me:'.
015500   CALL 'cobdom_create_element' USING 'aboutContent', 'div'.
015600   CALL 'cobdom_append_child' USING 'aboutSection',
015700     'contentDiv'.
015800   CALL 'cobdom_append_child' USING 'aboutHeader',
015900     'aboutSection'.
016000   CALL 'cobdom_append_child' USING 'aboutContent',
016100     'aboutSection'.
016200   CALL 'cobdom_create_element' USING 'ghStatsImg', 'img'.
016300   CALL 'cobdom_src' USING 'ghStatsImg', 'https://github-readme-st
016400-'ats.vercel.app/api/top-langs?username=BalakeKarbon&show_icons=tr
016500-'ue&locale=en&layout=compact&hide=html&theme=dark&hide_title=true
016600-'&card_width=500'.
016700   CALL 'cobdom_style' USING 'ghStatsImg', 'height', '15rem'.
016800   CALL 'cobdom_style' USING 'ghStatsImg', 'width', '100%'.
016900   CALL 'cobdom_append_child' USING 'ghStatsImg', 'aboutSection'.
017000*Contact section / Links / Socials
017100*Email,
017200*GitHub, LinkedIN
017300*Youtube, TikTok, Instagram,
017400   CALL 'cobdom_create_element' USING 'contactSection', 'div'.
017500   CALL 'cobdom_style' USING 'contactSection', 'width', '100%'.
017600   CALL 'cobdom_create_element' USING 'contactHeader', 'div'.
017700   CALL 'cobdom_set_class' USING 'contactHeader',
017800     'contentHeadersClass'.
017900   CALL 'cobdom_inner_html' USING 'contactHeader',
018000     'Contact Information:'.
018100   CALL 'cobdom_create_element' USING 'contactContent', 'div'.
018200   CALL 'cobdom_style' USING 'contactContent', 'width', '100%'.
018300   CALL 'cobdom_style' USING 'contactContent', 'textAlign',
018400     'center'.
018500   CALL 'cobdom_append_child' USING 'contactSection',
018600     'contentDiv'.
018700   CALL 'cobdom_append_child' USING 'contactHeader',
018800     'contactSection'.
018900   CALL 'cobdom_append_child' USING 'contactContent',
019000     'contactSection'.
019100   CALL 'cobdom_create_element' USING 'emailDiv', 'div'.
019200   CALL 'cobdom_inner_html' USING 'emailDiv',
019300     'karboncodes@gmail.com'.
019400   CALL 'cobdom_create_element' USING 'linksDiv', 'div'.
019500   CALL 'cobdom_style' USING 'linksDiv', 'display', 'flex'.
019600   CALL 'cobdom_style' USING 'linksDiv', 'width', '100%'.
019700   CALL 'cobdom_style' USING 'linksDiv', 'justifyContent',
019800     'center'.
019900*The following section could be done with a loop but it is not
020000*which is horrid
020100*GitHub
020200   CALL 'cobdom_create_element' USING 'ghContainer', 'span'.
020300   CALL 'cobdom_add_event_listener' USING 'ghContainer',
020400     'click', 'OPENGH'.
020500   CALL 'cobdom_set_class' USING 'ghContainer',
020600     'contactContainer'.
020700   CALL 'cobdom_create_element' USING 'ghImage', 'img'.
020800   CALL 'cobdom_src' USING 'ghImage', 
020900     '/res/icons/tabler-icons/icons/outline/brand-github.svg'.
021000   CALL 'cobdom_style' USING 'ghImage', 'width', '6rem'.
021100   CALL 'cobdom_style' USING 'ghImage', 'height', '6rem'.
021200   CALL 'cobdom_create_element' USING 'ghText', 'div'.
021300   CALL 'cobdom_inner_html' USING 'ghText', 'GitHub'.
021400   CALL 'cobdom_append_child' USING 'ghImage', 'ghContainer'.
021500   CALL 'cobdom_append_child' USING 'ghText', 'ghContainer'.
021600   CALL 'cobdom_append_child' USING 'ghContainer', 'linksDiv'.
021700*LinkedIn
021800   CALL 'cobdom_create_element' USING 'liContainer', 'span'.
021900   CALL 'cobdom_add_event_listener' USING 'liContainer',
022000     'click', 'OPENLI'.
022100   CALL 'cobdom_set_class' USING 'liContainer',
022200     'contactContainer'.
022300   CALL 'cobdom_create_element' USING 'liImage', 'img'.
022400   CALL 'cobdom_src' USING 'liImage', 
022500     '/res/icons/tabler-icons/icons/outline/brand-linkedin.svg'.
022600   CALL 'cobdom_style' USING 'liImage', 'width', '6rem'.
022700   CALL 'cobdom_style' USING 'liImage', 'height', '6rem'.
022800   CALL 'cobdom_create_element' USING 'liText', 'div'.
022900   CALL 'cobdom_inner_html' USING 'liText', 'Linkedin'.
023000   CALL 'cobdom_append_child' USING 'liImage', 'liContainer'.
023100   CALL 'cobdom_append_child' USING 'liText', 'liContainer'.
023200   CALL 'cobdom_append_child' USING 'liContainer', 'linksDiv'.
023300*Youtube
023400   CALL 'cobdom_create_element' USING 'ytContainer', 'span'.
023500   CALL 'cobdom_add_event_listener' USING 'ytContainer',
023600     'click', 'OPENYT'.
023700   CALL 'cobdom_set_class' USING 'ytContainer',
023800     'contactContainer'.
023900   CALL 'cobdom_create_element' USING 'ytImage', 'img'.
024000   CALL 'cobdom_src' USING 'ytImage', 
024100     '/res/icons/tabler-icons/icons/outline/brand-youtube.svg'.
024200   CALL 'cobdom_style' USING 'ytImage', 'width', '6rem'.
024300   CALL 'cobdom_style' USING 'ytImage', 'height', '6rem'.
024400   CALL 'cobdom_create_element' USING 'ytText', 'div'.
024500   CALL 'cobdom_inner_html' USING 'ytText', 'Youtube'.
024600   CALL 'cobdom_append_child' USING 'ytImage', 'ytContainer'.
024700   CALL 'cobdom_append_child' USING 'ytText', 'ytContainer'.
024800   CALL 'cobdom_append_child' USING 'ytContainer', 'linksDiv'.
024900*TikTok
025000   CALL 'cobdom_create_element' USING 'ttContainer', 'span'.
025100   CALL 'cobdom_add_event_listener' USING 'ttContainer',
025200     'click', 'OPENTT'.
025300   CALL 'cobdom_set_class' USING 'ttContainer',
025400     'contactContainer'.
025500   CALL 'cobdom_create_element' USING 'ttImage', 'img'.
025600   CALL 'cobdom_src' USING 'ttImage', 
025700     '/res/icons/tabler-icons/icons/outline/brand-tiktok.svg'.
025800   CALL 'cobdom_style' USING 'ttImage', 'width', '6rem'.
025900   CALL 'cobdom_style' USING 'ttImage', 'height', '6rem'.
026000   CALL 'cobdom_create_element' USING 'ttText', 'div'.
026100   CALL 'cobdom_inner_html' USING 'ttText', 'TikTok'.
026200   CALL 'cobdom_append_child' USING 'ttImage', 'ttContainer'.
026300   CALL 'cobdom_append_child' USING 'ttText', 'ttContainer'.
026400   CALL 'cobdom_append_child' USING 'ttContainer', 'linksDiv'.
026500*Instagram
026600   CALL 'cobdom_create_element' USING 'igContainer', 'span'.
026700   CALL 'cobdom_add_event_listener' USING 'igContainer',
026800     'click', 'OPENIG'.
026900   CALL 'cobdom_set_class' USING 'igContainer',
027000     'contactContainer'.
027100   CALL 'cobdom_create_element' USING 'igImage', 'img'.
027200   CALL 'cobdom_src' USING 'igImage', 
027300     '/res/icons/tabler-icons/icons/outline/brand-instagram.svg'.
027400   CALL 'cobdom_style' USING 'igImage', 'width', '6rem'.
027500   CALL 'cobdom_style' USING 'igImage', 'height', '6rem'.
027600   CALL 'cobdom_create_element' USING 'igText', 'div'.
027700   CALL 'cobdom_inner_html' USING 'igText', 'Instagram'.
027800   CALL 'cobdom_append_child' USING 'igImage', 'igContainer'.
027900   CALL 'cobdom_append_child' USING 'igText', 'igContainer'.
028000   CALL 'cobdom_append_child' USING 'igContainer', 'linksDiv'.
028100 
028200   CALL 'cobdom_append_child' USING 'emailDiv', 'contactContent'.
028300   CALL 'cobdom_append_child' USING 'linksDiv', 'contactContent'.
028400*Skills section
028500*  CALL 'cobdom_create_element' USING 'skillsSection', 'div'.
028600*  CALL 'cobdom_style' USING 'skillsSection', 'width', '100%'.
028700*  CALL 'cobdom_create_element' USING 'skillsHeader', 'div'.
028800*  CALL 'cobdom_set_class' USING 'skillsHeader',
028900*    'contentHeadersClass'.
029000*  CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills:'.
029100*  CALL 'cobdom_create_element' USING 'skillsContent', 'div'.
029200*
029300*  CALL 'cobdom_append_child' USING 'skillsSection',
029400*    'contentDiv'.
029500*  CALL 'cobdom_append_child' USING 'skillsHeader',
029600*    'skillsSection'.
029700*  CALL 'cobdom_append_child' USING 'skillsContent',
029800*    'skillsSection'.
029900*Project section
030000   CALL 'cobdom_create_element' USING 'projectSection', 'div'.
030100   CALL 'cobdom_style' USING 'projectSection', 'width', '100%'.
030200*  CALL 'cobdom_style' USING 'projectSection', 'margin', '2rem'.
030300   CALL 'cobdom_create_element' USING 'projectHeader', 'div'.
030400   CALL 'cobdom_set_class' USING 'projectHeader',
030500     'contentHeadersClass'.
030600   CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects:'.
030700   CALL 'cobdom_create_element' USING 'projectContent', 'div'.
030800   CALL 'cobdom_append_child' USING 'projectSection', 
030900     'contentDiv'.
031000   CALL 'cobdom_append_child' USING 'projectHeader', 
031100     'projectSection'.
031200   CALL 'cobdom_append_child' USING 'projectContent', 
031300     'projectSection'.
031400*Cobol section
031500   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
031600   CALL 'cobdom_style' USING 'cobolSection', 'width', '100%'.
031700*  CALL 'cobdom_style' USING 'cobolSection', 'margin', '2rem'.
031800   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
031900   CALL 'cobdom_set_class' USING 'cobolHeader',
032000     'contentHeadersClass'.
032100   CALL 'cobdom_inner_html' USING 'cobolHeader', 'COBOL'.
032200   CALL 'cobdom_create_element' USING 'cobolContent', 'span'.
032300   CALL 'cobdom_append_child' USING 'cobolSection',
032400     'contentDiv'.
032500   CALL 'cobdom_append_child' USING 'cobolHeader', 
032600     'cobolSection'.
032700   CALL 'cobdom_append_child' USING 'cobolContent', 
032800     'cobolSection'.
032900   CALL 'cobdom_create_element' USING 'cobolGithubLink',
033000     'span'.
033100   CALL 'cobdom_add_event_listener' USING 'cobolGithubLink',
033200     'click', 'OPENCOBOLSOURCE'.
033300   CALL 'cobdom_inner_html' USING 'cobolGithubLink',
033400     'GitHub.'.
033500   CALL 'cobdom_style' USING 'cobolGithubLink', 'textDecoration',
033600     'underline'.
033700   CALL 'cobdom_append_child' USING 'cobolGithubLink',
033800     'cobolSection'.
033900*Set contentHeadersClass class styles. Must be called after elements
034000*exist as this uses getElementsByClassName. A safer option would
034100*be to make a new style element but for the sake of demnostrating
034200*this part of the library I will use this here.
034300   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
034400     'fontSize', '2.5rem'.
034500   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
034600     'width', '100%'.
034700   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
034800     'textAlign', 'center'.
034900   CALL 'cobdom_class_style' USING 'contentHeadersClass',
035000     'fontWeight', 'bold'.
035100   CALL 'cobdom_class_style' USING 'contactContainer', 'margin',
035200     '1rem'.
035300  CALL 'cobdom_class_style' USING 'contactContainer', 'display',
035400     'flex'. 
035500   CALL 'cobdom_class_style' USING 'contactContainer',
035600     'flexDirection', 'column'.
035700   CALL 'cobdom_class_style' USING 'contactContainer',
035800     'alignItems', 'center'.
035900   CONTINUE.
036000 BUILD-MENUBAR.
036100   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
036200   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
036300   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
036400   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
036500     'space-between'.
036600   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
036700   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
036800   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
036900   CALL 'cobdom_style' USING 'headerDiv', 'backgroundColor',
037000     '#c0c0c0'.
037100*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
037200*    'blur(5px)'.
037300*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
037400*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
037500*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
037600*    '1rem'.
037700*  CALL 'cobdom_style' USING 'headerDiv',
037800*    'borderBottomRightRadius','1rem'.
037900   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
038000*Setup menu
038100   CALL 'cobdom_create_element' USING 'navArea', 'div'.
038200*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
038300   CALL 'cobdom_create_element' USING 'navButton', 'img'.
038400   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
038500   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
038600   CALL 'cobdom_src' USING 'navButton', 
038700     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
038800   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
038900     '#D9D4C7'.
039000*  CALL 'cobdom_style' USING 'navButton', 'filter', 
039100*    'invert(100%)'.
039200   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
039300   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
039400   CALL 'cobdom_style' USING 'navButton', 'padding', '.25rem'.
039500   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
039600   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
039700   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
039800   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
039900*Setup menu selectors
040000*About Me
040100   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
040200   CALL 'cobdom_add_event_listener' USING 'navAbout',
040300     'click', 'NAVABOUT'.
040400   CALL 'cobdom_style' USING 'navAbout', 'position', 'absolute'.
040500   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
040600     '#c0c0c0'.
040700*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
040800*    'blur(5px)'.
040900   CALL 'cobdom_style' USING 'navAbout', 
041000     'borderBottomRightRadius', '0.5rem'.
041100   CALL 'cobdom_style' USING 'navAbout', 
041200     'borderTopRightRadius', '0.5rem'.
041300   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
041400   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
041500   CALL 'cobdom_style' USING 'navAbout', 'top', '9rem'.
041600   CALL 'cobdom_style' USING 'navAbout', 'left', '-15rem'.
041700   CALL 'cobdom_style' USING 'navAbout', 'transition', 
041800     'transform 0.5s ease 0.1s'.
041900   CALL 'cobdom_append_child' USING 'navAbout', 'headerDiv'.
042000*Contact Me
042100   CALL 'cobdom_create_element' USING 'navContact', 'div'.
042200   CALL 'cobdom_add_event_listener' USING 'navContact',
042300     'click', 'NAVCONTACT'.
042400   CALL 'cobdom_style' USING 'navContact', 'position', 'absolute'.
042500   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
042600     '#c0c0c0'.
042700*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
042800*    'blur(5px)'.
042900   CALL 'cobdom_style' USING 'navContact', 
043000     'borderBottomRightRadius', '0.5rem'.
043100   CALL 'cobdom_style' USING 'navContact', 
043200     'borderTopRightRadius', '0.5rem'.
043300   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
043400   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
043500   CALL 'cobdom_style' USING 'navContact', 'top', '11rem'.
043600   CALL 'cobdom_style' USING 'navContact', 'left', '-15rem'.
043700   CALL 'cobdom_style' USING 'navContact', 'transition', 
043800     'transform 0.5s ease 0.2s'.
043900   CALL 'cobdom_append_child' USING 'navContact', 'headerDiv'.
044000*Skills
044100*  CALL 'cobdom_create_element' USING 'navSkills', 'div'.
044200*  CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
044300*  CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
044400*    '#c0c0c0'.
044500*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
044600*    'blur(5px)'.
044700*  CALL 'cobdom_style' USING 'navSkills', 
044800*    'borderBottomRightRadius', '0.5rem'.
044900*  CALL 'cobdom_style' USING 'navSkills', 
045000*    'borderTopRightRadius', '0.5rem'.
045100*  CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
045200*  CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
045300*  CALL 'cobdom_style' USING 'navSkills', 'top', '13rem'.
045400*  CALL 'cobdom_style' USING 'navSkills', 'left', '-15rem'.
045500*  CALL 'cobdom_style' USING 'navSkills', 'transition', 
045600*    'transform 0.5s ease 0.3s'.
045700*  CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
045800*Projects
045900   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
046000   CALL 'cobdom_add_event_listener' USING 'navProjects',
046100     'click', 'NAVPROJECTS'.
046200   CALL 'cobdom_style' USING 'navProjects', 'position', 
046300     'absolute'.
046400   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
046500     '#c0c0c0'.
046600*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
046700*    'blur(5px)'.
046800   CALL 'cobdom_style' USING 'navProjects', 
046900     'borderBottomRightRadius', '0.5rem'.
047000   CALL 'cobdom_style' USING 'navProjects', 
047100     'borderTopRightRadius', '0.5rem'.
047200   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
047300   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
047400   CALL 'cobdom_style' USING 'navProjects', 'top', '13rem'.
047500   CALL 'cobdom_style' USING 'navProjects', 'left', '-15rem'.
047600   CALL 'cobdom_style' USING 'navProjects', 'transition', 
047700     'transform 0.5s ease 0.4s'.
047800   CALL 'cobdom_append_child' USING 'navProjects', 'headerDiv'.
047900*Cobol?
048000   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
048100   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
048200   CALL 'cobdom_add_event_listener' USING 'navCobol',
048300     'click', 'NAVCOBOL'.
048400   CALL 'cobdom_style' USING 'navCobol', 'position', 
048500     'absolute'.
048600   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
048700     '#000000'.
048800*    '#c0c0c0'.
048900*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
049000*    'blur(5px)'.
049100   CALL 'cobdom_style' USING 'navCobol', 'color', 
049200     '#00ff00'.
049300   CALL 'cobdom_style' USING 'navCobol', 
049400     'borderBottomRightRadius', '0.5rem'.
049500   CALL 'cobdom_style' USING 'navCobol', 
049600     'borderTopRightRadius', '0.5rem'.
049700   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
049800   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
049900   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
050000   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
050100   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
050200   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
050300   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
050400   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
050500   CALL 'cobdom_style' USING 'navCobol', 'top', '15rem'.
050600   CALL 'cobdom_style' USING 'navCobol', 'left', '-15rem'.
050700   CALL 'cobdom_style' USING 'navCobol', 'transition', 
050800     'transform 0.5s ease 0.5s'.
050900   CALL 'cobdom_append_child' USING 'navCobol', 'headerDiv'.
051000*Add main menu button
051100   CALL 'cobdom_append_child' USING 'navArea', 'headerDiv'.
051200   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
051300     'MENUTOGGLE'.
051400*Setup ID area
051500   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
051600   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
051700   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
051800   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
051900   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '4rem'.
052000   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
052100   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
052200   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
052300   CALL 'cobdom_inner_html' USING 'taglineDiv', 
052400     'A guy that knows a guy.'.
052500   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
052600   CALL 'cobdom_append_child' USING 'idDiv', 'headerDiv'.
052700*Setup lang area
052800   CALL 'cobdom_create_element' USING 'langArea', 'span'.
052900   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
053000   CALL 'cobdom_append_child' USING 'langArea', 'headerDiv'.
053100*Setup language selector
053200   CALL 'cobdom_create_element' USING 'langUS', 'img'.
053300   CALL 'cobdom_create_element' USING 'langES', 'img'.
053400   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
053500   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
053600   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
053700   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
053800   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
053900   CALL 'cobdom_style' USING 'langUS', 'transition', 
054000     'opacity 0.5s ease, transform 0.5s ease'.
054100*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
054200*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
054300   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
054400   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
054500   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
054600   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
054700   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
054800   CALL 'cobdom_style' USING 'langES', 'transition', 
054900     'opacity 0.5s ease, transform 0.5s ease'.
055000*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
055100*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
055200   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
055300   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
055400     'SETLANGUS'.
055500   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
055600   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
055700     'SETLANGES'.
055800   CONTINUE.
055900 SET-ACTIVE-FLAG.
056000   IF WS-LANG = 'us' THEN
056100     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
056200     CALL 'cobdom_style' USING 'langUS', 'transform', 
056300       'translate(9rem, 0rem)'
056400     PERFORM UPDATE-TEXT
056500   ELSE
056600     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
056700     CALL 'cobdom_style' USING 'langUS', 'transform', 
056800       'translate(9rem, 0rem)'
056900     PERFORM UPDATE-TEXT
057000   END-IF.
057100   CONTINUE.
057200 LOAD-TEXTS.
057300   CALL 'cobdom_fetch' USING 'LOADENAM',
057400     '/res/text/en/aboutme.txt', 'GET', WS-NULL-BYTE.
057500   CALL 'cobdom_fetch' USING 'LOADESAM',
057600     '/res/text/es/aboutme.txt', 'GET', WS-NULL-BYTE.
057700   CALL 'cobdom_fetch' USING 'LOADENCOBA',
057800     '/res/text/en/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
057900   CALL 'cobdom_fetch' USING 'LOADENCOBB',
058000     '/res/text/en/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
058100   CALL 'cobdom_fetch' USING 'LOADESCOBA',
058200     '/res/text/es/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
058300   CALL 'cobdom_fetch' USING 'LOADESCOBB',
058400     '/res/text/es/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
058500   CONTINUE.
058600 UPDATE-TEXT.
058700   IF WS-LANG = 'us' THEN
058800     CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me'
058900     CALL 'cobdom_inner_html' USING 'contactHeader',
059000       'Contact Information / Links'
059100*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills'
059200     CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects'
059300     CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'
059400     CALL 'cobdom_inner_html' USING 'navContact', 'Contact/Links'
059500*    CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'
059600     CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'
059700     CALL 'cobdom_inner_html' USING 'aboutContent',
059800       TAB OF EN OF WS-TEXTS
059900     CALL 'cobdom_inner_html' USING 'cobolContent',
060000       TAB-COB OF EN OF WS-TEXTS
060100   ELSE
060200     CALL 'cobdom_inner_html' USING 'aboutHeader', 'Sobre Mi'
060300     CALL 'cobdom_inner_html' USING 'contactHeader',
060400       'Informacion de Contacto / Enlaces'
060500*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Habilidades'
060600     CALL 'cobdom_inner_html' USING 'projectHeader', 'Proyectos'
060700     CALL 'cobdom_inner_html' USING 'navAbout', 'Sobre Mi'
060800     CALL 'cobdom_inner_html' USING 'navContact',
060900       'Contacto/Enlaces'
061000*    CALL 'cobdom_inner_html' USING 'navSkills', 'Habilidades'
061100     CALL 'cobdom_inner_html' USING 'navProjects', 'Proyectos'
061200     CALL 'cobdom_inner_html' USING 'aboutContent',
061300       TAB OF ES OF WS-TEXTS
061400     CALL 'cobdom_inner_html' USING 'cobolContent',
061500       TAB-COB OF ES OF WS-TEXTS
061600   END-IF.
061700   CONTINUE.
061800 LANG-CHECK.
061900   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
062000     'lang'.
062100   IF WS-LANG = WS-NULL-BYTE THEN
062200     CALL 'cobdom_set_cookie' USING 'us', 'lang'
062300     MOVE 'us' TO WS-LANG
062400   END-IF.
062500   PERFORM SET-ACTIVE-FLAG.
062600   CONTINUE.
062700 COOKIE-ASK.
062800   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
062900   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
063000   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
063100   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
063200   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
063300   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
063400     '#00ff00'.
063500   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
063600     'center'.
063700   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
063800-'llow cookies to store your preferences such as language?&nbsp;'.
063900   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
064000   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
064100   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
064200   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
064300   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
064400   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
064500   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
064600   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
064700   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
064800   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
064900   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
065000   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
065100   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
065200     'COOKIEACCEPT'.
065300   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
065400     'COOKIEDENY'.
065500   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
065600   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
065700   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
065800*Note this must be called after the elements are added to the
065900*document because it must search for them.
066000   CALL 'cobdom_class_style' USING 'cookieButton', 
066100     'backgroundColor', '#ff0000'.
066200   CONTINUE.
066300 LOADENAM SECTION.
066400 ENTRY 'LOADENAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
066500   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF EN OF WS-TEXTS.
066600   PERFORM UPDATE-TEXT.
066700   GOBACK.
066800 LOADESAM SECTION.
066900 ENTRY 'LOADESAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
067000   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF ES OF WS-TEXTS.
067100   PERFORM UPDATE-TEXT.
067200   GOBACK.
067300 LOADENCOBA SECTION.
067400 ENTRY 'LOADENCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
067500   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF EN OF WS-TEXTS.
067600   PERFORM UPDATE-TEXT.
067700   GOBACK.
067800 LOADENCOBB SECTION.
067900 ENTRY 'LOADENCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
068000   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF EN OF WS-TEXTS.
068100   PERFORM UPDATE-TEXT.
068200   GOBACK.
068300 LOADESCOBA SECTION.
068400 ENTRY 'LOADESCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
068500   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF ES OF WS-TEXTS.
068600   PERFORM UPDATE-TEXT.
068700   GOBACK.
068800 LOADESCOBB SECTION.
068900 ENTRY 'LOADESCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
069000   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF ES OF WS-TEXTS.
069100*  DISPLAY ABOUT-ME OF ES OF WS-TEXTS.
069200   PERFORM UPDATE-TEXT.
069300   GOBACK.
069400 NAVABOUT SECTION.
069500 ENTRY 'NAVABOUT'.
069600   CALL 'cobdom_scroll_into_view' USING 'aboutHeader'.
069700   GOBACK.
069800 NAVCONTACT SECTION.
069900 ENTRY 'NAVCONTACT'.
070000   CALL 'cobdom_scroll_into_view' USING 'contactHeader'.
070100   GOBACK.
070200 NAVPROJECTS SECTION.
070300 ENTRY 'NAVPROJECTS'.
070400   CALL 'cobdom_scroll_into_view' USING 'projectHeader'.
070500   GOBACK.
070600 NAVCOBOL SECTION.
070700 ENTRY 'NAVCOBOL'.
070800   CALL 'cobdom_scroll_into_view' USING 'cobolHeader'.
070900   GOBACK.
071000 OPENCOBOLSOURCE SECTION.
071100 ENTRY 'OPENCOBOLSOURCE'.
071200   CALL 'cobdom_open_tab' USING 
071300     'https://github.com/BalakeKarbon/BalakeKarbon.github.io'.
071400   GOBACK.
071500 OPENGH SECTION.
071600 ENTRY 'OPENGH'.
071700   CALL 'cobdom_open_tab' USING 
071800     'https://github.com/BalakeKarbon/'.
071900   GOBACK.
072000 OPENLI SECTION.
072100 ENTRY 'OPENLI'.
072200   CALL 'cobdom_open_tab' USING 
072300     'https://www.linkedin.com/in/blake-karbon/'.
072400   GOBACK.
072500 OPENYT SECTION.
072600 ENTRY 'OPENYT'.
072700   CALL 'cobdom_open_tab' USING 
072800     'https://www.youtube.com/@karboncodes'.
072900   GOBACK.
073000 OPENTT SECTION.
073100 ENTRY 'OPENTT'.
073200   CALL 'cobdom_open_tab' USING 
073300     'https://www.tiktok.com/@karboncodes'.
073400   GOBACK.
073500 OPENIG SECTION.
073600 ENTRY 'OPENIG'.
073700   CALL 'cobdom_open_tab' USING 
073800     'https://www.instagram.com/karboncodes'.
073900   GOBACK.
074000 MENUTOGGLE SECTION.
074100 ENTRY 'MENUTOGGLE'.
074200   IF WS-MENU-TOGGLE = 0 THEN
074300     MOVE 1 TO WS-MENU-TOGGLE
074400     CALL 'cobdom_style' USING 'navButton', 'transform', 
074500       'scale(0.85)'
074600     CALL 'cobdom_src' USING 'navButton', 
074700       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
074800     CALL 'cobdom_style' USING 'navAbout', 'transform', 
074900       'translate(15rem, 0rem)' 
075000     CALL 'cobdom_style' USING 'navContact', 'transform', 
075100       'translate(15rem, 0rem)' 
075200     CALL 'cobdom_style' USING 'navSkills', 'transform', 
075300       'translate(15rem, 0rem)'
075400    CALL 'cobdom_style' USING 'navProjects', 'transform', 
075500       'translate(15rem, 0rem)'
075600    CALL 'cobdom_style' USING 'navCobol', 'transform', 
075700       'translate(15rem, 0rem)'
075800   ELSE
075900     MOVE 0 TO WS-MENU-TOGGLE
076000     CALL 'cobdom_style' USING 'navButton', 'transform', 
076100       'scale(1.0)'
076200     CALL 'cobdom_src' USING 'navButton', 
076300       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
076400     CALL 'cobdom_style' USING 'navAbout', 'transform', 
076500       'translate(0rem, 0rem)' 
076600     CALL 'cobdom_style' USING 'navContact', 'transform', 
076700       'translate(0rem, 0rem)' 
076800     CALL 'cobdom_style' USING 'navSkills', 'transform', 
076900       'translate(0rem, 0rem)'
077000    CALL 'cobdom_style' USING 'navProjects', 'transform', 
077100       'translate(0rem, 0rem)'
077200    CALL 'cobdom_style' USING 'navCobol', 'transform', 
077300       'translate(0rem, 0rem)'
077400   END-IF.
077500   GOBACK.
077600*TO-DO: Add a timer in case some fonts do never load
077700 FONTLOADED SECTION.
077800 ENTRY 'FONTLOADED'.
077900   ADD 1 TO WS-FONTS-LOADED.
078000   IF WS-FONTS-LOADED = 2 THEN
078100     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
078200     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
078300     CALL 'cobdom_style' USING 'cobolSection', 'fontFamily',
078400       'ibmpc'
078500   END-IF.
078600   GOBACK.
078700 WINDOWCHANGE SECTION.
078800 ENTRY 'WINDOWCHANGE'.
078900   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
079000   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
079100     '300'.
079200*Optimize this buffer time to not have a noticeable delay but also
079300*not call to often.
079400   GOBACK.
079500 SHAPEPAGE SECTION.
079600 ENTRY 'SHAPEPAGE'.
079700*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
079800*  DISPLAY 'Rendering! ' CENTISECS.
079900   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
080000     'window.innerWidth'.
080100   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
080200   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
080300     'window.innerHeight'.
080400   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
080500   GOBACK.
080600 COOKIEACCEPT SECTION.
080700 ENTRY 'COOKIEACCEPT'.
080800   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
080900   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
081000   MOVE 'y' TO WS-COOKIE-ALLOWED.
081100   IF WS-LANG = 'us' THEN
081200     CALL 'cobdom_set_cookie' USING 'us', 'lang'
081300   ELSE
081400     CALL 'cobdom_set_cookie' USING 'en', 'lang'
081500   END-IF.
081600   GOBACK.
081700 COOKIEDENY SECTION.
081800 ENTRY 'COOKIEDENY'.
081900   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
082000   MOVE 'n' TO WS-COOKIE-ALLOWED.
082100   GOBACK.
082200 SETPERCENTCOBOL SECTION.
082300 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
082400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF EN OF WS-TEXTS.
082500   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF ES OF WS-TEXTS.
082600*  CALL 'cobdom_inner_html' USING 'percentCobol',
082700*    WS-PERCENT-COBOL.
082800*  DISPLAY 'Currently this website is written in ' 
082900*    WS-PERCENT-COBOL '% COBOL.'.
083000   GOBACK.
083100 SETLANG SECTION.
083200 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
083300   if WS-LANG-SELECT-TOGGLE = 0 THEN
083400     MOVE 1 TO WS-LANG-SELECT-TOGGLE
083500     IF WS-LANG = 'us' THEN
083600       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
083700       CALL 'cobdom_style' USING 'langUS', 'transform', 
083800         'translate(0rem, 0rem)'
083900*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
084000     ELSE
084100       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
084200       CALL 'cobdom_style' USING 'langUS', 'transform', 
084300         'translate(0rem, 0rem)'
084400*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
084500     END-IF
084600   ELSE
084700     MOVE 0 TO WS-LANG-SELECT-TOGGLE
084800     IF WS-COOKIE-ALLOWED = 'y' THEN
084900       IF LS-LANG-CHOICE = 'us' THEN
085000         CALL 'cobdom_set_cookie' USING 'us', 'lang'
085100         MOVE 'us' TO WS-LANG
085200       ELSE
085300         CALL 'cobdom_set_cookie' USING 'es', 'lang'
085400         MOVE 'es' TO WS-LANG
085500       END-IF
085600       PERFORM SET-ACTIVE-FLAG
085700     ELSE
085800       MOVE LS-LANG-CHOICE TO WS-LANG
085900       PERFORM SET-ACTIVE-FLAG 
086000     END-IF
086100   END-IF.
086200   GOBACK.
086300 SETLANGUS SECTION.
086400 ENTRY 'SETLANGUS'.
086500   CALL 'SETLANG' USING 'us'.
086600   GOBACK.
086700 SETLANGES SECTION.
086800 ENTRY 'SETLANGES'.
086900   CALL 'SETLANG' USING 'es'.
087000   GOBACK.
087100*TERMINPUT SECTION.
087200*ENTRY 'TERMINPUT' USING LS-TERM-IN.
087300*  DISPLAY LS-TERM-IN.
087400*  GOBACK.
