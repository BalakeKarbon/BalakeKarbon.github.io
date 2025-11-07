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
016200   CALL 'cobdom_create_element' USING 'ghStatsDiv', 'div'.
016300   CALL 'cobdom_style' USING 'ghStatsDiv', 'width', '100%'.
016400   CALL 'cobdom_style' USING 'ghStatsDiv', 'textAlign', 'center'.
016500   CALL 'cobdom_append_child' USING 'ghStatsDiv', 'aboutSection'.
016600   CALL 'cobdom_create_element' USING 'ghStatsImg', 'img'.
016700   CALL 'cobdom_src' USING 'ghStatsImg', 'https://github-readme-st
016800-'ats.vercel.app/api/top-langs?username=BalakeKarbon&show_icons=tr
016900-'ue&locale=en&layout=compact&hide=html&hide_title=true&card_width
017000-'=500'.
017100   CALL 'cobdom_style' USING 'ghStatsImg', 'height', '10rem'.
017200*  CALL 'cobdom_style' USING 'ghStatsImg', 'transform', 
017300*    'translate(50%,0)'.
017400   CALL 'cobdom_append_child' USING 'ghStatsImg', 'ghStatsDiv'.
017500*Contact section / Links / Socials
017600*Email,
017700*GitHub, LinkedIN
017800*Youtube, TikTok, Instagram,
017900   CALL 'cobdom_create_element' USING 'contactSection', 'div'.
018000   CALL 'cobdom_style' USING 'contactSection', 'width', '100%'.
018100   CALL 'cobdom_create_element' USING 'contactHeader', 'div'.
018200   CALL 'cobdom_set_class' USING 'contactHeader',
018300     'contentHeadersClass'.
018400   CALL 'cobdom_inner_html' USING 'contactHeader',
018500     'Contact Information:'.
018600   CALL 'cobdom_create_element' USING 'contactContent', 'div'.
018700   CALL 'cobdom_style' USING 'contactContent', 'width', '100%'.
018800   CALL 'cobdom_style' USING 'contactContent', 'textAlign',
018900     'center'.
019000   CALL 'cobdom_append_child' USING 'contactSection',
019100     'contentDiv'.
019200   CALL 'cobdom_append_child' USING 'contactHeader',
019300     'contactSection'.
019400   CALL 'cobdom_append_child' USING 'contactContent',
019500     'contactSection'.
019600   CALL 'cobdom_create_element' USING 'emailDiv', 'div'.
019700   CALL 'cobdom_inner_html' USING 'emailDiv',
019800     'karboncodes@gmail.com'.
019900   CALL 'cobdom_create_element' USING 'linksDiv', 'div'.
020000   CALL 'cobdom_style' USING 'linksDiv', 'display', 'flex'.
020100   CALL 'cobdom_style' USING 'linksDiv', 'width', '100%'.
020200   CALL 'cobdom_style' USING 'linksDiv', 'justifyContent',
020300     'center'.
020400*The following section could be done with a loop but it is not
020500*which is horrid
020600*GitHub
020700   CALL 'cobdom_create_element' USING 'ghContainer', 'span'.
020800   CALL 'cobdom_add_event_listener' USING 'ghContainer',
020900     'click', 'OPENGH'.
021000   CALL 'cobdom_set_class' USING 'ghContainer',
021100     'contactContainer'.
021200   CALL 'cobdom_create_element' USING 'ghImage', 'img'.
021300   CALL 'cobdom_src' USING 'ghImage', 
021400     '/res/icons/tabler-icons/icons/outline/brand-github.svg'.
021500   CALL 'cobdom_style' USING 'ghImage', 'width', '6rem'.
021600   CALL 'cobdom_style' USING 'ghImage', 'height', '6rem'.
021700   CALL 'cobdom_create_element' USING 'ghText', 'div'.
021800   CALL 'cobdom_style' USING 'ghText', 'textDecoration',
021900     'underline'.
022000   CALL 'cobdom_inner_html' USING 'ghText', 'GitHub'.
022100   CALL 'cobdom_append_child' USING 'ghImage', 'ghContainer'.
022200   CALL 'cobdom_append_child' USING 'ghText', 'ghContainer'.
022300   CALL 'cobdom_append_child' USING 'ghContainer', 'linksDiv'.
022400*LinkedIn
022500   CALL 'cobdom_create_element' USING 'liContainer', 'span'.
022600   CALL 'cobdom_add_event_listener' USING 'liContainer',
022700     'click', 'OPENLI'.
022800   CALL 'cobdom_set_class' USING 'liContainer',
022900     'contactContainer'.
023000   CALL 'cobdom_create_element' USING 'liImage', 'img'.
023100   CALL 'cobdom_src' USING 'liImage', 
023200     '/res/icons/tabler-icons/icons/outline/brand-linkedin.svg'.
023300   CALL 'cobdom_style' USING 'liImage', 'width', '6rem'.
023400   CALL 'cobdom_style' USING 'liImage', 'height', '6rem'.
023500   CALL 'cobdom_create_element' USING 'liText', 'div'.
023600   CALL 'cobdom_style' USING 'liText', 'textDecoration',
023700     'underline'.
023800   CALL 'cobdom_inner_html' USING 'liText', 'Linkedin'.
023900   CALL 'cobdom_append_child' USING 'liImage', 'liContainer'.
024000   CALL 'cobdom_append_child' USING 'liText', 'liContainer'.
024100   CALL 'cobdom_append_child' USING 'liContainer', 'linksDiv'.
024200*Youtube
024300   CALL 'cobdom_create_element' USING 'ytContainer', 'span'.
024400   CALL 'cobdom_add_event_listener' USING 'ytContainer',
024500     'click', 'OPENYT'.
024600   CALL 'cobdom_set_class' USING 'ytContainer',
024700     'contactContainer'.
024800   CALL 'cobdom_create_element' USING 'ytImage', 'img'.
024900   CALL 'cobdom_src' USING 'ytImage', 
025000     '/res/icons/tabler-icons/icons/outline/brand-youtube.svg'.
025100   CALL 'cobdom_style' USING 'ytImage', 'width', '6rem'.
025200   CALL 'cobdom_style' USING 'ytImage', 'height', '6rem'.
025300   CALL 'cobdom_create_element' USING 'ytText', 'div'.
025400   CALL 'cobdom_style' USING 'ytText', 'textDecoration',
025500     'underline'.
025600   CALL 'cobdom_inner_html' USING 'ytText', 'Youtube'.
025700   CALL 'cobdom_append_child' USING 'ytImage', 'ytContainer'.
025800   CALL 'cobdom_append_child' USING 'ytText', 'ytContainer'.
025900   CALL 'cobdom_append_child' USING 'ytContainer', 'linksDiv'.
026000*TikTok
026100   CALL 'cobdom_create_element' USING 'ttContainer', 'span'.
026200   CALL 'cobdom_add_event_listener' USING 'ttContainer',
026300     'click', 'OPENTT'.
026400   CALL 'cobdom_set_class' USING 'ttContainer',
026500     'contactContainer'.
026600   CALL 'cobdom_create_element' USING 'ttImage', 'img'.
026700   CALL 'cobdom_src' USING 'ttImage', 
026800     '/res/icons/tabler-icons/icons/outline/brand-tiktok.svg'.
026900   CALL 'cobdom_style' USING 'ttImage', 'width', '6rem'.
027000   CALL 'cobdom_style' USING 'ttImage', 'height', '6rem'.
027100   CALL 'cobdom_create_element' USING 'ttText', 'div'.
027200   CALL 'cobdom_style' USING 'ttText', 'textDecoration',
027300     'underline'.
027400   CALL 'cobdom_inner_html' USING 'ttText', 'TikTok'.
027500   CALL 'cobdom_append_child' USING 'ttImage', 'ttContainer'.
027600   CALL 'cobdom_append_child' USING 'ttText', 'ttContainer'.
027700   CALL 'cobdom_append_child' USING 'ttContainer', 'linksDiv'.
027800*Instagram
027900   CALL 'cobdom_create_element' USING 'igContainer', 'span'.
028000   CALL 'cobdom_add_event_listener' USING 'igContainer',
028100     'click', 'OPENIG'.
028200   CALL 'cobdom_set_class' USING 'igContainer',
028300     'contactContainer'.
028400   CALL 'cobdom_create_element' USING 'igImage', 'img'.
028500   CALL 'cobdom_src' USING 'igImage', 
028600     '/res/icons/tabler-icons/icons/outline/brand-instagram.svg'.
028700   CALL 'cobdom_style' USING 'igImage', 'width', '6rem'.
028800   CALL 'cobdom_style' USING 'igImage', 'height', '6rem'.
028900   CALL 'cobdom_create_element' USING 'igText', 'div'.
029000   CALL 'cobdom_style' USING 'igText', 'textDecoration',
029100     'underline'.
029200   CALL 'cobdom_inner_html' USING 'igText', 'Instagram'.
029300   CALL 'cobdom_append_child' USING 'igImage', 'igContainer'.
029400   CALL 'cobdom_append_child' USING 'igText', 'igContainer'.
029500   CALL 'cobdom_append_child' USING 'igContainer', 'linksDiv'.
029600 
029700   CALL 'cobdom_append_child' USING 'emailDiv', 'contactContent'.
029800   CALL 'cobdom_append_child' USING 'linksDiv', 'contactContent'.
029900*Skills section
030000*  CALL 'cobdom_create_element' USING 'skillsSection', 'div'.
030100*  CALL 'cobdom_style' USING 'skillsSection', 'width', '100%'.
030200*  CALL 'cobdom_create_element' USING 'skillsHeader', 'div'.
030300*  CALL 'cobdom_set_class' USING 'skillsHeader',
030400*    'contentHeadersClass'.
030500*  CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills:'.
030600*  CALL 'cobdom_create_element' USING 'skillsContent', 'div'.
030700*
030800*  CALL 'cobdom_append_child' USING 'skillsSection',
030900*    'contentDiv'.
031000*  CALL 'cobdom_append_child' USING 'skillsHeader',
031100*    'skillsSection'.
031200*  CALL 'cobdom_append_child' USING 'skillsContent',
031300*    'skillsSection'.
031400*Project section
031500   CALL 'cobdom_create_element' USING 'projectSection', 'div'.
031600   CALL 'cobdom_style' USING 'projectSection', 'width', '100%'.
031700*  CALL 'cobdom_style' USING 'projectSection', 'margin', '2rem'.
031800   CALL 'cobdom_create_element' USING 'projectHeader', 'div'.
031900   CALL 'cobdom_set_class' USING 'projectHeader',
032000     'contentHeadersClass'.
032100   CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects:'.
032200   CALL 'cobdom_create_element' USING 'projectContent', 'div'.
032300   CALL 'cobdom_style' USING 'projectContent', 'textAlign',
032400     'center'.
032500   CALL 'cobdom_inner_html' USING 'projectContent', 'WIP'.
032600   CALL 'cobdom_append_child' USING 'projectSection', 
032700     'contentDiv'.
032800   CALL 'cobdom_append_child' USING 'projectHeader', 
032900     'projectSection'.
033000   CALL 'cobdom_append_child' USING 'projectContent', 
033100     'projectSection'.
033200*Cobol section
033300   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
033400   CALL 'cobdom_style' USING 'cobolSection', 'width', '100%'.
033500*  CALL 'cobdom_style' USING 'cobolSection', 'margin', '2rem'.
033600   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
033700   CALL 'cobdom_set_class' USING 'cobolHeader',
033800     'contentHeadersClass'.
033900   CALL 'cobdom_inner_html' USING 'cobolHeader', 'COBOL'.
034000   CALL 'cobdom_create_element' USING 'cobolContent', 'span'.
034100   CALL 'cobdom_append_child' USING 'cobolSection',
034200     'contentDiv'.
034300   CALL 'cobdom_append_child' USING 'cobolHeader', 
034400     'cobolSection'.
034500   CALL 'cobdom_append_child' USING 'cobolContent', 
034600     'cobolSection'.
034700   CALL 'cobdom_create_element' USING 'cobolGithubLink',
034800     'span'.
034900   CALL 'cobdom_add_event_listener' USING 'cobolGithubLink',
035000     'click', 'OPENCOBOLSOURCE'.
035100   CALL 'cobdom_inner_html' USING 'cobolGithubLink',
035200     'GitHub!'.
035300   CALL 'cobdom_style' USING 'cobolGithubLink', 'textDecoration',
035400     'underline'.
035500   CALL 'cobdom_append_child' USING 'cobolGithubLink',
035600     'cobolSection'.
035700*Set contentHeadersClass class styles. Must be called after elements
035800*exist as this uses getElementsByClassName. A safer option would
035900*be to make a new style element but for the sake of demnostrating
036000*this part of the library I will use this here.
036100   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
036200     'fontSize', '2.5rem'.
036300   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
036400     'width', '100%'.
036500   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
036600     'textAlign', 'center'.
036700   CALL 'cobdom_class_style' USING 'contentHeadersClass',
036800     'fontWeight', 'bold'.
036900   CALL 'cobdom_class_style' USING 'contactContainer', 'margin',
037000     '1rem'.
037100  CALL 'cobdom_class_style' USING 'contactContainer', 'display',
037200     'flex'. 
037300   CALL 'cobdom_class_style' USING 'contactContainer',
037400     'flexDirection', 'column'.
037500   CALL 'cobdom_class_style' USING 'contactContainer',
037600     'alignItems', 'center'.
037700   CONTINUE.
037800 BUILD-MENUBAR.
037900   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
038000   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
038100   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
038200   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
038300     'space-between'.
038400   CALL 'cobdom_style' USING 'headerDiv', 'flexDirection',
038500     'column'.
038600   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
038700   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
038800   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
038900*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
039000*    'blur(.3rem)'.
039100*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
039200*    'blur(5px)'.
039300*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
039400*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
039500*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
039600*    '1rem'.
039700*  CALL 'cobdom_style' USING 'headerDiv',
039800*    'borderBottomRightRadius','1rem'.
039900   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
040000   CALL 'cobdom_create_element' USING 'topArea', 'div'.
040100   CALL 'cobdom_style' USING 'topArea', 'display', 'flex'.
040200   CALL 'cobdom_style' USING 'topArea', 'backgroundColor',
040300     '#c9c9c9'.
040400   CALL 'cobdom_append_child' USING 'topArea', 'headerDiv'.
040500*Setup menu
040600   CALL 'cobdom_create_element' USING 'navArea', 'div'.
040700*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
040800   CALL 'cobdom_create_element' USING 'navButton', 'img'.
040900   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
041000   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
041100   CALL 'cobdom_src' USING 'navButton', 
041200     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
041300   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
041400     '#898989'.
041500*  CALL 'cobdom_style' USING 'navButton', 'filter', 
041600*    'invert(100%)'.
041700   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
041800   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
041900   CALL 'cobdom_style' USING 'navButton', 'padding', '.35rem'.
042000   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
042100   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
042200   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
042300   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
042400*Setup menu selectors
042500   CALL 'cobdom_create_element' USING 'selectorDiv', 'div'.
042600*About Me
042700   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
042800   CALL 'cobdom_style' USING 'navAbout', 'fontSize', '4rem'.
042900   CALL 'cobdom_style' USING 'navAbout', 'width', 
043000     'max-content'.
043100   CALL 'cobdom_add_event_listener' USING 'navAbout',
043200     'click', 'NAVABOUT'.
043300   CALL 'cobdom_style' USING 'navAbout', 'position', 'relative'.
043400   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
043500     '#c9c9c9'.
043600*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
043700*    'blur(.3rem)'.
043800*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
043900*    'blur(5px)'.
044000   CALL 'cobdom_style' USING 'navAbout', 
044100     'borderBottomRightRadius', '0.5rem'.
044200   CALL 'cobdom_style' USING 'navAbout', 
044300     'borderTopRightRadius', '0.5rem'.
044400   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
044500   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
044600*  CALL 'cobdom_style' USING 'navAbout', 'top', '9.46rem'.
044700   CALL 'cobdom_style' USING 'navAbout', 'left', '-35rem'.
044800   CALL 'cobdom_style' USING 'navAbout', 'transition', 
044900     'transform 0.5s ease 0.1s'.
045000   CALL 'cobdom_append_child' USING 'navAbout', 'selectorDiv'.
045100*Contact Me
045200   CALL 'cobdom_create_element' USING 'navContact', 'div'.
045300   CALL 'cobdom_style' USING 'navContact', 'fontSize', '4rem'.
045400   CALL 'cobdom_style' USING 'navContact', 'width', 
045500     'max-content'.
045600   CALL 'cobdom_add_event_listener' USING 'navContact',
045700     'click', 'NAVCONTACT'.
045800   CALL 'cobdom_style' USING 'navContact', 'position', 'relative'.
045900   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
046000     '#c9c9c9'.
046100*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
046200*    'blur(.3rem)'.
046300*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
046400*    'blur(5px)'.
046500   CALL 'cobdom_style' USING 'navContact', 
046600     'borderBottomRightRadius', '0.5rem'.
046700   CALL 'cobdom_style' USING 'navContact', 
046800     'borderTopRightRadius', '0.5rem'.
046900   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
047000   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
047100*  CALL 'cobdom_style' USING 'navContact', 'top', '14.86rem'.
047200   CALL 'cobdom_style' USING 'navContact', 'left', '-35rem'.
047300   CALL 'cobdom_style' USING 'navContact', 'transition', 
047400     'transform 0.5s ease 0.2s'.
047500   CALL 'cobdom_append_child' USING 'navContact', 'selectorDiv'.
047600*Skills
047700*  CALL 'cobdom_create_element' USING 'navSkills', 'div'.
047800*  CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
047900*  CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
048000*    '#c9c9c9'.
048100*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
048200*    'blur(5px)'.
048300*  CALL 'cobdom_style' USING 'navSkills', 
048400*    'borderBottomRightRadius', '0.5rem'.
048500*  CALL 'cobdom_style' USING 'navSkills', 
048600*    'borderTopRightRadius', '0.5rem'.
048700*  CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
048800*  CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
048900*  CALL 'cobdom_style' USING 'navSkills', 'top', '13rem'.
049000*  CALL 'cobdom_style' USING 'navSkills', 'left', '-35rem'.
049100*  CALL 'cobdom_style' USING 'navSkills', 'transition', 
049200*    'transform 0.5s ease 0.3s'.
049300*  CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
049400*Projects
049500   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
049600   CALL 'cobdom_style' USING 'navProjects', 'fontSize', '4rem'.
049700   CALL 'cobdom_style' USING 'navProjects', 'width', 
049800     'max-content'.
049900   CALL 'cobdom_add_event_listener' USING 'navProjects',
050000     'click', 'NAVPROJECTS'.
050100   CALL 'cobdom_style' USING 'navProjects', 'position', 
050200     'relative'.
050300   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
050400     '#c9c9c9'.
050500*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
050600*    'blur(.3rem)'.
050700*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
050800*    'blur(5px)'.
050900   CALL 'cobdom_style' USING 'navProjects', 
051000     'borderBottomRightRadius', '0.5rem'.
051100   CALL 'cobdom_style' USING 'navProjects', 
051200     'borderTopRightRadius', '0.5rem'.
051300   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
051400   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
051500*  CALL 'cobdom_style' USING 'navProjects', 'top', '20.27rem'.
051600   CALL 'cobdom_style' USING 'navProjects', 'left', '-35rem'.
051700   CALL 'cobdom_style' USING 'navProjects', 'transition', 
051800     'transform 0.5s ease 0.4s'.
051900   CALL 'cobdom_append_child' USING 'navProjects', 'selectorDiv'.
052000*Cobol?
052100   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
052200   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
052300   CALL 'cobdom_style' USING 'navCobol', 'fontSize', '4rem'.
052400   CALL 'cobdom_style' USING 'navCobol', 'width',
052500     'max-content'.
052600   CALL 'cobdom_add_event_listener' USING 'navCobol',
052700     'click', 'NAVCOBOL'.
052800   CALL 'cobdom_style' USING 'navCobol', 'position', 
052900     'relative'.
053000   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
053100     '#000000'.
053200*    '#c9c9c9'.
053300*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
053400*    'blur(5px)'.
053500   CALL 'cobdom_style' USING 'navCobol', 'color', 
053600     '#00FF00'.
053700   CALL 'cobdom_style' USING 'navCobol', 
053800     'borderBottomRightRadius', '0.5rem'.
053900   CALL 'cobdom_style' USING 'navCobol', 
054000     'borderTopRightRadius', '0.5rem'.
054100   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
054200   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
054300   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
054400   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
054500   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
054600   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
054700   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
054800   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
054900*  CALL 'cobdom_style' USING 'navCobol', 'top', '25.7rem'.
055000   CALL 'cobdom_style' USING 'navCobol', 'left', '-35rem'.
055100   CALL 'cobdom_style' USING 'navCobol', 'transition', 
055200     'transform 0.5s ease 0.5s'.
055300   CALL 'cobdom_append_child' USING 'navCobol', 'selectorDiv'.
055400*Add main menu button
055500   CALL 'cobdom_append_child' USING 'navArea', 'topArea'.
055600   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
055700     'MENUTOGGLE'.
055800*Setup ID area
055900   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
056000   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
056100   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
056200   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
056300   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '6rem'.
056400   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
056500   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
056600   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
056700*  CALL 'cobdom_inner_html' USING 'taglineDiv', 
056800*    'A guy that knows a guy.'.
056900   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
057000*Setup lang area
057100   CALL 'cobdom_create_element' USING 'langArea', 'span'.
057200   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
057300*Setup language selector
057400   CALL 'cobdom_create_element' USING 'langUS', 'img'.
057500   CALL 'cobdom_create_element' USING 'langES', 'img'.
057600   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
057700   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
057800   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
057900   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
058000   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
058100   CALL 'cobdom_style' USING 'langUS', 'transition', 
058200     'opacity 0.5s ease, transform 0.5s ease'.
058300*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
058400*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
058500   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
058600   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
058700   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
058800   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
058900   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
059000   CALL 'cobdom_style' USING 'langES', 'transition', 
059100     'opacity 0.5s ease, transform 0.5s ease'.
059200*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
059300*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
059400   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
059500   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
059600     'SETLANGUS'.
059700   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
059800   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
059900     'SETLANGES'.
060000   CALL 'cobdom_append_child' USING 'selectorDiv', 'headerDiv'.
060100   CALL 'cobdom_append_child' USING 'idDiv', 'topArea'.
060200   CALL 'cobdom_append_child' USING 'langArea', 'topArea'.
060300   CONTINUE.
060400 SET-ACTIVE-FLAG.
060500   IF WS-LANG = 'us' THEN
060600     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
060700     CALL 'cobdom_style' USING 'langUS', 'transform', 
060800       'translate(9rem, 0rem)'
060900     CALL 'UPDATETEXT'
061000   ELSE
061100     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
061200     CALL 'cobdom_style' USING 'langUS', 'transform', 
061300       'translate(9rem, 0rem)'
061400     CALL 'UPDATETEXT'
061500   END-IF.
061600   CONTINUE.
061700 LOAD-TEXTS.
061800   CALL 'cobdom_fetch' USING 'LOADENAM',
061900     '/res/text/en/aboutme.txt', 'GET', WS-NULL-BYTE.
062000   CALL 'cobdom_fetch' USING 'LOADESAM',
062100     '/res/text/es/aboutme.txt', 'GET', WS-NULL-BYTE.
062200   CALL 'cobdom_fetch' USING 'LOADENCOBA',
062300     '/res/text/en/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
062400   CALL 'cobdom_fetch' USING 'LOADENCOBB',
062500     '/res/text/en/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
062600   CALL 'cobdom_fetch' USING 'LOADESCOBA',
062700     '/res/text/es/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
062800   CALL 'cobdom_fetch' USING 'LOADESCOBB',
062900     '/res/text/es/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
063000   CONTINUE.
063100 LANG-CHECK.
063200   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
063300     'lang'.
063400   IF WS-LANG = WS-NULL-BYTE THEN
063500     CALL 'cobdom_set_cookie' USING 'us', 'lang'
063600     MOVE 'us' TO WS-LANG
063700   END-IF.
063800   PERFORM SET-ACTIVE-FLAG.
063900   CONTINUE.
064000 COOKIE-ASK.
064100   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
064200   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
064300   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
064400   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
064500   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
064600   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
064700     'rgba(37,186,181,.9)'.
064800   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
064900     'center'.
065000   CALL 'cobdom_style' USING 'cookieDiv', 'fontSize', 
065100     '4rem'.
065200   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
065300-'llow cookies to store your preferences such as language?&nbsp;'.
065400   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
065500   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
065600   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
065700   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
065800   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
065900   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
066000   CALL 'cobdom_style' USING 'cookieYes', 'backgroundColor', 
066100     '#86e059'.
066200   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
066300   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
066400   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
066500   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
066600   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
066700   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
066800   CALL 'cobdom_style' USING 'cookieNo', 'backgroundColor', 
066900     '#e05e59'.
067000   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
067100     'COOKIEACCEPT'.
067200   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
067300     'COOKIEDENY'.
067400   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
067500   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
067600   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
067700   CONTINUE.
067800 UPDATETEXT SECTION.
067900 ENTRY 'UPDATETEXT'.
068000   IF WS-LANG = 'us' THEN
068100     CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me'
068200     CALL 'cobdom_inner_html' USING 'contactHeader',
068300       'Contact Information / Links'
068400*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills'
068500     CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects'
068600     CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'
068700     CALL 'cobdom_inner_html' USING 'navContact', 'Contact/Links'
068800*    CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'
068900     CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'
069000     CALL 'cobdom_inner_html' USING 'aboutContent',
069100       TAB OF EN OF WS-TEXTS
069200     CALL 'cobdom_inner_html' USING 'cobolContent',
069300       TAB-COB OF EN OF WS-TEXTS
069400   ELSE
069500     CALL 'cobdom_inner_html' USING 'aboutHeader', 'Sobre Mi'
069600     CALL 'cobdom_inner_html' USING 'contactHeader',
069700       'Informacion de Contacto / Enlaces'
069800*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Habilidades'
069900     CALL 'cobdom_inner_html' USING 'projectHeader', 'Proyectos'
070000     CALL 'cobdom_inner_html' USING 'navAbout', 'Sobre Mi'
070100     CALL 'cobdom_inner_html' USING 'navContact',
070200       'Contacto/Enlaces'
070300*    CALL 'cobdom_inner_html' USING 'navSkills', 'Habilidades'
070400     CALL 'cobdom_inner_html' USING 'navProjects', 'Proyectos'
070500     CALL 'cobdom_inner_html' USING 'aboutContent',
070600       TAB OF ES OF WS-TEXTS
070700     CALL 'cobdom_inner_html' USING 'cobolContent',
070800       TAB-COB OF ES OF WS-TEXTS
070900   END-IF.
071000   GOBACK.
071100 LOADENAM SECTION.
071200 ENTRY 'LOADENAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
071300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF EN OF WS-TEXTS.
071400   CALL 'UPDATETEXT'.
071500   GOBACK.
071600 LOADESAM SECTION.
071700 ENTRY 'LOADESAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
071800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF ES OF WS-TEXTS.
071900   CALL 'UPDATETEXT'.
072000   GOBACK.
072100 LOADENCOBA SECTION.
072200 ENTRY 'LOADENCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
072300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF EN OF WS-TEXTS.
072400   CALL 'UPDATETEXT'.
072500   GOBACK.
072600 LOADENCOBB SECTION.
072700 ENTRY 'LOADENCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
072800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF EN OF WS-TEXTS.
072900   CALL 'UPDATETEXT'.
073000   GOBACK.
073100 LOADESCOBA SECTION.
073200 ENTRY 'LOADESCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
073300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF ES OF WS-TEXTS.
073400   CALL 'UPDATETEXT'.
073500   GOBACK.
073600 LOADESCOBB SECTION.
073700 ENTRY 'LOADESCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
073800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF ES OF WS-TEXTS.
073900*  DISPLAY ABOUT-ME OF ES OF WS-TEXTS.
074000   CALL 'UPDATETEXT'.
074100   GOBACK.
074200 NAVABOUT SECTION.
074300 ENTRY 'NAVABOUT'.
074400   CALL 'cobdom_scroll_into_view' USING 'aboutHeader'.
074500   GOBACK.
074600 NAVCONTACT SECTION.
074700 ENTRY 'NAVCONTACT'.
074800   CALL 'cobdom_scroll_into_view' USING 'contactHeader'.
074900   GOBACK.
075000 NAVPROJECTS SECTION.
075100 ENTRY 'NAVPROJECTS'.
075200   CALL 'cobdom_scroll_into_view' USING 'projectHeader'.
075300   GOBACK.
075400 NAVCOBOL SECTION.
075500 ENTRY 'NAVCOBOL'.
075600   CALL 'cobdom_scroll_into_view' USING 'cobolHeader'.
075700   GOBACK.
075800 OPENCOBOLSOURCE SECTION.
075900 ENTRY 'OPENCOBOLSOURCE'.
076000   CALL 'cobdom_open_tab' USING 
076100     'https://github.com/BalakeKarbon/BalakeKarbon.github.io'.
076200   GOBACK.
076300 OPENGH SECTION.
076400 ENTRY 'OPENGH'.
076500   CALL 'cobdom_open_tab' USING 
076600     'https://github.com/BalakeKarbon/'.
076700   GOBACK.
076800 OPENLI SECTION.
076900 ENTRY 'OPENLI'.
077000   CALL 'cobdom_open_tab' USING 
077100     'https://www.linkedin.com/in/blake-karbon/'.
077200   GOBACK.
077300 OPENYT SECTION.
077400 ENTRY 'OPENYT'.
077500   CALL 'cobdom_open_tab' USING 
077600     'https://www.youtube.com/@karboncodes'.
077700   GOBACK.
077800 OPENTT SECTION.
077900 ENTRY 'OPENTT'.
078000   CALL 'cobdom_open_tab' USING 
078100     'https://www.tiktok.com/@karboncodes'.
078200   GOBACK.
078300 OPENIG SECTION.
078400 ENTRY 'OPENIG'.
078500   CALL 'cobdom_open_tab' USING 
078600     'https://www.instagram.com/karboncodes'.
078700   GOBACK.
078800 MENUTOGGLE SECTION.
078900 ENTRY 'MENUTOGGLE'.
079000   IF WS-MENU-TOGGLE = 0 THEN
079100     MOVE 1 TO WS-MENU-TOGGLE
079200     CALL 'cobdom_style' USING 'navButton', 'transform', 
079300       'scale(0.85)'
079400     CALL 'cobdom_src' USING 'navButton', 
079500       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
079600     CALL 'cobdom_style' USING 'navAbout', 'transform', 
079700       'translate(35rem, 0rem)' 
079800     CALL 'cobdom_style' USING 'navContact', 'transform', 
079900       'translate(35rem, 0rem)' 
080000     CALL 'cobdom_style' USING 'navSkills', 'transform', 
080100       'translate(35rem, 0rem)'
080200    CALL 'cobdom_style' USING 'navProjects', 'transform', 
080300       'translate(35rem, 0rem)'
080400    CALL 'cobdom_style' USING 'navCobol', 'transform', 
080500       'translate(35rem, 0rem)'
080600   ELSE
080700     MOVE 0 TO WS-MENU-TOGGLE
080800     CALL 'cobdom_style' USING 'navButton', 'transform', 
080900       'scale(1.0)'
081000     CALL 'cobdom_src' USING 'navButton', 
081100       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
081200     CALL 'cobdom_style' USING 'navAbout', 'transform', 
081300       'translate(0rem, 0rem)' 
081400     CALL 'cobdom_style' USING 'navContact', 'transform', 
081500       'translate(0rem, 0rem)' 
081600     CALL 'cobdom_style' USING 'navSkills', 'transform', 
081700       'translate(0rem, 0rem)'
081800    CALL 'cobdom_style' USING 'navProjects', 'transform', 
081900       'translate(0rem, 0rem)'
082000    CALL 'cobdom_style' USING 'navCobol', 'transform', 
082100       'translate(0rem, 0rem)'
082200   END-IF.
082300   GOBACK.
082400*TO-DO: Add a timer in case some fonts do never load
082500 FONTLOADED SECTION.
082600 ENTRY 'FONTLOADED'.
082700   ADD 1 TO WS-FONTS-LOADED.
082800   IF WS-FONTS-LOADED = 2 THEN
082900     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
083000     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
083100     CALL 'cobdom_style' USING 'cobolSection', 'fontFamily',
083200       'ibmpc'
083300   END-IF.
083400   GOBACK.
083500 WINDOWCHANGE SECTION.
083600 ENTRY 'WINDOWCHANGE'.
083700   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
083800   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
083900     '300'.
084000*Optimize this buffer time to not have a noticeable delay but also
084100*not call to often.
084200   GOBACK.
084300 SHAPEPAGE SECTION.
084400 ENTRY 'SHAPEPAGE'.
084500*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
084600*  DISPLAY 'Rendering! ' CENTISECS.
084700   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
084800     'window.innerWidth'.
084900   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
085000   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
085100     'window.innerHeight'.
085200   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
085300   GOBACK.
085400 COOKIEACCEPT SECTION.
085500 ENTRY 'COOKIEACCEPT'.
085600   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
085700   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
085800   MOVE 'y' TO WS-COOKIE-ALLOWED.
085900   IF WS-LANG = 'us' THEN
086000     CALL 'cobdom_set_cookie' USING 'us', 'lang'
086100   ELSE
086200     CALL 'cobdom_set_cookie' USING 'en', 'lang'
086300   END-IF.
086400   GOBACK.
086500 COOKIEDENY SECTION.
086600 ENTRY 'COOKIEDENY'.
086700   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
086800   MOVE 'n' TO WS-COOKIE-ALLOWED.
086900   GOBACK.
087000 SETPERCENTCOBOL SECTION.
087100 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
087200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF EN OF WS-TEXTS.
087300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF ES OF WS-TEXTS.
087400*  CALL 'cobdom_inner_html' USING 'percentCobol',
087500*    WS-PERCENT-COBOL.
087600*  DISPLAY 'Currently this website is written in ' 
087700*    WS-PERCENT-COBOL '% COBOL.'.
087800   GOBACK.
087900 SETLANG SECTION.
088000 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
088100   if WS-LANG-SELECT-TOGGLE = 0 THEN
088200     MOVE 1 TO WS-LANG-SELECT-TOGGLE
088300     IF WS-LANG = 'us' THEN
088400       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
088500       CALL 'cobdom_style' USING 'langUS', 'transform', 
088600         'translate(0rem, 0rem)'
088700*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
088800     ELSE
088900       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
089000       CALL 'cobdom_style' USING 'langUS', 'transform', 
089100         'translate(0rem, 0rem)'
089200*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
089300     END-IF
089400   ELSE
089500     MOVE 0 TO WS-LANG-SELECT-TOGGLE
089600     IF WS-COOKIE-ALLOWED = 'y' THEN
089700       IF LS-LANG-CHOICE = 'us' THEN
089800         CALL 'cobdom_set_cookie' USING 'us', 'lang'
089900         MOVE 'us' TO WS-LANG
090000       ELSE
090100         CALL 'cobdom_set_cookie' USING 'es', 'lang'
090200         MOVE 'es' TO WS-LANG
090300       END-IF
090400       PERFORM SET-ACTIVE-FLAG
090500     ELSE
090600       MOVE LS-LANG-CHOICE TO WS-LANG
090700       PERFORM SET-ACTIVE-FLAG 
090800     END-IF
090900   END-IF.
091000   GOBACK.
091100 SETLANGUS SECTION.
091200 ENTRY 'SETLANGUS'.
091300   CALL 'SETLANG' USING 'us'.
091400   GOBACK.
091500 SETLANGES SECTION.
091600 ENTRY 'SETLANGES'.
091700   CALL 'SETLANG' USING 'es'.
091800   GOBACK.
091900*TERMINPUT SECTION.
092000*ENTRY 'TERMINPUT' USING LS-TERM-IN.
092100*  DISPLAY LS-TERM-IN.
092200*  GOBACK.
