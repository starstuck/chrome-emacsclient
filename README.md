Chrome extension integrating devtools with Emacs
================================================

This extension is supposed to provide some features of emacsclient command
line tool inside browser. Basic feature it tries to provide, is to allow
opening source files in your Emacs from Chrome Devtool panels.

## How does it work?

Extension hooks into `chrome.devtools.panels.setOpenResourceHandler`, which
is trigger when user click link in panels.

Once we get file details we can send it to http server inside emacs. It sent
via XMLHttpReques with url-enncoded body having file url and line. 

There is lisp function on Emacs side, similar to `compilation-find-file` which 
searches path part of url inside `compilation-search-path`. This variable may
already have reasonable paths if people are ruining unit tests, or jlint from Emacs.

## Installation

Right now extension is still in development and is not relased. You need to
checkout git repository and add it to your browser via "Loadn unpacked extension..."
button.

Once you have extension installed you will be able to open resource link in
emacs by choosing right option from link context menu. If you want to open links
to resources in emacs by default, you can change setting "Open links in" in 
"General" section of devtool settings.

Extension requires small server running in Emacs which will listen to requests
from Chrome Devtools. To run server you need to install `simple-httpd` package
first. You can do that by calling in emacs

    M-x package-install

Emacs will ask you for package name, which is `simple-httpd`.

After installation you will need to change default port to 8080. I find that default
`simple-httpd` port is often coliding with tomcat and other projects. You can use
command

    M-x customize-variable

to change value of `httpd-port` variable to 8081, which Chrome extension expects.
After taht you can start server.

    M-x httpd-start

The only remaining bit is loading emacs functions to deal with Chrome extension
requests. Just load `chromeserv.el` file from this project folder.

    M-x load-file

I am still thinking how to simplify setup on Emacs.

## Why not use native protocol?

It is all possible from Emacs side, but apparently Chrome extensions are not
allowed to used plain socket API. Ony Native apps.

The Emacs server listens to TCP connection. TO establish connection we need 
to know host (default to localhost), port (often randomized by emacs) and 
security token. All that information is duped into server file when emacs 
server is started. It is still open question how to make Chrome know about 
this stuff with as little hassle to user as possible. Even Chrome apps are
not allowed to access user filesystem.

Once we get that information, we can connect to socket as described in
[network communications guide at Chrome Developer Doc](http://developer.chrome.com/apps/app_network.html).

To eval any list expression in emacs you can send through socket

    -auth <authentication_token> -eval compilation-search-path

The server will respond with something like:

    -print ("c:/Home/mobile&-html5"&_nil)&n

Detailed description of protocol and available commands can be read in emacs
documentation to `server-process-filter` function.

## How do you plan to have console mirrored in Emacs?

Once we sort out reliable channel of communication, extension could add hook to
[Devtools Console](http://developer.chrome.com/extensions/experimental_devtools_console.html),
to get all messages. They could be forwarded to emacs and displayed in emacs 
buffer with whole editing power of Emacs. Extra minor modes like 
`compilation-shell-minor-mode` may than be used for extra features.

It is still open question how to make user friendly management of multiple 
console buffers.

## Current Status

Right now this project is only proof of concept, having basic functionality, opening 
files working.

Any feedback is much appreciated. You can raise feature requests or report bugs
at [project GitHub page](https://github.com/szarsti/chrome-emacsclient/issues)
