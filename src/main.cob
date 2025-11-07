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
020800*  CALL 'cobdom_style' USING 'ghContainer', 'backgroundColor',
020900*    '#00ff00'.
021000*  CALL 'cobdom_style' USING 'ghContainer', 'padding', '1rem'.
021100*  CALL 'cobdom_style' USING 'ghContainer', 'borderRadius',
021200*    '2rem'.
021300   CALL 'cobdom_add_event_listener' USING 'ghContainer',
021400     'click', 'OPENGH'.
021500   CALL 'cobdom_set_class' USING 'ghContainer',
021600     'contactContainer'.
021700   CALL 'cobdom_create_element' USING 'ghImage', 'img'.
021800   CALL 'cobdom_src' USING 'ghImage', 
021900     '/res/icons/tabler-icons/icons/outline/brand-github.svg'.
022000   CALL 'cobdom_style' USING 'ghImage', 'width', '6rem'.
022100   CALL 'cobdom_style' USING 'ghImage', 'height', '6rem'.
022200   CALL 'cobdom_create_element' USING 'ghText', 'div'.
022300   CALL 'cobdom_style' USING 'ghText', 'textDecoration',
022400     'underline'.
022500   CALL 'cobdom_inner_html' USING 'ghText', 'GitHub'.
022600   CALL 'cobdom_append_child' USING 'ghImage', 'ghContainer'.
022700   CALL 'cobdom_append_child' USING 'ghText', 'ghContainer'.
022800   CALL 'cobdom_append_child' USING 'ghContainer', 'linksDiv'.
022900   CALL 'cobdom_add_event_listener' USING 'ghImage',
023000     'click', 'OPENGH'.
023100   CALL 'cobdom_add_event_listener' USING 'ghText',
023200     'click', 'OPENGH'.
023300*LinkedIn
023400   CALL 'cobdom_create_element' USING 'liContainer', 'span'.
023500   CALL 'cobdom_add_event_listener' USING 'liContainer',
023600     'click', 'OPENLI'.
023700   CALL 'cobdom_set_class' USING 'liContainer',
023800     'contactContainer'.
023900   CALL 'cobdom_create_element' USING 'liImage', 'img'.
024000   CALL 'cobdom_src' USING 'liImage', 
024100     '/res/icons/tabler-icons/icons/outline/brand-linkedin.svg'.
024200   CALL 'cobdom_style' USING 'liImage', 'width', '6rem'.
024300   CALL 'cobdom_style' USING 'liImage', 'height', '6rem'.
024400   CALL 'cobdom_create_element' USING 'liText', 'div'.
024500   CALL 'cobdom_style' USING 'liText', 'textDecoration',
024600     'underline'.
024700   CALL 'cobdom_inner_html' USING 'liText', 'Linkedin'.
024800   CALL 'cobdom_append_child' USING 'liImage', 'liContainer'.
024900   CALL 'cobdom_append_child' USING 'liText', 'liContainer'.
025000   CALL 'cobdom_append_child' USING 'liContainer', 'linksDiv'.
025100   CALL 'cobdom_add_event_listener' USING 'liImage',
025200     'click', 'OPENLI'.
025300   CALL 'cobdom_add_event_listener' USING 'liText',
025400     'click', 'OPENLI'.
025500*Youtube
025600   CALL 'cobdom_create_element' USING 'ytContainer', 'span'.
025700   CALL 'cobdom_add_event_listener' USING 'ytContainer',
025800     'click', 'OPENYT'.
025900   CALL 'cobdom_set_class' USING 'ytContainer',
026000     'contactContainer'.
026100   CALL 'cobdom_create_element' USING 'ytImage', 'img'.
026200   CALL 'cobdom_src' USING 'ytImage', 
026300     '/res/icons/tabler-icons/icons/outline/brand-youtube.svg'.
026400   CALL 'cobdom_style' USING 'ytImage', 'width', '6rem'.
026500   CALL 'cobdom_style' USING 'ytImage', 'height', '6rem'.
026600   CALL 'cobdom_create_element' USING 'ytText', 'div'.
026700   CALL 'cobdom_style' USING 'ytText', 'textDecoration',
026800     'underline'.
026900   CALL 'cobdom_inner_html' USING 'ytText', 'Youtube'.
027000   CALL 'cobdom_append_child' USING 'ytImage', 'ytContainer'.
027100   CALL 'cobdom_append_child' USING 'ytText', 'ytContainer'.
027200   CALL 'cobdom_append_child' USING 'ytContainer', 'linksDiv'.
027300   CALL 'cobdom_add_event_listener' USING 'ytImage',
027400     'click', 'OPENYT'.
027500   CALL 'cobdom_add_event_listener' USING 'ytText',
027600     'click', 'OPENYT'.
027700*TikTok
027800   CALL 'cobdom_create_element' USING 'ttContainer', 'span'.
027900   CALL 'cobdom_add_event_listener' USING 'ttContainer',
028000     'click', 'OPENTT'.
028100   CALL 'cobdom_set_class' USING 'ttContainer',
028200     'contactContainer'.
028300   CALL 'cobdom_create_element' USING 'ttImage', 'img'.
028400   CALL 'cobdom_src' USING 'ttImage', 
028500     '/res/icons/tabler-icons/icons/outline/brand-tiktok.svg'.
028600   CALL 'cobdom_style' USING 'ttImage', 'width', '6rem'.
028700   CALL 'cobdom_style' USING 'ttImage', 'height', '6rem'.
028800   CALL 'cobdom_create_element' USING 'ttText', 'div'.
028900   CALL 'cobdom_style' USING 'ttText', 'textDecoration',
029000     'underline'.
029100   CALL 'cobdom_inner_html' USING 'ttText', 'TikTok'.
029200   CALL 'cobdom_append_child' USING 'ttImage', 'ttContainer'.
029300   CALL 'cobdom_append_child' USING 'ttText', 'ttContainer'.
029400   CALL 'cobdom_append_child' USING 'ttContainer', 'linksDiv'.
029500   CALL 'cobdom_add_event_listener' USING 'ttContainer',
029600     'click', 'OPENTT'.
029700   CALL 'cobdom_add_event_listener' USING 'ttContainer',
029800     'click', 'OPENTT'.
029900*Instagram
030000   CALL 'cobdom_create_element' USING 'igContainer', 'span'.
030100   CALL 'cobdom_add_event_listener' USING 'igContainer',
030200     'click', 'OPENIG'.
030300   CALL 'cobdom_set_class' USING 'igContainer',
030400     'contactContainer'.
030500   CALL 'cobdom_create_element' USING 'igImage', 'img'.
030600   CALL 'cobdom_src' USING 'igImage', 
030700     '/res/icons/tabler-icons/icons/outline/brand-instagram.svg'.
030800   CALL 'cobdom_style' USING 'igImage', 'width', '6rem'.
030900   CALL 'cobdom_style' USING 'igImage', 'height', '6rem'.
031000   CALL 'cobdom_create_element' USING 'igText', 'div'.
031100   CALL 'cobdom_style' USING 'igText', 'textDecoration',
031200     'underline'.
031300   CALL 'cobdom_inner_html' USING 'igText', 'Instagram'.
031400   CALL 'cobdom_append_child' USING 'igImage', 'igContainer'.
031500   CALL 'cobdom_append_child' USING 'igText', 'igContainer'.
031600   CALL 'cobdom_append_child' USING 'igContainer', 'linksDiv'.
031700   CALL 'cobdom_add_event_listener' USING 'igText',
031800     'click', 'OPENIG'.
031900   CALL 'cobdom_add_event_listener' USING 'igImage',
032000     'click', 'OPENIG'.
032100 
032200   CALL 'cobdom_append_child' USING 'emailDiv', 'contactContent'.
032300   CALL 'cobdom_append_child' USING 'linksDiv', 'contactContent'.
032400*Skills section
032500*  CALL 'cobdom_create_element' USING 'skillsSection', 'div'.
032600*  CALL 'cobdom_style' USING 'skillsSection', 'width', '100%'.
032700*  CALL 'cobdom_create_element' USING 'skillsHeader', 'div'.
032800*  CALL 'cobdom_set_class' USING 'skillsHeader',
032900*    'contentHeadersClass'.
033000*  CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills:'.
033100*  CALL 'cobdom_create_element' USING 'skillsContent', 'div'.
033200*
033300*  CALL 'cobdom_append_child' USING 'skillsSection',
033400*    'contentDiv'.
033500*  CALL 'cobdom_append_child' USING 'skillsHeader',
033600*    'skillsSection'.
033700*  CALL 'cobdom_append_child' USING 'skillsContent',
033800*    'skillsSection'.
033900*Project section
034000   CALL 'cobdom_create_element' USING 'projectSection', 'div'.
034100   CALL 'cobdom_style' USING 'projectSection', 'width', '100%'.
034200*  CALL 'cobdom_style' USING 'projectSection', 'margin', '2rem'.
034300   CALL 'cobdom_create_element' USING 'projectHeader', 'div'.
034400   CALL 'cobdom_set_class' USING 'projectHeader',
034500     'contentHeadersClass'.
034600   CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects:'.
034700   CALL 'cobdom_create_element' USING 'projectContent', 'div'.
034800   CALL 'cobdom_style' USING 'projectContent', 'textAlign',
034900     'center'.
035000   CALL 'cobdom_inner_html' USING 'projectContent', 'WIP'.
035100   CALL 'cobdom_append_child' USING 'projectSection', 
035200     'contentDiv'.
035300   CALL 'cobdom_append_child' USING 'projectHeader', 
035400     'projectSection'.
035500   CALL 'cobdom_append_child' USING 'projectContent', 
035600     'projectSection'.
035700*Cobol section
035800   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
035900   CALL 'cobdom_style' USING 'cobolSection', 'width', '100%'.
036000*  CALL 'cobdom_style' USING 'cobolSection', 'margin', '2rem'.
036100   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
036200   CALL 'cobdom_set_class' USING 'cobolHeader',
036300     'contentHeadersClass'.
036400   CALL 'cobdom_inner_html' USING 'cobolHeader', 'COBOL'.
036500   CALL 'cobdom_create_element' USING 'cobolContent', 'span'.
036600   CALL 'cobdom_append_child' USING 'cobolSection',
036700     'contentDiv'.
036800   CALL 'cobdom_append_child' USING 'cobolHeader', 
036900     'cobolSection'.
037000   CALL 'cobdom_append_child' USING 'cobolContent', 
037100     'cobolSection'.
037200   CALL 'cobdom_create_element' USING 'cobolGithubLink',
037300     'span'.
037400   CALL 'cobdom_add_event_listener' USING 'cobolGithubLink',
037500     'click', 'OPENCOBOLSOURCE'.
037600   CALL 'cobdom_inner_html' USING 'cobolGithubLink',
037700     'GitHub!'.
037800   CALL 'cobdom_style' USING 'cobolGithubLink', 'textDecoration',
037900     'underline'.
038000   CALL 'cobdom_append_child' USING 'cobolGithubLink',
038100     'cobolSection'.
038200*Set contentHeadersClass class styles. Must be called after elements
038300*exist as this uses getElementsByClassName. A safer option would
038400*be to make a new style element but for the sake of demnostrating
038500*this part of the library I will use this here.
038600   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
038700     'fontSize', '2.5rem'.
038800   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
038900     'width', '100%'.
039000   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
039100     'textAlign', 'center'.
039200   CALL 'cobdom_class_style' USING 'contentHeadersClass',
039300     'fontWeight', 'bold'.
039400   CALL 'cobdom_class_style' USING 'contactContainer', 'margin',
039500     '1rem'.
039600  CALL 'cobdom_class_style' USING 'contactContainer', 'display',
039700     'flex'. 
039800   CALL 'cobdom_class_style' USING 'contactContainer',
039900     'flexDirection', 'column'.
040000   CALL 'cobdom_class_style' USING 'contactContainer',
040100     'alignItems', 'center'.
040200   CONTINUE.
040300 BUILD-MENUBAR.
040400   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
040500   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
040600   CALL 'cobdom_style' USING 'headerDiv', 'pointerEvents', 'none'.
040700   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
040800   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
040900     'space-between'.
041000   CALL 'cobdom_style' USING 'headerDiv', 'flexDirection',
041100     'column'.
041200   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
041300   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
041400   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
041500*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
041600*    'blur(.3rem)'.
041700*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
041800*    'blur(5px)'.
041900*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
042000*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
042100*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
042200*    '1rem'.
042300*  CALL 'cobdom_style' USING 'headerDiv',
042400*    'borderBottomRightRadius','1rem'.
042500   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
042600   CALL 'cobdom_create_element' USING 'topArea', 'div'.
042700   CALL 'cobdom_style' USING 'topArea', 'display', 'flex'.
042800   CALL 'cobdom_style' USING 'topArea', 'pointerEvents', 'all'.
042900   CALL 'cobdom_style' USING 'topArea', 'backgroundColor',
043000     '#c9c9c9'.
043100   CALL 'cobdom_append_child' USING 'topArea', 'headerDiv'.
043200*Setup menu
043300   CALL 'cobdom_create_element' USING 'navArea', 'div'.
043400*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
043500   CALL 'cobdom_create_element' USING 'navButton', 'img'.
043600   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
043700   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
043800   CALL 'cobdom_src' USING 'navButton', 
043900     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
044000   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
044100     '#898989'.
044200*  CALL 'cobdom_style' USING 'navButton', 'filter', 
044300*    'invert(100%)'.
044400   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
044500   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
044600   CALL 'cobdom_style' USING 'navButton', 'padding', '.35rem'.
044700   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
044800   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
044900   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
045000   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
045100*Setup menu selectors
045200   CALL 'cobdom_create_element' USING 'selectorDiv', 'div'.
045300   CALL 'cobdom_style' USING 'selectorDiv', 'pointerEvents'
045400     'none'.
045500*About Me
045600   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
045700   CALL 'cobdom_style' USING 'navAbout', 'fontSize', '4rem'.
045800   CALL 'cobdom_style' USING 'navAbout', 'pointerEvents', 'all'.
045900   CALL 'cobdom_style' USING 'navAbout', 'width', 
046000     'max-content'.
046100   CALL 'cobdom_add_event_listener' USING 'navAbout',
046200     'click', 'NAVABOUT'.
046300   CALL 'cobdom_style' USING 'navAbout', 'position', 'relative'.
046400   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
046500     '#c9c9c9'.
046600*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
046700*    'blur(.3rem)'.
046800*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
046900*    'blur(5px)'.
047000   CALL 'cobdom_style' USING 'navAbout', 
047100     'borderBottomRightRadius', '0.5rem'.
047200   CALL 'cobdom_style' USING 'navAbout', 
047300     'borderTopRightRadius', '0.5rem'.
047400   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
047500   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
047600*  CALL 'cobdom_style' USING 'navAbout', 'top', '9.46rem'.
047700   CALL 'cobdom_style' USING 'navAbout', 'left', '-35rem'.
047800   CALL 'cobdom_style' USING 'navAbout', 'transition', 
047900     'transform 0.5s ease 0.1s'.
048000   CALL 'cobdom_append_child' USING 'navAbout', 'selectorDiv'.
048100*Contact Me
048200   CALL 'cobdom_create_element' USING 'navContact', 'div'.
048300   CALL 'cobdom_style' USING 'navContact', 'fontSize', '4rem'.
048400   CALL 'cobdom_style' USING 'navContact', 'pointerEvents', 'all'.
048500   CALL 'cobdom_style' USING 'navContact', 'width', 
048600     'max-content'.
048700   CALL 'cobdom_add_event_listener' USING 'navContact',
048800     'click', 'NAVCONTACT'.
048900   CALL 'cobdom_style' USING 'navContact', 'position', 'relative'.
049000   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
049100     '#c9c9c9'.
049200*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
049300*    'blur(.3rem)'.
049400*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
049500*    'blur(5px)'.
049600   CALL 'cobdom_style' USING 'navContact', 
049700     'borderBottomRightRadius', '0.5rem'.
049800   CALL 'cobdom_style' USING 'navContact', 
049900     'borderTopRightRadius', '0.5rem'.
050000   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
050100   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
050200*  CALL 'cobdom_style' USING 'navContact', 'top', '14.86rem'.
050300   CALL 'cobdom_style' USING 'navContact', 'left', '-35rem'.
050400   CALL 'cobdom_style' USING 'navContact', 'transition', 
050500     'transform 0.5s ease 0.2s'.
050600   CALL 'cobdom_append_child' USING 'navContact', 'selectorDiv'.
050700*Skills
050800*  CALL 'cobdom_create_element' USING 'navSkills', 'div'.
050900*  CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
051000*  CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
051100*    '#c9c9c9'.
051200*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
051300*    'blur(5px)'.
051400*  CALL 'cobdom_style' USING 'navSkills', 
051500*    'borderBottomRightRadius', '0.5rem'.
051600*  CALL 'cobdom_style' USING 'navSkills', 
051700*    'borderTopRightRadius', '0.5rem'.
051800*  CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
051900*  CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
052000*  CALL 'cobdom_style' USING 'navSkills', 'top', '13rem'.
052100*  CALL 'cobdom_style' USING 'navSkills', 'left', '-35rem'.
052200*  CALL 'cobdom_style' USING 'navSkills', 'transition', 
052300*    'transform 0.5s ease 0.3s'.
052400*  CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
052500*Projects
052600   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
052700   CALL 'cobdom_style' USING 'navProjects', 'fontSize', '4rem'.
052800   CALL 'cobdom_style' USING 'navProjects', 'pointerEvents', 
052900     'all'.
053000   CALL 'cobdom_style' USING 'navProjects', 'width', 
053100     'max-content'.
053200   CALL 'cobdom_add_event_listener' USING 'navProjects',
053300     'click', 'NAVPROJECTS'.
053400   CALL 'cobdom_style' USING 'navProjects', 'position', 
053500     'relative'.
053600   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
053700     '#c9c9c9'.
053800*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
053900*    'blur(.3rem)'.
054000*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
054100*    'blur(5px)'.
054200   CALL 'cobdom_style' USING 'navProjects', 
054300     'borderBottomRightRadius', '0.5rem'.
054400   CALL 'cobdom_style' USING 'navProjects', 
054500     'borderTopRightRadius', '0.5rem'.
054600   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
054700   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
054800*  CALL 'cobdom_style' USING 'navProjects', 'top', '20.27rem'.
054900   CALL 'cobdom_style' USING 'navProjects', 'left', '-35rem'.
055000   CALL 'cobdom_style' USING 'navProjects', 'transition', 
055100     'transform 0.5s ease 0.4s'.
055200   CALL 'cobdom_append_child' USING 'navProjects', 'selectorDiv'.
055300*Cobol?
055400   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
055500   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
055600   CALL 'cobdom_style' USING 'navCobol', 'fontSize', '4rem'.
055700   CALL 'cobdom_style' USING 'navCobol', 'pointerEvents', 'all'.
055800   CALL 'cobdom_style' USING 'navCobol', 'width',
055900     'max-content'.
056000   CALL 'cobdom_add_event_listener' USING 'navCobol',
056100     'click', 'NAVCOBOL'.
056200   CALL 'cobdom_style' USING 'navCobol', 'position', 
056300     'relative'.
056400   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
056500     '#000000'.
056600*    '#c9c9c9'.
056700*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
056800*    'blur(5px)'.
056900   CALL 'cobdom_style' USING 'navCobol', 'color', 
057000     '#00FF00'.
057100   CALL 'cobdom_style' USING 'navCobol', 
057200     'borderBottomRightRadius', '0.5rem'.
057300   CALL 'cobdom_style' USING 'navCobol', 
057400     'borderTopRightRadius', '0.5rem'.
057500   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
057600   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
057700   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
057800   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
057900   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
058000   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
058100   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
058200   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
058300*  CALL 'cobdom_style' USING 'navCobol', 'top', '25.7rem'.
058400   CALL 'cobdom_style' USING 'navCobol', 'left', '-35rem'.
058500   CALL 'cobdom_style' USING 'navCobol', 'transition', 
058600     'transform 0.5s ease 0.5s'.
058700   CALL 'cobdom_append_child' USING 'navCobol', 'selectorDiv'.
058800*Add main menu button
058900   CALL 'cobdom_append_child' USING 'navArea', 'topArea'.
059000   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
059100     'MENUTOGGLE'.
059200*Setup ID area
059300   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
059400   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
059500   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
059600   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
059700   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '6rem'.
059800   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
059900   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
060000   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
060100*  CALL 'cobdom_inner_html' USING 'taglineDiv', 
060200*    'A guy that knows a guy.'.
060300   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
060400*Setup lang area
060500   CALL 'cobdom_create_element' USING 'langArea', 'span'.
060600   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
060700*Setup language selector
060800   CALL 'cobdom_create_element' USING 'langUS', 'img'.
060900   CALL 'cobdom_create_element' USING 'langES', 'img'.
061000   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
061100   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
061200   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
061300   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
061400   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
061500   CALL 'cobdom_style' USING 'langUS', 'transition', 
061600     'opacity 0.5s ease, transform 0.5s ease'.
061700*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
061800*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
061900   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
062000   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
062100   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
062200   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
062300   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
062400   CALL 'cobdom_style' USING 'langES', 'transition', 
062500     'opacity 0.5s ease, transform 0.5s ease'.
062600*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
062700*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
062800   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
062900   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
063000     'SETLANGUS'.
063100   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
063200   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
063300     'SETLANGES'.
063400   CALL 'cobdom_append_child' USING 'selectorDiv', 'headerDiv'.
063500   CALL 'cobdom_append_child' USING 'idDiv', 'topArea'.
063600   CALL 'cobdom_append_child' USING 'langArea', 'topArea'.
063700   CONTINUE.
063800 SET-ACTIVE-FLAG.
063900   IF WS-LANG = 'us' THEN
064000     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
064100     CALL 'cobdom_style' USING 'langUS', 'transform', 
064200       'translate(9rem, 0rem)'
064300     CALL 'UPDATETEXT'
064400   ELSE
064500     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
064600     CALL 'cobdom_style' USING 'langUS', 'transform', 
064700       'translate(9rem, 0rem)'
064800     CALL 'UPDATETEXT'
064900   END-IF.
065000   CONTINUE.
065100 LOAD-TEXTS.
065200   CALL 'cobdom_fetch' USING 'LOADENAM',
065300     '/res/text/en/aboutme.txt', 'GET', WS-NULL-BYTE.
065400   CALL 'cobdom_fetch' USING 'LOADESAM',
065500     '/res/text/es/aboutme.txt', 'GET', WS-NULL-BYTE.
065600   CALL 'cobdom_fetch' USING 'LOADENCOBA',
065700     '/res/text/en/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
065800   CALL 'cobdom_fetch' USING 'LOADENCOBB',
065900     '/res/text/en/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
066000   CALL 'cobdom_fetch' USING 'LOADESCOBA',
066100     '/res/text/es/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
066200   CALL 'cobdom_fetch' USING 'LOADESCOBB',
066300     '/res/text/es/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
066400   CONTINUE.
066500 LANG-CHECK.
066600   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
066700     'lang'.
066800   IF WS-LANG = WS-NULL-BYTE THEN
066900     CALL 'cobdom_set_cookie' USING 'us', 'lang'
067000     MOVE 'us' TO WS-LANG
067100   END-IF.
067200   PERFORM SET-ACTIVE-FLAG.
067300   CONTINUE.
067400 COOKIE-ASK.
067500   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
067600   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
067700   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
067800   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
067900   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
068000   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
068100     'rgba(37,186,181,.9)'.
068200   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
068300     'center'.
068400   CALL 'cobdom_style' USING 'cookieDiv', 'fontSize', 
068500     '4rem'.
068600   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
068700-'llow cookies to store your preferences such as language?&nbsp;'.
068800   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
068900   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
069000   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
069100   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
069200   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
069300   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
069400   CALL 'cobdom_style' USING 'cookieYes', 'backgroundColor', 
069500     '#86e059'.
069600   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
069700   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
069800   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
069900   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
070000   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
070100   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
070200   CALL 'cobdom_style' USING 'cookieNo', 'backgroundColor', 
070300     '#e05e59'.
070400   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
070500     'COOKIEACCEPT'.
070600   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
070700     'COOKIEDENY'.
070800   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
070900   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
071000   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
071100   CONTINUE.
071200 UPDATETEXT SECTION.
071300 ENTRY 'UPDATETEXT'.
071400   IF WS-LANG = 'us' THEN
071500     CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me'
071600     CALL 'cobdom_inner_html' USING 'contactHeader',
071700       'Contact Information / Links'
071800*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills'
071900     CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects'
072000     CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'
072100     CALL 'cobdom_inner_html' USING 'navContact', 'Contact/Links'
072200*    CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'
072300     CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'
072400     CALL 'cobdom_inner_html' USING 'aboutContent',
072500       TAB OF EN OF WS-TEXTS
072600     CALL 'cobdom_inner_html' USING 'cobolContent',
072700       TAB-COB OF EN OF WS-TEXTS
072800   ELSE
072900     CALL 'cobdom_inner_html' USING 'aboutHeader', 'Sobre Mi'
073000     CALL 'cobdom_inner_html' USING 'contactHeader',
073100       'Informacion de Contacto / Enlaces'
073200*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Habilidades'
073300     CALL 'cobdom_inner_html' USING 'projectHeader', 'Proyectos'
073400     CALL 'cobdom_inner_html' USING 'navAbout', 'Sobre Mi'
073500     CALL 'cobdom_inner_html' USING 'navContact',
073600       'Contacto/Enlaces'
073700*    CALL 'cobdom_inner_html' USING 'navSkills', 'Habilidades'
073800     CALL 'cobdom_inner_html' USING 'navProjects', 'Proyectos'
073900     CALL 'cobdom_inner_html' USING 'aboutContent',
074000       TAB OF ES OF WS-TEXTS
074100     CALL 'cobdom_inner_html' USING 'cobolContent',
074200       TAB-COB OF ES OF WS-TEXTS
074300   END-IF.
074400   GOBACK.
074500 LOADENAM SECTION.
074600 ENTRY 'LOADENAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
074700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF EN OF WS-TEXTS.
074800   CALL 'UPDATETEXT'.
074900   GOBACK.
075000 LOADESAM SECTION.
075100 ENTRY 'LOADESAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
075200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF ES OF WS-TEXTS.
075300   CALL 'UPDATETEXT'.
075400   GOBACK.
075500 LOADENCOBA SECTION.
075600 ENTRY 'LOADENCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
075700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF EN OF WS-TEXTS.
075800   CALL 'UPDATETEXT'.
075900   GOBACK.
076000 LOADENCOBB SECTION.
076100 ENTRY 'LOADENCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
076200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF EN OF WS-TEXTS.
076300   CALL 'UPDATETEXT'.
076400   GOBACK.
076500 LOADESCOBA SECTION.
076600 ENTRY 'LOADESCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
076700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF ES OF WS-TEXTS.
076800   CALL 'UPDATETEXT'.
076900   GOBACK.
077000 LOADESCOBB SECTION.
077100 ENTRY 'LOADESCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
077200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF ES OF WS-TEXTS.
077300*  DISPLAY ABOUT-ME OF ES OF WS-TEXTS.
077400   CALL 'UPDATETEXT'.
077500   GOBACK.
077600 NAVABOUT SECTION.
077700 ENTRY 'NAVABOUT'.
077800   CALL 'cobdom_scroll_into_view' USING 'aboutHeader'.
077900   GOBACK.
078000 NAVCONTACT SECTION.
078100 ENTRY 'NAVCONTACT'.
078200   CALL 'cobdom_scroll_into_view' USING 'contactHeader'.
078300   GOBACK.
078400 NAVPROJECTS SECTION.
078500 ENTRY 'NAVPROJECTS'.
078600   CALL 'cobdom_scroll_into_view' USING 'projectHeader'.
078700   GOBACK.
078800 NAVCOBOL SECTION.
078900 ENTRY 'NAVCOBOL'.
079000   CALL 'cobdom_scroll_into_view' USING 'cobolHeader'.
079100   GOBACK.
079200 OPENCOBOLSOURCE SECTION.
079300 ENTRY 'OPENCOBOLSOURCE'.
079400   CALL 'cobdom_open_tab' USING 
079500     'https://github.com/BalakeKarbon/BalakeKarbon.github.io'.
079600   GOBACK.
079700 OPENGH SECTION.
079800 ENTRY 'OPENGH'.
079900   CALL 'cobdom_open_tab' USING 
080000     'https://github.com/BalakeKarbon/'.
080100   GOBACK.
080200 OPENLI SECTION.
080300 ENTRY 'OPENLI'.
080400   CALL 'cobdom_open_tab' USING 
080500     'https://www.linkedin.com/in/blake-karbon/'.
080600   GOBACK.
080700 OPENYT SECTION.
080800 ENTRY 'OPENYT'.
080900   CALL 'cobdom_open_tab' USING 
081000     'https://www.youtube.com/@karboncodes'.
081100   GOBACK.
081200 OPENTT SECTION.
081300 ENTRY 'OPENTT'.
081400   CALL 'cobdom_open_tab' USING 
081500     'https://www.tiktok.com/@karboncodes'.
081600   GOBACK.
081700 OPENIG SECTION.
081800 ENTRY 'OPENIG'.
081900   CALL 'cobdom_open_tab' USING 
082000     'https://www.instagram.com/karboncodes'.
082100   GOBACK.
082200 MENUTOGGLE SECTION.
082300 ENTRY 'MENUTOGGLE'.
082400   IF WS-MENU-TOGGLE = 0 THEN
082500     MOVE 1 TO WS-MENU-TOGGLE
082600     CALL 'cobdom_style' USING 'navButton', 'transform', 
082700       'scale(0.85)'
082800     CALL 'cobdom_src' USING 'navButton', 
082900       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
083000     CALL 'cobdom_style' USING 'navAbout', 'transform', 
083100       'translate(35rem, 0rem)' 
083200     CALL 'cobdom_style' USING 'navContact', 'transform', 
083300       'translate(35rem, 0rem)' 
083400     CALL 'cobdom_style' USING 'navSkills', 'transform', 
083500       'translate(35rem, 0rem)'
083600    CALL 'cobdom_style' USING 'navProjects', 'transform', 
083700       'translate(35rem, 0rem)'
083800    CALL 'cobdom_style' USING 'navCobol', 'transform', 
083900       'translate(35rem, 0rem)'
084000   ELSE
084100     MOVE 0 TO WS-MENU-TOGGLE
084200     CALL 'cobdom_style' USING 'navButton', 'transform', 
084300       'scale(1.0)'
084400     CALL 'cobdom_src' USING 'navButton', 
084500       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
084600     CALL 'cobdom_style' USING 'navAbout', 'transform', 
084700       'translate(0rem, 0rem)' 
084800     CALL 'cobdom_style' USING 'navContact', 'transform', 
084900       'translate(0rem, 0rem)' 
085000     CALL 'cobdom_style' USING 'navSkills', 'transform', 
085100       'translate(0rem, 0rem)'
085200    CALL 'cobdom_style' USING 'navProjects', 'transform', 
085300       'translate(0rem, 0rem)'
085400    CALL 'cobdom_style' USING 'navCobol', 'transform', 
085500       'translate(0rem, 0rem)'
085600   END-IF.
085700   GOBACK.
085800*TO-DO: Add a timer in case some fonts do never load
085900 FONTLOADED SECTION.
086000 ENTRY 'FONTLOADED'.
086100   ADD 1 TO WS-FONTS-LOADED.
086200   IF WS-FONTS-LOADED = 2 THEN
086300     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
086400     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
086500     CALL 'cobdom_style' USING 'cobolSection', 'fontFamily',
086600       'ibmpc'
086700   END-IF.
086800   GOBACK.
086900 WINDOWCHANGE SECTION.
087000 ENTRY 'WINDOWCHANGE'.
087100   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
087200   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
087300     '300'.
087400*Optimize this buffer time to not have a noticeable delay but also
087500*not call to often.
087600   GOBACK.
087700 SHAPEPAGE SECTION.
087800 ENTRY 'SHAPEPAGE'.
087900*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
088000*  DISPLAY 'Rendering! ' CENTISECS.
088100   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
088200     'window.innerWidth'.
088300   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
088400   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
088500     'window.innerHeight'.
088600   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
088700   GOBACK.
088800 COOKIEACCEPT SECTION.
088900 ENTRY 'COOKIEACCEPT'.
089000   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
089100   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
089200   MOVE 'y' TO WS-COOKIE-ALLOWED.
089300   IF WS-LANG = 'us' THEN
089400     CALL 'cobdom_set_cookie' USING 'us', 'lang'
089500   ELSE
089600     CALL 'cobdom_set_cookie' USING 'en', 'lang'
089700   END-IF.
089800   GOBACK.
089900 COOKIEDENY SECTION.
090000 ENTRY 'COOKIEDENY'.
090100   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
090200   MOVE 'n' TO WS-COOKIE-ALLOWED.
090300   GOBACK.
090400 SETPERCENTCOBOL SECTION.
090500 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
090600   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF EN OF WS-TEXTS.
090700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF ES OF WS-TEXTS.
090800*  CALL 'cobdom_inner_html' USING 'percentCobol',
090900*    WS-PERCENT-COBOL.
091000*  DISPLAY 'Currently this website is written in ' 
091100*    WS-PERCENT-COBOL '% COBOL.'.
091200   GOBACK.
091300 SETLANG SECTION.
091400 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
091500   if WS-LANG-SELECT-TOGGLE = 0 THEN
091600     MOVE 1 TO WS-LANG-SELECT-TOGGLE
091700     IF WS-LANG = 'us' THEN
091800       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
091900       CALL 'cobdom_style' USING 'langUS', 'transform', 
092000         'translate(0rem, 0rem)'
092100*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
092200     ELSE
092300       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
092400       CALL 'cobdom_style' USING 'langUS', 'transform', 
092500         'translate(0rem, 0rem)'
092600*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
092700     END-IF
092800   ELSE
092900     MOVE 0 TO WS-LANG-SELECT-TOGGLE
093000     IF WS-COOKIE-ALLOWED = 'y' THEN
093100       IF LS-LANG-CHOICE = 'us' THEN
093200         CALL 'cobdom_set_cookie' USING 'us', 'lang'
093300         MOVE 'us' TO WS-LANG
093400       ELSE
093500         CALL 'cobdom_set_cookie' USING 'es', 'lang'
093600         MOVE 'es' TO WS-LANG
093700       END-IF
093800       PERFORM SET-ACTIVE-FLAG
093900     ELSE
094000       MOVE LS-LANG-CHOICE TO WS-LANG
094100       PERFORM SET-ACTIVE-FLAG 
094200     END-IF
094300   END-IF.
094400   GOBACK.
094500 SETLANGUS SECTION.
094600 ENTRY 'SETLANGUS'.
094700   CALL 'SETLANG' USING 'us'.
094800   GOBACK.
094900 SETLANGES SECTION.
095000 ENTRY 'SETLANGES'.
095100   CALL 'SETLANG' USING 'es'.
095200   GOBACK.
095300*TERMINPUT SECTION.
095400*ENTRY 'TERMINPUT' USING LS-TERM-IN.
095500*  DISPLAY LS-TERM-IN.
095600*  GOBACK.
