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
008500*  CALL 'cobdom_style' USING 'contentDiv', 'backgroundColor',
008600*    'brown'.
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
016500-'ue&locale=en&layout=compact&hide=html&hide_title=true&card_width
016600-'=500'.
016700   CALL 'cobdom_style' USING 'ghStatsImg', 'height', '35rem'.
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
021300   CALL 'cobdom_style' USING 'ghText', 'textDecoration',
021400     'underline'.
021500   CALL 'cobdom_inner_html' USING 'ghText', 'GitHub'.
021600   CALL 'cobdom_append_child' USING 'ghImage', 'ghContainer'.
021700   CALL 'cobdom_append_child' USING 'ghText', 'ghContainer'.
021800   CALL 'cobdom_append_child' USING 'ghContainer', 'linksDiv'.
021900*LinkedIn
022000   CALL 'cobdom_create_element' USING 'liContainer', 'span'.
022100   CALL 'cobdom_add_event_listener' USING 'liContainer',
022200     'click', 'OPENLI'.
022300   CALL 'cobdom_set_class' USING 'liContainer',
022400     'contactContainer'.
022500   CALL 'cobdom_create_element' USING 'liImage', 'img'.
022600   CALL 'cobdom_src' USING 'liImage', 
022700     '/res/icons/tabler-icons/icons/outline/brand-linkedin.svg'.
022800   CALL 'cobdom_style' USING 'liImage', 'width', '6rem'.
022900   CALL 'cobdom_style' USING 'liImage', 'height', '6rem'.
023000   CALL 'cobdom_create_element' USING 'liText', 'div'.
023100   CALL 'cobdom_style' USING 'liText', 'textDecoration',
023200     'underline'.
023300   CALL 'cobdom_inner_html' USING 'liText', 'Linkedin'.
023400   CALL 'cobdom_append_child' USING 'liImage', 'liContainer'.
023500   CALL 'cobdom_append_child' USING 'liText', 'liContainer'.
023600   CALL 'cobdom_append_child' USING 'liContainer', 'linksDiv'.
023700*Youtube
023800   CALL 'cobdom_create_element' USING 'ytContainer', 'span'.
023900   CALL 'cobdom_add_event_listener' USING 'ytContainer',
024000     'click', 'OPENYT'.
024100   CALL 'cobdom_set_class' USING 'ytContainer',
024200     'contactContainer'.
024300   CALL 'cobdom_create_element' USING 'ytImage', 'img'.
024400   CALL 'cobdom_src' USING 'ytImage', 
024500     '/res/icons/tabler-icons/icons/outline/brand-youtube.svg'.
024600   CALL 'cobdom_style' USING 'ytImage', 'width', '6rem'.
024700   CALL 'cobdom_style' USING 'ytImage', 'height', '6rem'.
024800   CALL 'cobdom_create_element' USING 'ytText', 'div'.
024900   CALL 'cobdom_style' USING 'ytText', 'textDecoration',
025000     'underline'.
025100   CALL 'cobdom_inner_html' USING 'ytText', 'Youtube'.
025200   CALL 'cobdom_append_child' USING 'ytImage', 'ytContainer'.
025300   CALL 'cobdom_append_child' USING 'ytText', 'ytContainer'.
025400   CALL 'cobdom_append_child' USING 'ytContainer', 'linksDiv'.
025500*TikTok
025600   CALL 'cobdom_create_element' USING 'ttContainer', 'span'.
025700   CALL 'cobdom_add_event_listener' USING 'ttContainer',
025800     'click', 'OPENTT'.
025900   CALL 'cobdom_set_class' USING 'ttContainer',
026000     'contactContainer'.
026100   CALL 'cobdom_create_element' USING 'ttImage', 'img'.
026200   CALL 'cobdom_src' USING 'ttImage', 
026300     '/res/icons/tabler-icons/icons/outline/brand-tiktok.svg'.
026400   CALL 'cobdom_style' USING 'ttImage', 'width', '6rem'.
026500   CALL 'cobdom_style' USING 'ttImage', 'height', '6rem'.
026600   CALL 'cobdom_create_element' USING 'ttText', 'div'.
026700   CALL 'cobdom_style' USING 'ttText', 'textDecoration',
026800     'underline'.
026900   CALL 'cobdom_inner_html' USING 'ttText', 'TikTok'.
027000   CALL 'cobdom_append_child' USING 'ttImage', 'ttContainer'.
027100   CALL 'cobdom_append_child' USING 'ttText', 'ttContainer'.
027200   CALL 'cobdom_append_child' USING 'ttContainer', 'linksDiv'.
027300*Instagram
027400   CALL 'cobdom_create_element' USING 'igContainer', 'span'.
027500   CALL 'cobdom_add_event_listener' USING 'igContainer',
027600     'click', 'OPENIG'.
027700   CALL 'cobdom_set_class' USING 'igContainer',
027800     'contactContainer'.
027900   CALL 'cobdom_create_element' USING 'igImage', 'img'.
028000   CALL 'cobdom_src' USING 'igImage', 
028100     '/res/icons/tabler-icons/icons/outline/brand-instagram.svg'.
028200   CALL 'cobdom_style' USING 'igImage', 'width', '6rem'.
028300   CALL 'cobdom_style' USING 'igImage', 'height', '6rem'.
028400   CALL 'cobdom_create_element' USING 'igText', 'div'.
028500   CALL 'cobdom_style' USING 'igText', 'textDecoration',
028600     'underline'.
028700   CALL 'cobdom_inner_html' USING 'igText', 'Instagram'.
028800   CALL 'cobdom_append_child' USING 'igImage', 'igContainer'.
028900   CALL 'cobdom_append_child' USING 'igText', 'igContainer'.
029000   CALL 'cobdom_append_child' USING 'igContainer', 'linksDiv'.
029100 
029200   CALL 'cobdom_append_child' USING 'emailDiv', 'contactContent'.
029300   CALL 'cobdom_append_child' USING 'linksDiv', 'contactContent'.
029400*Skills section
029500*  CALL 'cobdom_create_element' USING 'skillsSection', 'div'.
029600*  CALL 'cobdom_style' USING 'skillsSection', 'width', '100%'.
029700*  CALL 'cobdom_create_element' USING 'skillsHeader', 'div'.
029800*  CALL 'cobdom_set_class' USING 'skillsHeader',
029900*    'contentHeadersClass'.
030000*  CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills:'.
030100*  CALL 'cobdom_create_element' USING 'skillsContent', 'div'.
030200*
030300*  CALL 'cobdom_append_child' USING 'skillsSection',
030400*    'contentDiv'.
030500*  CALL 'cobdom_append_child' USING 'skillsHeader',
030600*    'skillsSection'.
030700*  CALL 'cobdom_append_child' USING 'skillsContent',
030800*    'skillsSection'.
030900*Project section
031000   CALL 'cobdom_create_element' USING 'projectSection', 'div'.
031100   CALL 'cobdom_style' USING 'projectSection', 'width', '100%'.
031200*  CALL 'cobdom_style' USING 'projectSection', 'margin', '2rem'.
031300   CALL 'cobdom_create_element' USING 'projectHeader', 'div'.
031400   CALL 'cobdom_set_class' USING 'projectHeader',
031500     'contentHeadersClass'.
031600   CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects:'.
031700   CALL 'cobdom_create_element' USING 'projectContent', 'div'.
031800   CALL 'cobdom_style' USING 'projectContent', 'textAlign',
031900     'center'.
032000   CALL 'cobdom_inner_html' USING 'projectContent', 'WIP'.
032100   CALL 'cobdom_append_child' USING 'projectSection', 
032200     'contentDiv'.
032300   CALL 'cobdom_append_child' USING 'projectHeader', 
032400     'projectSection'.
032500   CALL 'cobdom_append_child' USING 'projectContent', 
032600     'projectSection'.
032700*Cobol section
032800   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
032900   CALL 'cobdom_style' USING 'cobolSection', 'width', '100%'.
033000*  CALL 'cobdom_style' USING 'cobolSection', 'margin', '2rem'.
033100   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
033200   CALL 'cobdom_set_class' USING 'cobolHeader',
033300     'contentHeadersClass'.
033400   CALL 'cobdom_inner_html' USING 'cobolHeader', 'COBOL'.
033500   CALL 'cobdom_create_element' USING 'cobolContent', 'span'.
033600   CALL 'cobdom_append_child' USING 'cobolSection',
033700     'contentDiv'.
033800   CALL 'cobdom_append_child' USING 'cobolHeader', 
033900     'cobolSection'.
034000   CALL 'cobdom_append_child' USING 'cobolContent', 
034100     'cobolSection'.
034200   CALL 'cobdom_create_element' USING 'cobolGithubLink',
034300     'span'.
034400   CALL 'cobdom_add_event_listener' USING 'cobolGithubLink',
034500     'click', 'OPENCOBOLSOURCE'.
034600   CALL 'cobdom_inner_html' USING 'cobolGithubLink',
034700     'GitHub!'.
034800   CALL 'cobdom_style' USING 'cobolGithubLink', 'textDecoration',
034900     'underline'.
035000   CALL 'cobdom_append_child' USING 'cobolGithubLink',
035100     'cobolSection'.
035200*Set contentHeadersClass class styles. Must be called after elements
035300*exist as this uses getElementsByClassName. A safer option would
035400*be to make a new style element but for the sake of demnostrating
035500*this part of the library I will use this here.
035600   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
035700     'fontSize', '2.5rem'.
035800   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
035900     'width', '100%'.
036000   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
036100     'textAlign', 'center'.
036200   CALL 'cobdom_class_style' USING 'contentHeadersClass',
036300     'fontWeight', 'bold'.
036400   CALL 'cobdom_class_style' USING 'contactContainer', 'margin',
036500     '1rem'.
036600  CALL 'cobdom_class_style' USING 'contactContainer', 'display',
036700     'flex'. 
036800   CALL 'cobdom_class_style' USING 'contactContainer',
036900     'flexDirection', 'column'.
037000   CALL 'cobdom_class_style' USING 'contactContainer',
037100     'alignItems', 'center'.
037200   CONTINUE.
037300 BUILD-MENUBAR.
037400   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
037500   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
037600   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
037700   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
037800     'space-between'.
037900   CALL 'cobdom_style' USING 'headerDiv', 'flexDirection',
038000     'column'.
038100   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
038200   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
038300   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
038400*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
038500*    'blur(.3rem)'.
038600*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
038700*    'blur(5px)'.
038800*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
038900*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
039000*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
039100*    '1rem'.
039200*  CALL 'cobdom_style' USING 'headerDiv',
039300*    'borderBottomRightRadius','1rem'.
039400   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
039500   CALL 'cobdom_create_element' USING 'topArea', 'div'.
039600   CALL 'cobdom_style' USING 'topArea', 'display', 'flex'.
039700   CALL 'cobdom_style' USING 'topArea', 'backgroundColor',
039800     '#c9c9c9'.
039900   CALL 'cobdom_append_child' USING 'topArea', 'headerDiv'.
040000*Setup menu
040100   CALL 'cobdom_create_element' USING 'navArea', 'div'.
040200*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
040300   CALL 'cobdom_create_element' USING 'navButton', 'img'.
040400   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
040500   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
040600   CALL 'cobdom_src' USING 'navButton', 
040700     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
040800   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
040900     '#898989'.
041000*  CALL 'cobdom_style' USING 'navButton', 'filter', 
041100*    'invert(100%)'.
041200   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
041300   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
041400   CALL 'cobdom_style' USING 'navButton', 'padding', '.35rem'.
041500   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
041600   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
041700   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
041800   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
041900*Setup menu selectors
042000   CALL 'cobdom_create_element' USING 'selectorDiv', 'div'.
042100*About Me
042200   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
042300   CALL 'cobdom_style' USING 'navAbout', 'fontSize', '4rem'.
042400   CALL 'cobdom_style' USING 'navAbout', 'width', 
042500     'max-content'.
042600   CALL 'cobdom_add_event_listener' USING 'navAbout',
042700     'click', 'NAVABOUT'.
042800   CALL 'cobdom_style' USING 'navAbout', 'position', 'relative'.
042900   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
043000     '#c9c9c9'.
043100*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
043200*    'blur(.3rem)'.
043300*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
043400*    'blur(5px)'.
043500   CALL 'cobdom_style' USING 'navAbout', 
043600     'borderBottomRightRadius', '0.5rem'.
043700   CALL 'cobdom_style' USING 'navAbout', 
043800     'borderTopRightRadius', '0.5rem'.
043900   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
044000   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
044100*  CALL 'cobdom_style' USING 'navAbout', 'top', '9.46rem'.
044200   CALL 'cobdom_style' USING 'navAbout', 'left', '-35rem'.
044300   CALL 'cobdom_style' USING 'navAbout', 'transition', 
044400     'transform 0.5s ease 0.1s'.
044500   CALL 'cobdom_append_child' USING 'navAbout', 'selectorDiv'.
044600*Contact Me
044700   CALL 'cobdom_create_element' USING 'navContact', 'div'.
044800   CALL 'cobdom_style' USING 'navContact', 'fontSize', '4rem'.
044900   CALL 'cobdom_style' USING 'navContact', 'width', 
045000     'max-content'.
045100   CALL 'cobdom_add_event_listener' USING 'navContact',
045200     'click', 'NAVCONTACT'.
045300   CALL 'cobdom_style' USING 'navContact', 'position', 'relative'.
045400   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
045500     '#c9c9c9'.
045600*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
045700*    'blur(.3rem)'.
045800*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
045900*    'blur(5px)'.
046000   CALL 'cobdom_style' USING 'navContact', 
046100     'borderBottomRightRadius', '0.5rem'.
046200   CALL 'cobdom_style' USING 'navContact', 
046300     'borderTopRightRadius', '0.5rem'.
046400   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
046500   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
046600*  CALL 'cobdom_style' USING 'navContact', 'top', '14.86rem'.
046700   CALL 'cobdom_style' USING 'navContact', 'left', '-35rem'.
046800   CALL 'cobdom_style' USING 'navContact', 'transition', 
046900     'transform 0.5s ease 0.2s'.
047000   CALL 'cobdom_append_child' USING 'navContact', 'selectorDiv'.
047100*Skills
047200*  CALL 'cobdom_create_element' USING 'navSkills', 'div'.
047300*  CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
047400*  CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
047500*    '#c9c9c9'.
047600*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
047700*    'blur(5px)'.
047800*  CALL 'cobdom_style' USING 'navSkills', 
047900*    'borderBottomRightRadius', '0.5rem'.
048000*  CALL 'cobdom_style' USING 'navSkills', 
048100*    'borderTopRightRadius', '0.5rem'.
048200*  CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
048300*  CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
048400*  CALL 'cobdom_style' USING 'navSkills', 'top', '13rem'.
048500*  CALL 'cobdom_style' USING 'navSkills', 'left', '-35rem'.
048600*  CALL 'cobdom_style' USING 'navSkills', 'transition', 
048700*    'transform 0.5s ease 0.3s'.
048800*  CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
048900*Projects
049000   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
049100   CALL 'cobdom_style' USING 'navProjects', 'fontSize', '4rem'.
049200   CALL 'cobdom_style' USING 'navProjects', 'width', 
049300     'max-content'.
049400   CALL 'cobdom_add_event_listener' USING 'navProjects',
049500     'click', 'NAVPROJECTS'.
049600   CALL 'cobdom_style' USING 'navProjects', 'position', 
049700     'relative'.
049800   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
049900     '#c9c9c9'.
050000*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
050100*    'blur(.3rem)'.
050200*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
050300*    'blur(5px)'.
050400   CALL 'cobdom_style' USING 'navProjects', 
050500     'borderBottomRightRadius', '0.5rem'.
050600   CALL 'cobdom_style' USING 'navProjects', 
050700     'borderTopRightRadius', '0.5rem'.
050800   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
050900   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
051000*  CALL 'cobdom_style' USING 'navProjects', 'top', '20.27rem'.
051100   CALL 'cobdom_style' USING 'navProjects', 'left', '-35rem'.
051200   CALL 'cobdom_style' USING 'navProjects', 'transition', 
051300     'transform 0.5s ease 0.4s'.
051400   CALL 'cobdom_append_child' USING 'navProjects', 'selectorDiv'.
051500*Cobol?
051600   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
051700   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
051800   CALL 'cobdom_style' USING 'navCobol', 'fontSize', '4rem'.
051900   CALL 'cobdom_style' USING 'navCobol', 'width',
052000     'max-content'.
052100   CALL 'cobdom_add_event_listener' USING 'navCobol',
052200     'click', 'NAVCOBOL'.
052300   CALL 'cobdom_style' USING 'navCobol', 'position', 
052400     'relative'.
052500   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
052600     '#000000'.
052700*    '#c9c9c9'.
052800*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
052900*    'blur(5px)'.
053000   CALL 'cobdom_style' USING 'navCobol', 'color', 
053100     '#00FF00'.
053200   CALL 'cobdom_style' USING 'navCobol', 
053300     'borderBottomRightRadius', '0.5rem'.
053400   CALL 'cobdom_style' USING 'navCobol', 
053500     'borderTopRightRadius', '0.5rem'.
053600   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
053700   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
053800   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
053900   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
054000   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
054100   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
054200   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
054300   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
054400*  CALL 'cobdom_style' USING 'navCobol', 'top', '25.7rem'.
054500   CALL 'cobdom_style' USING 'navCobol', 'left', '-35rem'.
054600   CALL 'cobdom_style' USING 'navCobol', 'transition', 
054700     'transform 0.5s ease 0.5s'.
054800   CALL 'cobdom_append_child' USING 'navCobol', 'selectorDiv'.
054900*Add main menu button
055000   CALL 'cobdom_append_child' USING 'navArea', 'topArea'.
055100   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
055200     'MENUTOGGLE'.
055300*Setup ID area
055400   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
055500   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
055600   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
055700   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
055800   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '6rem'.
055900   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
056000   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
056100   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
056200*  CALL 'cobdom_inner_html' USING 'taglineDiv', 
056300*    'A guy that knows a guy.'.
056400   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
056500*Setup lang area
056600   CALL 'cobdom_create_element' USING 'langArea', 'span'.
056700   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
056800*Setup language selector
056900   CALL 'cobdom_create_element' USING 'langUS', 'img'.
057000   CALL 'cobdom_create_element' USING 'langES', 'img'.
057100   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
057200   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
057300   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
057400   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
057500   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
057600   CALL 'cobdom_style' USING 'langUS', 'transition', 
057700     'opacity 0.5s ease, transform 0.5s ease'.
057800*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
057900*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
058000   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
058100   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
058200   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
058300   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
058400   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
058500   CALL 'cobdom_style' USING 'langES', 'transition', 
058600     'opacity 0.5s ease, transform 0.5s ease'.
058700*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
058800*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
058900   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
059000   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
059100     'SETLANGUS'.
059200   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
059300   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
059400     'SETLANGES'.
059500   CALL 'cobdom_append_child' USING 'selectorDiv', 'headerDiv'.
059600   CALL 'cobdom_append_child' USING 'idDiv', 'topArea'.
059700   CALL 'cobdom_append_child' USING 'langArea', 'topArea'.
059800   CONTINUE.
059900 SET-ACTIVE-FLAG.
060000   IF WS-LANG = 'us' THEN
060100     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
060200     CALL 'cobdom_style' USING 'langUS', 'transform', 
060300       'translate(9rem, 0rem)'
060400     PERFORM UPDATE-TEXT
060500   ELSE
060600     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
060700     CALL 'cobdom_style' USING 'langUS', 'transform', 
060800       'translate(9rem, 0rem)'
060900     PERFORM UPDATE-TEXT
061000   END-IF.
061100   CONTINUE.
061200 LOAD-TEXTS.
061300   CALL 'cobdom_fetch' USING 'LOADENAM',
061400     '/res/text/en/aboutme.txt', 'GET', WS-NULL-BYTE.
061500   CALL 'cobdom_fetch' USING 'LOADESAM',
061600     '/res/text/es/aboutme.txt', 'GET', WS-NULL-BYTE.
061700   CALL 'cobdom_fetch' USING 'LOADENCOBA',
061800     '/res/text/en/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
061900   CALL 'cobdom_fetch' USING 'LOADENCOBB',
062000     '/res/text/en/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
062100   CALL 'cobdom_fetch' USING 'LOADESCOBA',
062200     '/res/text/es/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
062300   CALL 'cobdom_fetch' USING 'LOADESCOBB',
062400     '/res/text/es/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
062500   CONTINUE.
062600 UPDATE-TEXT.
062700   IF WS-LANG = 'us' THEN
062800     CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me'
062900     CALL 'cobdom_inner_html' USING 'contactHeader',
063000       'Contact Information / Links'
063100*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills'
063200     CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects'
063300     CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'
063400     CALL 'cobdom_inner_html' USING 'navContact', 'Contact/Links'
063500*    CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'
063600     CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'
063700     CALL 'cobdom_inner_html' USING 'aboutContent',
063800       TAB OF EN OF WS-TEXTS
063900     CALL 'cobdom_inner_html' USING 'cobolContent',
064000       TAB-COB OF EN OF WS-TEXTS
064100   ELSE
064200     CALL 'cobdom_inner_html' USING 'aboutHeader', 'Sobre Mi'
064300     CALL 'cobdom_inner_html' USING 'contactHeader',
064400       'Informacion de Contacto / Enlaces'
064500*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Habilidades'
064600     CALL 'cobdom_inner_html' USING 'projectHeader', 'Proyectos'
064700     CALL 'cobdom_inner_html' USING 'navAbout', 'Sobre Mi'
064800     CALL 'cobdom_inner_html' USING 'navContact',
064900       'Contacto/Enlaces'
065000*    CALL 'cobdom_inner_html' USING 'navSkills', 'Habilidades'
065100     CALL 'cobdom_inner_html' USING 'navProjects', 'Proyectos'
065200     CALL 'cobdom_inner_html' USING 'aboutContent',
065300       TAB OF ES OF WS-TEXTS
065400     CALL 'cobdom_inner_html' USING 'cobolContent',
065500       TAB-COB OF ES OF WS-TEXTS
065600   END-IF.
065700   CONTINUE.
065800 LANG-CHECK.
065900   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
066000     'lang'.
066100   IF WS-LANG = WS-NULL-BYTE THEN
066200     CALL 'cobdom_set_cookie' USING 'us', 'lang'
066300     MOVE 'us' TO WS-LANG
066400   END-IF.
066500   PERFORM SET-ACTIVE-FLAG.
066600   CONTINUE.
066700 COOKIE-ASK.
066800   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
066900   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
067000   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
067100   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
067200   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
067300   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
067400     'rgba(37,186,181,.9)'.
067500   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
067600     'center'.
067700   CALL 'cobdom_style' USING 'cookieDiv', 'fontSize', 
067800     '4rem'.
067900   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
068000-'llow cookies to store your preferences such as language?&nbsp;'.
068100   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
068200   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
068300   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
068400   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
068500   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
068600   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
068700   CALL 'cobdom_style' USING 'cookieYes', 'backgroundColor', 
068800     '#86e059'.
068900   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
069000   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
069100   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
069200   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
069300   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
069400   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
069500   CALL 'cobdom_style' USING 'cookieNo', 'backgroundColor', 
069600     '#e05e59'.
069700   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
069800     'COOKIEACCEPT'.
069900   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
070000     'COOKIEDENY'.
070100   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
070200   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
070300   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
070400   CONTINUE.
070500 LOADENAM SECTION.
070600 ENTRY 'LOADENAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
070700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF EN OF WS-TEXTS.
070800   PERFORM UPDATE-TEXT.
070900   GOBACK.
071000 LOADESAM SECTION.
071100 ENTRY 'LOADESAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
071200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF ES OF WS-TEXTS.
071300   PERFORM UPDATE-TEXT.
071400   GOBACK.
071500 LOADENCOBA SECTION.
071600 ENTRY 'LOADENCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
071700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF EN OF WS-TEXTS.
071800   PERFORM UPDATE-TEXT.
071900   GOBACK.
072000 LOADENCOBB SECTION.
072100 ENTRY 'LOADENCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
072200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF EN OF WS-TEXTS.
072300   PERFORM UPDATE-TEXT.
072400   GOBACK.
072500 LOADESCOBA SECTION.
072600 ENTRY 'LOADESCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
072700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF ES OF WS-TEXTS.
072800   PERFORM UPDATE-TEXT.
072900   GOBACK.
073000 LOADESCOBB SECTION.
073100 ENTRY 'LOADESCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
073200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF ES OF WS-TEXTS.
073300*  DISPLAY ABOUT-ME OF ES OF WS-TEXTS.
073400   PERFORM UPDATE-TEXT.
073500   GOBACK.
073600 NAVABOUT SECTION.
073700 ENTRY 'NAVABOUT'.
073800   CALL 'cobdom_scroll_into_view' USING 'aboutHeader'.
073900   GOBACK.
074000 NAVCONTACT SECTION.
074100 ENTRY 'NAVCONTACT'.
074200   CALL 'cobdom_scroll_into_view' USING 'contactHeader'.
074300   GOBACK.
074400 NAVPROJECTS SECTION.
074500 ENTRY 'NAVPROJECTS'.
074600   CALL 'cobdom_scroll_into_view' USING 'projectHeader'.
074700   GOBACK.
074800 NAVCOBOL SECTION.
074900 ENTRY 'NAVCOBOL'.
075000   CALL 'cobdom_scroll_into_view' USING 'cobolHeader'.
075100   GOBACK.
075200 OPENCOBOLSOURCE SECTION.
075300 ENTRY 'OPENCOBOLSOURCE'.
075400   CALL 'cobdom_open_tab' USING 
075500     'https://github.com/BalakeKarbon/BalakeKarbon.github.io'.
075600   GOBACK.
075700 OPENGH SECTION.
075800 ENTRY 'OPENGH'.
075900   CALL 'cobdom_open_tab' USING 
076000     'https://github.com/BalakeKarbon/'.
076100   GOBACK.
076200 OPENLI SECTION.
076300 ENTRY 'OPENLI'.
076400   CALL 'cobdom_open_tab' USING 
076500     'https://www.linkedin.com/in/blake-karbon/'.
076600   GOBACK.
076700 OPENYT SECTION.
076800 ENTRY 'OPENYT'.
076900   CALL 'cobdom_open_tab' USING 
077000     'https://www.youtube.com/@karboncodes'.
077100   GOBACK.
077200 OPENTT SECTION.
077300 ENTRY 'OPENTT'.
077400   CALL 'cobdom_open_tab' USING 
077500     'https://www.tiktok.com/@karboncodes'.
077600   GOBACK.
077700 OPENIG SECTION.
077800 ENTRY 'OPENIG'.
077900   CALL 'cobdom_open_tab' USING 
078000     'https://www.instagram.com/karboncodes'.
078100   GOBACK.
078200 MENUTOGGLE SECTION.
078300 ENTRY 'MENUTOGGLE'.
078400   IF WS-MENU-TOGGLE = 0 THEN
078500     MOVE 1 TO WS-MENU-TOGGLE
078600     CALL 'cobdom_style' USING 'navButton', 'transform', 
078700       'scale(0.85)'
078800     CALL 'cobdom_src' USING 'navButton', 
078900       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
079000     CALL 'cobdom_style' USING 'navAbout', 'transform', 
079100       'translate(35rem, 0rem)' 
079200     CALL 'cobdom_style' USING 'navContact', 'transform', 
079300       'translate(35rem, 0rem)' 
079400     CALL 'cobdom_style' USING 'navSkills', 'transform', 
079500       'translate(35rem, 0rem)'
079600    CALL 'cobdom_style' USING 'navProjects', 'transform', 
079700       'translate(35rem, 0rem)'
079800    CALL 'cobdom_style' USING 'navCobol', 'transform', 
079900       'translate(35rem, 0rem)'
080000   ELSE
080100     MOVE 0 TO WS-MENU-TOGGLE
080200     CALL 'cobdom_style' USING 'navButton', 'transform', 
080300       'scale(1.0)'
080400     CALL 'cobdom_src' USING 'navButton', 
080500       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
080600     CALL 'cobdom_style' USING 'navAbout', 'transform', 
080700       'translate(0rem, 0rem)' 
080800     CALL 'cobdom_style' USING 'navContact', 'transform', 
080900       'translate(0rem, 0rem)' 
081000     CALL 'cobdom_style' USING 'navSkills', 'transform', 
081100       'translate(0rem, 0rem)'
081200    CALL 'cobdom_style' USING 'navProjects', 'transform', 
081300       'translate(0rem, 0rem)'
081400    CALL 'cobdom_style' USING 'navCobol', 'transform', 
081500       'translate(0rem, 0rem)'
081600   END-IF.
081700   GOBACK.
081800*TO-DO: Add a timer in case some fonts do never load
081900 FONTLOADED SECTION.
082000 ENTRY 'FONTLOADED'.
082100   ADD 1 TO WS-FONTS-LOADED.
082200   IF WS-FONTS-LOADED = 2 THEN
082300     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
082400     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
082500     CALL 'cobdom_style' USING 'cobolSection', 'fontFamily',
082600       'ibmpc'
082700   END-IF.
082800   GOBACK.
082900 WINDOWCHANGE SECTION.
083000 ENTRY 'WINDOWCHANGE'.
083100   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
083200   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
083300     '300'.
083400*Optimize this buffer time to not have a noticeable delay but also
083500*not call to often.
083600   GOBACK.
083700 SHAPEPAGE SECTION.
083800 ENTRY 'SHAPEPAGE'.
083900*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
084000*  DISPLAY 'Rendering! ' CENTISECS.
084100   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
084200     'window.innerWidth'.
084300   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
084400   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
084500     'window.innerHeight'.
084600   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
084700   GOBACK.
084800 COOKIEACCEPT SECTION.
084900 ENTRY 'COOKIEACCEPT'.
085000   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
085100   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
085200   MOVE 'y' TO WS-COOKIE-ALLOWED.
085300   IF WS-LANG = 'us' THEN
085400     CALL 'cobdom_set_cookie' USING 'us', 'lang'
085500   ELSE
085600     CALL 'cobdom_set_cookie' USING 'en', 'lang'
085700   END-IF.
085800   GOBACK.
085900 COOKIEDENY SECTION.
086000 ENTRY 'COOKIEDENY'.
086100   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
086200   MOVE 'n' TO WS-COOKIE-ALLOWED.
086300   GOBACK.
086400 SETPERCENTCOBOL SECTION.
086500 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
086600   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF EN OF WS-TEXTS.
086700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF ES OF WS-TEXTS.
086800*  CALL 'cobdom_inner_html' USING 'percentCobol',
086900*    WS-PERCENT-COBOL.
087000*  DISPLAY 'Currently this website is written in ' 
087100*    WS-PERCENT-COBOL '% COBOL.'.
087200   GOBACK.
087300 SETLANG SECTION.
087400 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
087500   if WS-LANG-SELECT-TOGGLE = 0 THEN
087600     MOVE 1 TO WS-LANG-SELECT-TOGGLE
087700     IF WS-LANG = 'us' THEN
087800       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
087900       CALL 'cobdom_style' USING 'langUS', 'transform', 
088000         'translate(0rem, 0rem)'
088100*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
088200     ELSE
088300       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
088400       CALL 'cobdom_style' USING 'langUS', 'transform', 
088500         'translate(0rem, 0rem)'
088600*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
088700     END-IF
088800   ELSE
088900     MOVE 0 TO WS-LANG-SELECT-TOGGLE
089000     IF WS-COOKIE-ALLOWED = 'y' THEN
089100       IF LS-LANG-CHOICE = 'us' THEN
089200         CALL 'cobdom_set_cookie' USING 'us', 'lang'
089300         MOVE 'us' TO WS-LANG
089400       ELSE
089500         CALL 'cobdom_set_cookie' USING 'es', 'lang'
089600         MOVE 'es' TO WS-LANG
089700       END-IF
089800       PERFORM SET-ACTIVE-FLAG
089900     ELSE
090000       MOVE LS-LANG-CHOICE TO WS-LANG
090100       PERFORM SET-ACTIVE-FLAG 
090200     END-IF
090300   END-IF.
090400   GOBACK.
090500 SETLANGUS SECTION.
090600 ENTRY 'SETLANGUS'.
090700   CALL 'SETLANG' USING 'us'.
090800   GOBACK.
090900 SETLANGES SECTION.
091000 ENTRY 'SETLANGES'.
091100   CALL 'SETLANG' USING 'es'.
091200   GOBACK.
091300*TERMINPUT SECTION.
091400*ENTRY 'TERMINPUT' USING LS-TERM-IN.
091500*  DISPLAY LS-TERM-IN.
091600*  GOBACK.
