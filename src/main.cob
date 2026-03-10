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
003500     10 ABOUT-ME-STR.
003600       15 TAB PIC X(12) VALUE '&nbsp;&nbsp;'.
003700       15 ABOUT-ME PIC X(5000).
003800       15 NB PIC X(1) VALUE X'00'.
003900     10 COBOL-STR.
004000       15 TAB-COB PIC X(12) VALUE '&nbsp;&nbsp;'.
004100       15 COBOL-A PIC X(1000).
004200       15 PERCENT PIC X(5).
004300       15 COBOL-B PIC X(1000).
004400       15 NB PIC X(1) VALUE X'00'.
004500     10 TAGLINE-STR.
004600       15 TAGLINE PIC X(1000).
004700       15 NB PIC X(1) VALUE X'00'.
004800     10 PROJECTS-STR.
004900       15 PROJECTS PIC X(10000).
005000       15 NB PIC X(1) VALUE X'00'.
005100   05 ES.
005200     10 ABOUT-ME-STR.
005300       15 TAB PIC X(12) VALUE '&nbsp;&nbsp;'.
005400       15 ABOUT-ME PIC X(5000).
005500       15 NB PIC X(1) VALUE X'00'.
005600     10 COBOL-STR.
005700       15 TAB-COB PIC X(12) VALUE '&nbsp;&nbsp;'.
005800       15 COBOL-A PIC X(1000).
005900       15 PERCENT PIC X(5).
006000       15 COBOL-B PIC X(1000).
006100       15 NB PIC X(1) VALUE X'00'.
006200     10 TAGLINE-STR.
006300       15 TAGLINE PIC X(1000).
006400       15 NB PIC X(1) VALUE X'00'.
006500     10 PROJECTS-STR.
006600       15 PROJECTS PIC X(10000).
006700       15 NB PIC X(1) VALUE X'00'.
006800 LINKAGE SECTION.
006900 01 LS-BLOB PIC X(100000).
007000 01 LS-BLOB-SIZE PIC 9(10).
007100 01 LS-LANG-CHOICE PIC XX.
007200 01 LS-TERM-IN PIC X(10).
007300 PROCEDURE DIVISION.
007400 MAIN SECTION.
007500 ENTRY 'MAIN'.
007600   CALL 'cobdom_style' USING 'body', 'margin', '0'.
007700   CALL 'cobdom_style' USING 'body', 'fontSize', '1.5rem'.
007800   CALL 'cobdom_style' USING 'body', 'display', 'flex'.
007900   CALL 'cobdom_style' USING 'body', 'alignItems', 'center'.
008000   CALL 'cobdom_style' USING 'body', 'justifyContent', 'center'.
008100   CALL 'cobdom_add_event_listener' USING 'window', 'resize', 
008200     'WINDOWCHANGE'.
008300   CALL 'cobdom_add_event_listener' USING 'window', 
008400     'orientationchange', 'WINDOWCHANGE'.
008500   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
008600     'allowCookies'.
008700   CALL 'cobdom_create_element' USING 'percentCobol', 'span'.
008800   CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
008900     '/res/percent.txt', 'GET', WS-NULL-BYTE.
009000   CALL 'cobdom_create_element' USING 'contentDiv', 'div'.
009100   CALL 'cobdom_style' USING 'contentDiv', 'marginTop', '10rem'.
009200   CALL 'cobdom_style' USING 'contentDiv', 'marginBottom', 
009300     '10rem'.
009400   CALL 'cobdom_style' USING 'contentDiv', 'width', '80%'.
009500   CALL 'cobdom_style' USING 'contentDiv', 'display', 'flex'.
009600   CALL 'cobdom_style' USING 'contentDiv', 'flexDirection',
009700     'column'.
009800   CALL 'cobdom_style' USING 'contentDiv', 'alignItems',
009900     'flex-start'.
010000   CALL 'cobdom_append_child' USING 'contentDiv', 'body'.
010100   CALL 'cobdom_create_element' USING 'blinkStyle', 'style'.
010200   CALL 'cobdom_inner_html' USING 'blinkStyle', 
010300 '.blink { animation: blink 1s step-start infinite; } '.
010400   PERFORM BUILD-MENUBAR.
010500   PERFORM BUILD-CONTENT.
010600   CALL 'cobdom_font_face' USING 'mainFont',
010700     'url("/res/fonts/1971-ibm-3278/3270-Regular.ttf")',
010800     'FONTLOADED'.
010900   CALL 'cobdom_font_face' USING 'ibmpc',
011000     'url("/res/fonts/1985-ibm-pc-vga/PxPlus_IBM_VGA8.ttf")',
011100     'FONTLOADED'.
011200   PERFORM LOAD-TEXTS.
011300   IF WS-COOKIE-ALLOWED = 'y' THEN
011400     PERFORM LANG-CHECK
011500   ELSE
011600     PERFORM COOKIE-ASK
011700     MOVE 'us' TO WS-LANG
011800     PERFORM SET-ACTIVE-FLAG
011900   END-IF.
012000   CALL 'SHAPEPAGE'.
012100   GOBACK.
012200 BUILD-CONTENT.
012300   CALL 'cobdom_create_element' USING 'aboutSection', 'div'.
012400   CALL 'cobdom_style' USING 'aboutSection', 'width', '100%'.
012500   CALL 'cobdom_create_element' USING 'aboutHeader', 'div'.
012600   CALL 'cobdom_set_class' USING 'aboutHeader',
012700     'contentHeadersClass'.
012800   CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me:'.
012900   CALL 'cobdom_create_element' USING 'aboutContent', 'div'.
013000   CALL 'cobdom_append_child' USING 'aboutSection',
013100     'contentDiv'.
013200   CALL 'cobdom_append_child' USING 'aboutHeader',
013300     'aboutSection'.
013400   CALL 'cobdom_append_child' USING 'aboutContent',
013500     'aboutSection'.
013600   CALL 'cobdom_create_element' USING 'ghStatsDiv', 'div'.
013700   CALL 'cobdom_style' USING 'ghStatsDiv', 'width', '100%'.
013800   CALL 'cobdom_style' USING 'ghStatsDiv', 'textAlign', 'center'.
013900   CALL 'cobdom_append_child' USING 'ghStatsDiv', 'aboutSection'.
014000   CALL 'cobdom_create_element' USING 'ghStatsImg', 'img'.
014100   CALL 'cobdom_src' USING 'ghStatsImg', '/res/img/top-langs.svg'.
014200   CALL 'cobdom_style' USING 'ghStatsImg', 'height', '10rem'.
014300   CALL 'cobdom_append_child' USING 'ghStatsImg', 'ghStatsDiv'.
014400   CALL 'cobdom_create_element' USING 'contactSection', 'div'.
014500   CALL 'cobdom_style' USING 'contactSection', 'width', '100%'.
014600   CALL 'cobdom_create_element' USING 'contactHeader', 'div'.
014700   CALL 'cobdom_set_class' USING 'contactHeader',
014800     'contentHeadersClass'.
014900   CALL 'cobdom_inner_html' USING 'contactHeader',
015000     'Contact Information:'.
015100   CALL 'cobdom_create_element' USING 'contactContent', 'div'.
015200   CALL 'cobdom_style' USING 'contactContent', 'width', '100%'.
015300   CALL 'cobdom_style' USING 'contactContent', 'textAlign',
015400     'center'.
015500   CALL 'cobdom_append_child' USING 'contactSection',
015600     'contentDiv'.
015700   CALL 'cobdom_append_child' USING 'contactHeader',
015800     'contactSection'.
015900   CALL 'cobdom_append_child' USING 'contactContent',
016000     'contactSection'.
016100   CALL 'cobdom_create_element' USING 'emailDiv', 'div'.
016200   CALL 'cobdom_inner_html' USING 'emailDiv',
016300     'karboncodes@gmail.com'.
016400   CALL 'cobdom_create_element' USING 'linksDiv', 'div'.
016500   CALL 'cobdom_style' USING 'linksDiv', 'display', 'flex'.
016600   CALL 'cobdom_style' USING 'linksDiv', 'width', '100%'.
016700   CALL 'cobdom_style' USING 'linksDiv', 'justifyContent',
016800     'center'.
016900   CALL 'cobdom_create_element' USING 'ghContainer', 'span'.
017000   CALL 'cobdom_add_event_listener' USING 'ghContainer',
017100     'click', 'OPENGH'.
017200   CALL 'cobdom_set_class' USING 'ghContainer',
017300     'contactContainer'.
017400   CALL 'cobdom_create_element' USING 'ghImage', 'img'.
017500   CALL 'cobdom_src' USING 'ghImage', 
017600     '/res/icons/tabler-icons/icons/outline/brand-github.svg'.
017700   CALL 'cobdom_style' USING 'ghImage', 'width', '6rem'.
017800   CALL 'cobdom_style' USING 'ghImage', 'height', '6rem'.
017900   CALL 'cobdom_create_element' USING 'ghText', 'div'.
018000   CALL 'cobdom_style' USING 'ghText', 'textDecoration',
018100     'underline'.
018200   CALL 'cobdom_inner_html' USING 'ghText', 'GitHub'.
018300   CALL 'cobdom_append_child' USING 'ghImage', 'ghContainer'.
018400   CALL 'cobdom_append_child' USING 'ghText', 'ghContainer'.
018500   CALL 'cobdom_append_child' USING 'ghContainer', 'linksDiv'.
018600   CALL 'cobdom_create_element' USING 'liContainer', 'span'.
018700   CALL 'cobdom_add_event_listener' USING 'liContainer',
018800     'click', 'OPENLI'.
018900   CALL 'cobdom_set_class' USING 'liContainer',
019000     'contactContainer'.
019100   CALL 'cobdom_create_element' USING 'liImage', 'img'.
019200   CALL 'cobdom_src' USING 'liImage', 
019300     '/res/icons/tabler-icons/icons/outline/brand-linkedin.svg'.
019400   CALL 'cobdom_style' USING 'liImage', 'width', '6rem'.
019500   CALL 'cobdom_style' USING 'liImage', 'height', '6rem'.
019600   CALL 'cobdom_create_element' USING 'liText', 'div'.
019700   CALL 'cobdom_style' USING 'liText', 'textDecoration',
019800     'underline'.
019900   CALL 'cobdom_inner_html' USING 'liText', 'Linkedin'.
020000   CALL 'cobdom_append_child' USING 'liImage', 'liContainer'.
020100   CALL 'cobdom_append_child' USING 'liText', 'liContainer'.
020200   CALL 'cobdom_append_child' USING 'liContainer', 'linksDiv'.
020300   CALL 'cobdom_create_element' USING 'meContainer', 'span'.
020400   CALL 'cobdom_add_event_listener' USING 'meContainer',
020500     'click', 'OPENME'.
020600   CALL 'cobdom_set_class' USING 'meContainer',
020700     'contactContainer'.
020800   CALL 'cobdom_create_element' USING 'meImage', 'img'.
020900   CALL 'cobdom_src' USING 'meImage', 
021000     '/res/icons/tabler-icons/icons/outline/brand-medium.svg'.
021100   CALL 'cobdom_style' USING 'meImage', 'width', '6rem'.
021200   CALL 'cobdom_style' USING 'meImage', 'height', '6rem'.
021300   CALL 'cobdom_create_element' USING 'meText', 'div'.
021400   CALL 'cobdom_style' USING 'meText', 'textDecoration',
021500     'underline'.
021600   CALL 'cobdom_inner_html' USING 'meText', 'Medium'.
021700   CALL 'cobdom_append_child' USING 'meImage', 'meContainer'.
021800   CALL 'cobdom_append_child' USING 'meText', 'meContainer'.
021900   CALL 'cobdom_append_child' USING 'meContainer', 'linksDiv'.
022000   CALL 'cobdom_create_element' USING 'ytContainer', 'span'.
022100   CALL 'cobdom_add_event_listener' USING 'ytContainer',
022200     'click', 'OPENYT'.
022300   CALL 'cobdom_set_class' USING 'ytContainer',
022400     'contactContainer'.
022500   CALL 'cobdom_create_element' USING 'ytImage', 'img'.
022600   CALL 'cobdom_src' USING 'ytImage', 
022700     '/res/icons/tabler-icons/icons/outline/brand-youtube.svg'.
022800   CALL 'cobdom_style' USING 'ytImage', 'width', '6rem'.
022900   CALL 'cobdom_style' USING 'ytImage', 'height', '6rem'.
023000   CALL 'cobdom_create_element' USING 'ytText', 'div'.
023100   CALL 'cobdom_style' USING 'ytText', 'textDecoration',
023200     'underline'.
023300   CALL 'cobdom_inner_html' USING 'ytText', 'Youtube'.
023400   CALL 'cobdom_append_child' USING 'ytImage', 'ytContainer'.
023500   CALL 'cobdom_append_child' USING 'ytText', 'ytContainer'.
023600   CALL 'cobdom_append_child' USING 'ytContainer', 'linksDiv'.
023700   CALL 'cobdom_create_element' USING 'ttContainer', 'span'.
023800   CALL 'cobdom_add_event_listener' USING 'ttContainer',
023900     'click', 'OPENTT'.
024000   CALL 'cobdom_set_class' USING 'ttContainer',
024100     'contactContainer'.
024200   CALL 'cobdom_create_element' USING 'ttImage', 'img'.
024300   CALL 'cobdom_src' USING 'ttImage', 
024400     '/res/icons/tabler-icons/icons/outline/brand-tiktok.svg'.
024500   CALL 'cobdom_style' USING 'ttImage', 'width', '6rem'.
024600   CALL 'cobdom_style' USING 'ttImage', 'height', '6rem'.
024700   CALL 'cobdom_create_element' USING 'ttText', 'div'.
024800   CALL 'cobdom_style' USING 'ttText', 'textDecoration',
024900     'underline'.
025000   CALL 'cobdom_inner_html' USING 'ttText', 'TikTok'.
025100   CALL 'cobdom_append_child' USING 'ttImage', 'ttContainer'.
025200   CALL 'cobdom_append_child' USING 'ttText', 'ttContainer'.
025300   CALL 'cobdom_append_child' USING 'ttContainer', 'linksDiv'.
025400   CALL 'cobdom_create_element' USING 'igContainer', 'span'.
025500   CALL 'cobdom_add_event_listener' USING 'igContainer',
025600     'click', 'OPENIG'.
025700   CALL 'cobdom_set_class' USING 'igContainer',
025800     'contactContainer'.
025900   CALL 'cobdom_create_element' USING 'igImage', 'img'.
026000   CALL 'cobdom_src' USING 'igImage', 
026100     '/res/icons/tabler-icons/icons/outline/brand-instagram.svg'.
026200   CALL 'cobdom_style' USING 'igImage', 'width', '6rem'.
026300   CALL 'cobdom_style' USING 'igImage', 'height', '6rem'.
026400   CALL 'cobdom_create_element' USING 'igText', 'div'.
026500   CALL 'cobdom_style' USING 'igText', 'textDecoration',
026600     'underline'.
026700   CALL 'cobdom_inner_html' USING 'igText', 'Instagram'.
026800   CALL 'cobdom_append_child' USING 'igImage', 'igContainer'.
026900   CALL 'cobdom_append_child' USING 'igText', 'igContainer'.
027000   CALL 'cobdom_append_child' USING 'igContainer', 'linksDiv'.
027100   CALL 'cobdom_append_child' USING 'emailDiv', 'contactContent'.
027200   CALL 'cobdom_append_child' USING 'linksDiv', 'contactContent'.
027300   CALL 'cobdom_create_element' USING 'projectSection', 'div'.
027400   CALL 'cobdom_style' USING 'projectSection', 'width', '100%'.
027500   CALL 'cobdom_create_element' USING 'projectHeader', 'div'.
027600   CALL 'cobdom_set_class' USING 'projectHeader',
027700     'contentHeadersClass'.
027800   CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects:'.
027900   CALL 'cobdom_create_element' USING 'projectContent', 'div'.
028000   CALL 'cobdom_style' USING 'projectContent', 'textAlign',
028100     'center'.
028200   CALL 'cobdom_inner_html' USING 'projectContent', '&nbsp;'.
028300   CALL 'cobdom_append_child' USING 'projectSection', 
028400     'contentDiv'.
028500   CALL 'cobdom_append_child' USING 'projectHeader', 
028600     'projectSection'.
028700   CALL 'cobdom_append_child' USING 'projectContent', 
028800     'projectSection'.
028900   PERFORM ADD-PROJECTS.
029000   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
029100   CALL 'cobdom_style' USING 'cobolSection', 'width', '100%'.
029200   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
029300   CALL 'cobdom_set_class' USING 'cobolHeader',
029400     'contentHeadersClass'.
029500   CALL 'cobdom_inner_html' USING 'cobolHeader', 'COBOL'.
029600   CALL 'cobdom_create_element' USING 'cobolContent', 'span'.
029700   CALL 'cobdom_append_child' USING 'cobolSection',
029800     'contentDiv'.
029900   CALL 'cobdom_append_child' USING 'cobolHeader', 
030000     'cobolSection'.
030100   CALL 'cobdom_append_child' USING 'cobolContent', 
030200     'cobolSection'.
030300   CALL 'cobdom_create_element' USING 'cobolGithubLink',
030400     'span'.
030500   CALL 'cobdom_add_event_listener' USING 'cobolGithubLink',
030600     'click', 'OPENCOBOLSOURCE'.
030700   CALL 'cobdom_inner_html' USING 'cobolGithubLink',
030800     'GitHub!'.
030900   CALL 'cobdom_style' USING 'cobolGithubLink', 'textDecoration',
031000     'underline'.
031100   CALL 'cobdom_append_child' USING 'cobolGithubLink',
031200     'cobolSection'.
031300   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
031400     'fontSize', '2.5rem'.
031500   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
031600     'width', '100%'.
031700   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
031800     'textAlign', 'center'.
031900   CALL 'cobdom_class_style' USING 'contentHeadersClass',
032000     'fontWeight', 'bold'.
032100   CALL 'cobdom_class_style' USING 'contactContainer', 'margin',
032200     '1rem'.
032300   CALL 'cobdom_class_style' USING 'contactContainer', 'display',
032400     'flex'. 
032500   CALL 'cobdom_class_style' USING 'contactContainer',
032600     'flexDirection', 'column'.
032700   CALL 'cobdom_class_style' USING 'contactContainer',
032800     'alignItems', 'center'.
032900   CONTINUE.
033000 BUILD-MENUBAR.
033100   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
033200   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
033300   CALL 'cobdom_style' USING 'headerDiv', 'pointerEvents', 'none'.
033400   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
033500   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
033600     'space-between'.
033700   CALL 'cobdom_style' USING 'headerDiv', 'flexDirection',
033800     'column'.
033900   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
034000   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
034100   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
034200   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
034300   CALL 'cobdom_create_element' USING 'topArea', 'div'.
034400   CALL 'cobdom_style' USING 'topArea', 'display', 'flex'.
034500   CALL 'cobdom_style' USING 'topArea', 'pointerEvents', 'all'.
034600   CALL 'cobdom_style' USING 'topArea', 'backgroundColor',
034700     '#c9c9c9'.
034800   CALL 'cobdom_append_child' USING 'topArea', 'headerDiv'.
034900   CALL 'cobdom_create_element' USING 'navArea', 'div'.
035000   CALL 'cobdom_create_element' USING 'navButton', 'img'.
035100   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
035200   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
035300   CALL 'cobdom_src' USING 'navButton', 
035400     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
035500   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
035600     '#898989'.
035700   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
035800   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
035900   CALL 'cobdom_style' USING 'navButton', 'padding', '.35rem'.
036000   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
036100   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
036200   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
036300   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
036400   CALL 'cobdom_create_element' USING 'selectorDiv', 'div'.
036500   CALL 'cobdom_style' USING 'selectorDiv', 'pointerEvents'
036600     'none'.
036700   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
036800   CALL 'cobdom_style' USING 'navAbout', 'fontSize', '4rem'.
036900   CALL 'cobdom_style' USING 'navAbout', 'pointerEvents', 'all'.
037000   CALL 'cobdom_style' USING 'navAbout', 'width', 
037100     'max-content'.
037200   CALL 'cobdom_add_event_listener' USING 'navAbout',
037300     'click', 'NAVABOUT'.
037400   CALL 'cobdom_style' USING 'navAbout', 'position', 'relative'.
037500   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
037600     '#c9c9c9'.
037700   CALL 'cobdom_style' USING 'navAbout', 
037800     'borderBottomRightRadius', '0.5rem'.
037900   CALL 'cobdom_style' USING 'navAbout', 
038000     'borderTopRightRadius', '0.5rem'.
038100   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
038200   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
038300   CALL 'cobdom_style' USING 'navAbout', 'left', '-35rem'.
038400   CALL 'cobdom_style' USING 'navAbout', 'transition', 
038500     'transform 0.5s ease 0.1s'.
038600   CALL 'cobdom_append_child' USING 'navAbout', 'selectorDiv'.
038700   CALL 'cobdom_create_element' USING 'navContact', 'div'.
038800   CALL 'cobdom_style' USING 'navContact', 'fontSize', '4rem'.
038900   CALL 'cobdom_style' USING 'navContact', 'pointerEvents', 'all'.
039000   CALL 'cobdom_style' USING 'navContact', 'width', 
039100     'max-content'.
039200   CALL 'cobdom_add_event_listener' USING 'navContact',
039300     'click', 'NAVCONTACT'.
039400   CALL 'cobdom_style' USING 'navContact', 'position', 'relative'.
039500   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
039600     '#c9c9c9'.
039700   CALL 'cobdom_style' USING 'navContact', 
039800     'borderBottomRightRadius', '0.5rem'.
039900   CALL 'cobdom_style' USING 'navContact', 
040000     'borderTopRightRadius', '0.5rem'.
040100   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
040200   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
040300   CALL 'cobdom_style' USING 'navContact', 'left', '-35rem'.
040400   CALL 'cobdom_style' USING 'navContact', 'transition', 
040500     'transform 0.5s ease 0.2s'.
040600   CALL 'cobdom_append_child' USING 'navContact', 'selectorDiv'.
040700   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
040800   CALL 'cobdom_style' USING 'navProjects', 'fontSize', '4rem'.
040900   CALL 'cobdom_style' USING 'navProjects', 'pointerEvents', 
041000     'all'.
041100   CALL 'cobdom_style' USING 'navProjects', 'width', 
041200     'max-content'.
041300   CALL 'cobdom_add_event_listener' USING 'navProjects',
041400     'click', 'NAVPROJECTS'.
041500   CALL 'cobdom_style' USING 'navProjects', 'position', 
041600     'relative'.
041700   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
041800     '#c9c9c9'.
041900   CALL 'cobdom_style' USING 'navProjects', 
042000     'borderBottomRightRadius', '0.5rem'.
042100   CALL 'cobdom_style' USING 'navProjects', 
042200     'borderTopRightRadius', '0.5rem'.
042300   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
042400   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
042500   CALL 'cobdom_style' USING 'navProjects', 'left', '-35rem'.
042600   CALL 'cobdom_style' USING 'navProjects', 'transition', 
042700     'transform 0.5s ease 0.4s'.
042800   CALL 'cobdom_append_child' USING 'navProjects', 'selectorDiv'.
042900   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
043000   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
043100   CALL 'cobdom_style' USING 'navCobol', 'fontSize', '4rem'.
043200   CALL 'cobdom_style' USING 'navCobol', 'pointerEvents', 'all'.
043300   CALL 'cobdom_style' USING 'navCobol', 'width',
043400     'max-content'.
043500   CALL 'cobdom_add_event_listener' USING 'navCobol',
043600     'click', 'NAVCOBOL'.
043700   CALL 'cobdom_style' USING 'navCobol', 'position', 
043800     'relative'.
043900   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
044000     '#000000'.
044100   CALL 'cobdom_style' USING 'navCobol', 'color', 
044200     '#00FF00'.
044300   CALL 'cobdom_style' USING 'navCobol', 
044400     'borderBottomRightRadius', '0.5rem'.
044500   CALL 'cobdom_style' USING 'navCobol', 
044600     'borderTopRightRadius', '0.5rem'.
044700   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
044800   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
044900   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
045000   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
045100   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
045200   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
045300   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
045400   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
045500   CALL 'cobdom_style' USING 'navCobol', 'left', '-35rem'.
045600   CALL 'cobdom_style' USING 'navCobol', 'transition', 
045700     'transform 0.5s ease 0.5s'.
045800   CALL 'cobdom_append_child' USING 'navCobol', 'selectorDiv'.
045900   CALL 'cobdom_append_child' USING 'navArea', 'topArea'.
046000   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
046100     'MENUTOGGLE'.
046200   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
046300   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
046400   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
046500   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
046600   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '5rem'.
046700   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
046800   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
046900   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
047000   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
047100   CALL 'cobdom_create_element' USING 'langArea', 'span'.
047200   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
047300   CALL 'cobdom_create_element' USING 'langUS', 'img'.
047400   CALL 'cobdom_create_element' USING 'langES', 'img'.
047500   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
047600   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
047700   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
047800   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
047900   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
048000   CALL 'cobdom_style' USING 'langUS', 'transition', 
048100     'opacity 0.5s ease, transform 0.5s ease'.
048200   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
048300   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
048400   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
048500   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
048600   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
048700   CALL 'cobdom_style' USING 'langES', 'transition', 
048800     'opacity 0.5s ease, transform 0.5s ease'.
048900   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
049000   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
049100     'SETLANGUS'.
049200   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
049300   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
049400     'SETLANGES'.
049500   CALL 'cobdom_append_child' USING 'selectorDiv', 'headerDiv'.
049600   CALL 'cobdom_append_child' USING 'idDiv', 'topArea'.
049700   CALL 'cobdom_append_child' USING 'langArea', 'topArea'.
049800   CONTINUE.
049900 SET-ACTIVE-FLAG.
050000   IF WS-LANG = 'us' THEN
050100     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
050200     CALL 'cobdom_style' USING 'langUS', 'transform', 
050300       'translate(9rem, 0rem)'
050400   ELSE
050500     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
050600     CALL 'cobdom_style' USING 'langUS', 'transform', 
050700       'translate(9rem, 0rem)'
050800   END-IF.
050900   CALL 'UPDATETEXT'.
051000   CONTINUE.
051100 LOAD-TEXTS.
051200   CALL 'cobdom_fetch' USING 'LOADENAM',
051300     '/res/text/en/aboutme.txt', 'GET', WS-NULL-BYTE.
051400   CALL 'cobdom_fetch' USING 'LOADESAM',
051500     '/res/text/es/aboutme.txt', 'GET', WS-NULL-BYTE.
051600   CALL 'cobdom_fetch' USING 'LOADENCOBA',
051700     '/res/text/en/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
051800   CALL 'cobdom_fetch' USING 'LOADENCOBB',
051900     '/res/text/en/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
052000   CALL 'cobdom_fetch' USING 'LOADESCOBA',
052100     '/res/text/es/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
052200   CALL 'cobdom_fetch' USING 'LOADESCOBB',
052300     '/res/text/es/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
052400   CALL 'cobdom_fetch' USING 'LOADENTG',
052500     '/res/text/en/iam.txt', 'GET', WS-NULL-BYTE.
052600   CALL 'cobdom_fetch' USING 'LOADESTG',
052700     '/res/text/es/iam.txt', 'GET', WS-NULL-BYTE.
052800   CALL 'cobdom_fetch' USING 'LOADENPJ',
052900     '/res/text/en/projects.txt', 'GET', WS-NULL-BYTE.
053000   CALL 'cobdom_fetch' USING 'LOADESPJ',
053100     '/res/text/es/projects.txt', 'GET', WS-NULL-BYTE.
053200   CONTINUE.
053300 LANG-CHECK.
053400   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
053500     'lang'.
053600   IF WS-LANG = WS-NULL-BYTE THEN
053700     CALL 'cobdom_set_cookie' USING 'us', 'lang'
053800     MOVE 'us' TO WS-LANG
053900   END-IF.
054000   PERFORM SET-ACTIVE-FLAG.
054100   CONTINUE.
054200 COOKIE-ASK.
054300   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
054400   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
054500   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
054600   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
054700   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
054800   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
054900     'rgba(37,186,181,.9)'.
055000   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
055100     'center'.
055200   CALL 'cobdom_style' USING 'cookieDiv', 'fontSize', 
055300     '4rem'.
055400   CALL 'cobdom_inner_html' USING 'cookieDiv', 'Cookies? '.
055500   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
055600   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
055700   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
055800   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
055900   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
056000   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
056100   CALL 'cobdom_style' USING 'cookieYes', 'backgroundColor', 
056200     '#86e059'.
056300   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
056400   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
056500   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
056600   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
056700   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
056800   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
056900   CALL 'cobdom_style' USING 'cookieNo', 'backgroundColor', 
057000     '#e05e59'.
057100   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
057200     'COOKIEACCEPT'.
057300   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
057400     'COOKIEDENY'.
057500   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
057600   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
057700   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
057800   CONTINUE.
057900 ADD-PROJECTS.
058000   CALL 'cobdom_create_element' USING 'dtlImg', 'img'.
058100   CALL 'cobdom_src' USING 'dtlImg',
058200     'res/img/dlatch-characteristics.svg'.
058300   CALL 'cobdom_append_child' USING 'dtlImg', 'projectContent'.
058400   CONTINUE.
058500 UPDATETEXT SECTION.
058600 ENTRY 'UPDATETEXT'.
058700   IF WS-LANG = 'us' THEN
058800     CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me'
058900     CALL 'cobdom_inner_html' USING 'contactHeader',
059000       'Contact Information / Links'
059100     CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects'
059200     CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'
059300     CALL 'cobdom_inner_html' USING 'navContact', 'Contact/Links'
059400     CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'
059500     CALL 'cobdom_inner_html' USING 'aboutContent',
059600       ABOUT-ME-STR OF EN OF WS-TEXTS
059700     CALL 'cobdom_inner_html' USING 'cobolContent',
059800       COBOL-STR OF EN OF WS-TEXTS
059900     CALL 'cobdom_inner_html' USING 'taglineDiv',
060000       TAGLINE-STR OF EN OF WS-TEXTS
060100     CALL 'cobdom_inner_html' USING 'projectContent',
060200       PROJECTS-STR OF EN OF WS-TEXTS
060300   ELSE
060400     CALL 'cobdom_inner_html' USING 'aboutHeader', 'Sobre Mi'
060500     CALL 'cobdom_inner_html' USING 'contactHeader',
060600       'Informacion de Contacto / Enlaces'
060700     CALL 'cobdom_inner_html' USING 'projectHeader', 'Proyectos'
060800     CALL 'cobdom_inner_html' USING 'navAbout', 'Sobre Mi'
060900     CALL 'cobdom_inner_html' USING 'navContact',
061000       'Contacto/Enlaces'
061100     CALL 'cobdom_inner_html' USING 'navProjects', 'Proyectos'
061200     CALL 'cobdom_inner_html' USING 'aboutContent',
061300       ABOUT-ME-STR OF ES OF WS-TEXTS
061400     CALL 'cobdom_inner_html' USING 'cobolContent',
061500       COBOL-STR OF ES OF WS-TEXTS
061600     CALL 'cobdom_inner_html' USING 'taglineDiv',
061700       TAGLINE-STR OF ES OF WS-TEXTS
061800     CALL 'cobdom_inner_html' USING 'projectContent',
061900       PROJECTS-STR OF ES OF WS-TEXTS
062000   END-IF.
062100   GOBACK.
062200 LOADENAM SECTION.
062300 ENTRY 'LOADENAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
062400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF EN OF WS-TEXTS.
062500   CALL 'UPDATETEXT'.
062600   GOBACK.
062700 LOADESAM SECTION.
062800 ENTRY 'LOADESAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
062900   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF ES OF WS-TEXTS.
063000   CALL 'UPDATETEXT'.
063100   GOBACK.
063200 LOADENCOBA SECTION.
063300 ENTRY 'LOADENCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
063400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF EN OF WS-TEXTS.
063500   CALL 'UPDATETEXT'.
063600   GOBACK.
063700 LOADENCOBB SECTION.
063800 ENTRY 'LOADENCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
063900   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF EN OF WS-TEXTS.
064000   CALL 'UPDATETEXT'.
064100   GOBACK.
064200 LOADESCOBA SECTION.
064300 ENTRY 'LOADESCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
064400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF ES OF WS-TEXTS.
064500   CALL 'UPDATETEXT'.
064600   GOBACK.
064700 LOADESCOBB SECTION.
064800 ENTRY 'LOADESCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
064900   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF ES OF WS-TEXTS.
065000   CALL 'UPDATETEXT'.
065100   GOBACK.
065200 LOADENTG SECTION.
065300 ENTRY 'LOADENTG' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
065400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO TAGLINE OF EN OF WS-TEXTS.
065500   CALL 'UPDATETEXT'.
065600   GOBACK.
065700 LOADESTG SECTION.
065800 ENTRY 'LOADESTG' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
065900   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO TAGLINE OF ES OF WS-TEXTS.
066000   CALL 'UPDATETEXT'.
066100   GOBACK.
066200 LOADENPJ SECTION.
066300 ENTRY 'LOADENPJ' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
066400   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PROJECTS OF EN OF WS-TEXTS.
066500   CALL 'UPDATETEXT'.
066600   GOBACK.
066700 LOADESPJ SECTION.
066800 ENTRY 'LOADESPJ' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
066900   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PROJECTS OF ES OF WS-TEXTS.
067000   CALL 'UPDATETEXT'.
067100   GOBACK.
067200 NAVABOUT SECTION.
067300 ENTRY 'NAVABOUT'.
067400   CALL 'cobdom_scroll_into_view' USING 'aboutHeader'.
067500   GOBACK.
067600 NAVCONTACT SECTION.
067700 ENTRY 'NAVCONTACT'.
067800   CALL 'cobdom_scroll_into_view' USING 'contactHeader'.
067900   GOBACK.
068000 NAVPROJECTS SECTION.
068100 ENTRY 'NAVPROJECTS'.
068200   CALL 'cobdom_scroll_into_view' USING 'projectHeader'.
068300   GOBACK.
068400 NAVCOBOL SECTION.
068500 ENTRY 'NAVCOBOL'.
068600   CALL 'cobdom_scroll_into_view' USING 'cobolHeader'.
068700   GOBACK.
068800 OPENCOBOLSOURCE SECTION.
068900 ENTRY 'OPENCOBOLSOURCE'.
069000   CALL 'cobdom_open_tab' USING 
069100     'https://github.com/BalakeKarbon/BalakeKarbon.github.io'.
069200   GOBACK.
069300 OPENGH SECTION.
069400 ENTRY 'OPENGH'.
069500   CALL 'cobdom_open_tab' USING 
069600     'https://github.com/BalakeKarbon/'.
069700   GOBACK.
069800 OPENLI SECTION.
069900 ENTRY 'OPENLI'.
070000   CALL 'cobdom_open_tab' USING 
070100     'https://www.linkedin.com/in/blake-karbon/'.
070200   GOBACK.
070300 OPENME SECTION.
070400 ENTRY 'OPENME'.
070500   CALL 'cobdom_open_tab' USING 
070600     'https://medium.com/@karboncodes'.
070700   GOBACK.
070800 OPENYT SECTION.
070900 ENTRY 'OPENYT'.
071000   CALL 'cobdom_open_tab' USING 
071100     'https://www.youtube.com/@karboncodes'.
071200   GOBACK.
071300 OPENTT SECTION.
071400 ENTRY 'OPENTT'.
071500   CALL 'cobdom_open_tab' USING 
071600     'https://www.tiktok.com/@karboncodes'.
071700   GOBACK.
071800 OPENIG SECTION.
071900 ENTRY 'OPENIG'.
072000   CALL 'cobdom_open_tab' USING 
072100     'https://www.instagram.com/karboncodes'.
072200   GOBACK.
071300 MENUTOGGLE SECTION.
071400 ENTRY 'MENUTOGGLE'.
071500   IF WS-MENU-TOGGLE = 0 THEN
071600     MOVE 1 TO WS-MENU-TOGGLE
071700     CALL 'cobdom_style' USING 'navButton', 'transform', 
071800       'scale(0.85)'
071900     CALL 'cobdom_src' USING 'navButton', 
072000       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
072100     CALL 'cobdom_style' USING 'navAbout', 'transform', 
072200       'translate(35rem, 0rem)' 
072300     CALL 'cobdom_style' USING 'navContact', 'transform', 
072400       'translate(35rem, 0rem)' 
072500    CALL 'cobdom_style' USING 'navProjects', 'transform', 
072600       'translate(35rem, 0rem)'
072700    CALL 'cobdom_style' USING 'navCobol', 'transform', 
072800       'translate(35rem, 0rem)'
072900   ELSE
073000     MOVE 0 TO WS-MENU-TOGGLE
073100     CALL 'cobdom_style' USING 'navButton', 'transform', 
073200       'scale(1.0)'
073300     CALL 'cobdom_src' USING 'navButton', 
073400       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
073500     CALL 'cobdom_style' USING 'navAbout', 'transform', 
073600       'translate(0rem, 0rem)' 
073700     CALL 'cobdom_style' USING 'navContact', 'transform', 
073800       'translate(0rem, 0rem)' 
073900    CALL 'cobdom_style' USING 'navProjects', 'transform', 
074000       'translate(0rem, 0rem)'
074100    CALL 'cobdom_style' USING 'navCobol', 'transform', 
074200       'translate(0rem, 0rem)'
074300   END-IF.
074400   GOBACK.
074500 FONTLOADED SECTION.
074600 ENTRY 'FONTLOADED'.
074700   ADD 1 TO WS-FONTS-LOADED.
074800   IF WS-FONTS-LOADED = 2 THEN
074900     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
075000     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
075100     CALL 'cobdom_style' USING 'cobolSection', 'fontFamily',
075200       'ibmpc'
075300   END-IF.
075400   GOBACK.
075500 WINDOWCHANGE SECTION.
075600 ENTRY 'WINDOWCHANGE'.
075700   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
075800   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
075900     '300'.
076000   GOBACK.
076100 SHAPEPAGE SECTION.
076200 ENTRY 'SHAPEPAGE'.
076300   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
076400     'window.innerWidth'.
076500   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
076600   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
076700     'window.innerHeight'.
076800   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
076900   GOBACK.
077000 COOKIEACCEPT SECTION.
077100 ENTRY 'COOKIEACCEPT'.
077200   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
077300   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
077400   MOVE 'y' TO WS-COOKIE-ALLOWED.
077500   IF WS-LANG = 'us' THEN
077600     CALL 'cobdom_set_cookie' USING 'us', 'lang'
077700   ELSE
077800     CALL 'cobdom_set_cookie' USING 'en', 'lang'
077900   END-IF.
078000   GOBACK.
078100 COOKIEDENY SECTION.
078200 ENTRY 'COOKIEDENY'.
078300   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
078400   MOVE 'n' TO WS-COOKIE-ALLOWED.
078500   GOBACK.
078600 SETPERCENTCOBOL SECTION.
078700 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
078800   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF EN OF WS-TEXTS.
078900   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF ES OF WS-TEXTS.
079000   GOBACK.
079100 SETLANG SECTION.
079200 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
079300   if WS-LANG-SELECT-TOGGLE = 0 THEN
079400     MOVE 1 TO WS-LANG-SELECT-TOGGLE
079500     IF WS-LANG = 'us' THEN
079600       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
079700       CALL 'cobdom_style' USING 'langUS', 'transform', 
079800         'translate(0rem, 0rem)'
079900     ELSE
080000       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
080100       CALL 'cobdom_style' USING 'langUS', 'transform', 
080200         'translate(0rem, 0rem)'
080300     END-IF
080400   ELSE
080500     MOVE 0 TO WS-LANG-SELECT-TOGGLE
080600     IF WS-COOKIE-ALLOWED = 'y' THEN
080700       IF LS-LANG-CHOICE = 'us' THEN
080800         CALL 'cobdom_set_cookie' USING 'us', 'lang'
080900         MOVE 'us' TO WS-LANG
081000       ELSE
081100         CALL 'cobdom_set_cookie' USING 'es', 'lang'
081200         MOVE 'es' TO WS-LANG
081300       END-IF
081400       PERFORM SET-ACTIVE-FLAG
081500     ELSE
081600       MOVE LS-LANG-CHOICE TO WS-LANG
081700       PERFORM SET-ACTIVE-FLAG 
081800     END-IF
081900   END-IF.
082000   GOBACK.
082100 SETLANGUS SECTION.
082200 ENTRY 'SETLANGUS'.
082300   CALL 'SETLANG' USING 'us'.
082400   GOBACK.
082500 SETLANGES SECTION.
082600 ENTRY 'SETLANGES'.
082700   CALL 'SETLANG' USING 'es'.
082800   GOBACK.
