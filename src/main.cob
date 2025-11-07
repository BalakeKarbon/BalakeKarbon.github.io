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
037900   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
038000   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
038100   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
038200   CALL 'cobdom_style' USING 'headerDiv', 'backgroundColor',
038300     '#c9c9c9'.
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
039500*Setup menu
039600   CALL 'cobdom_create_element' USING 'navArea', 'div'.
039700*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
039800   CALL 'cobdom_create_element' USING 'navButton', 'img'.
039900   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
040000   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
040100   CALL 'cobdom_src' USING 'navButton', 
040200     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
040300   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
040400     '#898989'.
040500*  CALL 'cobdom_style' USING 'navButton', 'filter', 
040600*    'invert(100%)'.
040700   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
040800   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
040900   CALL 'cobdom_style' USING 'navButton', 'padding', '.25rem'.
041000   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
041100   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
041200   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
041300   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
041400*Setup menu selectors
041500*About Me
041600   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
041700   CALL 'cobdom_add_event_listener' USING 'navAbout',
041800     'click', 'NAVABOUT'.
041900   CALL 'cobdom_style' USING 'navAbout', 'position', 'absolute'.
042000   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
042100     '#c9c9c9'.
042200*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
042300*    'blur(.3rem)'.
042400*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
042500*    'blur(5px)'.
042600   CALL 'cobdom_style' USING 'navAbout', 
042700     'borderBottomRightRadius', '0.5rem'.
042800   CALL 'cobdom_style' USING 'navAbout', 
042900     'borderTopRightRadius', '0.5rem'.
043000   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
043100   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
043200   CALL 'cobdom_style' USING 'navAbout', 'top', '9.46rem'.
043300   CALL 'cobdom_style' USING 'navAbout', 'left', '-15rem'.
043400   CALL 'cobdom_style' USING 'navAbout', 'transition', 
043500     'transform 0.5s ease 0.1s'.
043600   CALL 'cobdom_append_child' USING 'navAbout', 'headerDiv'.
043700*Contact Me
043800   CALL 'cobdom_create_element' USING 'navContact', 'div'.
043900   CALL 'cobdom_add_event_listener' USING 'navContact',
044000     'click', 'NAVCONTACT'.
044100   CALL 'cobdom_style' USING 'navContact', 'position', 'absolute'.
044200   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
044300     '#c9c9c9'.
044400*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
044500*    'blur(.3rem)'.
044600*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
044700*    'blur(5px)'.
044800   CALL 'cobdom_style' USING 'navContact', 
044900     'borderBottomRightRadius', '0.5rem'.
045000   CALL 'cobdom_style' USING 'navContact', 
045100     'borderTopRightRadius', '0.5rem'.
045200   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
045300   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
045400   CALL 'cobdom_style' USING 'navContact', 'top', '11.86rem'.
045500   CALL 'cobdom_style' USING 'navContact', 'left', '-15rem'.
045600   CALL 'cobdom_style' USING 'navContact', 'transition', 
045700     'transform 0.5s ease 0.2s'.
045800   CALL 'cobdom_append_child' USING 'navContact', 'headerDiv'.
045900*Skills
046000*  CALL 'cobdom_create_element' USING 'navSkills', 'div'.
046100*  CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
046200*  CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
046300*    '#c9c9c9'.
046400*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
046500*    'blur(5px)'.
046600*  CALL 'cobdom_style' USING 'navSkills', 
046700*    'borderBottomRightRadius', '0.5rem'.
046800*  CALL 'cobdom_style' USING 'navSkills', 
046900*    'borderTopRightRadius', '0.5rem'.
047000*  CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
047100*  CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
047200*  CALL 'cobdom_style' USING 'navSkills', 'top', '13rem'.
047300*  CALL 'cobdom_style' USING 'navSkills', 'left', '-15rem'.
047400*  CALL 'cobdom_style' USING 'navSkills', 'transition', 
047500*    'transform 0.5s ease 0.3s'.
047600*  CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
047700*Projects
047800   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
047900   CALL 'cobdom_add_event_listener' USING 'navProjects',
048000     'click', 'NAVPROJECTS'.
048100   CALL 'cobdom_style' USING 'navProjects', 'position', 
048200     'absolute'.
048300   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
048400     '#c9c9c9'.
048500*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
048600*    'blur(.3rem)'.
048700*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
048800*    'blur(5px)'.
048900   CALL 'cobdom_style' USING 'navProjects', 
049000     'borderBottomRightRadius', '0.5rem'.
049100   CALL 'cobdom_style' USING 'navProjects', 
049200     'borderTopRightRadius', '0.5rem'.
049300   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
049400   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
049500   CALL 'cobdom_style' USING 'navProjects', 'top', '14.27rem'.
049600   CALL 'cobdom_style' USING 'navProjects', 'left', '-15rem'.
049700   CALL 'cobdom_style' USING 'navProjects', 'transition', 
049800     'transform 0.5s ease 0.4s'.
049900   CALL 'cobdom_append_child' USING 'navProjects', 'headerDiv'.
050000*Cobol?
050100   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
050200   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
050300   CALL 'cobdom_add_event_listener' USING 'navCobol',
050400     'click', 'NAVCOBOL'.
050500   CALL 'cobdom_style' USING 'navCobol', 'position', 
050600     'absolute'.
050700   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
050800     '#000000'.
050900*    '#c9c9c9'.
051000*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
051100*    'blur(5px)'.
051200   CALL 'cobdom_style' USING 'navCobol', 'color', 
051300     '#00FF00'.
051400   CALL 'cobdom_style' USING 'navCobol', 
051500     'borderBottomRightRadius', '0.5rem'.
051600   CALL 'cobdom_style' USING 'navCobol', 
051700     'borderTopRightRadius', '0.5rem'.
051800   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
051900   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
052000   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
052100   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
052200   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
052300   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
052400   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
052500   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
052600   CALL 'cobdom_style' USING 'navCobol', 'top', '16.7rem'.
052700   CALL 'cobdom_style' USING 'navCobol', 'left', '-15rem'.
052800   CALL 'cobdom_style' USING 'navCobol', 'transition', 
052900     'transform 0.5s ease 0.5s'.
053000   CALL 'cobdom_append_child' USING 'navCobol', 'headerDiv'.
053100*Add main menu button
053200   CALL 'cobdom_append_child' USING 'navArea', 'headerDiv'.
053300   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
053400     'MENUTOGGLE'.
053500*Setup ID area
053600   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
053700   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
053800   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
053900   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
054000   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '4rem'.
054100   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
054200   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
054300   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
054400*  CALL 'cobdom_inner_html' USING 'taglineDiv', 
054500*    'A guy that knows a guy.'.
054600   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
054700   CALL 'cobdom_append_child' USING 'idDiv', 'headerDiv'.
054800*Setup lang area
054900   CALL 'cobdom_create_element' USING 'langArea', 'span'.
055000   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
055100   CALL 'cobdom_append_child' USING 'langArea', 'headerDiv'.
055200*Setup language selector
055300   CALL 'cobdom_create_element' USING 'langUS', 'img'.
055400   CALL 'cobdom_create_element' USING 'langES', 'img'.
055500   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
055600   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
055700   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
055800   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
055900   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
056000   CALL 'cobdom_style' USING 'langUS', 'transition', 
056100     'opacity 0.5s ease, transform 0.5s ease'.
056200*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
056300*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
056400   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
056500   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
056600   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
056700   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
056800   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
056900   CALL 'cobdom_style' USING 'langES', 'transition', 
057000     'opacity 0.5s ease, transform 0.5s ease'.
057100*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
057200*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
057300   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
057400   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
057500     'SETLANGUS'.
057600   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
057700   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
057800     'SETLANGES'.
057900   CONTINUE.
058000 SET-ACTIVE-FLAG.
058100   IF WS-LANG = 'us' THEN
058200     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
058300     CALL 'cobdom_style' USING 'langUS', 'transform', 
058400       'translate(9rem, 0rem)'
058500     PERFORM UPDATE-TEXT
058600   ELSE
058700     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
058800     CALL 'cobdom_style' USING 'langUS', 'transform', 
058900       'translate(9rem, 0rem)'
059000     PERFORM UPDATE-TEXT
059100   END-IF.
059200   CONTINUE.
059300 LOAD-TEXTS.
059400   CALL 'cobdom_fetch' USING 'LOADENAM',
059500     '/res/text/en/aboutme.txt', 'GET', WS-NULL-BYTE.
059600   CALL 'cobdom_fetch' USING 'LOADESAM',
059700     '/res/text/es/aboutme.txt', 'GET', WS-NULL-BYTE.
059800   CALL 'cobdom_fetch' USING 'LOADENCOBA',
059900     '/res/text/en/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
060000   CALL 'cobdom_fetch' USING 'LOADENCOBB',
060100     '/res/text/en/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
060200   CALL 'cobdom_fetch' USING 'LOADESCOBA',
060300     '/res/text/es/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
060400   CALL 'cobdom_fetch' USING 'LOADESCOBB',
060500     '/res/text/es/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
060600   CONTINUE.
060700 UPDATE-TEXT.
060800   IF WS-LANG = 'us' THEN
060900     CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me'
061000     CALL 'cobdom_inner_html' USING 'contactHeader',
061100       'Contact Information / Links'
061200*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills'
061300     CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects'
061400     CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'
061500     CALL 'cobdom_inner_html' USING 'navContact', 'Contact/Links'
061600*    CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'
061700     CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'
061800     CALL 'cobdom_inner_html' USING 'aboutContent',
061900       TAB OF EN OF WS-TEXTS
062000     CALL 'cobdom_inner_html' USING 'cobolContent',
062100       TAB-COB OF EN OF WS-TEXTS
062200   ELSE
062300     CALL 'cobdom_inner_html' USING 'aboutHeader', 'Sobre Mi'
062400     CALL 'cobdom_inner_html' USING 'contactHeader',
062500       'Informacion de Contacto / Enlaces'
062600*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Habilidades'
062700     CALL 'cobdom_inner_html' USING 'projectHeader', 'Proyectos'
062800     CALL 'cobdom_inner_html' USING 'navAbout', 'Sobre Mi'
062900     CALL 'cobdom_inner_html' USING 'navContact',
063000       'Contacto/Enlaces'
063100*    CALL 'cobdom_inner_html' USING 'navSkills', 'Habilidades'
063200     CALL 'cobdom_inner_html' USING 'navProjects', 'Proyectos'
063300     CALL 'cobdom_inner_html' USING 'aboutContent',
063400       TAB OF ES OF WS-TEXTS
063500     CALL 'cobdom_inner_html' USING 'cobolContent',
063600       TAB-COB OF ES OF WS-TEXTS
063700   END-IF.
063800   CONTINUE.
063900 LANG-CHECK.
064000   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
064100     'lang'.
064200   IF WS-LANG = WS-NULL-BYTE THEN
064300     CALL 'cobdom_set_cookie' USING 'us', 'lang'
064400     MOVE 'us' TO WS-LANG
064500   END-IF.
064600   PERFORM SET-ACTIVE-FLAG.
064700   CONTINUE.
064800 COOKIE-ASK.
064900   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
065000   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
065100   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
065200   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
065300   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
065400   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
065500     'rgba(37,186,181,.9)'.
065600   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
065700     'center'.
065800   CALL 'cobdom_style' USING 'cookieDiv', 'fontSize', 
065900     '4rem'.
066000   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
066100-'llow cookies to store your preferences such as language?&nbsp;'.
066200   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
066300   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
066400   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
066500   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
066600   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
066700   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
066800   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
066900   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
067000   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
067100   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
067200   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
067300   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
067400   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
067500     'COOKIEACCEPT'.
067600   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
067700     'COOKIEDENY'.
067800   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
067900   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
068000   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
068100*Note this must be called after the elements are added to the
068200*document because it must search for them.
068300   CALL 'cobdom_class_style' USING 'cookieButton', 
068400     'backgroundColor', '#25bab5'.
068500   CONTINUE.
068600 LOADENAM SECTION.
068700 ENTRY 'LOADENAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
068800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF EN OF WS-TEXTS.
068900   PERFORM UPDATE-TEXT.
069000   GOBACK.
069100 LOADESAM SECTION.
069200 ENTRY 'LOADESAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
069300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF ES OF WS-TEXTS.
069400   PERFORM UPDATE-TEXT.
069500   GOBACK.
069600 LOADENCOBA SECTION.
069700 ENTRY 'LOADENCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
069800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF EN OF WS-TEXTS.
069900   PERFORM UPDATE-TEXT.
070000   GOBACK.
070100 LOADENCOBB SECTION.
070200 ENTRY 'LOADENCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
070300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF EN OF WS-TEXTS.
070400   PERFORM UPDATE-TEXT.
070500   GOBACK.
070600 LOADESCOBA SECTION.
070700 ENTRY 'LOADESCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
070800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF ES OF WS-TEXTS.
070900   PERFORM UPDATE-TEXT.
071000   GOBACK.
071100 LOADESCOBB SECTION.
071200 ENTRY 'LOADESCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
071300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF ES OF WS-TEXTS.
071400*  DISPLAY ABOUT-ME OF ES OF WS-TEXTS.
071500   PERFORM UPDATE-TEXT.
071600   GOBACK.
071700 NAVABOUT SECTION.
071800 ENTRY 'NAVABOUT'.
071900   CALL 'cobdom_scroll_into_view' USING 'aboutHeader'.
072000   GOBACK.
072100 NAVCONTACT SECTION.
072200 ENTRY 'NAVCONTACT'.
072300   CALL 'cobdom_scroll_into_view' USING 'contactHeader'.
072400   GOBACK.
072500 NAVPROJECTS SECTION.
072600 ENTRY 'NAVPROJECTS'.
072700   CALL 'cobdom_scroll_into_view' USING 'projectHeader'.
072800   GOBACK.
072900 NAVCOBOL SECTION.
073000 ENTRY 'NAVCOBOL'.
073100   CALL 'cobdom_scroll_into_view' USING 'cobolHeader'.
073200   GOBACK.
073300 OPENCOBOLSOURCE SECTION.
073400 ENTRY 'OPENCOBOLSOURCE'.
073500   CALL 'cobdom_open_tab' USING 
073600     'https://github.com/BalakeKarbon/BalakeKarbon.github.io'.
073700   GOBACK.
073800 OPENGH SECTION.
073900 ENTRY 'OPENGH'.
074000   CALL 'cobdom_open_tab' USING 
074100     'https://github.com/BalakeKarbon/'.
074200   GOBACK.
074300 OPENLI SECTION.
074400 ENTRY 'OPENLI'.
074500   CALL 'cobdom_open_tab' USING 
074600     'https://www.linkedin.com/in/blake-karbon/'.
074700   GOBACK.
074800 OPENYT SECTION.
074900 ENTRY 'OPENYT'.
075000   CALL 'cobdom_open_tab' USING 
075100     'https://www.youtube.com/@karboncodes'.
075200   GOBACK.
075300 OPENTT SECTION.
075400 ENTRY 'OPENTT'.
075500   CALL 'cobdom_open_tab' USING 
075600     'https://www.tiktok.com/@karboncodes'.
075700   GOBACK.
075800 OPENIG SECTION.
075900 ENTRY 'OPENIG'.
076000   CALL 'cobdom_open_tab' USING 
076100     'https://www.instagram.com/karboncodes'.
076200   GOBACK.
076300 MENUTOGGLE SECTION.
076400 ENTRY 'MENUTOGGLE'.
076500   IF WS-MENU-TOGGLE = 0 THEN
076600     MOVE 1 TO WS-MENU-TOGGLE
076700     CALL 'cobdom_style' USING 'navButton', 'transform', 
076800       'scale(0.85)'
076900     CALL 'cobdom_src' USING 'navButton', 
077000       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
077100     CALL 'cobdom_style' USING 'navAbout', 'transform', 
077200       'translate(15rem, 0rem)' 
077300     CALL 'cobdom_style' USING 'navContact', 'transform', 
077400       'translate(15rem, 0rem)' 
077500     CALL 'cobdom_style' USING 'navSkills', 'transform', 
077600       'translate(15rem, 0rem)'
077700    CALL 'cobdom_style' USING 'navProjects', 'transform', 
077800       'translate(15rem, 0rem)'
077900    CALL 'cobdom_style' USING 'navCobol', 'transform', 
078000       'translate(15rem, 0rem)'
078100   ELSE
078200     MOVE 0 TO WS-MENU-TOGGLE
078300     CALL 'cobdom_style' USING 'navButton', 'transform', 
078400       'scale(1.0)'
078500     CALL 'cobdom_src' USING 'navButton', 
078600       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
078700     CALL 'cobdom_style' USING 'navAbout', 'transform', 
078800       'translate(0rem, 0rem)' 
078900     CALL 'cobdom_style' USING 'navContact', 'transform', 
079000       'translate(0rem, 0rem)' 
079100     CALL 'cobdom_style' USING 'navSkills', 'transform', 
079200       'translate(0rem, 0rem)'
079300    CALL 'cobdom_style' USING 'navProjects', 'transform', 
079400       'translate(0rem, 0rem)'
079500    CALL 'cobdom_style' USING 'navCobol', 'transform', 
079600       'translate(0rem, 0rem)'
079700   END-IF.
079800   GOBACK.
079900*TO-DO: Add a timer in case some fonts do never load
080000 FONTLOADED SECTION.
080100 ENTRY 'FONTLOADED'.
080200   ADD 1 TO WS-FONTS-LOADED.
080300   IF WS-FONTS-LOADED = 2 THEN
080400     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
080500     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
080600     CALL 'cobdom_style' USING 'cobolSection', 'fontFamily',
080700       'ibmpc'
080800   END-IF.
080900   GOBACK.
081000 WINDOWCHANGE SECTION.
081100 ENTRY 'WINDOWCHANGE'.
081200   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
081300   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
081400     '300'.
081500*Optimize this buffer time to not have a noticeable delay but also
081600*not call to often.
081700   GOBACK.
081800 SHAPEPAGE SECTION.
081900 ENTRY 'SHAPEPAGE'.
082000*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
082100*  DISPLAY 'Rendering! ' CENTISECS.
082200   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
082300     'window.innerWidth'.
082400   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
082500   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
082600     'window.innerHeight'.
082700   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
082800   GOBACK.
082900 COOKIEACCEPT SECTION.
083000 ENTRY 'COOKIEACCEPT'.
083100   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
083200   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
083300   MOVE 'y' TO WS-COOKIE-ALLOWED.
083400   IF WS-LANG = 'us' THEN
083500     CALL 'cobdom_set_cookie' USING 'us', 'lang'
083600   ELSE
083700     CALL 'cobdom_set_cookie' USING 'en', 'lang'
083800   END-IF.
083900   GOBACK.
084000 COOKIEDENY SECTION.
084100 ENTRY 'COOKIEDENY'.
084200   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
084300   MOVE 'n' TO WS-COOKIE-ALLOWED.
084400   GOBACK.
084500 SETPERCENTCOBOL SECTION.
084600 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
084700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF EN OF WS-TEXTS.
084800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF ES OF WS-TEXTS.
084900*  CALL 'cobdom_inner_html' USING 'percentCobol',
085000*    WS-PERCENT-COBOL.
085100*  DISPLAY 'Currently this website is written in ' 
085200*    WS-PERCENT-COBOL '% COBOL.'.
085300   GOBACK.
085400 SETLANG SECTION.
085500 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
085600   if WS-LANG-SELECT-TOGGLE = 0 THEN
085700     MOVE 1 TO WS-LANG-SELECT-TOGGLE
085800     IF WS-LANG = 'us' THEN
085900       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
086000       CALL 'cobdom_style' USING 'langUS', 'transform', 
086100         'translate(0rem, 0rem)'
086200*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
086300     ELSE
086400       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
086500       CALL 'cobdom_style' USING 'langUS', 'transform', 
086600         'translate(0rem, 0rem)'
086700*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
086800     END-IF
086900   ELSE
087000     MOVE 0 TO WS-LANG-SELECT-TOGGLE
087100     IF WS-COOKIE-ALLOWED = 'y' THEN
087200       IF LS-LANG-CHOICE = 'us' THEN
087300         CALL 'cobdom_set_cookie' USING 'us', 'lang'
087400         MOVE 'us' TO WS-LANG
087500       ELSE
087600         CALL 'cobdom_set_cookie' USING 'es', 'lang'
087700         MOVE 'es' TO WS-LANG
087800       END-IF
087900       PERFORM SET-ACTIVE-FLAG
088000     ELSE
088100       MOVE LS-LANG-CHOICE TO WS-LANG
088200       PERFORM SET-ACTIVE-FLAG 
088300     END-IF
088400   END-IF.
088500   GOBACK.
088600 SETLANGUS SECTION.
088700 ENTRY 'SETLANGUS'.
088800   CALL 'SETLANG' USING 'us'.
088900   GOBACK.
089000 SETLANGES SECTION.
089100 ENTRY 'SETLANGES'.
089200   CALL 'SETLANG' USING 'es'.
089300   GOBACK.
089400*TERMINPUT SECTION.
089500*ENTRY 'TERMINPUT' USING LS-TERM-IN.
089600*  DISPLAY LS-TERM-IN.
089700*  GOBACK.
