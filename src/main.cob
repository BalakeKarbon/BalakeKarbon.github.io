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
037900*Cobol section
038000   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
038100   CALL 'cobdom_style' USING 'cobolSection', 'width', '100%'.
038200*  CALL 'cobdom_style' USING 'cobolSection', 'margin', '2rem'.
038300   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
038400   CALL 'cobdom_set_class' USING 'cobolHeader',
038500     'contentHeadersClass'.
038600   CALL 'cobdom_inner_html' USING 'cobolHeader', 'COBOL'.
038700   CALL 'cobdom_create_element' USING 'cobolContent', 'span'.
038800   CALL 'cobdom_append_child' USING 'cobolSection',
038900     'contentDiv'.
039000   CALL 'cobdom_append_child' USING 'cobolHeader', 
039100     'cobolSection'.
039200   CALL 'cobdom_append_child' USING 'cobolContent', 
039300     'cobolSection'.
039400   CALL 'cobdom_create_element' USING 'cobolGithubLink',
039500     'span'.
039600   CALL 'cobdom_add_event_listener' USING 'cobolGithubLink',
039700     'click', 'OPENCOBOLSOURCE'.
039800   CALL 'cobdom_inner_html' USING 'cobolGithubLink',
039900     'GitHub!'.
040000   CALL 'cobdom_style' USING 'cobolGithubLink', 'textDecoration',
040100     'underline'.
040200   CALL 'cobdom_append_child' USING 'cobolGithubLink',
040300     'cobolSection'.
040400*Set contentHeadersClass class styles. Must be called after elements
040500*exist as this uses getElementsByClassName. A safer option would
040600*be to make a new style element but for the sake of demnostrating
040700*this part of the library I will use this here.
040800   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
040900     'fontSize', '2.5rem'.
041000   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
041100     'width', '100%'.
041200   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
041300     'textAlign', 'center'.
041400   CALL 'cobdom_class_style' USING 'contentHeadersClass',
041500     'fontWeight', 'bold'.
041600   CALL 'cobdom_class_style' USING 'contactContainer', 'margin',
041700     '1rem'.
041800  CALL 'cobdom_class_style' USING 'contactContainer', 'display',
041900     'flex'. 
042000   CALL 'cobdom_class_style' USING 'contactContainer',
042100     'flexDirection', 'column'.
042200   CALL 'cobdom_class_style' USING 'contactContainer',
042300     'alignItems', 'center'.
042400   CONTINUE.
042500 BUILD-MENUBAR.
042600   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
042700   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
042800   CALL 'cobdom_style' USING 'headerDiv', 'pointerEvents', 'none'.
042900   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
043000   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
043100     'space-between'.
043200   CALL 'cobdom_style' USING 'headerDiv', 'flexDirection',
043300     'column'.
043400   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
043500   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
043600   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
043700*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
043800*    'blur(.3rem)'.
043900*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
044000*    'blur(5px)'.
044100*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
044200*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
044300*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
044400*    '1rem'.
044500*  CALL 'cobdom_style' USING 'headerDiv',
044600*    'borderBottomRightRadius','1rem'.
044700   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
044800   CALL 'cobdom_create_element' USING 'topArea', 'div'.
044900   CALL 'cobdom_style' USING 'topArea', 'display', 'flex'.
045000   CALL 'cobdom_style' USING 'topArea', 'pointerEvents', 'all'.
045100   CALL 'cobdom_style' USING 'topArea', 'backgroundColor',
045200     '#c9c9c9'.
045300   CALL 'cobdom_append_child' USING 'topArea', 'headerDiv'.
045400*Setup menu
045500   CALL 'cobdom_create_element' USING 'navArea', 'div'.
045600*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
045700   CALL 'cobdom_create_element' USING 'navButton', 'img'.
045800   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
045900   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
046000   CALL 'cobdom_src' USING 'navButton', 
046100     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
046200   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
046300     '#898989'.
046400*  CALL 'cobdom_style' USING 'navButton', 'filter', 
046500*    'invert(100%)'.
046600   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
046700   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
046800   CALL 'cobdom_style' USING 'navButton', 'padding', '.35rem'.
046900   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
047000   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
047100   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
047200   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
047300*Setup menu selectors
047400   CALL 'cobdom_create_element' USING 'selectorDiv', 'div'.
047500   CALL 'cobdom_style' USING 'selectorDiv', 'pointerEvents'
047600     'none'.
047700*About Me
047800   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
047900   CALL 'cobdom_style' USING 'navAbout', 'fontSize', '4rem'.
048000   CALL 'cobdom_style' USING 'navAbout', 'pointerEvents', 'all'.
048100   CALL 'cobdom_style' USING 'navAbout', 'width', 
048200     'max-content'.
048300   CALL 'cobdom_add_event_listener' USING 'navAbout',
048400     'click', 'NAVABOUT'.
048500   CALL 'cobdom_style' USING 'navAbout', 'position', 'relative'.
048600   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
048700     '#c9c9c9'.
048800*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
048900*    'blur(.3rem)'.
049000*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
049100*    'blur(5px)'.
049200   CALL 'cobdom_style' USING 'navAbout', 
049300     'borderBottomRightRadius', '0.5rem'.
049400   CALL 'cobdom_style' USING 'navAbout', 
049500     'borderTopRightRadius', '0.5rem'.
049600   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
049700   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
049800*  CALL 'cobdom_style' USING 'navAbout', 'top', '9.46rem'.
049900   CALL 'cobdom_style' USING 'navAbout', 'left', '-35rem'.
050000   CALL 'cobdom_style' USING 'navAbout', 'transition', 
050100     'transform 0.5s ease 0.1s'.
050200   CALL 'cobdom_append_child' USING 'navAbout', 'selectorDiv'.
050300*Contact Me
050400   CALL 'cobdom_create_element' USING 'navContact', 'div'.
050500   CALL 'cobdom_style' USING 'navContact', 'fontSize', '4rem'.
050600   CALL 'cobdom_style' USING 'navContact', 'pointerEvents', 'all'.
050700   CALL 'cobdom_style' USING 'navContact', 'width', 
050800     'max-content'.
050900   CALL 'cobdom_add_event_listener' USING 'navContact',
051000     'click', 'NAVCONTACT'.
051100   CALL 'cobdom_style' USING 'navContact', 'position', 'relative'.
051200   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
051300     '#c9c9c9'.
051400*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
051500*    'blur(.3rem)'.
051600*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
051700*    'blur(5px)'.
051800   CALL 'cobdom_style' USING 'navContact', 
051900     'borderBottomRightRadius', '0.5rem'.
052000   CALL 'cobdom_style' USING 'navContact', 
052100     'borderTopRightRadius', '0.5rem'.
052200   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
052300   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
052400*  CALL 'cobdom_style' USING 'navContact', 'top', '14.86rem'.
052500   CALL 'cobdom_style' USING 'navContact', 'left', '-35rem'.
052600   CALL 'cobdom_style' USING 'navContact', 'transition', 
052700     'transform 0.5s ease 0.2s'.
052800   CALL 'cobdom_append_child' USING 'navContact', 'selectorDiv'.
052900*Skills
053000*  CALL 'cobdom_create_element' USING 'navSkills', 'div'.
053100*  CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
053200*  CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
053300*    '#c9c9c9'.
053400*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
053500*    'blur(5px)'.
053600*  CALL 'cobdom_style' USING 'navSkills', 
053700*    'borderBottomRightRadius', '0.5rem'.
053800*  CALL 'cobdom_style' USING 'navSkills', 
053900*    'borderTopRightRadius', '0.5rem'.
054000*  CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
054100*  CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
054200*  CALL 'cobdom_style' USING 'navSkills', 'top', '13rem'.
054300*  CALL 'cobdom_style' USING 'navSkills', 'left', '-35rem'.
054400*  CALL 'cobdom_style' USING 'navSkills', 'transition', 
054500*    'transform 0.5s ease 0.3s'.
054600*  CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
054700*Projects
054800   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
054900   CALL 'cobdom_style' USING 'navProjects', 'fontSize', '4rem'.
055000   CALL 'cobdom_style' USING 'navProjects', 'pointerEvents', 
055100     'all'.
055200   CALL 'cobdom_style' USING 'navProjects', 'width', 
055300     'max-content'.
055400   CALL 'cobdom_add_event_listener' USING 'navProjects',
055500     'click', 'NAVPROJECTS'.
055600   CALL 'cobdom_style' USING 'navProjects', 'position', 
055700     'relative'.
055800   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
055900     '#c9c9c9'.
056000*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
056100*    'blur(.3rem)'.
056200*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
056300*    'blur(5px)'.
056400   CALL 'cobdom_style' USING 'navProjects', 
056500     'borderBottomRightRadius', '0.5rem'.
056600   CALL 'cobdom_style' USING 'navProjects', 
056700     'borderTopRightRadius', '0.5rem'.
056800   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
056900   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
057000*  CALL 'cobdom_style' USING 'navProjects', 'top', '20.27rem'.
057100   CALL 'cobdom_style' USING 'navProjects', 'left', '-35rem'.
057200   CALL 'cobdom_style' USING 'navProjects', 'transition', 
057300     'transform 0.5s ease 0.4s'.
057400   CALL 'cobdom_append_child' USING 'navProjects', 'selectorDiv'.
057500*Cobol?
057600   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
057700   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
057800   CALL 'cobdom_style' USING 'navCobol', 'fontSize', '4rem'.
057900   CALL 'cobdom_style' USING 'navCobol', 'pointerEvents', 'all'.
058000   CALL 'cobdom_style' USING 'navCobol', 'width',
058100     'max-content'.
058200   CALL 'cobdom_add_event_listener' USING 'navCobol',
058300     'click', 'NAVCOBOL'.
058400   CALL 'cobdom_style' USING 'navCobol', 'position', 
058500     'relative'.
058600   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
058700     '#000000'.
058800*    '#c9c9c9'.
058900*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
059000*    'blur(5px)'.
059100   CALL 'cobdom_style' USING 'navCobol', 'color', 
059200     '#00FF00'.
059300   CALL 'cobdom_style' USING 'navCobol', 
059400     'borderBottomRightRadius', '0.5rem'.
059500   CALL 'cobdom_style' USING 'navCobol', 
059600     'borderTopRightRadius', '0.5rem'.
059700   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
059800   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
059900   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
060000   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
060100   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
060200   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
060300   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
060400   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
060500*  CALL 'cobdom_style' USING 'navCobol', 'top', '25.7rem'.
060600   CALL 'cobdom_style' USING 'navCobol', 'left', '-35rem'.
060700   CALL 'cobdom_style' USING 'navCobol', 'transition', 
060800     'transform 0.5s ease 0.5s'.
060900   CALL 'cobdom_append_child' USING 'navCobol', 'selectorDiv'.
061000*Add main menu button
061100   CALL 'cobdom_append_child' USING 'navArea', 'topArea'.
061200   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
061300     'MENUTOGGLE'.
061400*Setup ID area
061500   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
061600   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
061700   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
061800   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
061900   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '6rem'.
062000   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
062100   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
062200   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
062300*  CALL 'cobdom_inner_html' USING 'taglineDiv', 
062400*    'A guy that knows a guy.'.
062500   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
062600*Setup lang area
062700   CALL 'cobdom_create_element' USING 'langArea', 'span'.
062800   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
062900*Setup language selector
063000   CALL 'cobdom_create_element' USING 'langUS', 'img'.
063100   CALL 'cobdom_create_element' USING 'langES', 'img'.
063200   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
063300   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
063400   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
063500   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
063600   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
063700   CALL 'cobdom_style' USING 'langUS', 'transition', 
063800     'opacity 0.5s ease, transform 0.5s ease'.
063900*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
064000*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
064100   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
064200   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
064300   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
064400   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
064500   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
064600   CALL 'cobdom_style' USING 'langES', 'transition', 
064700     'opacity 0.5s ease, transform 0.5s ease'.
064800*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
064900*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
065000   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
065100   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
065200     'SETLANGUS'.
065300   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
065400   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
065500     'SETLANGES'.
065600   CALL 'cobdom_append_child' USING 'selectorDiv', 'headerDiv'.
065700   CALL 'cobdom_append_child' USING 'idDiv', 'topArea'.
065800   CALL 'cobdom_append_child' USING 'langArea', 'topArea'.
065900   CONTINUE.
066000 SET-ACTIVE-FLAG.
066100   IF WS-LANG = 'us' THEN
066200     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
066300     CALL 'cobdom_style' USING 'langUS', 'transform', 
066400       'translate(9rem, 0rem)'
066500     CALL 'UPDATETEXT'
066600   ELSE
066700     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
066800     CALL 'cobdom_style' USING 'langUS', 'transform', 
066900       'translate(9rem, 0rem)'
067000     CALL 'UPDATETEXT'
067100   END-IF.
067200   CONTINUE.
067300 LOAD-TEXTS.
067400   CALL 'cobdom_fetch' USING 'LOADENAM',
067500     '/res/text/en/aboutme.txt', 'GET', WS-NULL-BYTE.
067600   CALL 'cobdom_fetch' USING 'LOADESAM',
067700     '/res/text/es/aboutme.txt', 'GET', WS-NULL-BYTE.
067800   CALL 'cobdom_fetch' USING 'LOADENCOBA',
067900     '/res/text/en/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
068000   CALL 'cobdom_fetch' USING 'LOADENCOBB',
068100     '/res/text/en/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
068200   CALL 'cobdom_fetch' USING 'LOADESCOBA',
068300     '/res/text/es/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
068400   CALL 'cobdom_fetch' USING 'LOADESCOBB',
068500     '/res/text/es/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
068600   CONTINUE.
068700 LANG-CHECK.
068800   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
068900     'lang'.
069000   IF WS-LANG = WS-NULL-BYTE THEN
069100     CALL 'cobdom_set_cookie' USING 'us', 'lang'
069200     MOVE 'us' TO WS-LANG
069300   END-IF.
069400   PERFORM SET-ACTIVE-FLAG.
069500   CONTINUE.
069600 COOKIE-ASK.
069700   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
069800   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
069900   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
070000   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
070100   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
070200   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
070300     'rgba(37,186,181,.9)'.
070400   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
070500     'center'.
070600   CALL 'cobdom_style' USING 'cookieDiv', 'fontSize', 
070700     '4rem'.
070800   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
070900-'llow cookies to store your preferences such as language?&nbsp;'.
071000   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
071100   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
071200   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
071300   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
071400   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
071500   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
071600   CALL 'cobdom_style' USING 'cookieYes', 'backgroundColor', 
071700     '#86e059'.
071800   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
071900   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
072000   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
072100   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
072200   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
072300   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
072400   CALL 'cobdom_style' USING 'cookieNo', 'backgroundColor', 
072500     '#e05e59'.
072600   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
072700     'COOKIEACCEPT'.
072800   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
072900     'COOKIEDENY'.
073000   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
073100   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
073200   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
073300   CONTINUE.
073400 UPDATETEXT SECTION.
073500 ENTRY 'UPDATETEXT'.
073600   IF WS-LANG = 'us' THEN
073700     CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me'
073800     CALL 'cobdom_inner_html' USING 'contactHeader',
073900       'Contact Information / Links'
074000*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills'
074100     CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects'
074200     CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'
074300     CALL 'cobdom_inner_html' USING 'navContact', 'Contact/Links'
074400*    CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'
074500     CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'
074600     CALL 'cobdom_inner_html' USING 'aboutContent',
074700       TAB OF EN OF WS-TEXTS
074800     CALL 'cobdom_inner_html' USING 'cobolContent',
074900       TAB-COB OF EN OF WS-TEXTS
075000   ELSE
075100     CALL 'cobdom_inner_html' USING 'aboutHeader', 'Sobre Mi'
075200     CALL 'cobdom_inner_html' USING 'contactHeader',
075300       'Informacion de Contacto / Enlaces'
075400*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Habilidades'
075500     CALL 'cobdom_inner_html' USING 'projectHeader', 'Proyectos'
075600     CALL 'cobdom_inner_html' USING 'navAbout', 'Sobre Mi'
075700     CALL 'cobdom_inner_html' USING 'navContact',
075800       'Contacto/Enlaces'
075900*    CALL 'cobdom_inner_html' USING 'navSkills', 'Habilidades'
076000     CALL 'cobdom_inner_html' USING 'navProjects', 'Proyectos'
076100     CALL 'cobdom_inner_html' USING 'aboutContent',
076200       TAB OF ES OF WS-TEXTS
076300     CALL 'cobdom_inner_html' USING 'cobolContent',
076400       TAB-COB OF ES OF WS-TEXTS
076500   END-IF.
076600   GOBACK.
076700 LOADENAM SECTION.
076800 ENTRY 'LOADENAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
076900   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF EN OF WS-TEXTS.
077000   CALL 'UPDATETEXT'.
077100   GOBACK.
077200 LOADESAM SECTION.
077300 ENTRY 'LOADESAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
077400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF ES OF WS-TEXTS.
077500   CALL 'UPDATETEXT'.
077600   GOBACK.
077700 LOADENCOBA SECTION.
077800 ENTRY 'LOADENCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
077900   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF EN OF WS-TEXTS.
078000   CALL 'UPDATETEXT'.
078100   GOBACK.
078200 LOADENCOBB SECTION.
078300 ENTRY 'LOADENCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
078400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF EN OF WS-TEXTS.
078500   CALL 'UPDATETEXT'.
078600   GOBACK.
078700 LOADESCOBA SECTION.
078800 ENTRY 'LOADESCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
078900   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF ES OF WS-TEXTS.
079000   CALL 'UPDATETEXT'.
079100   GOBACK.
079200 LOADESCOBB SECTION.
079300 ENTRY 'LOADESCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
079400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF ES OF WS-TEXTS.
079500*  DISPLAY ABOUT-ME OF ES OF WS-TEXTS.
079600   CALL 'UPDATETEXT'.
079700   GOBACK.
079800 NAVABOUT SECTION.
079900 ENTRY 'NAVABOUT'.
080000   CALL 'cobdom_scroll_into_view' USING 'aboutHeader'.
080100   GOBACK.
080200 NAVCONTACT SECTION.
080300 ENTRY 'NAVCONTACT'.
080400   CALL 'cobdom_scroll_into_view' USING 'contactHeader'.
080500   GOBACK.
080600 NAVPROJECTS SECTION.
080700 ENTRY 'NAVPROJECTS'.
080800   CALL 'cobdom_scroll_into_view' USING 'projectHeader'.
080900   GOBACK.
081000 NAVCOBOL SECTION.
081100 ENTRY 'NAVCOBOL'.
081200   CALL 'cobdom_scroll_into_view' USING 'cobolHeader'.
081300   GOBACK.
081400 OPENCOBOLSOURCE SECTION.
081500 ENTRY 'OPENCOBOLSOURCE'.
081600   CALL 'cobdom_open_tab' USING 
081700     'https://github.com/BalakeKarbon/BalakeKarbon.github.io'.
081800   GOBACK.
081900 OPENGH SECTION.
082000 ENTRY 'OPENGH'.
082100   CALL 'cobdom_open_tab' USING 
082200     'https://github.com/BalakeKarbon/'.
082300   GOBACK.
082400 OPENLI SECTION.
082500 ENTRY 'OPENLI'.
082600   CALL 'cobdom_open_tab' USING 
082700     'https://www.linkedin.com/in/blake-karbon/'.
082800   GOBACK.
082900 OPENME SECTION.
083000 ENTRY 'OPENME'.
083100   CALL 'cobdom_open_tab' USING 
083200     'https://medium.com/@karboncodes'.
083300   GOBACK.
083400 OPENYT SECTION.
083500 ENTRY 'OPENYT'.
083600   CALL 'cobdom_open_tab' USING 
083700     'https://www.youtube.com/@karboncodes'.
083800   GOBACK.
083900 OPENTT SECTION.
084000 ENTRY 'OPENTT'.
084100   CALL 'cobdom_open_tab' USING 
084200     'https://www.tiktok.com/@karboncodes'.
084300   GOBACK.
084400 OPENIG SECTION.
084500 ENTRY 'OPENIG'.
084600   CALL 'cobdom_open_tab' USING 
084700     'https://www.instagram.com/karboncodes'.
084800   GOBACK.
084900 MENUTOGGLE SECTION.
085000 ENTRY 'MENUTOGGLE'.
085100   IF WS-MENU-TOGGLE = 0 THEN
085200     MOVE 1 TO WS-MENU-TOGGLE
085300     CALL 'cobdom_style' USING 'navButton', 'transform', 
085400       'scale(0.85)'
085500     CALL 'cobdom_src' USING 'navButton', 
085600       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
085700     CALL 'cobdom_style' USING 'navAbout', 'transform', 
085800       'translate(35rem, 0rem)' 
085900     CALL 'cobdom_style' USING 'navContact', 'transform', 
086000       'translate(35rem, 0rem)' 
086100     CALL 'cobdom_style' USING 'navSkills', 'transform', 
086200       'translate(35rem, 0rem)'
086300    CALL 'cobdom_style' USING 'navProjects', 'transform', 
086400       'translate(35rem, 0rem)'
086500    CALL 'cobdom_style' USING 'navCobol', 'transform', 
086600       'translate(35rem, 0rem)'
086700   ELSE
086800     MOVE 0 TO WS-MENU-TOGGLE
086900     CALL 'cobdom_style' USING 'navButton', 'transform', 
087000       'scale(1.0)'
087100     CALL 'cobdom_src' USING 'navButton', 
087200       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
087300     CALL 'cobdom_style' USING 'navAbout', 'transform', 
087400       'translate(0rem, 0rem)' 
087500     CALL 'cobdom_style' USING 'navContact', 'transform', 
087600       'translate(0rem, 0rem)' 
087700     CALL 'cobdom_style' USING 'navSkills', 'transform', 
087800       'translate(0rem, 0rem)'
087900    CALL 'cobdom_style' USING 'navProjects', 'transform', 
088000       'translate(0rem, 0rem)'
088100    CALL 'cobdom_style' USING 'navCobol', 'transform', 
088200       'translate(0rem, 0rem)'
088300   END-IF.
088400   GOBACK.
088500*TO-DO: Add a timer in case some fonts do never load
088600 FONTLOADED SECTION.
088700 ENTRY 'FONTLOADED'.
088800   ADD 1 TO WS-FONTS-LOADED.
088900   IF WS-FONTS-LOADED = 2 THEN
089000     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
089100     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
089200     CALL 'cobdom_style' USING 'cobolSection', 'fontFamily',
089300       'ibmpc'
089400   END-IF.
089500   GOBACK.
089600 WINDOWCHANGE SECTION.
089700 ENTRY 'WINDOWCHANGE'.
089800   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
089900   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
090000     '300'.
090100*Optimize this buffer time to not have a noticeable delay but also
090200*not call to often.
090300   GOBACK.
090400 SHAPEPAGE SECTION.
090500 ENTRY 'SHAPEPAGE'.
090600*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
090700*  DISPLAY 'Rendering! ' CENTISECS.
090800   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
090900     'window.innerWidth'.
091000   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
091100   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
091200     'window.innerHeight'.
091300   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
091400   GOBACK.
091500 COOKIEACCEPT SECTION.
091600 ENTRY 'COOKIEACCEPT'.
091700   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
091800   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
091900   MOVE 'y' TO WS-COOKIE-ALLOWED.
092000   IF WS-LANG = 'us' THEN
092100     CALL 'cobdom_set_cookie' USING 'us', 'lang'
092200   ELSE
092300     CALL 'cobdom_set_cookie' USING 'en', 'lang'
092400   END-IF.
092500   GOBACK.
092600 COOKIEDENY SECTION.
092700 ENTRY 'COOKIEDENY'.
092800   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
092900   MOVE 'n' TO WS-COOKIE-ALLOWED.
093000   GOBACK.
093100 SETPERCENTCOBOL SECTION.
093200 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
093300   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF EN OF WS-TEXTS.
093400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF ES OF WS-TEXTS.
093500*  CALL 'cobdom_inner_html' USING 'percentCobol',
093600*    WS-PERCENT-COBOL.
093700*  DISPLAY 'Currently this website is written in ' 
093800*    WS-PERCENT-COBOL '% COBOL.'.
093900   GOBACK.
094000 SETLANG SECTION.
094100 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
094200   if WS-LANG-SELECT-TOGGLE = 0 THEN
094300     MOVE 1 TO WS-LANG-SELECT-TOGGLE
094400     IF WS-LANG = 'us' THEN
094500       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
094600       CALL 'cobdom_style' USING 'langUS', 'transform', 
094700         'translate(0rem, 0rem)'
094800*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
094900     ELSE
095000       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
095100       CALL 'cobdom_style' USING 'langUS', 'transform', 
095200         'translate(0rem, 0rem)'
095300*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
095400     END-IF
095500   ELSE
095600     MOVE 0 TO WS-LANG-SELECT-TOGGLE
095700     IF WS-COOKIE-ALLOWED = 'y' THEN
095800       IF LS-LANG-CHOICE = 'us' THEN
095900         CALL 'cobdom_set_cookie' USING 'us', 'lang'
096000         MOVE 'us' TO WS-LANG
096100       ELSE
096200         CALL 'cobdom_set_cookie' USING 'es', 'lang'
096300         MOVE 'es' TO WS-LANG
096400       END-IF
096500       PERFORM SET-ACTIVE-FLAG
096600     ELSE
096700       MOVE LS-LANG-CHOICE TO WS-LANG
096800       PERFORM SET-ACTIVE-FLAG 
096900     END-IF
097000   END-IF.
097100   GOBACK.
097200 SETLANGUS SECTION.
097300 ENTRY 'SETLANGUS'.
097400   CALL 'SETLANG' USING 'us'.
097500   GOBACK.
097600 SETLANGES SECTION.
097700 ENTRY 'SETLANGES'.
097800   CALL 'SETLANG' USING 'es'.
097900   GOBACK.
098000*TERMINPUT SECTION.
098100*ENTRY 'TERMINPUT' USING LS-TERM-IN.
098200*  DISPLAY LS-TERM-IN.
098300*  GOBACK.
