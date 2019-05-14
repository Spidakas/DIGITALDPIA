﻿<%@ Page Language="vb" AutoEventWireup="false" CodeBehind="nocookies.aspx.vb" Inherits="InformationSharingPortal.nocookies" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head id="Head1" runat="server">

    <title>Data Protection Impact Assessment Tool Error</title>
    <link href="Content/Site.css" rel="stylesheet" />
    <style>
        body {
    color: #333;
}

a {
    color: #4bb1eb;
    text-decoration: none;
}
.hiddencol
    {
        display:none;
    }
.clearfix:before, .clearfix:after {
    display: table;
    content: " ";
}

.clearfix:after {
    clear: both;
}
/*
 * -- HELPER STYLES --
 * Over-riding some of the .pure-button styles to make my buttons look unique
 */
.primary-button,
.secondary-button {
    border-radius: 20px;
    -moz-box-shadow: none;
    -webkit-box-shadow: none;
    box-shadow: none;
}

.primary-button {
    margin: 1em 0;
    background: #1b98f8;
    color: #fff;
}

.secondary-button {
    padding: 0.5em 2em;
    border: 1px solid #ddd;
    background: #fff;
    color: #666;
    font-size: 80%;
}

html {
    background-color: #e2e2e2;
    margin: 0;
    padding: 0;
}

body {
    background-color: #fff;
    border-top: solid 10px #000;
    color: #333;
    font-size: .85em;
    font-family: "Segoe UI", Verdana, Helvetica, Sans-Serif;
    margin: 0;
    padding: 0;
}

a {
    color: #333;
    outline: none;
    padding-left: 3px;
    padding-right: 3px;
    text-decoration: underline;
}

    a:link, a:visited,
    a:active, a:hover {
        color: #333;
    }

    a:hover {
        background-color: #c7d1d6;
    }

header, footer, hgroup,
nav, section {
    display: block;
}

mark {
    background-color: #a6dbed;
    padding-left: 5px;
    padding-right: 5px;
}

.float-left {
    float: left;
}

.float-right {
    float: right;
}

.clear-fix:after {
    content: ".";
    clear: both;
    display: block;
    height: 0;
    visibility: hidden;
}

h1, h2, h3,
h4, h5, h6 {
    color: #000;
    margin-bottom: 0;
    padding-bottom: 0;
}

h1 {
    font-size: 2em;
}

h2 {
    font-size: 1.75em;
}

h3 {
    font-size: 1.2em;
}

h4 {
    font-size: 1.1em;
}

h5, h6 {
    font-size: 1em;
}

    h5 a:link, h5 a:visited, h5 a:active {
        padding: 0;
        text-decoration: none;
    }

/* main layout
----------------------------------------------------------*/
.content-wrapper {
    margin: 0 auto;
    max-width: 960px;
}

#body {
    background-color: #efeeef;
    clear: both;
    padding-bottom: 35px;
}

    .main-content {
        /*background: url("../Images/accent.png") no-repeat;*/
        padding-left: 10px;
        padding-top: 30px;
    }

    .featured + .main-content {
        /*background: url("../Images/heroAccent.png") no-repeat;*/
    }

header .content-wrapper {
    padding-top: 20px; 
}
    
footer {
    clear: both;
    background-color: #e2e2e2;
    font-size: .8em;
    height: 100px;
}


/* site title
----------------------------------------------------------*/
.site-title {
    color: #c8c8c8;
    font-family: Rockwell, Consolas, "Courier New", Courier, monospace;
    font-size: 2.3em;
    margin: 0;
}

.site-title a, .site-title a:hover, .site-title a:active {
    background: none;
    color: #c8c8c8;
    outline: none;
    text-decoration: none;
}


/* login
----------------------------------------------------------*/
#login {
    display: block;
    font-size: .85em;
    margin: 0 0 10px;
    text-align: right;
}

    #login a {
        background-color: #d3dce0;
        margin-left: 10px;
        margin-right: 3px;
        padding: 2px 3px;
        text-decoration: none;
    }

    #login a.username {
        background: none;
        margin-left: 0px;
        text-decoration: underline;
    }

    #login ul {
        margin: 0;
    }

    #login li {
        display: inline;
        list-style: none;
    }


/* menu
----------------------------------------------------------*/
ul#menu {
    font-size: 1.3em;
    font-weight: 600;
    margin: 0 0 5px;
    padding: 0;
    text-align: right;
}

    ul#menu li {
        display: inline;
        list-style: none;
        padding-left: 15px;
    }

        ul#menu li a {
            background: none;
            color: #999;
            text-decoration: none;
        }

        ul#menu li a:hover {
            color: #333;
            text-decoration: none;
        }


