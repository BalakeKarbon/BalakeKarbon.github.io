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
016700*  CALL 'cobdom_src' USING 'ghStatsImg', 'https://github-readme-st
016800*'ats.vercel.app/api/top-langs?username=BalakeKarbon&show_icons=tr
016900*'ue&locale=en&layout=compact&hide=html&hide_title=true&card_width
017000*'=500'.
017100   CALL 'cobdom_src' USING 'ghStatsImg', '/res/img/top-lang.svg'.
017200   CALL 'cobdom_style' USING 'ghStatsImg', 'height', '10rem'.
017300*  CALL 'cobdom_style' USING 'ghStatsImg', 'transform', 
017400*    'translate(50%,0)'.
017500   CALL 'cobdom_append_child' USING 'ghStatsImg', 'ghStatsDiv'.
017600*Contact section / Links / Socials
017700*Email,
017800*GitHub, LinkedIN
017900*Youtube, TikTok, Instagram,
018000   CALL 'cobdom_create_element' USING 'contactSection', 'div'.
018100   CALL 'cobdom_style' USING 'contactSection', 'width', '100%'.
018200   CALL 'cobdom_create_element' USING 'contactHeader', 'div'.
018300   CALL 'cobdom_set_class' USING 'contactHeader',
018400     'contentHeadersClass'.
018500   CALL 'cobdom_inner_html' USING 'contactHeader',
018600     'Contact Information:'.
018700   CALL 'cobdom_create_element' USING 'contactContent', 'div'.
018800   CALL 'cobdom_style' USING 'contactContent', 'width', '100%'.
018900   CALL 'cobdom_style' USING 'contactContent', 'textAlign',
019000     'center'.
019100   CALL 'cobdom_append_child' USING 'contactSection',
019200     'contentDiv'.
019300   CALL 'cobdom_append_child' USING 'contactHeader',
019400     'contactSection'.
019500   CALL 'cobdom_append_child' USING 'contactContent',
019600     'contactSection'.
019700   CALL 'cobdom_create_element' USING 'emailDiv', 'div'.
019800   CALL 'cobdom_inner_html' USING 'emailDiv',
019900     'karboncodes@gmail.com'.
020000   CALL 'cobdom_create_element' USING 'linksDiv', 'div'.
020100   CALL 'cobdom_style' USING 'linksDiv', 'display', 'flex'.
020200   CALL 'cobdom_style' USING 'linksDiv', 'width', '100%'.
020300   CALL 'cobdom_style' USING 'linksDiv', 'justifyContent',
020400     'center'.
020500*The following section could be done with a loop but it is not
020600*which is horrid
020700*GitHub
020800   CALL 'cobdom_create_element' USING 'ghContainer', 'span'.
020900*  CALL 'cobdom_style' USING 'ghContainer', 'backgroundColor',
021000*    '#00ff00'.
021100*  CALL 'cobdom_style' USING 'ghContainer', 'padding', '1rem'.
021200*  CALL 'cobdom_style' USING 'ghContainer', 'borderRadius',
021300*    '2rem'.
021400   CALL 'cobdom_add_event_listener' USING 'ghContainer',
021500     'click', 'OPENGH'.
021600   CALL 'cobdom_set_class' USING 'ghContainer',
021700     'contactContainer'.
021800   CALL 'cobdom_create_element' USING 'ghImage', 'img'.
021900   CALL 'cobdom_src' USING 'ghImage', 
022000     '/res/icons/tabler-icons/icons/outline/brand-github.svg'.
022100   CALL 'cobdom_style' USING 'ghImage', 'width', '6rem'.
022200   CALL 'cobdom_style' USING 'ghImage', 'height', '6rem'.
022300   CALL 'cobdom_create_element' USING 'ghText', 'div'.
022400   CALL 'cobdom_style' USING 'ghText', 'textDecoration',
022500     'underline'.
022600   CALL 'cobdom_inner_html' USING 'ghText', 'GitHub'.
022700   CALL 'cobdom_append_child' USING 'ghImage', 'ghContainer'.
022800   CALL 'cobdom_append_child' USING 'ghText', 'ghContainer'.
022900   CALL 'cobdom_append_child' USING 'ghContainer', 'linksDiv'.
023000   CALL 'cobdom_add_event_listener' USING 'ghImage',
023100     'click', 'OPENGH'.
023200   CALL 'cobdom_add_event_listener' USING 'ghText',
023300     'click', 'OPENGH'.
023400*LinkedIn
023500   CALL 'cobdom_create_element' USING 'liContainer', 'span'.
023600   CALL 'cobdom_add_event_listener' USING 'liContainer',
023700     'click', 'OPENLI'.
023800   CALL 'cobdom_set_class' USING 'liContainer',
023900     'contactContainer'.
024000   CALL 'cobdom_create_element' USING 'liImage', 'img'.
024100   CALL 'cobdom_src' USING 'liImage', 
024200     '/res/icons/tabler-icons/icons/outline/brand-linkedin.svg'.
024300   CALL 'cobdom_style' USING 'liImage', 'width', '6rem'.
024400   CALL 'cobdom_style' USING 'liImage', 'height', '6rem'.
024500   CALL 'cobdom_create_element' USING 'liText', 'div'.
024600   CALL 'cobdom_style' USING 'liText', 'textDecoration',
024700     'underline'.
024800   CALL 'cobdom_inner_html' USING 'liText', 'Linkedin'.
024900   CALL 'cobdom_append_child' USING 'liImage', 'liContainer'.
025000   CALL 'cobdom_append_child' USING 'liText', 'liContainer'.
025100   CALL 'cobdom_append_child' USING 'liContainer', 'linksDiv'.
025200   CALL 'cobdom_add_event_listener' USING 'liImage',
025300     'click', 'OPENLI'.
025400   CALL 'cobdom_add_event_listener' USING 'liText',
025500     'click', 'OPENLI'.
025600*Medium
025700   CALL 'cobdom_create_element' USING 'meContainer', 'span'.
025800   CALL 'cobdom_add_event_listener' USING 'meContainer',
025900     'click', 'OPENME'.
026000   CALL 'cobdom_set_class' USING 'meContainer',
026100     'contactContainer'.
026200   CALL 'cobdom_create_element' USING 'meImage', 'img'.
026300   CALL 'cobdom_src' USING 'meImage', 
026400     '/res/icons/tabler-icons/icons/outline/brand-medium.svg'.
026500   CALL 'cobdom_style' USING 'meImage', 'width', '6rem'.
026600   CALL 'cobdom_style' USING 'meImage', 'height', '6rem'.
026700   CALL 'cobdom_create_element' USING 'meText', 'div'.
026800   CALL 'cobdom_style' USING 'meText', 'textDecoration',
026900     'underline'.
027000   CALL 'cobdom_inner_html' USING 'meText', 'Medium'.
027100   CALL 'cobdom_append_child' USING 'meImage', 'meContainer'.
027200   CALL 'cobdom_append_child' USING 'meText', 'meContainer'.
027300   CALL 'cobdom_append_child' USING 'meContainer', 'linksDiv'.
027400   CALL 'cobdom_add_event_listener' USING 'meImage',
027500     'click', 'OPENME'.
027600   CALL 'cobdom_add_event_listener' USING 'meText',
027700     'click', 'OPENME'.
027800*Youtube
027900   CALL 'cobdom_create_element' USING 'ytContainer', 'span'.
028000   CALL 'cobdom_add_event_listener' USING 'ytContainer',
028100     'click', 'OPENYT'.
028200   CALL 'cobdom_set_class' USING 'ytContainer',
028300     'contactContainer'.
028400   CALL 'cobdom_create_element' USING 'ytImage', 'img'.
028500   CALL 'cobdom_src' USING 'ytImage', 
028600     '/res/icons/tabler-icons/icons/outline/brand-youtube.svg'.
028700   CALL 'cobdom_style' USING 'ytImage', 'width', '6rem'.
028800   CALL 'cobdom_style' USING 'ytImage', 'height', '6rem'.
028900   CALL 'cobdom_create_element' USING 'ytText', 'div'.
029000   CALL 'cobdom_style' USING 'ytText', 'textDecoration',
029100     'underline'.
029200   CALL 'cobdom_inner_html' USING 'ytText', 'Youtube'.
029300   CALL 'cobdom_append_child' USING 'ytImage', 'ytContainer'.
029400   CALL 'cobdom_append_child' USING 'ytText', 'ytContainer'.
029500   CALL 'cobdom_append_child' USING 'ytContainer', 'linksDiv'.
029600   CALL 'cobdom_add_event_listener' USING 'ytImage',
029700     'click', 'OPENYT'.
029800   CALL 'cobdom_add_event_listener' USING 'ytText',
029900     'click', 'OPENYT'.
030000*TikTok
030100   CALL 'cobdom_create_element' USING 'ttContainer', 'span'.
030200   CALL 'cobdom_add_event_listener' USING 'ttContainer',
030300     'click', 'OPENTT'.
030400   CALL 'cobdom_set_class' USING 'ttContainer',
030500     'contactContainer'.
030600   CALL 'cobdom_create_element' USING 'ttImage', 'img'.
030700   CALL 'cobdom_src' USING 'ttImage', 
030800     '/res/icons/tabler-icons/icons/outline/brand-tiktok.svg'.
030900   CALL 'cobdom_style' USING 'ttImage', 'width', '6rem'.
031000   CALL 'cobdom_style' USING 'ttImage', 'height', '6rem'.
031100   CALL 'cobdom_create_element' USING 'ttText', 'div'.
031200   CALL 'cobdom_style' USING 'ttText', 'textDecoration',
031300     'underline'.
031400   CALL 'cobdom_inner_html' USING 'ttText', 'TikTok'.
031500   CALL 'cobdom_append_child' USING 'ttImage', 'ttContainer'.
031600   CALL 'cobdom_append_child' USING 'ttText', 'ttContainer'.
031700   CALL 'cobdom_append_child' USING 'ttContainer', 'linksDiv'.
031800   CALL 'cobdom_add_event_listener' USING 'ttContainer',
031900     'click', 'OPENTT'.
032000   CALL 'cobdom_add_event_listener' USING 'ttContainer',
032100     'click', 'OPENTT'.
032200*Instagram
032300   CALL 'cobdom_create_element' USING 'igContainer', 'span'.
032400   CALL 'cobdom_add_event_listener' USING 'igContainer',
032500     'click', 'OPENIG'.
032600   CALL 'cobdom_set_class' USING 'igContainer',
032700     'contactContainer'.
032800   CALL 'cobdom_create_element' USING 'igImage', 'img'.
032900   CALL 'cobdom_src' USING 'igImage', 
033000     '/res/icons/tabler-icons/icons/outline/brand-instagram.svg'.
033100   CALL 'cobdom_style' USING 'igImage', 'width', '6rem'.
033200   CALL 'cobdom_style' USING 'igImage', 'height', '6rem'.
033300   CALL 'cobdom_create_element' USING 'igText', 'div'.
033400   CALL 'cobdom_style' USING 'igText', 'textDecoration',
033500     'underline'.
033600   CALL 'cobdom_inner_html' USING 'igText', 'Instagram'.
033700   CALL 'cobdom_append_child' USING 'igImage', 'igContainer'.
033800   CALL 'cobdom_append_child' USING 'igText', 'igContainer'.
033900   CALL 'cobdom_append_child' USING 'igContainer', 'linksDiv'.
034000   CALL 'cobdom_add_event_listener' USING 'igText',
034100     'click', 'OPENIG'.
034200   CALL 'cobdom_add_event_listener' USING 'igImage',
034300     'click', 'OPENIG'.
034400 
034500   CALL 'cobdom_append_child' USING 'emailDiv', 'contactContent'.
034600   CALL 'cobdom_append_child' USING 'linksDiv', 'contactContent'.
034700*Skills section
034800*  CALL 'cobdom_create_element' USING 'skillsSection', 'div'.
034900*  CALL 'cobdom_style' USING 'skillsSection', 'width', '100%'.
035000*  CALL 'cobdom_create_element' USING 'skillsHeader', 'div'.
035100*  CALL 'cobdom_set_class' USING 'skillsHeader',
035200*    'contentHeadersClass'.
035300*  CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills:'.
035400*  CALL 'cobdom_create_element' USING 'skillsContent', 'div'.
035500*
035600*  CALL 'cobdom_append_child' USING 'skillsSection',
035700*    'contentDiv'.
035800*  CALL 'cobdom_append_child' USING 'skillsHeader',
035900*    'skillsSection'.
036000*  CALL 'cobdom_append_child' USING 'skillsContent',
036100*    'skillsSection'.
036200*Project section
036300   CALL 'cobdom_create_element' USING 'projectSection', 'div'.
036400   CALL 'cobdom_style' USING 'projectSection', 'width', '100%'.
036500*  CALL 'cobdom_style' USING 'projectSection', 'margin', '2rem'.
036600   CALL 'cobdom_create_element' USING 'projectHeader', 'div'.
036700   CALL 'cobdom_set_class' USING 'projectHeader',
036800     'contentHeadersClass'.
036900   CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects:'.
037000   CALL 'cobdom_create_element' USING 'projectContent', 'div'.
037100   CALL 'cobdom_style' USING 'projectContent', 'textAlign',
037200     'center'.
037300   CALL 'cobdom_inner_html' USING 'projectContent', 'WIP'.
037400   CALL 'cobdom_append_child' USING 'projectSection', 
037500     'contentDiv'.
037600   CALL 'cobdom_append_child' USING 'projectHeader', 
037700     'projectSection'.
037800   CALL 'cobdom_append_child' USING 'projectContent', 
037900     'projectSection'.
038000   PERFORM ADD-PROJECTS.
038100*Cobol section
038200   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
038300   CALL 'cobdom_style' USING 'cobolSection', 'width', '100%'.
038400*  CALL 'cobdom_style' USING 'cobolSection', 'margin', '2rem'.
038500   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
038600   CALL 'cobdom_set_class' USING 'cobolHeader',
038700     'contentHeadersClass'.
038800   CALL 'cobdom_inner_html' USING 'cobolHeader', 'COBOL'.
038900   CALL 'cobdom_create_element' USING 'cobolContent', 'span'.
039000   CALL 'cobdom_append_child' USING 'cobolSection',
039100     'contentDiv'.
039200   CALL 'cobdom_append_child' USING 'cobolHeader', 
039300     'cobolSection'.
039400   CALL 'cobdom_append_child' USING 'cobolContent', 
039500     'cobolSection'.
039600   CALL 'cobdom_create_element' USING 'cobolGithubLink',
039700     'span'.
039800   CALL 'cobdom_add_event_listener' USING 'cobolGithubLink',
039900     'click', 'OPENCOBOLSOURCE'.
040000   CALL 'cobdom_inner_html' USING 'cobolGithubLink',
040100     'GitHub!'.
040200   CALL 'cobdom_style' USING 'cobolGithubLink', 'textDecoration',
040300     'underline'.
040400   CALL 'cobdom_append_child' USING 'cobolGithubLink',
040500     'cobolSection'.
040600*Set contentHeadersClass class styles. Must be called after elements
040700*exist as this uses getElementsByClassName. A safer option would
040800*be to make a new style element but for the sake of demnostrating
040900*this part of the library I will use this here.
041000   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
041100     'fontSize', '2.5rem'.
041200   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
041300     'width', '100%'.
041400   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
041500     'textAlign', 'center'.
041600   CALL 'cobdom_class_style' USING 'contentHeadersClass',
041700     'fontWeight', 'bold'.
041800   CALL 'cobdom_class_style' USING 'contactContainer', 'margin',
041900     '1rem'.
042000  CALL 'cobdom_class_style' USING 'contactContainer', 'display',
042100     'flex'. 
042200   CALL 'cobdom_class_style' USING 'contactContainer',
042300     'flexDirection', 'column'.
042400   CALL 'cobdom_class_style' USING 'contactContainer',
042500     'alignItems', 'center'.
042600   CONTINUE.
042700 BUILD-MENUBAR.
042800   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
042900   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
043000   CALL 'cobdom_style' USING 'headerDiv', 'pointerEvents', 'none'.
043100   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
043200   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
043300     'space-between'.
043400   CALL 'cobdom_style' USING 'headerDiv', 'flexDirection',
043500     'column'.
043600   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
043700   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
043800   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
043900*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
044000*    'blur(.3rem)'.
044100*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
044200*    'blur(5px)'.
044300*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
044400*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
044500*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
044600*    '1rem'.
044700*  CALL 'cobdom_style' USING 'headerDiv',
044800*    'borderBottomRightRadius','1rem'.
044900   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
045000   CALL 'cobdom_create_element' USING 'topArea', 'div'.
045100   CALL 'cobdom_style' USING 'topArea', 'display', 'flex'.
045200   CALL 'cobdom_style' USING 'topArea', 'pointerEvents', 'all'.
045300   CALL 'cobdom_style' USING 'topArea', 'backgroundColor',
045400     '#c9c9c9'.
045500   CALL 'cobdom_append_child' USING 'topArea', 'headerDiv'.
045600*Setup menu
045700   CALL 'cobdom_create_element' USING 'navArea', 'div'.
045800*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
045900   CALL 'cobdom_create_element' USING 'navButton', 'img'.
046000   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
046100   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
046200   CALL 'cobdom_src' USING 'navButton', 
046300     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
046400   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
046500     '#898989'.
046600*  CALL 'cobdom_style' USING 'navButton', 'filter', 
046700*    'invert(100%)'.
046800   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
046900   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
047000   CALL 'cobdom_style' USING 'navButton', 'padding', '.35rem'.
047100   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
047200   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
047300   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
047400   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
047500*Setup menu selectors
047600   CALL 'cobdom_create_element' USING 'selectorDiv', 'div'.
047700   CALL 'cobdom_style' USING 'selectorDiv', 'pointerEvents'
047800     'none'.
047900*About Me
048000   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
048100   CALL 'cobdom_style' USING 'navAbout', 'fontSize', '4rem'.
048200   CALL 'cobdom_style' USING 'navAbout', 'pointerEvents', 'all'.
048300   CALL 'cobdom_style' USING 'navAbout', 'width', 
048400     'max-content'.
048500   CALL 'cobdom_add_event_listener' USING 'navAbout',
048600     'click', 'NAVABOUT'.
048700   CALL 'cobdom_style' USING 'navAbout', 'position', 'relative'.
048800   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
048900     '#c9c9c9'.
049000*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
049100*    'blur(.3rem)'.
049200*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
049300*    'blur(5px)'.
049400   CALL 'cobdom_style' USING 'navAbout', 
049500     'borderBottomRightRadius', '0.5rem'.
049600   CALL 'cobdom_style' USING 'navAbout', 
049700     'borderTopRightRadius', '0.5rem'.
049800   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
049900   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
050000*  CALL 'cobdom_style' USING 'navAbout', 'top', '9.46rem'.
050100   CALL 'cobdom_style' USING 'navAbout', 'left', '-35rem'.
050200   CALL 'cobdom_style' USING 'navAbout', 'transition', 
050300     'transform 0.5s ease 0.1s'.
050400   CALL 'cobdom_append_child' USING 'navAbout', 'selectorDiv'.
050500*Contact Me
050600   CALL 'cobdom_create_element' USING 'navContact', 'div'.
050700   CALL 'cobdom_style' USING 'navContact', 'fontSize', '4rem'.
050800   CALL 'cobdom_style' USING 'navContact', 'pointerEvents', 'all'.
050900   CALL 'cobdom_style' USING 'navContact', 'width', 
051000     'max-content'.
051100   CALL 'cobdom_add_event_listener' USING 'navContact',
051200     'click', 'NAVCONTACT'.
051300   CALL 'cobdom_style' USING 'navContact', 'position', 'relative'.
051400   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
051500     '#c9c9c9'.
051600*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
051700*    'blur(.3rem)'.
051800*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
051900*    'blur(5px)'.
052000   CALL 'cobdom_style' USING 'navContact', 
052100     'borderBottomRightRadius', '0.5rem'.
052200   CALL 'cobdom_style' USING 'navContact', 
052300     'borderTopRightRadius', '0.5rem'.
052400   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
052500   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
052600*  CALL 'cobdom_style' USING 'navContact', 'top', '14.86rem'.
052700   CALL 'cobdom_style' USING 'navContact', 'left', '-35rem'.
052800   CALL 'cobdom_style' USING 'navContact', 'transition', 
052900     'transform 0.5s ease 0.2s'.
053000   CALL 'cobdom_append_child' USING 'navContact', 'selectorDiv'.
053100*Skills
053200*  CALL 'cobdom_create_element' USING 'navSkills', 'div'.
053300*  CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
053400*  CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
053500*    '#c9c9c9'.
053600*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
053700*    'blur(5px)'.
053800*  CALL 'cobdom_style' USING 'navSkills', 
053900*    'borderBottomRightRadius', '0.5rem'.
054000*  CALL 'cobdom_style' USING 'navSkills', 
054100*    'borderTopRightRadius', '0.5rem'.
054200*  CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
054300*  CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
054400*  CALL 'cobdom_style' USING 'navSkills', 'top', '13rem'.
054500*  CALL 'cobdom_style' USING 'navSkills', 'left', '-35rem'.
054600*  CALL 'cobdom_style' USING 'navSkills', 'transition', 
054700*    'transform 0.5s ease 0.3s'.
054800*  CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
054900*Projects
055000   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
055100   CALL 'cobdom_style' USING 'navProjects', 'fontSize', '4rem'.
055200   CALL 'cobdom_style' USING 'navProjects', 'pointerEvents', 
055300     'all'.
055400   CALL 'cobdom_style' USING 'navProjects', 'width', 
055500     'max-content'.
055600   CALL 'cobdom_add_event_listener' USING 'navProjects',
055700     'click', 'NAVPROJECTS'.
055800   CALL 'cobdom_style' USING 'navProjects', 'position', 
055900     'relative'.
056000   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
056100     '#c9c9c9'.
056200*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
056300*    'blur(.3rem)'.
056400*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
056500*    'blur(5px)'.
056600   CALL 'cobdom_style' USING 'navProjects', 
056700     'borderBottomRightRadius', '0.5rem'.
056800   CALL 'cobdom_style' USING 'navProjects', 
056900     'borderTopRightRadius', '0.5rem'.
057000   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
057100   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
057200*  CALL 'cobdom_style' USING 'navProjects', 'top', '20.27rem'.
057300   CALL 'cobdom_style' USING 'navProjects', 'left', '-35rem'.
057400   CALL 'cobdom_style' USING 'navProjects', 'transition', 
057500     'transform 0.5s ease 0.4s'.
057600   CALL 'cobdom_append_child' USING 'navProjects', 'selectorDiv'.
057700*Cobol?
057800   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
057900   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
058000   CALL 'cobdom_style' USING 'navCobol', 'fontSize', '4rem'.
058100   CALL 'cobdom_style' USING 'navCobol', 'pointerEvents', 'all'.
058200   CALL 'cobdom_style' USING 'navCobol', 'width',
058300     'max-content'.
058400   CALL 'cobdom_add_event_listener' USING 'navCobol',
058500     'click', 'NAVCOBOL'.
058600   CALL 'cobdom_style' USING 'navCobol', 'position', 
058700     'relative'.
058800   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
058900     '#000000'.
059000*    '#c9c9c9'.
059100*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
059200*    'blur(5px)'.
059300   CALL 'cobdom_style' USING 'navCobol', 'color', 
059400     '#00FF00'.
059500   CALL 'cobdom_style' USING 'navCobol', 
059600     'borderBottomRightRadius', '0.5rem'.
059700   CALL 'cobdom_style' USING 'navCobol', 
059800     'borderTopRightRadius', '0.5rem'.
059900   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
060000   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
060100   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
060200   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
060300   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
060400   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
060500   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
060600   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
060700*  CALL 'cobdom_style' USING 'navCobol', 'top', '25.7rem'.
060800   CALL 'cobdom_style' USING 'navCobol', 'left', '-35rem'.
060900   CALL 'cobdom_style' USING 'navCobol', 'transition', 
061000     'transform 0.5s ease 0.5s'.
061100   CALL 'cobdom_append_child' USING 'navCobol', 'selectorDiv'.
061200*Add main menu button
061300   CALL 'cobdom_append_child' USING 'navArea', 'topArea'.
061400   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
061500     'MENUTOGGLE'.
061600*Setup ID area
061700   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
061800   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
061900   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
062000   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
062100   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '5rem'.
062200   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
062300   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
062400   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
062500*  CALL 'cobdom_inner_html' USING 'taglineDiv', 
062600*    'A guy that knows a guy.'.
062700   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
062800*Setup lang area
062900   CALL 'cobdom_create_element' USING 'langArea', 'span'.
063000   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
063100*Setup language selector
063200   CALL 'cobdom_create_element' USING 'langUS', 'img'.
063300   CALL 'cobdom_create_element' USING 'langES', 'img'.
063400   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
063500   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
063600   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
063700   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
063800   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
063900   CALL 'cobdom_style' USING 'langUS', 'transition', 
064000     'opacity 0.5s ease, transform 0.5s ease'.
064100*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
064200*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
064300   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
064400   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
064500   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
064600   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
064700   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
064800   CALL 'cobdom_style' USING 'langES', 'transition', 
064900     'opacity 0.5s ease, transform 0.5s ease'.
065000*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
065100*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
065200   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
065300   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
065400     'SETLANGUS'.
065500   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
065600   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
065700     'SETLANGES'.
065800   CALL 'cobdom_append_child' USING 'selectorDiv', 'headerDiv'.
065900   CALL 'cobdom_append_child' USING 'idDiv', 'topArea'.
066000   CALL 'cobdom_append_child' USING 'langArea', 'topArea'.
066100   CONTINUE.
066200 SET-ACTIVE-FLAG.
066300   IF WS-LANG = 'us' THEN
066400     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
066500     CALL 'cobdom_style' USING 'langUS', 'transform', 
066600       'translate(9rem, 0rem)'
066700     CALL 'UPDATETEXT'
066800   ELSE
066900     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
067000     CALL 'cobdom_style' USING 'langUS', 'transform', 
067100       'translate(9rem, 0rem)'
067200     CALL 'UPDATETEXT'
067300   END-IF.
067400   CONTINUE.
067500 LOAD-TEXTS.
067600   CALL 'cobdom_fetch' USING 'LOADENAM',
067700     '/res/text/en/aboutme.txt', 'GET', WS-NULL-BYTE.
067800   CALL 'cobdom_fetch' USING 'LOADESAM',
067900     '/res/text/es/aboutme.txt', 'GET', WS-NULL-BYTE.
068000   CALL 'cobdom_fetch' USING 'LOADENCOBA',
068100     '/res/text/en/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
068200   CALL 'cobdom_fetch' USING 'LOADENCOBB',
068300     '/res/text/en/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
068400   CALL 'cobdom_fetch' USING 'LOADESCOBA',
068500     '/res/text/es/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
068600   CALL 'cobdom_fetch' USING 'LOADESCOBB',
068700     '/res/text/es/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
068800   CONTINUE.
068900 LANG-CHECK.
069000   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
069100     'lang'.
069200   IF WS-LANG = WS-NULL-BYTE THEN
069300     CALL 'cobdom_set_cookie' USING 'us', 'lang'
069400     MOVE 'us' TO WS-LANG
069500   END-IF.
069600   PERFORM SET-ACTIVE-FLAG.
069700   CONTINUE.
069800 COOKIE-ASK.
069900   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
070000   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
070100   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
070200   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
070300   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
070400   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
070500     'rgba(37,186,181,.9)'.
070600   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
070700     'center'.
070800   CALL 'cobdom_style' USING 'cookieDiv', 'fontSize', 
070900     '4rem'.
071000   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
071100-'llow cookies to store your preferences such as language?&nbsp;'.
071200   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
071300   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
071400   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
071500   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
071600   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
071700   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
071800   CALL 'cobdom_style' USING 'cookieYes', 'backgroundColor', 
071900     '#86e059'.
072000   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
072100   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
072200   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
072300   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
072400   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
072500   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
072600   CALL 'cobdom_style' USING 'cookieNo', 'backgroundColor', 
072700     '#e05e59'.
072800   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
072900     'COOKIEACCEPT'.
073000   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
073100     'COOKIEDENY'.
073200   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
073300   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
073400   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
073500   CONTINUE.
073600 ADD-PROJECTS.
073700*Computer Design
073800   CALL 'cobdom_create_element' USING 'dtlImg', 'img'.
073900   CALL 'cobdom_src' USING 'dtlImg',
074000     'res/img/dlatch-characteristics.svg'.
074100*   CALL 'cobdom_style' USING 'dtImg',''.
074200   CALL 'cobdom_append_child' USING 'dtlImg', 'projectContent'.
074300   CONTINUE.
074400 UPDATETEXT SECTION.
074500 ENTRY 'UPDATETEXT'.
074600   IF WS-LANG = 'us' THEN
074700     CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me'
074800     CALL 'cobdom_inner_html' USING 'contactHeader',
074900       'Contact Information / Links'
075000*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills'
075100     CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects'
075200     CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'
075300     CALL 'cobdom_inner_html' USING 'navContact', 'Contact/Links'
075400*    CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'
075500     CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'
075600     CALL 'cobdom_inner_html' USING 'aboutContent',
075700       TAB OF EN OF WS-TEXTS
075800     CALL 'cobdom_inner_html' USING 'cobolContent',
075900       TAB-COB OF EN OF WS-TEXTS
076000   ELSE
076100     CALL 'cobdom_inner_html' USING 'aboutHeader', 'Sobre Mi'
076200     CALL 'cobdom_inner_html' USING 'contactHeader',
076300       'Informacion de Contacto / Enlaces'
076400*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Habilidades'
076500     CALL 'cobdom_inner_html' USING 'projectHeader', 'Proyectos'
076600     CALL 'cobdom_inner_html' USING 'navAbout', 'Sobre Mi'
076700     CALL 'cobdom_inner_html' USING 'navContact',
076800       'Contacto/Enlaces'
076900*    CALL 'cobdom_inner_html' USING 'navSkills', 'Habilidades'
077000     CALL 'cobdom_inner_html' USING 'navProjects', 'Proyectos'
077100     CALL 'cobdom_inner_html' USING 'aboutContent',
077200       TAB OF ES OF WS-TEXTS
077300     CALL 'cobdom_inner_html' USING 'cobolContent',
077400       TAB-COB OF ES OF WS-TEXTS
077500   END-IF.
077600   GOBACK.
077700 LOADENAM SECTION.
077800 ENTRY 'LOADENAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
077900   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF EN OF WS-TEXTS.
078000   CALL 'UPDATETEXT'.
078100   GOBACK.
078200 LOADESAM SECTION.
078300 ENTRY 'LOADESAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
078400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF ES OF WS-TEXTS.
078500   CALL 'UPDATETEXT'.
078600   GOBACK.
078700 LOADENCOBA SECTION.
078800 ENTRY 'LOADENCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
078900   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF EN OF WS-TEXTS.
079000   CALL 'UPDATETEXT'.
079100   GOBACK.
079200 LOADENCOBB SECTION.
079300 ENTRY 'LOADENCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
079400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF EN OF WS-TEXTS.
079500   CALL 'UPDATETEXT'.
079600   GOBACK.
079700 LOADESCOBA SECTION.
079800 ENTRY 'LOADESCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
079900   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF ES OF WS-TEXTS.
080000   CALL 'UPDATETEXT'.
080100   GOBACK.
080200 LOADESCOBB SECTION.
080300 ENTRY 'LOADESCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
080400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF ES OF WS-TEXTS.
080500*  DISPLAY ABOUT-ME OF ES OF WS-TEXTS.
080600   CALL 'UPDATETEXT'.
080700   GOBACK.
080800 NAVABOUT SECTION.
080900 ENTRY 'NAVABOUT'.
081000   CALL 'cobdom_scroll_into_view' USING 'aboutHeader'.
081100   GOBACK.
081200 NAVCONTACT SECTION.
081300 ENTRY 'NAVCONTACT'.
081400   CALL 'cobdom_scroll_into_view' USING 'contactHeader'.
081500   GOBACK.
081600 NAVPROJECTS SECTION.
081700 ENTRY 'NAVPROJECTS'.
081800   CALL 'cobdom_scroll_into_view' USING 'projectHeader'.
081900   GOBACK.
082000 NAVCOBOL SECTION.
082100 ENTRY 'NAVCOBOL'.
082200   CALL 'cobdom_scroll_into_view' USING 'cobolHeader'.
082300   GOBACK.
082400 OPENCOBOLSOURCE SECTION.
082500 ENTRY 'OPENCOBOLSOURCE'.
082600   CALL 'cobdom_open_tab' USING 
082700     'https://github.com/BalakeKarbon/BalakeKarbon.github.io'.
082800   GOBACK.
082900 OPENGH SECTION.
083000 ENTRY 'OPENGH'.
083100   CALL 'cobdom_open_tab' USING 
083200     'https://github.com/BalakeKarbon/'.
083300   GOBACK.
083400 OPENLI SECTION.
083500 ENTRY 'OPENLI'.
083600   CALL 'cobdom_open_tab' USING 
083700     'https://www.linkedin.com/in/blake-karbon/'.
083800   GOBACK.
083900 OPENME SECTION.
084000 ENTRY 'OPENME'.
084100   CALL 'cobdom_open_tab' USING 
084200     'https://medium.com/@karboncodes'.
084300   GOBACK.
084400 OPENYT SECTION.
084500 ENTRY 'OPENYT'.
084600   CALL 'cobdom_open_tab' USING 
084700     'https://www.youtube.com/@karboncodes'.
084800   GOBACK.
084900 OPENTT SECTION.
085000 ENTRY 'OPENTT'.
085100   CALL 'cobdom_open_tab' USING 
085200     'https://www.tiktok.com/@karboncodes'.
085300   GOBACK.
085400 OPENIG SECTION.
085500 ENTRY 'OPENIG'.
085600   CALL 'cobdom_open_tab' USING 
085700     'https://www.instagram.com/karboncodes'.
085800   GOBACK.
085900 MENUTOGGLE SECTION.
086000 ENTRY 'MENUTOGGLE'.
086100   IF WS-MENU-TOGGLE = 0 THEN
086200     MOVE 1 TO WS-MENU-TOGGLE
086300     CALL 'cobdom_style' USING 'navButton', 'transform', 
086400       'scale(0.85)'
086500     CALL 'cobdom_src' USING 'navButton', 
086600       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
086700     CALL 'cobdom_style' USING 'navAbout', 'transform', 
086800       'translate(35rem, 0rem)' 
086900     CALL 'cobdom_style' USING 'navContact', 'transform', 
087000       'translate(35rem, 0rem)' 
087100     CALL 'cobdom_style' USING 'navSkills', 'transform', 
087200       'translate(35rem, 0rem)'
087300    CALL 'cobdom_style' USING 'navProjects', 'transform', 
087400       'translate(35rem, 0rem)'
087500    CALL 'cobdom_style' USING 'navCobol', 'transform', 
087600       'translate(35rem, 0rem)'
087700   ELSE
087800     MOVE 0 TO WS-MENU-TOGGLE
087900     CALL 'cobdom_style' USING 'navButton', 'transform', 
088000       'scale(1.0)'
088100     CALL 'cobdom_src' USING 'navButton', 
088200       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
088300     CALL 'cobdom_style' USING 'navAbout', 'transform', 
088400       'translate(0rem, 0rem)' 
088500     CALL 'cobdom_style' USING 'navContact', 'transform', 
088600       'translate(0rem, 0rem)' 
088700     CALL 'cobdom_style' USING 'navSkills', 'transform', 
088800       'translate(0rem, 0rem)'
088900    CALL 'cobdom_style' USING 'navProjects', 'transform', 
089000       'translate(0rem, 0rem)'
089100    CALL 'cobdom_style' USING 'navCobol', 'transform', 
089200       'translate(0rem, 0rem)'
089300   END-IF.
089400   GOBACK.
089500*TO-DO: Add a timer in case some fonts do never load
089600 FONTLOADED SECTION.
089700 ENTRY 'FONTLOADED'.
089800   ADD 1 TO WS-FONTS-LOADED.
089900   IF WS-FONTS-LOADED = 2 THEN
090000     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
090100     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
090200     CALL 'cobdom_style' USING 'cobolSection', 'fontFamily',
090300       'ibmpc'
090400   END-IF.
090500   GOBACK.
090600 WINDOWCHANGE SECTION.
090700 ENTRY 'WINDOWCHANGE'.
090800   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
090900   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
091000     '300'.
091100*Optimize this buffer time to not have a noticeable delay but also
091200*not call to often.
091300   GOBACK.
091400 SHAPEPAGE SECTION.
091500 ENTRY 'SHAPEPAGE'.
091600*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
091700*  DISPLAY 'Rendering! ' CENTISECS.
091800   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
091900     'window.innerWidth'.
092000   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
092100   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
092200     'window.innerHeight'.
092300   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
092400   GOBACK.
092500 COOKIEACCEPT SECTION.
092600 ENTRY 'COOKIEACCEPT'.
092700   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
092800   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
092900   MOVE 'y' TO WS-COOKIE-ALLOWED.
093000   IF WS-LANG = 'us' THEN
093100     CALL 'cobdom_set_cookie' USING 'us', 'lang'
093200   ELSE
093300     CALL 'cobdom_set_cookie' USING 'en', 'lang'
093400   END-IF.
093500   GOBACK.
093600 COOKIEDENY SECTION.
093700 ENTRY 'COOKIEDENY'.
093800   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
093900   MOVE 'n' TO WS-COOKIE-ALLOWED.
094000   GOBACK.
094100 SETPERCENTCOBOL SECTION.
094200 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
094300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF EN OF WS-TEXTS.
094400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF ES OF WS-TEXTS.
094500*  CALL 'cobdom_inner_html' USING 'percentCobol',
094600*    WS-PERCENT-COBOL.
094700*  DISPLAY 'Currently this website is written in ' 
094800*    WS-PERCENT-COBOL '% COBOL.'.
094900   GOBACK.
095000 SETLANG SECTION.
095100 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
095200   if WS-LANG-SELECT-TOGGLE = 0 THEN
095300     MOVE 1 TO WS-LANG-SELECT-TOGGLE
095400     IF WS-LANG = 'us' THEN
095500       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
095600       CALL 'cobdom_style' USING 'langUS', 'transform', 
095700         'translate(0rem, 0rem)'
095800*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
095900     ELSE
096000       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
096100       CALL 'cobdom_style' USING 'langUS', 'transform', 
096200         'translate(0rem, 0rem)'
096300*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
096400     END-IF
096500   ELSE
096600     MOVE 0 TO WS-LANG-SELECT-TOGGLE
096700     IF WS-COOKIE-ALLOWED = 'y' THEN
096800       IF LS-LANG-CHOICE = 'us' THEN
096900         CALL 'cobdom_set_cookie' USING 'us', 'lang'
097000         MOVE 'us' TO WS-LANG
097100       ELSE
097200         CALL 'cobdom_set_cookie' USING 'es', 'lang'
097300         MOVE 'es' TO WS-LANG
097400       END-IF
097500       PERFORM SET-ACTIVE-FLAG
097600     ELSE
097700       MOVE LS-LANG-CHOICE TO WS-LANG
097800       PERFORM SET-ACTIVE-FLAG 
097900     END-IF
098000   END-IF.
098100   GOBACK.
098200 SETLANGUS SECTION.
098300 ENTRY 'SETLANGUS'.
098400   CALL 'SETLANG' USING 'us'.
098500   GOBACK.
098600 SETLANGES SECTION.
098700 ENTRY 'SETLANGES'.
098800   CALL 'SETLANG' USING 'es'.
098900   GOBACK.
099000*TERMINPUT SECTION.
099100*ENTRY 'TERMINPUT' USING LS-TERM-IN.
099200*  DISPLAY LS-TERM-IN.
099300*  GOBACK.
