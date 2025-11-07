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
003800     10 COBOL-A PIC X(1000).
003900     10 PERCENT PIC X(5).
004000     10 COBOL-B PIC X(1000).
004100     10 NB PIC X(1) VALUE X'00'.
004200   05 ES.
004300     10 TAB PIC X(12) VALUE '&nbsp;&nbsp;'.
004400     10 ABOUT-ME PIC X(1000).
004500     10 NB PIC X(1) VALUE X'00'.
004600     10 COBOL-A PIC X(1000).
004700     10 PERCENT PIC X(5).
004800     10 COBOL-B PIC X(1000).
004900     10 NB PIC X(1) VALUE X'00'.
005000*This has to be pic 10 as that is what is returned from
005100*the library.
005200 LINKAGE SECTION.
005300 01 LS-BLOB PIC X(100000).
005400 01 LS-BLOB-SIZE PIC 9(10).
005500 01 LS-LANG-CHOICE PIC XX.
005600 01 LS-TERM-IN PIC X(10).
005700 PROCEDURE DIVISION.
005800 MAIN SECTION.
005900 ENTRY 'MAIN'.
006000   CALL 'cobdom_style' USING 'body', 'margin', '0'.
006100*  CALL 'cobdom_style' USING 'body', 'color', '#ffffff'.
006200   CALL 'cobdom_style' USING 'body', 'fontSize', '1.5rem'.
006300   CALL 'cobdom_style' USING 'body', 'display', 'flex'.
006400   CALL 'cobdom_style' USING 'body', 'alignItems', 'center'.
006500   CALL 'cobdom_style' USING 'body', 'justifyContent', 'center'.
006600   CALL 'cobdom_add_event_listener' USING 'window', 'resize', 
006700     'WINDOWCHANGE'.
006800   CALL 'cobdom_add_event_listener' USING 'window', 
006900     'orientationchange', 'WINDOWCHANGE'.
007000   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
007100     'allowCookies'.
007200   CALL 'cobdom_create_element' USING 'percentCobol', 'span'.
007300   CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
007400     '/res/percent.txt', 'GET', WS-NULL-BYTE.
007500*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
007600*Setup content div
007700   CALL 'cobdom_create_element' USING 'contentDiv', 'div'.
007800   CALL 'cobdom_style' USING 'contentDiv', 'marginTop', '10rem'.
007900   CALL 'cobdom_style' USING 'contentDiv', 'marginBottom', 
008000     '2rem'.
008100*  CALL 'cobdom_inner_html' USING 'contentDiv', 
008200   CALL 'cobdom_style' USING 'contentDiv', 'maxWidth', '80rem'.
008300   CALL 'cobdom_style' USING 'contentDiv', 'backgroundColor',
008400     'brown'.
008500   CALL 'cobdom_style' USING 'contentDiv', 'width', '100%'.
008600*  CALL 'cobdom_style' USING 'contentDiv', 'height', '100vh'.
008700   CALL 'cobdom_style' USING 'contentDiv', 'display', 'flex'.
008800   CALL 'cobdom_style' USING 'contentDiv', 'flexDirection',
008900     'column'.
009000   CALL 'cobdom_style' USING 'contentDiv', 'alignItems',
009100     'flex-start'.
009200   CALL 'cobdom_append_child' USING 'contentDiv', 'body'.
009300*Set up blink style
009400   CALL 'cobdom_create_element' USING 'blinkStyle', 'style'.
009500   CALL 'cobdom_inner_html' USING 'blinkStyle', 
009600 '.blink { animation: blink 1s step-start infinite; } @keyframes b
009700-'link { 50% { opacity: 0; } }'.
009800   PERFORM BUILD-MENUBAR.
009900   PERFORM BUILD-CONTENT.
010000*Load and set fonts
010100   CALL 'cobdom_font_face' USING 'mainFont',
010200     'url("/res/fonts/1971-ibm-3278/3270-Regular.ttf")',
010300*    'url("/res/fonts/Proggy/ProggyVector-Regular.otf")',
010400     'FONTLOADED'.
010500   CALL 'cobdom_font_face' USING 'ibmpc',
010600*    'url("/res/fonts/1977-commodore-pet/PetMe.ttf")',
010700     'url("/res/fonts/1985-ibm-pc-vga/PxPlus_IBM_VGA8.ttf")',
010800     'FONTLOADED'.
010900*Load texts
011000   PERFORM LOAD-TEXTS.
011100*Terminal
011200*  CALL 'cobdom_create_element' USING 'terminalDiv', 'div'.
011300*  CALL 'cobdom_append_child' USING 'terminalDiv', 'contentDiv'.
011400*  CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB,
011500*    '(function() { window["term"] = new Terminal(); window["term"
011600*'].open(window["terminalDiv"]); term.onData(data => { Module.ccal
011700*'l("TERMINPUT", null, ["string"], [data]); }); return ""; })()'.
011800*Check for cookies
011900   IF WS-COOKIE-ALLOWED = 'y' THEN
012000     PERFORM LANG-CHECK
012100*GET LAST LOGIN
012200   ELSE
012300     PERFORM COOKIE-ASK
012400     MOVE 'us' TO WS-LANG
012500     PERFORM SET-ACTIVE-FLAG
012600   END-IF.
012700*Render
012800   CALL 'SHAPEPAGE'.
012900   GOBACK.
013000 RELOAD-TEXT.
013100   CONTINUE.
013200 BUILD-CONTENT.
013300*  CALL 'cobdom_create_element' USING 'profilePic', 'img'.
013400*  CALL 'cobdom_src' USING 'profilePic', '/res/img/me.png'.
013500*  CALL 'cobdom_style' USING 'profilePic', 'width', '20rem'.
013600*  CALL 'cobdom_style' USING 'profilePic', 'height', '20rem'.
013700*  CALL 'cobdom_style' USING 'profilePic', 'borderRadius', '50%'.
013800*  CALL 'cobdom_style' USING 'profilePic', 'objectFit', 'cover'.
013900*  CALL 'cobdom_style' USING 'profilePic', 'objectPosition',
014000*    '50% 0%'.
014100*  CALL 'cobdom_style' USING 'profilePic', 'height', '20rem'.
014200* 
014300*  CALL 'cobdom_append_child' USING 'profilePic', 'introContent'.
014400*About section
014500   CALL 'cobdom_create_element' USING 'aboutSection', 'div'.
014600   CALL 'cobdom_style' USING 'aboutSection', 'width', '100%'.
014700   CALL 'cobdom_create_element' USING 'aboutHeader', 'div'.
014800   CALL 'cobdom_set_class' USING 'aboutHeader',
014900     'contentHeadersClass'.
015000   CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me:'.
015100   CALL 'cobdom_create_element' USING 'aboutContent', 'div'.
015200   CALL 'cobdom_append_child' USING 'aboutSection',
015300     'contentDiv'.
015400   CALL 'cobdom_append_child' USING 'aboutHeader',
015500     'aboutSection'.
015600   CALL 'cobdom_append_child' USING 'aboutContent',
015700     'aboutSection'.
015800   CALL 'cobdom_create_element' USING 'ghStatsImg', 'img'.
015900   CALL 'cobdom_src' USING 'ghStatsImg', 'https://github-readme-st
016000-'ats.vercel.app/api/top-langs?username=BalakeKarbon&show_icons=tr
016100-'ue&locale=en&layout=compact&hide=html&theme=dark&hide_title=true
016200-'&card_width=500'.
016300   CALL 'cobdom_style' USING 'ghStatsImg', 'height', '15rem'.
016400   CALL 'cobdom_style' USING 'ghStatsImg', 'width', '100%'.
016500   CALL 'cobdom_append_child' USING 'ghStatsImg', 'aboutSection'.
016600*Contact section / Links / Socials
016700*Email,
016800*GitHub, LinkedIN
016900*Youtube, TikTok, Instagram,
017000   CALL 'cobdom_create_element' USING 'contactSection', 'div'.
017100   CALL 'cobdom_style' USING 'contactSection', 'width', '100%'.
017200   CALL 'cobdom_create_element' USING 'contactHeader', 'div'.
017300   CALL 'cobdom_set_class' USING 'contactHeader',
017400     'contentHeadersClass'.
017500   CALL 'cobdom_inner_html' USING 'contactHeader',
017600     'Contact Information:'.
017700   CALL 'cobdom_create_element' USING 'contactContent', 'div'.
017800   CALL 'cobdom_style' USING 'contactContent', 'width', '100%'.
017900   CALL 'cobdom_style' USING 'contactContent', 'textAlign',
018000     'center'.
018100   CALL 'cobdom_append_child' USING 'contactSection',
018200     'contentDiv'.
018300   CALL 'cobdom_append_child' USING 'contactHeader',
018400     'contactSection'.
018500   CALL 'cobdom_append_child' USING 'contactContent',
018600     'contactSection'.
018700   CALL 'cobdom_create_element' USING 'emailDiv', 'div'.
018800   CALL 'cobdom_inner_html' USING 'emailDiv',
018900     'karboncodes@gmail.com'.
019000   CALL 'cobdom_create_element' USING 'linksDiv', 'div'.
019100   CALL 'cobdom_style' USING 'linksDiv', 'display', 'flex'.
019200   CALL 'cobdom_style' USING 'linksDiv', 'width', '100%'.
019300   CALL 'cobdom_style' USING 'linksDiv', 'justifyContent',
019400     'center'.
019500*The following section could be done with a loop but it is not
019600*which is horrid
019700*GitHub
019800   CALL 'cobdom_create_element' USING 'ghContainer', 'span'.
019900   CALL 'cobdom_set_class' USING 'ghContainer',
020000     'contactContainer'.
020100   CALL 'cobdom_create_element' USING 'ghImage', 'img'.
020200   CALL 'cobdom_src' USING 'ghImage', 
020300     '/res/icons/tabler-icons/icons/outline/brand-github.svg'.
020400   CALL 'cobdom_style' USING 'ghImage', 'width', '6rem'.
020500   CALL 'cobdom_style' USING 'ghImage', 'height', '6rem'.
020600   CALL 'cobdom_create_element' USING 'ghText', 'div'.
020700   CALL 'cobdom_inner_html' USING 'ghText', 'GitHub'.
020800   CALL 'cobdom_append_child' USING 'ghImage', 'ghContainer'.
020900   CALL 'cobdom_append_child' USING 'ghText', 'ghContainer'.
021000   CALL 'cobdom_append_child' USING 'ghContainer', 'linksDiv'.
021100*LinkedIn
021200   CALL 'cobdom_create_element' USING 'liContainer', 'span'.
021300   CALL 'cobdom_set_class' USING 'liContainer',
021400     'contactContainer'.
021500   CALL 'cobdom_create_element' USING 'liImage', 'img'.
021600   CALL 'cobdom_src' USING 'liImage', 
021700     '/res/icons/tabler-icons/icons/outline/brand-linkedin.svg'.
021800   CALL 'cobdom_style' USING 'liImage', 'width', '6rem'.
021900   CALL 'cobdom_style' USING 'liImage', 'height', '6rem'.
022000   CALL 'cobdom_create_element' USING 'liText', 'div'.
022100   CALL 'cobdom_inner_html' USING 'liText', 'Linkedin'.
022200   CALL 'cobdom_append_child' USING 'liImage', 'liContainer'.
022300   CALL 'cobdom_append_child' USING 'liText', 'liContainer'.
022400   CALL 'cobdom_append_child' USING 'liContainer', 'linksDiv'.
022500*Youtube
022600   CALL 'cobdom_create_element' USING 'ytContainer', 'span'.
022700   CALL 'cobdom_set_class' USING 'ytContainer',
022800     'contactContainer'.
022900   CALL 'cobdom_create_element' USING 'ytImage', 'img'.
023000   CALL 'cobdom_src' USING 'ytImage', 
023100     '/res/icons/tabler-icons/icons/outline/brand-youtube.svg'.
023200   CALL 'cobdom_style' USING 'ytImage', 'width', '6rem'.
023300   CALL 'cobdom_style' USING 'ytImage', 'height', '6rem'.
023400   CALL 'cobdom_create_element' USING 'ytText', 'div'.
023500   CALL 'cobdom_inner_html' USING 'ytText', 'Youtube'.
023600   CALL 'cobdom_append_child' USING 'ytImage', 'ytContainer'.
023700   CALL 'cobdom_append_child' USING 'ytText', 'ytContainer'.
023800   CALL 'cobdom_append_child' USING 'ytContainer', 'linksDiv'.
023900*TikTok
024000   CALL 'cobdom_create_element' USING 'ttContainer', 'span'.
024100   CALL 'cobdom_set_class' USING 'ttContainer',
024200     'contactContainer'.
024300   CALL 'cobdom_create_element' USING 'ttImage', 'img'.
024400   CALL 'cobdom_src' USING 'ttImage', 
024500     '/res/icons/tabler-icons/icons/outline/brand-tiktok.svg'.
024600   CALL 'cobdom_style' USING 'ttImage', 'width', '6rem'.
024700   CALL 'cobdom_style' USING 'ttImage', 'height', '6rem'.
024800   CALL 'cobdom_create_element' USING 'ttText', 'div'.
024900   CALL 'cobdom_inner_html' USING 'ttText', 'TikTok'.
025000   CALL 'cobdom_append_child' USING 'ttImage', 'ttContainer'.
025100   CALL 'cobdom_append_child' USING 'ttText', 'ttContainer'.
025200   CALL 'cobdom_append_child' USING 'ttContainer', 'linksDiv'.
025300*Instagram
025400   CALL 'cobdom_create_element' USING 'igContainer', 'span'.
025500   CALL 'cobdom_set_class' USING 'igContainer',
025600     'contactContainer'.
025700   CALL 'cobdom_create_element' USING 'igImage', 'img'.
025800   CALL 'cobdom_src' USING 'igImage', 
025900     '/res/icons/tabler-icons/icons/outline/brand-instagram.svg'.
026000   CALL 'cobdom_style' USING 'igImage', 'width', '6rem'.
026100   CALL 'cobdom_style' USING 'igImage', 'height', '6rem'.
026200   CALL 'cobdom_create_element' USING 'igText', 'div'.
026300   CALL 'cobdom_inner_html' USING 'igText', 'Instagram'.
026400   CALL 'cobdom_append_child' USING 'igImage', 'igContainer'.
026500   CALL 'cobdom_append_child' USING 'igText', 'igContainer'.
026600   CALL 'cobdom_append_child' USING 'igContainer', 'linksDiv'.
026700 
026800   CALL 'cobdom_append_child' USING 'emailDiv', 'contactContent'.
026900   CALL 'cobdom_append_child' USING 'linksDiv', 'contactContent'.
027000*Skills section
027100*  CALL 'cobdom_create_element' USING 'skillsSection', 'div'.
027200*  CALL 'cobdom_style' USING 'skillsSection', 'width', '100%'.
027300*  CALL 'cobdom_create_element' USING 'skillsHeader', 'div'.
027400*  CALL 'cobdom_set_class' USING 'skillsHeader',
027500*    'contentHeadersClass'.
027600*  CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills:'.
027700*  CALL 'cobdom_create_element' USING 'skillsContent', 'div'.
027800*
027900*  CALL 'cobdom_append_child' USING 'skillsSection',
028000*    'contentDiv'.
028100*  CALL 'cobdom_append_child' USING 'skillsHeader',
028200*    'skillsSection'.
028300*  CALL 'cobdom_append_child' USING 'skillsContent',
028400*    'skillsSection'.
028500*Project section
028600   CALL 'cobdom_create_element' USING 'projectSection', 'div'.
028700   CALL 'cobdom_style' USING 'projectSection', 'width', '100%'.
028800   CALL 'cobdom_create_element' USING 'projectHeader', 'div'.
028900   CALL 'cobdom_set_class' USING 'projectHeader',
029000     'contentHeadersClass'.
029100   CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects:'.
029200   CALL 'cobdom_create_element' USING 'projectContent', 'div'.
029300   CALL 'cobdom_append_child' USING 'projectSection', 
029400     'contentDiv'.
029500   CALL 'cobdom_append_child' USING 'projectHeader', 
029600     'projectSection'.
029700   CALL 'cobdom_append_child' USING 'projectContent', 
029800     'projectSection'.
029900*Cobol section
030000   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
030100   CALL 'cobdom_style' USING 'cobolSection', 'width', '100%'.
030200   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
030300   CALL 'cobdom_set_class' USING 'cobolHeader',
030400     'contentHeadersClass'.
030500   CALL 'cobdom_inner_html' USING 'cobolHeader', 'COBOL'.
030600   CALL 'cobdom_create_element' USING 'cobolContent', 'span'.
030700   CALL 'cobdom_append_child' USING 'cobolSection',
030800     'contentDiv'.
030900   CALL 'cobdom_append_child' USING 'cobolHeader', 
031000     'cobolSection'.
031100   CALL 'cobdom_append_child' USING 'cobolContent', 
031200     'cobolSection'.
031300   CALL 'cobdom_create_element' USING 'cobolGithubLink',
031400     'span'.
031500   CALL 'cobdom_inner_html' USING 'cobolGithubLink',
031600     'GitHub.'.
031700   CALL 'cobdom_append_child' USING 'cobolGithubLink',
031800     'cobolSection'.
031900*Set contentHeadersClass class styles. Must be called after elements
032000*exist as this uses getElementsByClassName. A safer option would
032100*be to make a new style element but for the sake of demnostrating
032200*this part of the library I will use this here.
032300   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
032400     'fontSize', '2.5rem'.
032500   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
032600     'width', '100%'.
032700   CALL 'cobdom_class_style' USING 'contentHeadersClass', 
032800     'textAlign', 'center'.
032900   CALL 'cobdom_class_style' USING 'contentHeadersClass',
033000     'fontWeight', 'bold'.
033100   CALL 'cobdom_class_style' USING 'contactContainer', 'margin',
033200     '1rem'.
033300  CALL 'cobdom_class_style' USING 'contactContainer', 'display',
033400     'flex'. 
033500   CALL 'cobdom_class_style' USING 'contactContainer',
033600     'flexDirection', 'column'.
033700   CALL 'cobdom_class_style' USING 'contactContainer',
033800     'alignItems', 'center'.
033900   CONTINUE.
034000 BUILD-MENUBAR.
034100   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
034200   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
034300   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
034400   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
034500     'space-between'.
034600   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
034700   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
034800   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
034900   CALL 'cobdom_style' USING 'headerDiv', 'backgroundColor',
035000     '#c0c0c0'.
035100*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
035200*    'blur(5px)'.
035300*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
035400*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
035500*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
035600*    '1rem'.
035700*  CALL 'cobdom_style' USING 'headerDiv',
035800*    'borderBottomRightRadius','1rem'.
035900   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
036000*Setup menu
036100   CALL 'cobdom_create_element' USING 'navArea', 'div'.
036200*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
036300   CALL 'cobdom_create_element' USING 'navButton', 'img'.
036400   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
036500   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
036600   CALL 'cobdom_src' USING 'navButton', 
036700     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
036800   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
036900     '#D9D4C7'.
037000*  CALL 'cobdom_style' USING 'navButton', 'filter', 
037100*    'invert(100%)'.
037200   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
037300   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
037400   CALL 'cobdom_style' USING 'navButton', 'padding', '.25rem'.
037500   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
037600   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
037700   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
037800   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
037900*Setup menu selectors
038000*About Me
038100   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
038200   CALL 'cobdom_style' USING 'navAbout', 'position', 'absolute'.
038300   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
038400     '#c0c0c0'.
038500*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
038600*    'blur(5px)'.
038700   CALL 'cobdom_style' USING 'navAbout', 
038800     'borderBottomRightRadius', '0.5rem'.
038900   CALL 'cobdom_style' USING 'navAbout', 
039000     'borderTopRightRadius', '0.5rem'.
039100   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
039200   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
039300   CALL 'cobdom_style' USING 'navAbout', 'top', '9rem'.
039400   CALL 'cobdom_style' USING 'navAbout', 'left', '-15rem'.
039500   CALL 'cobdom_style' USING 'navAbout', 'transition', 
039600     'transform 0.5s ease 0.1s'.
039700   CALL 'cobdom_append_child' USING 'navAbout', 'headerDiv'.
039800*Contact Me
039900   CALL 'cobdom_create_element' USING 'navContact', 'div'.
040000   CALL 'cobdom_style' USING 'navContact', 'position', 'absolute'.
040100   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
040200     '#c0c0c0'.
040300*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
040400*    'blur(5px)'.
040500   CALL 'cobdom_style' USING 'navContact', 
040600     'borderBottomRightRadius', '0.5rem'.
040700   CALL 'cobdom_style' USING 'navContact', 
040800     'borderTopRightRadius', '0.5rem'.
040900   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
041000   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
041100   CALL 'cobdom_style' USING 'navContact', 'top', '11rem'.
041200   CALL 'cobdom_style' USING 'navContact', 'left', '-15rem'.
041300   CALL 'cobdom_style' USING 'navContact', 'transition', 
041400     'transform 0.5s ease 0.2s'.
041500   CALL 'cobdom_append_child' USING 'navContact', 'headerDiv'.
041600*Skills
041700*  CALL 'cobdom_create_element' USING 'navSkills', 'div'.
041800*  CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
041900*  CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
042000*    '#c0c0c0'.
042100*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
042200*    'blur(5px)'.
042300*  CALL 'cobdom_style' USING 'navSkills', 
042400*    'borderBottomRightRadius', '0.5rem'.
042500*  CALL 'cobdom_style' USING 'navSkills', 
042600*    'borderTopRightRadius', '0.5rem'.
042700*  CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
042800*  CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
042900*  CALL 'cobdom_style' USING 'navSkills', 'top', '13rem'.
043000*  CALL 'cobdom_style' USING 'navSkills', 'left', '-15rem'.
043100*  CALL 'cobdom_style' USING 'navSkills', 'transition', 
043200*    'transform 0.5s ease 0.3s'.
043300*  CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
043400*Projects
043500   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
043600   CALL 'cobdom_style' USING 'navProjects', 'position', 
043700     'absolute'.
043800   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
043900     '#c0c0c0'.
044000*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
044100*    'blur(5px)'.
044200   CALL 'cobdom_style' USING 'navProjects', 
044300     'borderBottomRightRadius', '0.5rem'.
044400   CALL 'cobdom_style' USING 'navProjects', 
044500     'borderTopRightRadius', '0.5rem'.
044600   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
044700   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
044800   CALL 'cobdom_style' USING 'navProjects', 'top', '13rem'.
044900   CALL 'cobdom_style' USING 'navProjects', 'left', '-15rem'.
045000   CALL 'cobdom_style' USING 'navProjects', 'transition', 
045100     'transform 0.5s ease 0.4s'.
045200   CALL 'cobdom_append_child' USING 'navProjects', 'headerDiv'.
045300*Cobol?
045400   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
045500   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
045600   CALL 'cobdom_style' USING 'navCobol', 'position', 
045700     'absolute'.
045800   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
045900     '#000000'.
046000*    '#c0c0c0'.
046100*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
046200*    'blur(5px)'.
046300   CALL 'cobdom_style' USING 'navCobol', 'color', 
046400     '#00ff00'.
046500   CALL 'cobdom_style' USING 'navCobol', 
046600     'borderBottomRightRadius', '0.5rem'.
046700   CALL 'cobdom_style' USING 'navCobol', 
046800     'borderTopRightRadius', '0.5rem'.
046900   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
047000   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
047100   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
047200   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
047300   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
047400   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
047500   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
047600   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
047700   CALL 'cobdom_style' USING 'navCobol', 'top', '15rem'.
047800   CALL 'cobdom_style' USING 'navCobol', 'left', '-15rem'.
047900   CALL 'cobdom_style' USING 'navCobol', 'transition', 
048000     'transform 0.5s ease 0.5s'.
048100   CALL 'cobdom_append_child' USING 'navCobol', 'headerDiv'.
048200*Add main menu button
048300   CALL 'cobdom_append_child' USING 'navArea', 'headerDiv'.
048400   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
048500     'MENUTOGGLE'.
048600*Setup ID area
048700   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
048800   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
048900   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
049000   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
049100   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '4rem'.
049200   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
049300   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
049400   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
049500   CALL 'cobdom_inner_html' USING 'taglineDiv', 
049600     'A guy that knows a guy.'.
049700   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
049800   CALL 'cobdom_append_child' USING 'idDiv', 'headerDiv'.
049900*Setup lang area
050000   CALL 'cobdom_create_element' USING 'langArea', 'span'.
050100   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
050200   CALL 'cobdom_append_child' USING 'langArea', 'headerDiv'.
050300*Setup language selector
050400   CALL 'cobdom_create_element' USING 'langUS', 'img'.
050500   CALL 'cobdom_create_element' USING 'langES', 'img'.
050600   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
050700   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
050800   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
050900   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
051000   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
051100   CALL 'cobdom_style' USING 'langUS', 'transition', 
051200     'opacity 0.5s ease, transform 0.5s ease'.
051300*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
051400*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
051500   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
051600   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
051700   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
051800   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
051900   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
052000   CALL 'cobdom_style' USING 'langES', 'transition', 
052100     'opacity 0.5s ease, transform 0.5s ease'.
052200*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
052300*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
052400   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
052500   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
052600     'SETLANGUS'.
052700   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
052800   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
052900     'SETLANGES'.
053000   CONTINUE.
053100 SET-ACTIVE-FLAG.
053200   IF WS-LANG = 'us' THEN
053300     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
053400     CALL 'cobdom_style' USING 'langUS', 'transform', 
053500       'translate(9rem, 0rem)'
053600     PERFORM UPDATE-TEXT
053700   ELSE
053800     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
053900     CALL 'cobdom_style' USING 'langUS', 'transform', 
054000       'translate(9rem, 0rem)'
054100     PERFORM UPDATE-TEXT
054200   END-IF.
054300   CONTINUE.
054400 LOAD-TEXTS.
054500   CALL 'cobdom_fetch' USING 'LOADENAM',
054600     '/res/text/en/aboutme.txt', 'GET', WS-NULL-BYTE.
054700   CALL 'cobdom_fetch' USING 'LOADESAM',
054800     '/res/text/es/aboutme.txt', 'GET', WS-NULL-BYTE.
054900   CALL 'cobdom_fetch' USING 'LOADENCOBA',
055000     '/res/text/en/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
055100   CALL 'cobdom_fetch' USING 'LOADENCOBB',
055200     '/res/text/en/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
055300   CALL 'cobdom_fetch' USING 'LOADESCOBA',
055400     '/res/text/es/cobol/cobolA.txt', 'GET', WS-NULL-BYTE.
055500   CALL 'cobdom_fetch' USING 'LOADESCOBB',
055600     '/res/text/es/cobol/cobolB.txt', 'GET', WS-NULL-BYTE.
055700   CONTINUE.
055800 UPDATE-TEXT.
055900   IF WS-LANG = 'us' THEN
056000     CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me'
056100     CALL 'cobdom_inner_html' USING 'contactHeader',
056200       'Contact Information / Links'
056300*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills'
056400     CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects'
056500     CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'
056600     CALL 'cobdom_inner_html' USING 'navContact', 'Contact/Links'
056700*    CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'
056800     CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'
056900     CALL 'cobdom_inner_html' USING 'aboutContent',
057000       TAB OF EN OF WS-TEXTS
057100     CALL 'cobdom_inner_html' USING 'cobolContent',
057200       COBOL-A OF EN OF WS-TEXTS
057300   ELSE
057400     CALL 'cobdom_inner_html' USING 'aboutHeader', 'Sobre Mi'
057500     CALL 'cobdom_inner_html' USING 'contactHeader',
057600       'Informacion de Contacto / Enlaces'
057700*    CALL 'cobdom_inner_html' USING 'skillsHeader', 'Habilidades'
057800     CALL 'cobdom_inner_html' USING 'projectHeader', 'Proyectos'
057900     CALL 'cobdom_inner_html' USING 'navAbout', 'Sobre Mi'
058000     CALL 'cobdom_inner_html' USING 'navContact',
058100       'Contacto/Enlaces'
058200*    CALL 'cobdom_inner_html' USING 'navSkills', 'Habilidades'
058300     CALL 'cobdom_inner_html' USING 'navProjects', 'Proyectos'
058400     CALL 'cobdom_inner_html' USING 'aboutContent',
058500       TAB OF ES OF WS-TEXTS
058600     CALL 'cobdom_inner_html' USING 'cobolContent',
058700       COBOL-A OF ES OF WS-TEXTS
058800   END-IF.
058900   CONTINUE.
059000 LANG-CHECK.
059100   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
059200     'lang'.
059300   IF WS-LANG = WS-NULL-BYTE THEN
059400     CALL 'cobdom_set_cookie' USING 'us', 'lang'
059500     MOVE 'us' TO WS-LANG
059600   END-IF.
059700   PERFORM SET-ACTIVE-FLAG.
059800   CONTINUE.
059900 COOKIE-ASK.
060000   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
060100   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
060200   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
060300   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
060400   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
060500   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
060600     '#00ff00'.
060700   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
060800     'center'.
060900   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
061000-'llow cookies to store your preferences such as language?&nbsp;'.
061100   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
061200   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
061300   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
061400   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
061500   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
061600   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
061700   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
061800   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
061900   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
062000   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
062100   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
062200   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
062300   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
062400     'COOKIEACCEPT'.
062500   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
062600     'COOKIEDENY'.
062700   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
062800   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
062900   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
063000*Note this must be called after the elements are added to the
063100*document because it must search for them.
063200   CALL 'cobdom_class_style' USING 'cookieButton', 
063300     'backgroundColor', '#ff0000'.
063400   CONTINUE.
063500 LOADENAM SECTION.
063600 ENTRY 'LOADENAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
063700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF EN OF WS-TEXTS.
063800   PERFORM UPDATE-TEXT.
063900   GOBACK.
064000 LOADESAM SECTION.
064100 ENTRY 'LOADESAM' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
064200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO ABOUT-ME OF ES OF WS-TEXTS.
064300   PERFORM UPDATE-TEXT.
064400   GOBACK.
064500 LOADENCOBA SECTION.
064600 ENTRY 'LOADENCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
064700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF EN OF WS-TEXTS.
064800   PERFORM UPDATE-TEXT.
064900   GOBACK.
065000 LOADENCOBB SECTION.
065100 ENTRY 'LOADENCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
065200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF EN OF WS-TEXTS.
065300   PERFORM UPDATE-TEXT.
065400   GOBACK.
065500 LOADESCOBA SECTION.
065600 ENTRY 'LOADESCOBA' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
065700   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-A OF ES OF WS-TEXTS.
065800   PERFORM UPDATE-TEXT.
065900   GOBACK.
066000 LOADESCOBB SECTION.
066100 ENTRY 'LOADESCOBB' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
066200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO COBOL-B OF ES OF WS-TEXTS.
066300*  DISPLAY ABOUT-ME OF ES OF WS-TEXTS.
066400   PERFORM UPDATE-TEXT.
066500   GOBACK.
066600 MENUTOGGLE SECTION.
066700 ENTRY 'MENUTOGGLE'.
066800   IF WS-MENU-TOGGLE = 0 THEN
066900     MOVE 1 TO WS-MENU-TOGGLE
067000     CALL 'cobdom_style' USING 'navButton', 'transform', 
067100       'scale(0.85)'
067200     CALL 'cobdom_src' USING 'navButton', 
067300       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
067400     CALL 'cobdom_style' USING 'navAbout', 'transform', 
067500       'translate(15rem, 0rem)' 
067600     CALL 'cobdom_style' USING 'navContact', 'transform', 
067700       'translate(15rem, 0rem)' 
067800     CALL 'cobdom_style' USING 'navSkills', 'transform', 
067900       'translate(15rem, 0rem)'
068000    CALL 'cobdom_style' USING 'navProjects', 'transform', 
068100       'translate(15rem, 0rem)'
068200    CALL 'cobdom_style' USING 'navCobol', 'transform', 
068300       'translate(15rem, 0rem)'
068400   ELSE
068500     MOVE 0 TO WS-MENU-TOGGLE
068600     CALL 'cobdom_style' USING 'navButton', 'transform', 
068700       'scale(1.0)'
068800     CALL 'cobdom_src' USING 'navButton', 
068900       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
069000     CALL 'cobdom_style' USING 'navAbout', 'transform', 
069100       'translate(0rem, 0rem)' 
069200     CALL 'cobdom_style' USING 'navContact', 'transform', 
069300       'translate(0rem, 0rem)' 
069400     CALL 'cobdom_style' USING 'navSkills', 'transform', 
069500       'translate(0rem, 0rem)'
069600    CALL 'cobdom_style' USING 'navProjects', 'transform', 
069700       'translate(0rem, 0rem)'
069800    CALL 'cobdom_style' USING 'navCobol', 'transform', 
069900       'translate(0rem, 0rem)'
070000   END-IF.
070100   GOBACK.
070200*TO-DO: Add a timer in case some fonts do never load
070300 FONTLOADED SECTION.
070400 ENTRY 'FONTLOADED'.
070500   ADD 1 TO WS-FONTS-LOADED.
070600   IF WS-FONTS-LOADED = 2 THEN
070700     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
070800     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
070900     CALL 'cobdom_style' USING 'cobolSection', 'fontFamily',
071000       'ibmpc'
071100   END-IF.
071200   GOBACK.
071300 WINDOWCHANGE SECTION.
071400 ENTRY 'WINDOWCHANGE'.
071500   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
071600   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
071700     '300'.
071800*Optimize this buffer time to not have a noticeable delay but also
071900*not call to often.
072000   GOBACK.
072100 SHAPEPAGE SECTION.
072200 ENTRY 'SHAPEPAGE'.
072300*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
072400*  DISPLAY 'Rendering! ' CENTISECS.
072500   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
072600     'window.innerWidth'.
072700   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
072800   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
072900     'window.innerHeight'.
073000   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
073100   GOBACK.
073200 COOKIEACCEPT SECTION.
073300 ENTRY 'COOKIEACCEPT'.
073400   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
073500   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
073600   MOVE 'y' TO WS-COOKIE-ALLOWED.
073700   IF WS-LANG = 'us' THEN
073800     CALL 'cobdom_set_cookie' USING 'us', 'lang'
073900   ELSE
074000     CALL 'cobdom_set_cookie' USING 'en', 'lang'
074100   END-IF.
074200   GOBACK.
074300 COOKIEDENY SECTION.
074400 ENTRY 'COOKIEDENY'.
074500   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
074600   MOVE 'n' TO WS-COOKIE-ALLOWED.
074700   GOBACK.
074800 SETPERCENTCOBOL SECTION.
074900 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
075000   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF EN OF WS-TEXTS.
075100   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO PERCENT OF ES OF WS-TEXTS.
075200*  CALL 'cobdom_inner_html' USING 'percentCobol',
075300*    WS-PERCENT-COBOL.
075400*  DISPLAY 'Currently this website is written in ' 
075500*    WS-PERCENT-COBOL '% COBOL.'.
075600   GOBACK.
075700 SETLANG SECTION.
075800 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
075900   if WS-LANG-SELECT-TOGGLE = 0 THEN
076000     MOVE 1 TO WS-LANG-SELECT-TOGGLE
076100     IF WS-LANG = 'us' THEN
076200       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
076300       CALL 'cobdom_style' USING 'langUS', 'transform', 
076400         'translate(0rem, 0rem)'
076500*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
076600     ELSE
076700       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
076800       CALL 'cobdom_style' USING 'langUS', 'transform', 
076900         'translate(0rem, 0rem)'
077000*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
077100     END-IF
077200   ELSE
077300     MOVE 0 TO WS-LANG-SELECT-TOGGLE
077400     IF WS-COOKIE-ALLOWED = 'y' THEN
077500       IF LS-LANG-CHOICE = 'us' THEN
077600         CALL 'cobdom_set_cookie' USING 'us', 'lang'
077700         MOVE 'us' TO WS-LANG
077800       ELSE
077900         CALL 'cobdom_set_cookie' USING 'es', 'lang'
078000         MOVE 'es' TO WS-LANG
078100       END-IF
078200       PERFORM SET-ACTIVE-FLAG
078300     ELSE
078400       MOVE LS-LANG-CHOICE TO WS-LANG
078500       PERFORM SET-ACTIVE-FLAG 
078600     END-IF
078700   END-IF.
078800   GOBACK.
078900 SETLANGUS SECTION.
079000 ENTRY 'SETLANGUS'.
079100   CALL 'SETLANG' USING 'us'.
079200   GOBACK.
079300 SETLANGES SECTION.
079400 ENTRY 'SETLANGES'.
079500   CALL 'SETLANG' USING 'es'.
079600   GOBACK.
079700*TERMINPUT SECTION.
079800*ENTRY 'TERMINPUT' USING LS-TERM-IN.
079900*  DISPLAY LS-TERM-IN.
080000*  GOBACK.
