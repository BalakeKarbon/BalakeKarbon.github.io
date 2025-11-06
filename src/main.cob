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
003300*This has to be pic 10 as that is what is returned from
003400*the library.
003500 LINKAGE SECTION.
003600 01 LS-BLOB PIC X(100000).
003700 01 LS-BLOB-SIZE PIC 9(10).
003800 01 LS-LANG-CHOICE PIC XX.
003900 01 LS-TERM-IN PIC X(10).
004000 PROCEDURE DIVISION.
004100 MAIN SECTION.
004200 ENTRY 'MAIN'.
004300   CALL 'cobdom_style' USING 'body', 'margin', '0'.
004400*  CALL 'cobdom_style' USING 'body', 'color', '#ffffff'.
004500   CALL 'cobdom_style' USING 'body', 'fontSize', '2rem'.
004600   CALL 'cobdom_style' USING 'body', 'display', 'flex'.
004700   CALL 'cobdom_style' USING 'body', 'alignItems', 'center'.
004800   CALL 'cobdom_style' USING 'body', 'justifyContent', 'center'.
004900   CALL 'cobdom_add_event_listener' USING 'window', 'resize', 
005000     'WINDOWCHANGE'.
005100   CALL 'cobdom_add_event_listener' USING 'window', 
005200     'orientationchange', 'WINDOWCHANGE'.
005300   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-COOKIE-ALLOWED,
005400     'allowCookies'.
005500   CALL 'cobdom_create_element' USING 'percentCobol', 'span'.
005600*  CALL 'cobdom_fetch' USING 'SETPERCENTCOBOL',
005700*    '/res/percent.txt', 'GET', WS-NULL-BYTE.
005800*  CALL 'cobdom_append_child' USING 'percentCobol', 'contentDiv'
005900*Setup content div
006000   CALL 'cobdom_create_element' USING 'contentDiv', 'div'.
006100   CALL 'cobdom_style' USING 'contentDiv', 'marginTop', '10rem'.
006200*  CALL 'cobdom_inner_html' USING 'contentDiv', 
006300*    'ALL KINDS OF TEST CONTENT HERE WOO HOO I WONER WHAT THIS WIL
006400*'L ALL LOOK LIKE MUAHAHAHAHAHAHAHAHAHHAHA'.
006500   CALL 'cobdom_style' USING 'contentDiv', 'maxWidth', '80rem'.
006600   CALL 'cobdom_style' USING 'contentDiv', 'backgroundColor',
006700     'brown'.
006800   CALL 'cobdom_style' USING 'contentDiv', 'width', '100%'.
006900*  CALL 'cobdom_style' USING 'contentDiv', 'height', '100vh'.
007000   CALL 'cobdom_style' USING 'contentDiv', 'display', 'flex'.
007100   CALL 'cobdom_style' USING 'contentDiv', 'flexDirection',
007200     'column'.
007300   CALL 'cobdom_style' USING 'contentDiv', 'alignItems',
007400     'flex-start'.
007500   CALL 'cobdom_append_child' USING 'contentDiv', 'body'.
007600*Set up blink style
007700   CALL 'cobdom_create_element' USING 'blinkStyle', 'style'.
007800   CALL 'cobdom_inner_html' USING 'blinkStyle', 
007900 '.blink { animation: blink 1s step-start infinite; } @keyframes b
008000-'link { 50% { opacity: 0; } }'.
008100   PERFORM BUILD-MENUBAR.
008200   PERFORM BUILD-CONTENT.
008300*Load and set fonts
008400   CALL 'cobdom_font_face' USING 'mainFont',
008500     'url("/res/fonts/Proggy/ProggyVector-Regular.otf")',
008600     'FONTLOADED'.
008700   CALL 'cobdom_font_face' USING 'ibmpc',
008800*    'url("/res/fonts/1977-commodore-pet/PetMe.ttf")',
008900     'url("/res/fonts/1985-ibm-pc-vga/PxPlus_IBM_VGA8.ttf")',
009000     'FONTLOADED'.
009100*Load texts
009200   PERFORM LOAD-TEXTS.
009300*Terminal
009400*  CALL 'cobdom_create_element' USING 'terminalDiv', 'div'.
009500*  CALL 'cobdom_append_child' USING 'terminalDiv', 'contentDiv'.
009600*  CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB,
009700*    '(function() { window["term"] = new Terminal(); window["term"
009800*'].open(window["terminalDiv"]); term.onData(data => { Module.ccal
009900*'l("TERMINPUT", null, ["string"], [data]); }); return ""; })()'.
010000*Check for cookies
010100   IF WS-COOKIE-ALLOWED = 'y' THEN
010200     PERFORM LANG-CHECK
010300*GET LAST LOGIN
010400   ELSE
010500     PERFORM COOKIE-ASK
010600     MOVE 'us' TO WS-LANG
010700     PERFORM SET-ACTIVE-FLAG
010800   END-IF.
010900*Render
011000   CALL 'SHAPEPAGE'.
011100   GOBACK.
011200 RELOAD-TEXT.
011300   CONTINUE.
011400 BUILD-CONTENT.
011500*  CALL 'cobdom_create_element' USING 'profilePic', 'img'.
011600*  CALL 'cobdom_src' USING 'profilePic', '/res/img/me.png'.
011700*  CALL 'cobdom_style' USING 'profilePic', 'width', '20rem'.
011800*  CALL 'cobdom_style' USING 'profilePic', 'height', '20rem'.
011900*  CALL 'cobdom_style' USING 'profilePic', 'borderRadius', '50%'.
012000*  CALL 'cobdom_style' USING 'profilePic', 'objectFit', 'cover'.
012100*  CALL 'cobdom_style' USING 'profilePic', 'objectPosition',
012200*    '50% 0%'.
012300*  CALL 'cobdom_style' USING 'profilePic', 'height', '20rem'.
012400* 
012500*  CALL 'cobdom_append_child' USING 'profilePic', 'introContent'.
012600*About section
012700   CALL 'cobdom_create_element' USING 'aboutSection', 'div'.
012800   CALL 'cobdom_create_element' USING 'aboutHeader', 'div'.
012900   CALL 'cobdom_set_class' USING 'aboutHeader',
013000     'contactHeadersClass'.
013100   CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me:'.
013200   CALL 'cobdom_create_element' USING 'aboutContent', 'div'.
013300   CALL 'cobdom_append_child' USING 'aboutSection',
013400     'contentDiv'.
013500   CALL 'cobdom_append_child' USING 'aboutHeader',
013600     'aboutSection'.
013700   CALL 'cobdom_append_child' USING 'aboutContent',
013800     'aboutSection'.
013900*Contact section / Links / Socials
014000*Email,
014100*GitHub, LinkedIN
014200*Youtube, TikTok, Instagram,
014300   CALL 'cobdom_create_element' USING 'contactSection', 'div'.
014400   CALL 'cobdom_create_element' USING 'contactHeader', 'div'.
014500   CALL 'cobdom_set_class' USING 'contactHeader',
014600     'contactHeadersClass'.
014700   CALL 'cobdom_inner_html' USING 'contactHeader',
014800     'Contact Information:'.
014900   CALL 'cobdom_create_element' USING 'contactContent', 'div'.
015000   CALL 'cobdom_append_child' USING 'contactSection',
015100     'contentDiv'.
015200   CALL 'cobdom_append_child' USING 'contactHeader',
015300     'contactSection'.
015400   CALL 'cobdom_append_child' USING 'contactContent',
015500     'contactSection'.
015600   CALL 'cobdom_create_element' USING 'emailDiv', 'div'.
015700   CALL 'cobdom_inner_html' USING 'emailDiv',
015800     'karboncodes@gmail.com'.
015900   CALL 'cobdom_create_element' USING 'linksDiv', 'div'.
016000   CALL 'cobdom_style' USING 'linksDiv', 'display', 'flex'.
016100*The following section could be done with a loop but it is not
016200*which is horrid
016300*GitHub
016400   CALL 'cobdom_create_element' USING 'ghContainer', 'span'.
016500   CALL 'cobdom_set_class' USING 'ghContainer',
016600     'contactContainer'.
016700   CALL 'cobdom_create_element' USING 'ghImage', 'img'.
016800   CALL 'cobdom_src' USING 'ghImage', 
016900     '/res/icons/tabler-icons/icons/outline/brand-github.svg'.
017000   CALL 'cobdom_style' USING 'ghImage', 'width', '6rem'.
017100   CALL 'cobdom_style' USING 'ghImage', 'height', '6rem'.
017200   CALL 'cobdom_create_element' USING 'ghLink', 'div'.
017300   CALL 'cobdom_inner_html' USING 'ghLink', 'GitHub'.
017400   CALL 'cobdom_append_child' USING 'ghImage', 'ghContainer'.
017500   CALL 'cobdom_append_child' USING 'ghLink', 'ghContainer'.
017600   CALL 'cobdom_append_child' USING 'ghContainer', 'linksDiv'.
017700*LinkedIn
017800   CALL 'cobdom_create_element' USING 'liContainer', 'span'.
017900   CALL 'cobdom_set_class' USING 'liContainer',
018000     'contactContainer'.
018100   CALL 'cobdom_create_element' USING 'liImage', 'img'.
018200   CALL 'cobdom_src' USING 'liImage', 
018300     '/res/icons/tabler-icons/icons/outline/brand-linkedin.svg'.
018400   CALL 'cobdom_style' USING 'liImage', 'width', '6rem'.
018500   CALL 'cobdom_style' USING 'liImage', 'height', '6rem'.
018600   CALL 'cobdom_create_element' USING 'liLink', 'div'.
018700   CALL 'cobdom_inner_html' USING 'liLink', 'Linkedin'.
018800   CALL 'cobdom_append_child' USING 'liImage', 'liContainer'.
018900   CALL 'cobdom_append_child' USING 'liLink', 'liContainer'.
019000   CALL 'cobdom_append_child' USING 'liContainer', 'linksDiv'.
019100*Youtube
019200   CALL 'cobdom_create_element' USING 'ytContainer', 'span'.
019300   CALL 'cobdom_set_class' USING 'ytContainer',
019400     'contactContainer'.
019500   CALL 'cobdom_create_element' USING 'ytImage', 'img'.
019600   CALL 'cobdom_src' USING 'ytImage', 
019700     '/res/icons/tabler-icons/icons/outline/brand-youtube.svg'.
019800   CALL 'cobdom_style' USING 'ytImage', 'width', '6rem'.
019900   CALL 'cobdom_style' USING 'ytImage', 'height', '6rem'.
020000   CALL 'cobdom_create_element' USING 'ytLink', 'div'.
020100   CALL 'cobdom_inner_html' USING 'ytLink', 'Youtube'.
020200   CALL 'cobdom_append_child' USING 'ytImage', 'ytContainer'.
020300   CALL 'cobdom_append_child' USING 'ytLink', 'ytContainer'.
020400   CALL 'cobdom_append_child' USING 'ytContainer', 'linksDiv'.
020500*TikTok
020600   CALL 'cobdom_create_element' USING 'ttContainer', 'span'.
020700   CALL 'cobdom_set_class' USING 'ttContainer',
020800     'contactContainer'.
020900   CALL 'cobdom_create_element' USING 'ttImage', 'img'.
021000   CALL 'cobdom_src' USING 'ttImage', 
021100     '/res/icons/tabler-icons/icons/outline/brand-tiktok.svg'.
021200   CALL 'cobdom_style' USING 'ttImage', 'width', '6rem'.
021300   CALL 'cobdom_style' USING 'ttImage', 'height', '6rem'.
021400   CALL 'cobdom_create_element' USING 'ttLink', 'div'.
021500   CALL 'cobdom_inner_html' USING 'ttLink', 'TikTok'.
021600   CALL 'cobdom_append_child' USING 'ttImage', 'ttContainer'.
021700   CALL 'cobdom_append_child' USING 'ttLink', 'ttContainer'.
021800   CALL 'cobdom_append_child' USING 'ttContainer', 'linksDiv'.
021900*Instagram
022000   CALL 'cobdom_create_element' USING 'igContainer', 'span'.
022100   CALL 'cobdom_set_class' USING 'igContainer',
022200     'contactContainer'.
022300   CALL 'cobdom_create_element' USING 'igImage', 'img'.
022400   CALL 'cobdom_src' USING 'igImage', 
022500     '/res/icons/tabler-icons/icons/outline/brand-instagram.svg'.
022600   CALL 'cobdom_style' USING 'igImage', 'width', '6rem'.
022700   CALL 'cobdom_style' USING 'igImage', 'height', '6rem'.
022800   CALL 'cobdom_create_element' USING 'igLink', 'div'.
022900   CALL 'cobdom_inner_html' USING 'igLink', 'Instagram'.
023000   CALL 'cobdom_append_child' USING 'igImage', 'igContainer'.
023100   CALL 'cobdom_append_child' USING 'igLink', 'igContainer'.
023200   CALL 'cobdom_append_child' USING 'igContainer', 'linksDiv'.
023300 
023400   CALL 'cobdom_append_child' USING 'emailDiv', 'contactContent'.
023500   CALL 'cobdom_append_child' USING 'linksDiv', 'contactContent'.
023600*Skills section
023700   CALL 'cobdom_create_element' USING 'skillsSection', 'div'.
023800   CALL 'cobdom_create_element' USING 'skillsHeader', 'div'.
023900   CALL 'cobdom_set_class' USING 'skillsHeader',
024000     'contactHeadersClass'.
024100   CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills:'.
024200   CALL 'cobdom_create_element' USING 'skillsContent', 'div'.
024300   CALL 'cobdom_append_child' USING 'skillsSection',
024400     'contentDiv'.
024500   CALL 'cobdom_append_child' USING 'skillsHeader',
024600     'skillsSection'.
024700   CALL 'cobdom_append_child' USING 'skillsContent',
024800     'skillsSection'.
024900*Project section
025000   CALL 'cobdom_create_element' USING 'projectSection', 'div'.
025100   CALL 'cobdom_create_element' USING 'projectHeader', 'div'.
025200   CALL 'cobdom_set_class' USING 'projectHeader',
025300     'contactHeadersClass'.
025400   CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects:'.
025500   CALL 'cobdom_create_element' USING 'projectContent', 'div'.
025600   CALL 'cobdom_append_child' USING 'projectSection', 
025700     'contentDiv'.
025800   CALL 'cobdom_append_child' USING 'projectHeader', 
025900     'projectSection'.
026000   CALL 'cobdom_append_child' USING 'projectContent', 
026100     'projectSection'.
026200*Cobol section
026300   CALL 'cobdom_create_element' USING 'cobolSection', 'div'.
026400   CALL 'cobdom_create_element' USING 'cobolHeader', 'div'.
026500   CALL 'cobdom_set_class' USING 'cobolHeader',
026600     'contactHeadersClass'.
026700   CALL 'cobdom_inner_html' USING 'cobolHeader', 'COBOL:'.
026800   CALL 'cobdom_create_element' USING 'cobolContent', 'div'.
026900   CALL 'cobdom_append_child' USING 'cobolSection',
027000     'contentDiv'.
027100   CALL 'cobdom_append_child' USING 'cobolHeader', 
027200     'cobolSection'.
027300   CALL 'cobdom_append_child' USING 'cobolContent', 
027400     'cobolSection'.
027500*Set contactHeadersClass class styles. Must be called after elements
027600*exist as this uses getElementsByClassName. A safer option would
027700*be to make a new style element but for the sake of demnostrating
027800*this part of the library I will use this here.
027900   CALL 'cobdom_class_style' USING 'contactHeadersClass', 
028000     'fontSize', '2.5rem'.
028100   CALL 'cobdom_class_style' USING 'contactHeadersClass',
028200     'fontWeight', 'bold'.
028300   CALL 'cobdom_class_style' USING 'contactContainer', 'margin',
028400     '1rem'.
028500  CALL 'cobdom_class_style' USING 'contactContainer', 'display',
028600     'flex'. 
028700   CALL 'cobdom_class_style' USING 'contactContainer',
028800     'flexDirection', 'column'.
028900   CALL 'cobdom_class_style' USING 'contactContainer',
029000     'alignItems', 'center'.
029100   CONTINUE.
029200 BUILD-MENUBAR.
029300   CALL 'cobdom_create_element' USING 'headerDiv', 'div'.
029400   CALL 'cobdom_style' USING 'headerDiv', 'position', 'fixed'.
029500   CALL 'cobdom_style' USING 'headerDiv', 'display', 'flex'.
029600   CALL 'cobdom_style' USING 'headerDiv', 'justifyContent', 
029700     'space-between'.
029800   CALL 'cobdom_style' USING 'headerDiv', 'top', '0'.
029900   CALL 'cobdom_style' USING 'headerDiv', 'left', '0'.
030000   CALL 'cobdom_style' USING 'headerDiv', 'width', '100%'.
030100   CALL 'cobdom_style' USING 'headerDiv', 'backgroundColor',
030200     '#c0c0c0'.
030300*  CALL 'cobdom_style' USING 'headerDiv', 'backdropFilter',
030400*    'blur(5px)'.
030500*  CALL 'cobdom_style' USING 'headerDiv', 'boxShadow', 
030600*    '1rem 1rem 0.5rem rgba(0, 0, 0, 0.2)'.
030700*  CALL 'cobdom_style' USING 'headerDiv', 'borderBottomLeftRadius',
030800*    '1rem'.
030900*  CALL 'cobdom_style' USING 'headerDiv',
031000*    'borderBottomRightRadius','1rem'.
031100   CALL 'cobdom_append_child' USING 'headerDiv', 'body'.
031200*Setup menu
031300   CALL 'cobdom_create_element' USING 'navArea', 'div'.
031400*  CALL 'cobdom_style' USING 'navArea', 'position', 'relative'.
031500   CALL 'cobdom_create_element' USING 'navButton', 'img'.
031600   CALL 'cobdom_style' USING 'navButton', 'position', 'absolute'.
031700   CALL 'cobdom_append_child' USING 'navButton', 'navArea'.
031800   CALL 'cobdom_src' USING 'navButton', 
031900     '/res/icons/tabler-icons/icons/outline/menu-2.svg'.
032000   CALL 'cobdom_style' USING 'navButton', 'backgroundColor',
032100     '#D9D4C7'.
032200*  CALL 'cobdom_style' USING 'navButton', 'filter', 
032300*    'invert(100%)'.
032400   CALL 'cobdom_style' USING 'navButton', 'width', '8rem'.
032500   CALL 'cobdom_style' USING 'navButton', 'height', '8rem'.
032600   CALL 'cobdom_style' USING 'navButton', 'padding', '.25rem'.
032700   CALL 'cobdom_style' USING 'navButton', 'margin', '.5rem'.
032800   CALL 'cobdom_style' USING 'navButton', 'borderRadius', '2rem'.
032900   CALL 'cobdom_style' USING 'navButton', 'top', '0rem'.
033000   CALL 'cobdom_style' USING 'navButton', 'left', '0rem'.
033100*Setup menu selectors
033200*About Me
033300   CALL 'cobdom_create_element' USING 'navAbout', 'div'.
033400   CALL 'cobdom_style' USING 'navAbout', 'position', 'absolute'.
033500   CALL 'cobdom_style' USING 'navAbout', 'backgroundColor', 
033600     '#c0c0c0'.
033700*  CALL 'cobdom_style' USING 'navAbout', 'backdropFilter',
033800*    'blur(5px)'.
033900   CALL 'cobdom_style' USING 'navAbout', 
034000     'borderBottomRightRadius', '0.5rem'.
034100   CALL 'cobdom_style' USING 'navAbout', 
034200     'borderTopRightRadius', '0.5rem'.
034300   CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'.
034400   CALL 'cobdom_style' USING 'navAbout', 'padding', '.3rem'.
034500   CALL 'cobdom_style' USING 'navAbout', 'top', '9rem'.
034600   CALL 'cobdom_style' USING 'navAbout', 'left', '-15rem'.
034700   CALL 'cobdom_style' USING 'navAbout', 'transition', 
034800     'transform 0.5s ease 0.1s'.
034900   CALL 'cobdom_append_child' USING 'navAbout', 'headerDiv'.
035000*Contact Me
035100   CALL 'cobdom_create_element' USING 'navContact', 'div'.
035200   CALL 'cobdom_style' USING 'navContact', 'position', 'absolute'.
035300   CALL 'cobdom_style' USING 'navContact', 'backgroundColor', 
035400     '#c0c0c0'.
035500*  CALL 'cobdom_style' USING 'navContact', 'backdropFilter',
035600*    'blur(5px)'.
035700   CALL 'cobdom_style' USING 'navContact', 
035800     'borderBottomRightRadius', '0.5rem'.
035900   CALL 'cobdom_style' USING 'navContact', 
036000     'borderTopRightRadius', '0.5rem'.
036100   CALL 'cobdom_inner_html' USING 'navContact', 'Contact'.
036200   CALL 'cobdom_style' USING 'navContact', 'padding', '.3rem'.
036300   CALL 'cobdom_style' USING 'navContact', 'top', '12rem'.
036400   CALL 'cobdom_style' USING 'navContact', 'left', '-15rem'.
036500   CALL 'cobdom_style' USING 'navContact', 'transition', 
036600     'transform 0.5s ease 0.2s'.
036700   CALL 'cobdom_append_child' USING 'navContact', 'headerDiv'.
036800*Skills
036900   CALL 'cobdom_create_element' USING 'navSkills', 'div'.
037000   CALL 'cobdom_style' USING 'navSkills', 'position', 'absolute'.
037100   CALL 'cobdom_style' USING 'navSkills', 'backgroundColor', 
037200     '#c0c0c0'.
037300*  CALL 'cobdom_style' USING 'navSkills', 'backdropFilter',
037400*    'blur(5px)'.
037500   CALL 'cobdom_style' USING 'navSkills', 
037600     'borderBottomRightRadius', '0.5rem'.
037700   CALL 'cobdom_style' USING 'navSkills', 
037800     'borderTopRightRadius', '0.5rem'.
037900   CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'.
038000   CALL 'cobdom_style' USING 'navSkills', 'padding', '.3rem'.
038100   CALL 'cobdom_style' USING 'navSkills', 'top', '15rem'.
038200   CALL 'cobdom_style' USING 'navSkills', 'left', '-15rem'.
038300   CALL 'cobdom_style' USING 'navSkills', 'transition', 
038400     'transform 0.5s ease 0.3s'.
038500   CALL 'cobdom_append_child' USING 'navSkills', 'headerDiv'.
038600*Projects
038700   CALL 'cobdom_create_element' USING 'navProjects', 'div'.
038800   CALL 'cobdom_style' USING 'navProjects', 'position', 
038900     'absolute'.
039000   CALL 'cobdom_style' USING 'navProjects', 'backgroundColor', 
039100     '#c0c0c0'.
039200*  CALL 'cobdom_style' USING 'navProjects', 'backdropFilter',
039300*    'blur(5px)'.
039400   CALL 'cobdom_style' USING 'navProjects', 
039500     'borderBottomRightRadius', '0.5rem'.
039600   CALL 'cobdom_style' USING 'navProjects', 
039700     'borderTopRightRadius', '0.5rem'.
039800   CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'.
039900   CALL 'cobdom_style' USING 'navProjects', 'padding', '.3rem'.
040000   CALL 'cobdom_style' USING 'navProjects', 'top', '18rem'.
040100   CALL 'cobdom_style' USING 'navProjects', 'left', '-15rem'.
040200   CALL 'cobdom_style' USING 'navProjects', 'transition', 
040300     'transform 0.5s ease 0.4s'.
040400   CALL 'cobdom_append_child' USING 'navProjects', 'headerDiv'.
040500*Cobol?
040600   CALL 'cobdom_append_child' USING 'blinkStyle', 'body'.
040700   CALL 'cobdom_create_element' USING 'navCobol', 'div'.
040800   CALL 'cobdom_style' USING 'navCobol', 'position', 
040900     'absolute'.
041000   CALL 'cobdom_style' USING 'navCobol', 'backgroundColor', 
041100     '#000000'.
041200*    '#c0c0c0'.
041300*  CALL 'cobdom_style' USING 'navCobol', 'backdropFilter',
041400*    'blur(5px)'.
041500   CALL 'cobdom_style' USING 'navCobol', 'color', 
041600     '#00ff00'.
041700   CALL 'cobdom_style' USING 'navCobol', 
041800     'borderBottomRightRadius', '0.5rem'.
041900   CALL 'cobdom_style' USING 'navCobol', 
042000     'borderTopRightRadius', '0.5rem'.
042100   CALL 'cobdom_create_element' USING 'navCobolText', 'span'.
042200   CALL 'cobdom_inner_html' USING 'navCobolText', 'COBOL'.
042300   CALL 'cobdom_create_element' USING 'navCobolCursor', 'span'.
042400   CALL 'cobdom_inner_html' USING 'navCobolCursor', '?'.
042500   CALL 'cobdom_set_class' USING 'navCobolCursor', 'blink'.
042600   CALL 'cobdom_append_child' USING 'navCobolText', 'navCobol'.
042700   CALL 'cobdom_append_child' USING 'navCobolCursor', 'navCobol'.
042800   CALL 'cobdom_style' USING 'navCobol', 'padding', '.3rem'.
042900   CALL 'cobdom_style' USING 'navCobol', 'top', '21rem'.
043000   CALL 'cobdom_style' USING 'navCobol', 'left', '-15rem'.
043100   CALL 'cobdom_style' USING 'navCobol', 'transition', 
043200     'transform 0.5s ease 0.5s'.
043300   CALL 'cobdom_append_child' USING 'navCobol', 'headerDiv'.
043400*Add main menu button
043500   CALL 'cobdom_append_child' USING 'navArea', 'headerDiv'.
043600   CALL 'cobdom_add_event_listener' USING 'navButton', 'click', 
043700     'MENUTOGGLE'.
043800*Setup ID area
043900   CALL 'cobdom_create_element' USING 'idDiv', 'div'.
044000   CALL 'cobdom_style' USING 'idDiv', 'padding', '.5rem'.
044100   CALL 'cobdom_style' USING 'idDiv', 'marginLeft', '9rem'.
044200   CALL 'cobdom_create_element' USING 'nameDiv', 'div'.
044300   CALL 'cobdom_style' USING 'nameDiv', 'fontSize', '4rem'.
044400   CALL 'cobdom_inner_html' USING 'nameDiv', 'Blake Karbon'.
044500   CALL 'cobdom_append_child' USING 'nameDiv', 'idDiv'.
044600   CALL 'cobdom_create_element' USING 'taglineDiv', 'div'.
044700   CALL 'cobdom_inner_html' USING 'taglineDiv', 
044800     'A guy that knows a guy.'.
044900   CALL 'cobdom_append_child' USING 'taglineDiv', 'idDiv'.
045000   CALL 'cobdom_append_child' USING 'idDiv', 'headerDiv'.
045100*Setup lang area
045200   CALL 'cobdom_create_element' USING 'langArea', 'span'.
045300   CALL 'cobdom_style' USING 'langArea', 'marginLeft', 'auto'.
045400   CALL 'cobdom_append_child' USING 'langArea', 'headerDiv'.
045500*Setup language selector
045600   CALL 'cobdom_create_element' USING 'langUS', 'img'.
045700   CALL 'cobdom_create_element' USING 'langES', 'img'.
045800   CALL 'cobdom_src' USING 'langUS', '/res/icons/us.svg'.
045900   CALL 'cobdom_style' USING 'langUS', 'width', '7rem'.
046000   CALL 'cobdom_style' USING 'langUS', 'height', '7rem'.
046100   CALL 'cobdom_style' USING 'langUS', 'margin', '1rem'.
046200   CALL 'cobdom_style' USING 'langUS', 'borderRadius', '2rem'.
046300   CALL 'cobdom_style' USING 'langUS', 'transition', 
046400     'opacity 0.5s ease, transform 0.5s ease'.
046500*  CALL 'cobdom_style' USING 'langUS', 'boxShadow', 
046600*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
046700   CALL 'cobdom_src' USING 'langES', '/res/icons/es.svg'.
046800   CALL 'cobdom_style' USING 'langES', 'width', '7rem'.
046900   CALL 'cobdom_style' USING 'langES', 'height', '7rem'.
047000   CALL 'cobdom_style' USING 'langES', 'margin', '1rem'.
047100   CALL 'cobdom_style' USING 'langES', 'borderRadius', '2rem'.
047200   CALL 'cobdom_style' USING 'langES', 'transition', 
047300     'opacity 0.5s ease, transform 0.5s ease'.
047400*  CALL 'cobdom_style' USING 'langES', 'boxShadow', 
047500*    '.5rem .5rem 0.5rem rgba(0, 0, 0, 0.2)'.
047600   CALL 'cobdom_append_child' USING 'langUS', 'langArea'.
047700   CALL 'cobdom_add_event_listener' USING 'langUS', 'click', 
047800     'SETLANGUS'.
047900   CALL 'cobdom_append_child' USING 'langES', 'langArea'.
048000   CALL 'cobdom_add_event_listener' USING 'langES', 'click', 
048100     'SETLANGES'.
048200   CONTINUE.
048300 SET-ACTIVE-FLAG.
048400   IF WS-LANG = 'us' THEN
048500     CALL 'cobdom_style' USING 'langES', 'opacity', '0'
048600     CALL 'cobdom_style' USING 'langUS', 'transform', 
048700       'translate(9rem, 0rem)'
048800     PERFORM UPDATE-TEXT
048900   ELSE
049000     CALL 'cobdom_style' USING 'langUS', 'opacity', '0'
049100     CALL 'cobdom_style' USING 'langUS', 'transform', 
049200       'translate(9rem, 0rem)'
049300     PERFORM UPDATE-TEXT
049400   END-IF.
049500   CONTINUE.
049600 LOAD-TEXTS.
049700   CONTINUE.
049800 UPDATE-TEXT.
049900   IF WS-LANG = 'us' THEN
050000     CALL 'cobdom_inner_html' USING 'aboutHeader', 'About Me:'
050100     CALL 'cobdom_inner_html' USING 'contactHeader',
050200       'Contact Information:'
050300     CALL 'cobdom_inner_html' USING 'skillsHeader', 'Skills:'
050400     CALL 'cobdom_inner_html' USING 'projectHeader', 'Projects:'
050500     CALL 'cobdom_inner_html' USING 'navAbout', 'About Me'
050600     CALL 'cobdom_inner_html' USING 'navContact', 'Contact'
050700     CALL 'cobdom_inner_html' USING 'navSkills', 'Skills'
050800     CALL 'cobdom_inner_html' USING 'navProjects', 'Projects'
050900   ELSE
051000     CALL 'cobdom_inner_html' USING 'aboutHeader', 'Sobre Mi:'
051100     CALL 'cobdom_inner_html' USING 'contactHeader',
051200       'Contacto:'
051300     CALL 'cobdom_inner_html' USING 'skillsHeader', 'Habilidades:'
051400     CALL 'cobdom_inner_html' USING 'projectHeader', 'Proyectos:'
051500     CALL 'cobdom_inner_html' USING 'navAbout', 'Sobre Mi'
051600     CALL 'cobdom_inner_html' USING 'navContact', 'Contacto'
051700     CALL 'cobdom_inner_html' USING 'navSkills', 'Habilidades'
051800     CALL 'cobdom_inner_html' USING 'navProjects', 'Proyectos'
051900   END-IF.
052000   CONTINUE.
052100 LANG-CHECK.
052200   CALL 'cobdom_get_cookie' USING BY REFERENCE WS-LANG,
052300     'lang'.
052400   IF WS-LANG = WS-NULL-BYTE THEN
052500     CALL 'cobdom_set_cookie' USING 'us', 'lang'
052600     MOVE 'us' TO WS-LANG
052700   END-IF.
052800   PERFORM SET-ACTIVE-FLAG.
052900   CONTINUE.
053000 COOKIE-ASK.
053100   CALL 'cobdom_create_element' USING 'cookieDiv', 'div'.
053200   CALL 'cobdom_style' USING 'cookieDiv', 'position', 'fixed'.
053300   CALL 'cobdom_style' USING 'cookieDiv', 'bottom', '0'.
053400   CALL 'cobdom_style' USING 'cookieDiv', 'left', '0'.
053500   CALL 'cobdom_style' USING 'cookieDiv', 'width', '100%'.
053600   CALL 'cobdom_style' USING 'cookieDiv', 'backgroundColor', 
053700     '#00ff00'.
053800   CALL 'cobdom_style' USING 'cookieDiv', 'textAlign', 
053900     'center'.
054000   CALL 'cobdom_inner_html' USING 'cookieDiv','Would you like to a
054100-'llow cookies to store your preferences such as language?&nbsp;'.
054200   CALL 'cobdom_create_element' USING 'cookieYes', 'span'.
054300   CALL 'cobdom_set_class' USING 'cookieYes', 'cookieButton'.
054400   CALL 'cobdom_inner_html' USING 'cookieYes', 'Yes'.
054500   CALL 'cobdom_style' USING 'cookieYes', 'margin', '.3rem'.
054600   CALL 'cobdom_style' USING 'cookieYes', 'padding', '.3rem'.
054700   CALL 'cobdom_style' USING 'cookieYes', 'borderRadius', '1rem'.
054800   CALL 'cobdom_create_element' USING 'cookieNo', 'span'.
054900   CALL 'cobdom_set_class' USING 'cookieNo', 'cookieButton'.
055000   CALL 'cobdom_inner_html' USING 'cookieNo', 'No'.
055100   CALL 'cobdom_style' USING 'cookieNo', 'margin', '.3rem'.
055200   CALL 'cobdom_style' USING 'cookieNo', 'padding', '.3rem'.
055300   CALL 'cobdom_style' USING 'cookieNo', 'borderRadius', '1rem'.
055400   CALL 'cobdom_add_event_listener' USING 'cookieYes', 'click',
055500     'COOKIEACCEPT'.
055600   CALL 'cobdom_add_event_listener' USING 'cookieNo', 'click',
055700     'COOKIEDENY'.
055800   CALL 'cobdom_append_child' USING 'cookieYes', 'cookieDiv'.
055900   CALL 'cobdom_append_child' USING 'cookieNo', 'cookieDiv'.
056000   CALL 'cobdom_append_child' USING 'cookieDiv', 'body'.
056100*Note this must be called after the elements are added to the
056200*document because it must search for them.
056300   CALL 'cobdom_class_style' USING 'cookieButton', 
056400     'backgroundColor', '#ff0000'.
056500   CONTINUE.
056600 MENUTOGGLE SECTION.
056700 ENTRY 'MENUTOGGLE'.
056800   IF WS-MENU-TOGGLE = 0 THEN
056900     MOVE 1 TO WS-MENU-TOGGLE
057000     CALL 'cobdom_style' USING 'navButton', 'transform', 
057100       'scale(0.85)'
057200     CALL 'cobdom_src' USING 'navButton', 
057300       '/res/icons/tabler-icons/icons/outline/menu-4.svg'
057400     CALL 'cobdom_style' USING 'navAbout', 'transform', 
057500       'translate(15rem, 0rem)' 
057600     CALL 'cobdom_style' USING 'navContact', 'transform', 
057700       'translate(15rem, 0rem)' 
057800     CALL 'cobdom_style' USING 'navSkills', 'transform', 
057900       'translate(15rem, 0rem)'
058000    CALL 'cobdom_style' USING 'navProjects', 'transform', 
058100       'translate(15rem, 0rem)'
058200    CALL 'cobdom_style' USING 'navCobol', 'transform', 
058300       'translate(15rem, 0rem)'
058400   ELSE
058500     MOVE 0 TO WS-MENU-TOGGLE
058600     CALL 'cobdom_style' USING 'navButton', 'transform', 
058700       'scale(1.0)'
058800     CALL 'cobdom_src' USING 'navButton', 
058900       '/res/icons/tabler-icons/icons/outline/menu-2.svg'
059000     CALL 'cobdom_style' USING 'navAbout', 'transform', 
059100       'translate(0rem, 0rem)' 
059200     CALL 'cobdom_style' USING 'navContact', 'transform', 
059300       'translate(0rem, 0rem)' 
059400     CALL 'cobdom_style' USING 'navSkills', 'transform', 
059500       'translate(0rem, 0rem)'
059600    CALL 'cobdom_style' USING 'navProjects', 'transform', 
059700       'translate(0rem, 0rem)'
059800    CALL 'cobdom_style' USING 'navCobol', 'transform', 
059900       'translate(0rem, 0rem)'
060000   END-IF.
060100   GOBACK.
060200*TO-DO: Add a timer in case some fonts do never load
060300 FONTLOADED SECTION.
060400 ENTRY 'FONTLOADED'.
060500   ADD 1 TO WS-FONTS-LOADED.
060600   IF WS-FONTS-LOADED = 2 THEN
060700     CALL 'cobdom_style' USING 'body', 'fontFamily', 'mainFont'
060800     CALL 'cobdom_style' USING 'navCobol', 'fontFamily', 'ibmpc'
060900     CALL 'cobdom_style' USING 'cobolHeader', 'fontFamily',
061000       'ibmpc'
061100     CALL 'cobdom_style' USING 'cobolContent', 'fontFamily',
061200       'ibmpc'
061300   END-IF.
061400   GOBACK.
061500 WINDOWCHANGE SECTION.
061600 ENTRY 'WINDOWCHANGE'.
061700   CALL 'cobdom_clear_timeout' USING 'renderTimeout'.
061800   CALL 'cobdom_set_timeout' USING 'renderTimeout', 'SHAPEPAGE'
061900     '300'.
062000*Optimize this buffer time to not have a noticeable delay but also
062100*not call to often.
062200   GOBACK.
062300 SHAPEPAGE SECTION.
062400 ENTRY 'SHAPEPAGE'.
062500*  MOVE FUNCTION CURRENT-DATE(13:4) TO CENTISECS OF WS-TMP
062600*  DISPLAY 'Rendering! ' CENTISECS.
062700   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
062800     'window.innerWidth'.
062900   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO WIDTH OF WS-WINDOW.
063000   CALL 'cobdom_eval' USING BY REFERENCE WS-BLOB-SIZE, WS-BLOB, 
063100     'window.innerHeight'.
063200   MOVE WS-BLOB(1:WS-BLOB-SIZE) TO HEIGHT OF WS-WINDOW.
063300   GOBACK.
063400 COOKIEACCEPT SECTION.
063500 ENTRY 'COOKIEACCEPT'.
063600   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
063700   CALL 'cobdom_set_cookie' USING 'y', 'allowCookies' .
063800   MOVE 'y' TO WS-COOKIE-ALLOWED.
063900   IF WS-LANG = 'us' THEN
064000     CALL 'cobdom_set_cookie' USING 'us', 'lang'
064100   ELSE
064200     CALL 'cobdom_set_cookie' USING 'en', 'lang'
064300   END-IF.
064400   GOBACK.
064500 COOKIEDENY SECTION.
064600 ENTRY 'COOKIEDENY'.
064700   CALL 'cobdom_style' USING 'cookieDiv', 'display', 'none'.
064800   MOVE 'n' TO WS-COOKIE-ALLOWED.
064900   GOBACK.
065000 SETPERCENTCOBOL SECTION.
065100 ENTRY 'SETPERCENTCOBOL' USING BY REFERENCE LS-BLOB-SIZE,LS-BLOB.
065200   MOVE LS-BLOB(1:LS-BLOB-SIZE) TO WS-PERCENT-COBOL.
065300   CALL 'cobdom_inner_html' USING 'percentCobol',
065400     WS-PERCENT-COBOL.
065500   DISPLAY 'Currently this website is written in ' 
065600     WS-PERCENT-COBOL '% COBOL.'.
065700   GOBACK.
065800 SETLANG SECTION.
065900 ENTRY 'SETLANG' USING LS-LANG-CHOICE.
066000   if WS-LANG-SELECT-TOGGLE = 0 THEN
066100     MOVE 1 TO WS-LANG-SELECT-TOGGLE
066200     IF WS-LANG = 'us' THEN
066300       CALL 'cobdom_style' USING 'langES', 'opacity', '1'
066400       CALL 'cobdom_style' USING 'langUS', 'transform', 
066500         'translate(0rem, 0rem)'
066600*      CALL 'cobdom_style' USING 'langES', 'display', 'inline'
066700     ELSE
066800       CALL 'cobdom_style' USING 'langUS', 'opacity', '1'
066900       CALL 'cobdom_style' USING 'langUS', 'transform', 
067000         'translate(0rem, 0rem)'
067100*      CALL 'cobdom_style' USING 'langUS', 'display', 'inline'
067200     END-IF
067300   ELSE
067400     MOVE 0 TO WS-LANG-SELECT-TOGGLE
067500     IF WS-COOKIE-ALLOWED = 'y' THEN
067600       IF LS-LANG-CHOICE = 'us' THEN
067700         CALL 'cobdom_set_cookie' USING 'us', 'lang'
067800         MOVE 'us' TO WS-LANG
067900       ELSE
068000         CALL 'cobdom_set_cookie' USING 'es', 'lang'
068100         MOVE 'es' TO WS-LANG
068200       END-IF
068300       PERFORM SET-ACTIVE-FLAG
068400     ELSE
068500       MOVE LS-LANG-CHOICE TO WS-LANG
068600       PERFORM SET-ACTIVE-FLAG 
068700     END-IF
068800   END-IF.
068900   GOBACK.
069000 SETLANGUS SECTION.
069100 ENTRY 'SETLANGUS'.
069200   CALL 'SETLANG' USING 'us'.
069300   GOBACK.
069400 SETLANGES SECTION.
069500 ENTRY 'SETLANGES'.
069600   CALL 'SETLANG' USING 'es'.
069700   GOBACK.
069800*TERMINPUT SECTION.
069900*ENTRY 'TERMINPUT' USING LS-TERM-IN.
070000*  DISPLAY LS-TERM-IN.
070100*  GOBACK.
