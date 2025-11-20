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
025500*Medium
025600   CALL 'cobdom_create_element' USING 'meContainer', 'span'.
025700   CALL 'cobdom_add_event_listener' USING 'meContainer',
025800     'click', 'OPENME'.
025900   CALL 'cobdom_set_class' USING 'meContainer',
026000     'contactContainer'.
026100   CALL 'cobdom_create_element' USING 'meImage', 'img'.
026200   CALL 'cobdom_src' USING 'meImage', 
026300     '/res/icons/tabler-icons/icons/outline/brand-medium.svg'.
026400   CALL 'cobdom_style' USING 'meImage', 'width', '6rem'.
026500   CALL 'cobdom_style' USING 'meImage', 'height', '6rem'.
026600   CALL 'cobdom_create_element' USING 'meText', 'div'.
026700   CALL 'cobdom_style' USING 'meText', 'textDecoration',
026800     'underline'.
026900   CALL 'cobdom_inner_html' USING 'meText', 'Medium'.
027000   CALL 'cobdom_append_child' USING 'meImage', 'meContainer'.
027100   CALL 'cobdom_append_child' USING 'meText', 'meContainer'.
027200   CALL 'cobdom_append_child' USING 'meContainer', 'linksDiv'.
027300   CALL 'cobdom_add_event_listener' USING 'meImage',
027400     'click', 'OPENME'.
027500   CALL 'cobdom_add_event_listener' USING 'meText',
027600     'click', 'OPENME'.
027700*Youtube
027800   CALL 'cobdom_create_element' USING 'ytContainer', 'span'.
027900   CALL 'cobdom_add_event_listener' USING 'ytContainer',
028000     'click', 'OPENYT'.
028100   CALL 'cobdom_set_class' USING 'ytContainer',
028200     'contactContainer'.
028300   CALL 'cobdom_create_element' USING 'ytImage', 'img'.
028400   CALL 'cobdom_src' USING 'ytImage', 
028500     '/res/icons/tabler-icons/icons/outline/brand-youtube.svg'.
028600   CALL 'cobdom_style' USING 'ytImage', 'width', '6rem'.
028700   CALL 'cobdom_style' USING 'ytImage', 'height', '6rem'.
028800   CALL 'cobdom_create_element' USING 'ytText', 'div'.
028900   CALL 'cobdom_style' USING 'ytText', 'textDecoration',
029000     'underline'.
029100   CALL 'cobdom_inner_html' USING 'ytText', 'Youtube'.
029200   CALL 'cobdom_append_child' USING 'ytImage', 'ytContainer'.
029300   CALL 'cobdom_append_child' USING 'ytText', 'ytContainer'.
029400   CALL 'cobdom_append_child' USING 'ytContainer', 'linksDiv'.
029500   CALL 'cobdom_add_event_listener' USING 'ytImage',
029600     'click', 'OPENYT'.
029700   CALL 'cobdom_add_event_listener' USING 'ytText',
029800     'click', 'OPENYT'.
029900*TikTok
030000   CALL 'cobdom_create_element' USING 'ttContainer', 'span'.
030100   CALL 'cobdom_add_event_listener' USING 'ttContainer',
030200     'click', 'OPENTT'.
030300   CALL 'cobdom_set_class' USING 'ttContainer',
030400     'contactContainer'.
030500   CALL 'cobdom_create_element' USING 'ttImage', 'img'.
030600   CALL 'cobdom_src' USING 'ttImage', 
030700     '/res/icons/tabler-icons/icons/outline/brand-tiktok.svg'.
030800   CALL 'cobdom_style' USING 'ttImage', 'width', '6rem'.
030900   CALL 'cobdom_style' USING 'ttImage', 'height', '6rem'.
031000   CALL 'cobdom_create_element' USING 'ttText', 'div'.
031100   CALL 'cobdom_style' USING 'ttText', 'textDecoration',
031200     'underline'.
031300   CALL 'cobdom_inner_html' USING 'ttText', 'TikTok'.
031400   CALL 'cobdom_append_child' USING 'ttImage', 'ttContainer'.
031500   CALL 'cobdom_append_child' USING 'ttText', 'ttContainer'.
031600   CALL 'cobdom_append_child' USING 'ttContainer', 'linksDiv'.
031700   CALL 'cobdom_add_event_listener' USING 'ttContainer',
031800     'click', 'OPENTT'.
031900   CALL 'cobdom_add_event_listener' USING 'ttContainer',
032000     'click', 'OPENTT'.
032100*Instagram
032200   CALL 'cobdom_create_element' USING 'igContainer', 'span'.
032300   CALL 'cobdom_add_event_listener' USING 'igContainer',
032400     'click', 'OPENIG'.
032500   CALL 'cobdom_set_class' USING 'igContainer',
032600     'contactContainer'.
032700   CALL 'cobdom_create_element' USING 'igImage', 'img'.
032800   CALL 'cobdom_src' USING 'igImage', 
032900     '/res/icons/tabler-icons/icons/outline/brand-instagram.svg'.
033000   CALL 'cobdom_style' USING 'igImage', 'width', '6rem'.
033100   CALL 'cobdom_style' USING 'igImage', 'height', '6rem'.
033200   CALL 'cobdom_create_element' USING 'igText', 'div'.
033300   CALL 'cobdom_style' USING 'igText', 'textDecoration',
033400     'underline'.
033500   CALL 'cobdom_inner_html' USING 'igText', 'Instagram'.
033600   CALL 'cobdom_append_child' USING 'igImage', 'igContainer'.
033700   CALL 'cobdom_append_child' USING 'igText', 'igContainer'.
033800   CALL 'cobdom_append_child' USING 'igContainer', 'linksDiv'.
033900   CALL 'cobdom_add_event_listener' USING 'igText',
034000     'click', 'OPENIG'.
034100   CALL 'cobdom_add_event_listener' USING 'igImage',
034200     'click', 'OPENIG'.
034300 
034400   CALL 'cobdom_append_child' USING 'emailDiv', 'contactContent'.
034500   CALL 'cobdom_append_child' USING 'linksDiv', 'contactContent'.
034600*Skills section
034700*  CALL 'cobdom_create_element' USING 'skillsSection', 'div'.
034800*  CALL 'cobdom_style' USING 'skillsSection', 'width', '100%'.
034900*  CALL 'cobdom_create_element' USING 'skillsHeader', 'div'.
035000*  CALL 'cobdom_set_class' USING 'skillsHeader',
035100*    'contentHeadersClass'.
035200*  CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills:'.
035300*  CALL 'cobdom_create_element' USING 'skillsContent', 'div'.
035400*
035500*  CALL 'cobdom_append_child' USING 'skillsSection',
035600*    'contentDiv'.
035700*  CALL 'cobdom_append_child' USING 'skillsHeader',
035800*    'skillsSection'.
035900*  CALL 'cobdom_append_child' USING 'skillsContent',
036000*    'skillsSection'.
036100*Project section
036200   CALL 'cobdom_create_element' USING 'projectSection', 'div'.
036300   CALL 'cobdom_style' USING 'projectSection', 'width', '100%'.
036400*  CALL 'cobdom_style' USING 'projectSection', 'margin', '2rem'.
036500   CALL 'cobdom_create_element' USING 'projectHeader', 'div'.
036600   CALL 'cobdom_set_class' USING 'projectHeader',
036700     'contentHeadersClass'.
036800   CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects:'.
036900   CALL 'cobdom_create_element' USING 'projectContent', 'div'.
037000   CALL 'cobdom_style' USING 'projectContent', 'textAlign',
037100     'center'.
037200   CALL 'cobdom_inner_html' USING 'projectContent', 'WIP'.
037300   CALL 'cobdom_append_child' USING 'projectSection', 
037400     'contentDiv'.
037500   CALL 'cobdom_append_child' USING 'projectHeader', 
037600     'projectSection'.
037700   CALL 'cobdom_append_child' USING 'projectContent', 
037800     'projectSection'.
037900   PERFORM ADD-PROJECTS.
038000*Cobol section
038100   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
038200   CALL 'cobdom_style' USING 'cobolSection', 'width', '100%'.
038300*  CALL 'cobdom_style' USING 'cobolSection', 'margin', '2rem'.
038400   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
038500   CALL 'cobdom_set_class' USING 'cobolHeader',
038600     'contentHeadersClass'.
038700   CALL 'cobdom_inner_html' USING 'cobolHeader', 'COBOL'.
038800   CALL 'cobdom_create_element' USING 'cobolContent', 'span'.
038900   CALL 'cobdom_append_child' USING 'cobolSection',
039000     'contentDiv'.
039100   CALL 'cobdom_append_child' USING 'cobolHeader', 
039200     'cobolSection'.
039300   CALL 'cobdom_append_child' USING 'cobolContent', 
039400     'cobolSection'.
039500   CALL 'cobdom_create_element' USING 'cobolGithubLink',
039600     'span'.
039700   CALL 'cobdom_add_event_listener' USING 'cobolGithubLink',
039800     'click', 'OPENCOBOLSOURCE'.
039900   CALL 'cobdom_inner_html' USING 'cobolGithubLink',
040000     'GitHub!'.
040100   CALL 'cobdom_style' USING 'cobolGithubLink', 'textDecoration',
040200     'underline'.
040300   CALL 'cobdom_append_child' USING 'cobolGithubLink',
040400     'cobolSection'.
040500*Set contentHeadersClass class styles. Must be called after elements
040600*exist as this uses getElementsByClassName. A safer option would
040700*be to make a new style element but for the sake of demnostrating
040800*this part of the library I will use this here.
040900   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
041000     'fontSize', '2.5rem'.
041100   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
041200     'width', '100%'.
041300   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
041400     'textAlign', 'center'.
041500   CALL 'cobdom_class_style' USING 'contentHeadersClass',
041600     'fontWeight', 'bold'.
041700   CALL 'cobdom_class_style' USING 'contactContainer', 'margin',
041800     '1rem'.
041900  CALL 'cobdom_class_style' USING 'contactContainer', 'display',
042000     'flex'. 
042100   CALL 'cobdom_class_style' USING 'contactContainer',
042200     'flexDirection', 'column'.
042300   CALL 'cobdom_class_style' USING 'contactContainer',
042400     'alignItems', 'center'.
042500   CONTINUE.
042600 BUILD-MENUBAR.
042700   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
042800   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
042900   CALL 'cobdom_style' USING 'headerDiv', 'pointerEvents', 'none'.
043000   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
043100   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
043200     'space-between'.
043300   CALL 'cobdom_style' USING 'headerDiv', 'flexDirection',
043400     'column'.
043500   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
043600   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
043700   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
043800*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
043900*    'blur(.3rem)'.
044000*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
044100*    'blur(5px)'.
044200*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
044300*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
044400*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
044500*    '1rem'.
044600*  CALL 'cobdom_style' USING 'headerDiv',
044700*    'borderBottomRightRadius','1rem'.
044800   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
044900   CALL 'cobdom_create_element' USING 'topArea', 'div'.
045000   CALL 'cobdom_style' USING 'topArea', 'display', 'flex'.
045100   CALL 'cobdom_style' USING 'topArea', 'pointerEvents', 'all'.
045200   CALL 'cobdom_style' USING 'topArea', 'backgroundColor',
045300     '#c9c9c9'.
045400   CALL 'cobdom_append_child' USING 'topArea', 'headerDiv'.
045500*Setup menu
045600   CALL 'cobdom_create_element' USING 'navArea', 'div'.
045700*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
045800   CALL 'cobdom_create_element' USING 'navButton', 'img'.
045900   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
046000   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
046100   CALL 'cobdom_src' USING 'navButton', 
046200     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
046300   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
046400     '#898989'.
046500*  CALL 'cobdom_style' USING 'navButton', 'filter', 
046600*    'invert(100%)'.
046700   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
046800   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
046900   CALL 'cobdom_style' USING 'navButton', 'padding', '.35rem'.
047000   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
047100   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
047200   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
047300   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
047400*Setup menu selectors
047500   CALL 'cobdom_create_element' USING 'selectorDiv', 'div'.
047600   CALL 'cobdom_style' USING 'selectorDiv', 'pointerEvents'
047700     'none'.
047800*About Me
047900   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
048000   CALL 'cobdom_style' USING 'navAbout', 'fontSize', '4rem'.
048100   CALL 'cobdom_style' USING 'navAbout', 'pointerEvents', 'all'.
048200   CALL 'cobdom_style' USING 'navAbout', 'width', 
048300     'max-content'.
048400   CALL 'cobdom_add_event_listener' USING 'navAbout',
048500     'click', 'NAVABOUT'.
048600   CALL 'cobdom_style' USING 'navAbout', 'position', 'relative'.
048700   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
048800     '#c9c9c9'.
048900*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
049000*    'blur(.3rem)'.
049100*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
049200*    'blur(5px)'.
049300   CALL 'cobdom_style' USING 'navAbout', 
049400     'borderBottomRightRadius', '0.5rem'.
049500   CALL 'cobdom_style' USING 'navAbout', 
049600     'borderTopRightRadius', '0.5rem'.
049700   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
049800   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
049900*  CALL 'cobdom_style' USING 'navAbout', 'top', '9.46rem'.
050000   CALL 'cobdom_style' USING 'navAbout', 'left', '-35rem'.
050100   CALL 'cobdom_style' USING 'navAbout', 'transition', 
050200     'transform 0.5s ease 0.1s'.
050300   CALL 'cobdom_append_child' USING 'navAbout', 'selectorDiv'.
050400*Contact Me
050500   CALL 'cobdom_create_element' USING 'navContact', 'div'.
050600   CALL 'cobdom_style' USING 'navContact', 'fontSize', '4rem'.
050700   CALL 'cobdom_style' USING 'navContact', 'pointerEvents', 'all'.
050800   CALL 'cobdom_style' USING 'navContact', 'width', 
050900     'max-content'.
051000   CALL 'cobdom_add_event_listener' USING 'navContact',
051100     'click', 'NAVCONTACT'.
051200   CALL 'cobdom_style' USING 'navContact', 'position', 'relative'.
051300   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
051400     '#c9c9c9'.
051500*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
051600*    'blur(.3rem)'.
051700*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
051800*    'blur(5px)'.
051900   CALL 'cobdom_style' USING 'navContact', 
052000     'borderBottomRightRadius', '0.5rem'.
052100   CALL 'cobdom_style' USING 'navContact', 
052200     'borderTopRightRadius', '0.5rem'.
052300   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
052400   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
052500*  CALL 'cobdom_style' USING 'navContact', 'top', '14.86rem'.
052600   CALL 'cobdom_style' USING 'navContact', 'left', '-35rem'.
052700   CALL 'cobdom_style' USING 'navContact', 'transition', 
052800     'transform 0.5s ease 0.2s'.
052900   CALL 'cobdom_append_child' USING 'navContact', 'selectorDiv'.
053000*Skills
053100*  CALL 'cobdom_create_element' USING 'navSkills', 'div'.
053200*  CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
053300*  CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
053400*    '#c9c9c9'.
053500*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
053600*    'blur(5px)'.
053700*  CALL 'cobdom_style' USING 'navSkills', 
053800*    'borderBottomRightRadius', '0.5rem'.
053900*  CALL 'cobdom_style' USING 'navSkills', 
054000*    'borderTopRightRadius', '0.5rem'.
054100*  CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
054200*  CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
054300*  CALL 'cobdom_style' USING 'navSkills', 'top', '13rem'.
054400*  CALL 'cobdom_style' USING 'navSkills', 'left', '-35rem'.
054500*  CALL 'cobdom_style' USING 'navSkills', 'transition', 
054600*    'transform 0.5s ease 0.3s'.
054700*  CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
054800*Projects
054900   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
055000   CALL 'cobdom_style' USING 'navProjects', 'fontSize', '4rem'.
055100   CALL 'cobdom_style' USING 'navProjects', 'pointerEvents', 
055200     'all'.
055300   CALL 'cobdom_style' USING 'navProjects', 'width', 
055400     'max-content'.
055500   CALL 'cobdom_add_event_listener' USING 'navProjects',
055600     'click', 'NAVPROJECTS'.
055700   CALL 'cobdom_style' USING 'navProjects', 'position', 
055800     'relative'.
055900   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
056000     '#c9c9c9'.
056100*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
056200*    'blur(.3rem)'.
056300*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
056400*    'blur(5px)'.
056500   CALL 'cobdom_style' USING 'navProjects', 
056600     'borderBottomRightRadius', '0.5rem'.
056700   CALL 'cobdom_style' USING 'navProjects', 
056800     'borderTopRightRadius', '0.5rem'.
056900   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
057000   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
057100*  CALL 'cobdom_style' USING 'navProjects', 'top', '20.27rem'.
057200   CALL 'cobdom_style' USING 'navProjects', 'left', '-35rem'.
057300   CALL 'cobdom_style' USING 'navProjects', 'transition', 
057400     'transform 0.5s ease 0.4s'.
057500   CALL 'cobdom_append_child' USING 'navProjects', 'selectorDiv'.
057600*Cobol?
057700   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
057800   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
057900   CALL 'cobdom_style' USING 'navCobol', 'fontSize', '4rem'.
058000   CALL 'cobdom_style' USING 'navCobol', 'pointerEvents', 'all'.
058100   CALL 'cobdom_style' USING 'navCobol', 'width',
058200     'max-content'.
058300   CALL 'cobdom_add_event_listener' USING 'navCobol',
058400     'click', 'NAVCOBOL'.
058500   CALL 'cobdom_style' USING 'navCobol', 'position', 
058600     'relative'.
058700   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
058800     '#000000'.
058900*    '#c9c9c9'.
059000*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
059100*    'blur(5px)'.
059200   CALL 'cobdom_style' USING 'navCobol', 'color', 
059300     '#00FF00'.
059400   CALL 'cobdom_style' USING 'navCobol', 
059500     'borderBottomRightRadius', '0.5rem'.
059600   CALL 'cobdom_style' USING 'navCobol', 
059700     'borderTopRightRadius', '0.5rem'.
059800   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
059900   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
060000   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
060100   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
060200   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
060300   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
060400   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
060500   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
060600*  CALL 'cobdom_style' USING 'navCobol', 'top', '25.7rem'.
060700   CALL 'cobdom_style' USING 'navCobol', 'left', '-35rem'.
060800   CALL 'cobdom_style' USING 'navCobol', 'transition', 
060900     'transform 0.5s ease 0.5s'.
061000   CALL 'cobdom_append_child' USING 'navCobol', 'selectorDiv'.
061100*Add main menu button
061200   CALL 'cobdom_append_child' USING 'navArea', 'topArea'.
061300   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
061400     'MENUTOGGLE'.
061500*Setup ID area
061600   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
061700   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
061800   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
061900   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
062000   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '5rem'.
062100   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
062200   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
062300   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
062400*  CALL 'cobdom_inner_html' USING 'taglineDiv', 
062500*    'A guy that knows a guy.'.
062600   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
062700*Setup lang area
062800   CALL 'cobdom_create_element' USING 'langArea', 'span'.
062900   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
063000*Setup language selector
063100   CALL 'cobdom_create_element' USING 'langUS', 'img'.
063200   CALL 'cobdom_create_element' USING 'langES', 'img'.
063300   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
063400   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
063500   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
063600   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
063700   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
063800   CALL 'cobdom_style' USING 'langUS', 'transition', 
063900     'opacity 0.5s ease, transform 0.5s ease'.
064000*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
064100*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
064200   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
064300   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
064400   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
064500   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
064600   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
064700   CALL 'cobdom_style' USING 'langES', 'transition', 
064800     'opacity 0.5s ease, transform 0.5s ease'.
064900*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
065000*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
065100   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
065200   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
065300     'SETLANGUS'.
065400   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
065500   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
065600     'SETLANGES'.
065700   CALL 'cobdom_append_child' USING 'selectorDiv', 'headerDiv'.
065800   CALL 'cobdom_append_child' USING 'idDiv', 'topArea'.
065900   CALL 'cobdom_append_child' USING 'langArea', 'topArea'.
066000   CONTINUE.
066100 SET-ACTIVE-FLAG.
066200   IF WS-LANG = 'us' THEN
066300     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
066400     CALL 'cobdom_style' USING 'langUS', 'transform', 
066500       'translate(9rem, 0rem)'
066600     CALL 'UPDATETEXT'
066700   ELSE
066800     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
066900     CALL 'cobdom_style' USING 'langUS', 'transform', 
067000       'translate(9rem, 0rem)'
067100     CALL 'UPDATETEXT'
067200   END-IF.
067300   CONTINUE.
067400 LOAD-TEXTS.
067500   CALL 'cobdom_fetch' USING 'LOADENAM',
067600     '/res/text/en/aboutme.txt', 'GET', WS-NULL-BYTE.
067700   CALL 'cobdom_fetch' USING 'LOADESAM',
067800     '/res/text/es/aboutme.txt', 'GET', WS-NULL-BYTE.
067900   CALL 'cobdom_fetch' USING 'LOADENCOBA',
068000     '/res/text/en/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
068100   CALL 'cobdom_fetch' USING 'LOADENCOBB',
068200     '/res/text/en/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
068300   CALL 'cobdom_fetch' USING 'LOADESCOBA',
068400     '/res/text/es/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
068500   CALL 'cobdom_fetch' USING 'LOADESCOBB',
068600     '/res/text/es/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
068700   CONTINUE.
068800 LANG-CHECK.
068900   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
069000     'lang'.
069100   IF WS-LANG = WS-NULL-BYTE THEN
069200     CALL 'cobdom_set_cookie' USING 'us', 'lang'
069300     MOVE 'us' TO WS-LANG
069400   END-IF.
069500   PERFORM SET-ACTIVE-FLAG.
069600   CONTINUE.
069700 COOKIE-ASK.
069800   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
069900   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
070000   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
070100   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
070200   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
070300   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
070400     'rgba(37,186,181,.9)'.
070500   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
070600     'center'.
070700   CALL 'cobdom_style' USING 'cookieDiv', 'fontSize', 
070800     '4rem'.
070900   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
071000-'llow cookies to store your preferences such as language?&nbsp;'.
071100   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
071200   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
071300   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
071400   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
071500   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
071600   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
071700   CALL 'cobdom_style' USING 'cookieYes', 'backgroundColor', 
071800     '#86e059'.
071900   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
072000   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
072100   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
072200   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
072300   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
072400   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
072500   CALL 'cobdom_style' USING 'cookieNo', 'backgroundColor', 
072600     '#e05e59'.
072700   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
072800     'COOKIEACCEPT'.
072900   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
073000     'COOKIEDENY'.
073100   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
073200   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
073300   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
073400   CONTINUE.
073500 ADD-PROJECTS.
073600*Computer Design
073700   CALL 'cobdom_create_element' USING 'dtlImg', 'img'.
073800   CALL 'cobdom_src' USING 'dtlImg',
073900     'res/img/dlatch-characteristics.svg'.
074000*   CALL 'cobdom_style' USING 'dtImg',''.
074100   CALL 'cobdom_append_child' USING 'dtlImg', 'projectContent'.
074200   CONTINUE.
074300 UPDATETEXT SECTION.
074400 ENTRY 'UPDATETEXT'.
074500   IF WS-LANG = 'us' THEN
074600     CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me'
074700     CALL 'cobdom_inner_html' USING 'contactHeader',
074800       'Contact Information / Links'
074900*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills'
075000     CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects'
075100     CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'
075200     CALL 'cobdom_inner_html' USING 'navContact', 'Contact/Links'
075300*    CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'
075400     CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'
075500     CALL 'cobdom_inner_html' USING 'aboutContent',
075600       TAB OF EN OF WS-TEXTS
075700     CALL 'cobdom_inner_html' USING 'cobolContent',
075800       TAB-COB OF EN OF WS-TEXTS
075900   ELSE
076000     CALL 'cobdom_inner_html' USING 'aboutHeader', 'Sobre Mi'
076100     CALL 'cobdom_inner_html' USING 'contactHeader',
076200       'Informacion de Contacto / Enlaces'
076300*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Habilidades'
076400     CALL 'cobdom_inner_html' USING 'projectHeader', 'Proyectos'
076500     CALL 'cobdom_inner_html' USING 'navAbout', 'Sobre Mi'
076600     CALL 'cobdom_inner_html' USING 'navContact',
076700       'Contacto/Enlaces'
076800*    CALL 'cobdom_inner_html' USING 'navSkills', 'Habilidades'
076900     CALL 'cobdom_inner_html' USING 'navProjects', 'Proyectos'
077000     CALL 'cobdom_inner_html' USING 'aboutContent',
077100       TAB OF ES OF WS-TEXTS
077200     CALL 'cobdom_inner_html' USING 'cobolContent',
077300       TAB-COB OF ES OF WS-TEXTS
077400   END-IF.
077500   GOBACK.
077600 LOADENAM SECTION.
077700 ENTRY 'LOADENAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
077800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF EN OF WS-TEXTS.
077900   CALL 'UPDATETEXT'.
078000   GOBACK.
078100 LOADESAM SECTION.
078200 ENTRY 'LOADESAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
078300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF ES OF WS-TEXTS.
078400   CALL 'UPDATETEXT'.
078500   GOBACK.
078600 LOADENCOBA SECTION.
078700 ENTRY 'LOADENCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
078800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF EN OF WS-TEXTS.
078900   CALL 'UPDATETEXT'.
079000   GOBACK.
079100 LOADENCOBB SECTION.
079200 ENTRY 'LOADENCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
079300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF EN OF WS-TEXTS.
079400   CALL 'UPDATETEXT'.
079500   GOBACK.
079600 LOADESCOBA SECTION.
079700 ENTRY 'LOADESCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
079800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF ES OF WS-TEXTS.
079900   CALL 'UPDATETEXT'.
080000   GOBACK.
080100 LOADESCOBB SECTION.
080200 ENTRY 'LOADESCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
080300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF ES OF WS-TEXTS.
080400*  DISPLAY ABOUT-ME OF ES OF WS-TEXTS.
080500   CALL 'UPDATETEXT'.
080600   GOBACK.
080700 NAVABOUT SECTION.
080800 ENTRY 'NAVABOUT'.
080900   CALL 'cobdom_scroll_into_view' USING 'aboutHeader'.
081000   GOBACK.
081100 NAVCONTACT SECTION.
081200 ENTRY 'NAVCONTACT'.
081300   CALL 'cobdom_scroll_into_view' USING 'contactHeader'.
081400   GOBACK.
081500 NAVPROJECTS SECTION.
081600 ENTRY 'NAVPROJECTS'.
081700   CALL 'cobdom_scroll_into_view' USING 'projectHeader'.
081800   GOBACK.
081900 NAVCOBOL SECTION.
082000 ENTRY 'NAVCOBOL'.
082100   CALL 'cobdom_scroll_into_view' USING 'cobolHeader'.
082200   GOBACK.
082300 OPENCOBOLSOURCE SECTION.
082400 ENTRY 'OPENCOBOLSOURCE'.
082500   CALL 'cobdom_open_tab' USING 
082600     'https://github.com/BalakeKarbon/BalakeKarbon.github.io'.
082700   GOBACK.
082800 OPENGH SECTION.
082900 ENTRY 'OPENGH'.
083000   CALL 'cobdom_open_tab' USING 
083100     'https://github.com/BalakeKarbon/'.
083200   GOBACK.
083300 OPENLI SECTION.
083400 ENTRY 'OPENLI'.
083500   CALL 'cobdom_open_tab' USING 
083600     'https://www.linkedin.com/in/blake-karbon/'.
083700   GOBACK.
083800 OPENME SECTION.
083900 ENTRY 'OPENME'.
084000   CALL 'cobdom_open_tab' USING 
084100     'https://medium.com/@karboncodes'.
084200   GOBACK.
084300 OPENYT SECTION.
084400 ENTRY 'OPENYT'.
084500   CALL 'cobdom_open_tab' USING 
084600     'https://www.youtube.com/@karboncodes'.
084700   GOBACK.
084800 OPENTT SECTION.
084900 ENTRY 'OPENTT'.
085000   CALL 'cobdom_open_tab' USING 
085100     'https://www.tiktok.com/@karboncodes'.
085200   GOBACK.
085300 OPENIG SECTION.
085400 ENTRY 'OPENIG'.
085500   CALL 'cobdom_open_tab' USING 
085600     'https://www.instagram.com/karboncodes'.
085700   GOBACK.
085800 MENUTOGGLE SECTION.
085900 ENTRY 'MENUTOGGLE'.
086000   IF WS-MENU-TOGGLE = 0 THEN
086100     MOVE 1 TO WS-MENU-TOGGLE
086200     CALL 'cobdom_style' USING 'navButton', 'transform', 
086300       'scale(0.85)'
086400     CALL 'cobdom_src' USING 'navButton', 
086500       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
086600     CALL 'cobdom_style' USING 'navAbout', 'transform', 
086700       'translate(35rem, 0rem)' 
086800     CALL 'cobdom_style' USING 'navContact', 'transform', 
086900       'translate(35rem, 0rem)' 
087000     CALL 'cobdom_style' USING 'navSkills', 'transform', 
087100       'translate(35rem, 0rem)'
087200    CALL 'cobdom_style' USING 'navProjects', 'transform', 
087300       'translate(35rem, 0rem)'
087400    CALL 'cobdom_style' USING 'navCobol', 'transform', 
087500       'translate(35rem, 0rem)'
087600   ELSE
087700     MOVE 0 TO WS-MENU-TOGGLE
087800     CALL 'cobdom_style' USING 'navButton', 'transform', 
087900       'scale(1.0)'
088000     CALL 'cobdom_src' USING 'navButton', 
088100       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
088200     CALL 'cobdom_style' USING 'navAbout', 'transform', 
088300       'translate(0rem, 0rem)' 
088400     CALL 'cobdom_style' USING 'navContact', 'transform', 
088500       'translate(0rem, 0rem)' 
088600     CALL 'cobdom_style' USING 'navSkills', 'transform', 
088700       'translate(0rem, 0rem)'
088800    CALL 'cobdom_style' USING 'navProjects', 'transform', 
088900       'translate(0rem, 0rem)'
089000    CALL 'cobdom_style' USING 'navCobol', 'transform', 
089100       'translate(0rem, 0rem)'
089200   END-IF.
089300   GOBACK.
089400*TO-DO: Add a timer in case some fonts do never load
089500 FONTLOADED SECTION.
089600 ENTRY 'FONTLOADED'.
089700   ADD 1 TO WS-FONTS-LOADED.
089800   IF WS-FONTS-LOADED = 2 THEN
089900     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
090000     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
090100     CALL 'cobdom_style' USING 'cobolSection', 'fontFamily',
090200       'ibmpc'
090300   END-IF.
090400   GOBACK.
090500 WINDOWCHANGE SECTION.
090600 ENTRY 'WINDOWCHANGE'.
090700   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
090800   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
090900     '300'.
091000*Optimize this buffer time to not have a noticeable delay but also
091100*not call to often.
091200   GOBACK.
091300 SHAPEPAGE SECTION.
091400 ENTRY 'SHAPEPAGE'.
091500*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
091600*  DISPLAY 'Rendering! ' CENTISECS.
091700   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
091800     'window.innerWidth'.
091900   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
092000   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
092100     'window.innerHeight'.
092200   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
092300   GOBACK.
092400 COOKIEACCEPT SECTION.
092500 ENTRY 'COOKIEACCEPT'.
092600   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
092700   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
092800   MOVE 'y' TO WS-COOKIE-ALLOWED.
092900   IF WS-LANG = 'us' THEN
093000     CALL 'cobdom_set_cookie' USING 'us', 'lang'
093100   ELSE
093200     CALL 'cobdom_set_cookie' USING 'en', 'lang'
093300   END-IF.
093400   GOBACK.
093500 COOKIEDENY SECTION.
093600 ENTRY 'COOKIEDENY'.
093700   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
093800   MOVE 'n' TO WS-COOKIE-ALLOWED.
093900   GOBACK.
094000 SETPERCENTCOBOL SECTION.
094100 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
094200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF EN OF WS-TEXTS.
094300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF ES OF WS-TEXTS.
094400*  CALL 'cobdom_inner_html' USING 'percentCobol',
094500*    WS-PERCENT-COBOL.
094600*  DISPLAY 'Currently this website is written in ' 
094700*    WS-PERCENT-COBOL '% COBOL.'.
094800   GOBACK.
094900 SETLANG SECTION.
095000 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
095100   if WS-LANG-SELECT-TOGGLE = 0 THEN
095200     MOVE 1 TO WS-LANG-SELECT-TOGGLE
095300     IF WS-LANG = 'us' THEN
095400       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
095500       CALL 'cobdom_style' USING 'langUS', 'transform', 
095600         'translate(0rem, 0rem)'
095700*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
095800     ELSE
095900       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
096000       CALL 'cobdom_style' USING 'langUS', 'transform', 
096100         'translate(0rem, 0rem)'
096200*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
096300     END-IF
096400   ELSE
096500     MOVE 0 TO WS-LANG-SELECT-TOGGLE
096600     IF WS-COOKIE-ALLOWED = 'y' THEN
096700       IF LS-LANG-CHOICE = 'us' THEN
096800         CALL 'cobdom_set_cookie' USING 'us', 'lang'
096900         MOVE 'us' TO WS-LANG
097000       ELSE
097100         CALL 'cobdom_set_cookie' USING 'es', 'lang'
097200         MOVE 'es' TO WS-LANG
097300       END-IF
097400       PERFORM SET-ACTIVE-FLAG
097500     ELSE
097600       MOVE LS-LANG-CHOICE TO WS-LANG
097700       PERFORM SET-ACTIVE-FLAG 
097800     END-IF
097900   END-IF.
098000   GOBACK.
098100 SETLANGUS SECTION.
098200 ENTRY 'SETLANGUS'.
098300   CALL 'SETLANG' USING 'us'.
098400   GOBACK.
098500 SETLANGES SECTION.
098600 ENTRY 'SETLANGES'.
098700   CALL 'SETLANG' USING 'es'.
098800   GOBACK.
098900*TERMINPUT SECTION.
099000*ENTRY 'TERMINPUT' USING LS-TERM-IN.
099100*  DISPLAY LS-TERM-IN.
099200*  GOBACK.