/* page elements
----------------------------------------------------------*/
/* featured */
.featured {
    background-color: #fff;
}

    .featured .content-wrapper {
        background-color: #7ac0da;
        background-image: -ms-linear-gradient(left, #7ac0da 0%, #a4d4e6 100%);
        background-image: -o-linear-gradient(left, #7ac0da 0%, #a4d4e6 100%);
        background-image: -webkit-gradient(linear, left top, right top, color-stop(0, #7ac0da), color-stop(1, #a4d4e6));
        background-image: -webkit-linear-gradient(left, #7ac0da 0%, #a4d4e6 100%);
        background-image: linear-gradient(left, #7ac0da 0%, #a4d4e6 100%);
        color: #3e5667;
        padding: 20px 40px 30px 40px;
    }

        .featured hgroup.title h1, .featured hgroup.title h2 {
            color: #fff;
        }

        .featured p {
            font-size: 1.1em;
        }

/* page titles */
hgroup.title {
    margin-bottom: 10px;
}

hgroup.title h1, hgroup.title h2 {
    display: inline;
}

hgroup.title h2 {
    font-weight: normal;
    margin-left: 3px;
}

/* features */
section.feature {
    width: 300px;
    float: left;
    padding: 10px;
}

/* ordered list */
ol.round {
    list-style-type: none;
    padding-left: 0;
}

    ol.round li {
        margin: 25px 0;
        padding-left: 45px;
    }

        ol.round li.zero {
            background: url("../Images/orderedList0.png") no-repeat;
        }

        ol.round li.one {
            background: url("../Images/orderedList1.png") no-repeat;
        }

        ol.round li.two {
            background: url("../Images/orderedList2.png") no-repeat;
        }

        ol.round li.three {
            background: url("../Images/orderedList3.png") no-repeat;
        }

        ol.round li.four {
            background: url("../Images/orderedList4.png") no-repeat;
        }

        ol.round li.five {
            background: url("../Images/orderedList5.png") no-repeat;
        }

        ol.round li.six {
            background: url("../Images/orderedList6.png") no-repeat;
        }

        ol.round li.seven {
            background: url("../Images/orderedList7.png") no-repeat;
        }

        ol.round li.eight {
            background: url("../Images/orderedList8.png") no-repeat;
        }

        ol.round li.nine {
            background: url("../Images/orderedList9.png") no-repeat;
        }

/* content */
article {
    float: left;
    width: 70%;
}

aside {
    float: right;
    width: 25%;
}

    aside ul {
        list-style: none;
        padding: 0;
    }

        aside ul li {
            background: url("../Images/bullet.png") no-repeat 0 50%;
            padding: 2px 0 2px 20px;
        }

.label {
    font-weight: 700;
}

/* login page */
#loginForm {
    border-right: solid 2px #c8c8c8;
    float: left;
    width: 55%;
}

    #loginForm .validation-error {
        display: block;
        margin-left: 15px;
    }

#socialLoginForm {
    margin-left: 40px;
    float: left;
    width: 40%;
}

    #socialLoginForm h2 {
        margin-bottom:  5px;
    }

fieldset.open-auth-providers {
    margin-top: 15px;
}

    fieldset.open-auth-providers button {
        margin-bottom: 12px;
    }
    
/* contact */
.contact h3 {
    font-size: 1.2em;
}

.contact p {
    margin: 5px 0 0 10px;
}

.contact iframe {
    border: 1px solid #333;
    margin: 5px 0 0 10px;
}

/* forms */
fieldset {
    border: none;
    margin: 0;
    padding: 0;
}

    fieldset legend {
        display: none;
    }
    
    fieldset ol {
        padding: 0;
        list-style: none;
    }

        fieldset ol li {
            padding-bottom: 5px;
        }

    label {
        display: block;
        font-size: 1.2em;
        font-weight: 600;
    }

    label.checkbox {
        display: inline;
    }

    input, textarea {
        border: 1px solid #e2e2e2;
        background: #fff;
        color: #333;
        font-size: 1.2em;
        margin: 5px 0 6px 0;
        padding: 5px;
        width: 300px;
    }

    textarea {
        font-family: inherit;
        width: 500px;
    }
    
        input:focus, textarea:focus {
            border: 1px solid #7ac0da;
        }

        input[type="checkbox"] {
            background: transparent;
            border: inherit;
            width: auto;
        }
        
    /*input[type="submit"],
    input[type="button"],
    button {
        background-color: #d3dce0;
        border: 1px solid #787878;
        cursor: pointer;
        font-size: 1.2em;
        font-weight: 600;
        padding: 7px;
        margin-right: 8px;
        width: auto;
    }*/

    td input[type="submit"],
    td input[type="button"],
    td button {
        font-size: 1em;
        padding: 4px;
        margin-right: 4px;
    }

/* info and errors */
.message-info {
    border: 1px solid;
    clear: both;
    padding: 10px 20px;
}

.message-error {
    clear: both;
    color: #e80c4d;
    font-size: 1.1em;
    font-weight: bold;
    margin: 20px 0 10px 0;
}

.message-success {
    color: #7ac0da;
    font-size: 1.3em;
    font-weight: bold;
    margin: 20px 0 10px 0;
}

.error {
    color: #e80c4d;
}

/* styles for validation helpers */
.bg-danger {
    color: #e80c4d;
    font-weight: bold;
}

.field-validation-valid {
    display: none;
}

input.input-validation-error {
    border: 1px solid #e80c4d;
}

input[type="checkbox"].input-validation-error {
    border: 0 none;
}

.validation-summary-errors {
    color: #e80c4d;
    font-weight: bold;
    font-size: 1.1em;
}

.validation-summary-valid {
    display: none;
}

/* tables
----------------------------------------------------------*/
table {
    border-collapse: collapse;
    border-spacing: 0;
    margin-top: 0.75em;
    border: 0 none;
}

th {
	font-size: 1.2em;
    text-align: left;
    border: none 0px;
    padding-left: 0;
}

    th a {
        display: block;
        position: relative;
        
    }

	th a:link, th a:visited, th a:active, th a:hover {
		color: #333;
		font-weight: 600;
		text-decoration: none;
        padding: 0;
	}

	th a:hover {
		color: #000;
	}

    th.asc a, th.desc a {
        margin-right: .75em;
    }
    
    th.asc a:after, th.desc a:after {
		display: block;
        position: absolute;
        right: 0em;
        top: 0;
        font-size: 0.75em;
	}

	th.asc a:after {
		content: '▲';
	}

	th.desc a:after {
		content: '▼';
	}

td {
    padding: 0.25em 2em 0.25em 0em;
    border: 0 none;
}

tr.pager td {
    padding: 0 0.25em 0 0;
}


/********************
*   Mobile Styles   *
********************/
@media only screen and (max-width: 850px) {

    /* header
    ----------------------------------------------------------*/
    header .float-left,
    header .float-right {
        float: none;
    }

    /* logo */
    header .site-title {
        margin: 10px;
        text-align: center;
    }

    /* login */
    #login {
        font-size: .85em;
        margin: 0 0 12px;
        text-align: center;
    }

        #login ul {
            margin: 5px 0;
            padding: 0;
        }

        #login li {
            display: inline;
            list-style: none;
            margin: 0;
            padding: 0;
        }

        #login a {
            background: none;
            color: #999;
            font-weight: 600;
            margin: 2px;
            padding: 0;
        }

        #login a:hover {
            color: #333;
        }

    /* menu */
    nav {
        margin-bottom: 5px;
    }

    ul#menu {
        margin: 0;
        padding: 0;
        text-align: center;
    }

        ul#menu li {
            margin: 0;
            padding: 0;
        }


    /* main layout
    ----------------------------------------------------------*/
    .main-content,
    .featured + .main-content {
        background-position: 10px 0;
    }

    .content-wrapper {
        padding-right: 10px;
        padding-left: 10px;
    }

    .featured .content-wrapper {
        padding: 10px;
    }

    /* page content */
    article, aside {
        float: none;
        width: 100%;
    }

    /* ordered list */
    ol.round {
        list-style-type: none;
        padding-left: 0;
    }

        ol.round li {
            padding-left: 10px;
            margin: 25px 0;
        }

            ol.round li.zero,
            ol.round li.one,
            ol.round li.two,
            ol.round li.three,
            ol.round li.four,
            ol.round li.five,
            ol.round li.six,
            ol.round li.seven,
            ol.round li.eight,
            ol.round li.nine {
                background: none;
            }

     /* features */
     section.feature {
        float: none;
        padding: 10px;
        width: auto;
     }

        section.feature img {
            color: #999;
            content: attr(alt);
            font-size: 1.5em;
            font-weight: 600;
        }

    /* forms */
    input {
        width: 90%;
    }

    
    
    /* login page */
    #loginForm {
        border-right: none;
        float: none;
        width: auto;
    }

        #loginForm .validation-error {
            display: block;
            margin-left: 15px;
        }

    #socialLoginForm {
        margin-left: 0;
        float: none;
        width: auto;
    }

    /* footer
    ----------------------------------------------------------*/
    footer .float-left,
    footer .float-right {
        float: none;
    }

    footer {
        text-align: center;
        height: auto;
        padding: 10px 0;
    }

        footer p {
            margin: 0;
        }
}
/* END: Mobile Styles */

    </style>
</head>
<body>
    <form id="form1" runat="server">
    <div style="padding:20%">
    <h2>Data Protection Impact Assessment Tool Requires Cookies</h2>
       <p>Cookies must be enabled to use this website.</p>
        <p>Please adjust your browser's settings to allow this site to use cookies before continuing.</p>
        <p>Once you have enabled cookies, click <a href="/Account/Login.aspx">here</a> to return to the Data Protection Impact Assessment Tool. </p>
    </div>
    </form>
</body>
</html>
