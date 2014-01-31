Chrome extension connection browser to Emacs editor
===================================================

This extension is supposed to provide some features of emacsclient command
line tool inside browser. Basic feature it tries to provide, is to allow
opening source files in your Emacs from Chrome Devtool panels.

## How to achieve it?

Extension hooks into `chrome.devtools.panels.setOpenResourceHandler`, which
is trigger when user click link in panels.

Once we get user request we can connect to emacs server. The server ca listen
on tcp. TO establish connection we need to know host (default to localhost),
port (often randomized by emacs) and security token. All that information is
duped into server file when emacs server is started. It is still open question
how to make Chrome know about this stuff with as little hassle to user as
possible. Apparently access to user filesystem is limited if not blocked at all.

Once we get that information, you can connect to socket as described in
[network communications guide at Chrome Developer Doc](http://developer.chrome.com/apps/app_network.html).

To eval any list expression in emacs you can send through socket

    -auth <authentication_token> -eval compilation-search-path

The server will respond with something like:

    -print ("c:/Home/mobile&-html5"&_nil)&n

Detailed description of protocol and available commands can be read in emacs
documentation to `server-process-filter` function.

Once we establish reliable connection there is going to be a problem of mapping
url to file path. I guess we could implements some lisp function similar to
`compilation-find-file` which would search path part of url in some predefined
search directories. I think it makes sense to use `compilation-search-path` for
that, because anyone using phantomjs or other unit testing frameworks will have
it set up to something reasonable. 

## Current Status

Right now this project is only proof of concept and completely not usable.
