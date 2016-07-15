CREATE OR REPLACE PACKAGE BODY MSTR.startpage IS
	PROCEDURE aspx (SPHostUrl IN VARCHAR2 DEFAULT NULL,
									SPLanguage IN VARCHAR2 DEFAULT NULL,
									SPClientTag IN VARCHAR2 DEFAULT NULL,
									SPProductNumber IN VARCHAR2 DEFAULT NULL,
									SPAppToken IN VARCHAR2 DEFAULT NULL,
									SPSiteUrl IN VARCHAR2 DEFAULT NULL,
									SPSiteTitle IN VARCHAR2 DEFAULT NULL,
									SPSiteLogoUrl IN VARCHAR2 DEFAULT NULL,
									SPSiteLanguage IN VARCHAR2 DEFAULT NULL,
									SPSiteCulture IN VARCHAR2 DEFAULT NULL,
									SPRedirectMessage IN VARCHAR2 DEFAULT NULL,
									SPErrorCorrelationId IN VARCHAR2 DEFAULT NULL,
									SPCorrelationId IN VARCHAR2 DEFAULT NULL,
									SPErrorInfo IN VARCHAR2 DEFAULT NULL) IS
	BEGIN
		HTP.P ('<!DOCTYPE html><html lang="en" xmlns="http://www.w3.org/1999/xhtml"><head><title>Provider hosted app</title>');
--        HTP.p('<style type="text/css">
--            body, html
--            {
--                margin: 0; padding: 0; height: 100%; overflow: hidden;
--            }
--            #header
--            {
--                position:absolute; left: 0; top: 0; right: 0; height: 90px; background: red;
--            }
--            #content
--            {
--                position:absolute; left: 0; right: 0; bottom: 0; top: 90px; background: blue; height: expression(document.body.clientHeight-90);
--            }
--        </style>');
		HTP.p ('<script src="//ajax.aspnetcdn.com/ajax/4.0/1/MicrosoftAjax.js" type="text/javascript"></script>');
		HTP.p ('<script type="text/javascript" src="//ajax.aspnetcdn.com/ajax/jQuery/jquery-1.7.2.min.js"></script>');
		HTP.p ('<script type="text/javascript" src="ChromeLoader.js"></script>');
        htp.p('<script type="text/javascript">
"use strict";

var hostweburl;

//load the SharePoint resources
$(document).ready(function () {
    //Get the URI decoded URL.
    hostweburl =
        decodeURIComponent(
            getQueryStringParameter("SPHostUrl")
    );
    //alert(getQueryStringParameter("SPSiteLogoUrl"));

    // The SharePoint js files URL are in the form:
    // web_url/_layouts/15/resource
    var scriptbase = hostweburl + "/_layouts/15/";

    // Load the js file and continue to the 
    //   success handler
    $.getScript(scriptbase + "SP.UI.Controls.js", renderChrome)
});

// Callback for the onCssLoaded event defined
//  in the options object of the chrome control
function chromeLoaded() {
    // When the page has loaded the required
    //  resources for the chrome control,
    //  display the page body.
    $("body").show();
}

//Function to prepare the options and render the control
function renderChrome() {
    // The Help, Account and Contact pages receive the 
    //   same query string parameters as the main page
    var options = {
        "appIconUrl": "http://eurostrategy.net/MicroStrategy/plugins/_Interface/style/images/logo_small.png", //decodeURIComponent(getQueryStringParameter("SPSiteLogoUrl")),
        "appTitle": "PANDAStrategy",
        "appHelpPageUrl": "Help.html?"
            + document.URL.split("?")[1],
        // The onCssLoaded event allows you to 
        //  specify a callback to execute when the
        //  chrome resources have been loaded.
        "onCssLoaded": "chromeLoaded()",
        "settingsLinks": [
            {
                "linkUrl": "Account.html?"
                    + document.URL.split("?")[1],
                "displayName": "Account settings"
            },
            {
                "linkUrl": "Contact.html?"
                    + document.URL.split("?")[1],
                "displayName": "Contact us"
            }
        ]
    };

    var nav = new SP.UI.Controls.Navigation(
                            "chrome_ctrl_placeholder",
                            options
                        );
    nav.setVisible(true);
}

// Function to retrieve a query string value.
// For production purposes you may want to use
//  a library to handle the query string.
function getQueryStringParameter(paramToRetrieve) {
    var params =
        document.URL.split("?")[1].split("&");
    var strParams = "";
    for (var i = 0; i < params.length; i = i + 1) {
        var singleParam = params[i].split("=");
        if (singleParam[0] == paramToRetrieve)
            return singleParam[1];
    }
}
</script>');

		--				HTP.p (
		--	 '<link rel="stylesheet" href="http://metroui.org.ua/css/metro-bootstrap.css"><script src="http://metroui.org.ua/js/jquery/jquery.min.js"></script><script src="http://metroui.org.ua/js/jquery/jquery.widget.min.js"></script>');
		HTP.p ('</head>');
        HTP.p('<body style="display: none; margin: 0; padding: 0; height: 100%; overflow: hidden;">
            <!-- Chrome control placeholder -->
            <div id="chrome_ctrl_placeholder"></div>
            <!-- The chrome control also makes the SharePoint
                  Website stylesheet available to your page -->
            <h1 class="ms-accentText">PANDAStrategy</h1>
            <div id="MainContent">
            <iframe style="position:absolute; left: 0; right: 0; bottom: 0; top: 100px; background: blue; height: expression(document.body.clientHeight-90);" width="100%" height="100%" src="http://eurostrategy.net/MicroStrategy/servlet/mstrWeb?&uid=EHSOUARE&pwd=Amazon&hiddenSections=header,path,dockTop,dockLeft,footer"></iframe>           
            </div>
        </body>');
		HTP.p ('<h6>');
		HTP.p ('<br />SSPSiteUrl ' || SPSiteUrl);
		HTP.p ('<br />SPSiteTitle ' || SPSiteTitle);
		HTP.p ('<br />SPSiteLogoUrl ' || SPSiteLogoUrl);
		HTP.p ('<br />SPSiteLanguage ' || SPSiteLanguage);
		HTP.p ('<br />SPSiteCulture ' || SPSiteCulture);
		HTP.p ('<br />SPRedirectMessage ' || SPRedirectMessage);
		HTP.p ('<br />SPErrorInfo ' || SPErrorInfo);
		HTP.p ('<br />SPErrorCorrelationId ' || SPErrorCorrelationId);
		HTP.p ('<br />SPCorrelationId ' || SPCorrelationId);
		HTP.p ('<br />SPAppToken ' || SPAppToken);
		-- OWA_UTIL.PRINT_CGI_ENV;
		HTP.p ('</h6></body></html>');
	END aspx;
END startpage;
/

