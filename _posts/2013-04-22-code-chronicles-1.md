---
layout: post
title: Code Chronicles {1}

---


{{ page.title }}
================

I've been working pretty much exclusively in JavaScript off-late thanks to PeerCDN where both the client and the server are in JavaScript. Ran into a cool commenting style:

```
function(event /* , args... */ ) 
```

And after that, you do `var args = Array.prototype.slice.call(arguments).slice(1)`.

Why use `typeof`? `Nonexistent !== undefined` causes a ReferenceError. But `typeof 'Nonexistent' !== undefined` works like you want it to.

One important practice in setting up dependencies is to hard-code dependency versions. Without that, you could introduce errors even if you have testing. It's always safer albeit a bit more tedious to manually upgrade dependencies. Looking into this with npm. [Semver](http://semver.org/) is a smart versioning convention that technically all modules on npm should follow (no idea how good compliance actually is). Format is major.minor.patch. Major version numbers change public API. Patch fixes bugs. Backwards compatible API additions/changes increment the minor version.

npm uses [node-semver](https://github.com/isaacs/node-semver) to parse version strings in `package.json`. npm uses `*` for total wildcard, but `1.x` rather than `1.*` for a partial wildcard which is a weird inconsistency.. npm also supports `>=`, and `~`, for example, `~1.2.3` is equalavalent to `>=1.2.3 <1.3.0`. For modules past major version 0, a good practice is to code the version as `X.x`. For modules still in major version 0, best practice is `X.Y.x`.

Jenkins is fantastic for continuous integration. It uses process exit codes to determine build success (in UNIX, 0 is success). Makefiles run a list of commands and if the exit code is ever non-zero (i.e. failure), then they don't run the rest of the commands. In Bash, `$?` gives the exit code of the previous process. (cd /path/to && ./executable [ARGS]) is a trick temporarily cd to a new folder and run something in places where every command is executed in a new shell? Such as with a Makefile.

Feross isn't a big fan of jQuery. There are good arguments to not use jQuery in [many cases](http://i.stack.imgur.com/ssRUr.gif). The #1 argument is code size (jQuery minified is 93KB; compare with PeerCDN which is currently at ~28KB). So, I've been trying to [wean myself off jQuery](http://substack.net/weaning_yourself_off_jquery). When writing developer tools, such concerns for code size should be thrown out the window. Faster development time is way more important in code size in most cases where perf is not an issue.

Bower is clearly immature. I had to setup some custom Bower repositories in order to get past the lack of a post-install hooks ([post-install scripts are bad](https://github.com/twitter/bower/issues/249)) or some kind of package server based build process. Bower doesn't pull from `HEAD` either, instead it finds the latest version tagged commit. For specific commits to be targeted, see [#275](https://github.com/twitter/bower/issues/275). `bower cache-clean` is useful to get rid of locally cached copies of repos. [Tags in Git](http://git-scm.com/book/en/Git-Basics-Tagging) are pretty similar to branches with respect to adding/deleting them locally and remotely.


In order to make a JavaScript program really reliable, `window.onerror` is incredibly useful.

    function uncaughtExceptionHandler(message, url, line) {  
      alert(message)  
    }  
    window.onerror = uncaughtExceptionHandler  


Unfortunately, you can't get the original `Error` object that triggered the exception because apparently, window.onerror gets run in a different context.

Here's another useful snippet for posterity (I'm too used to using `$.ajax`).

    function XHRPost(url, data){
      var req = new XMLHttpRequest()
      req.open('POST', url)
      req.send(JSON.stringify(data))
    }


Mocha is a really great test runner. I've been using it with chai.js (would like to use it with should.js but there's node-specific code in should.js and I'm running tests in a browser). Other cool modules this week: [MicroEvent](https://github.com/jeromeetienne/microevent.js) (renamed the functions because I prefer `on`, `off`, `emit` over `bind`, `unbind`, `trigger`, etc.). http-proxy.

Annoyingly, nodemon doesn't have a way to specify the directory from which to read .nodemonignore. It uses cwd instead. So, if you have a git repo with multiple projects/servers, you had `cd` first and run nodemon in the correct cwd.

[GitGutter](https://github.com/jisaacks/GitGutter) lets you see what you changed faster instead of having to do a `git diff`. DocBlockr helps you write jsdoc comments that are Closure compatible. Cmd-D is incredibly useful for refactoring JS 
I've been trying to get better at using split views. I think it could make coding server/client code simultaneously much faster.  But because the shortcuts are annoying and I didn't have them memorized, I didn't use it as much.

To debug node, I've picked up the built-in [debugger](http://nodejs.org/api/debugger.html). Printing values is annoying because it seems to print the entire nested object structure. Always having to `cont` on the first run is another annoyance. Learnt about this other tool Hardware IO Tools for Xcode that lets you emulate arbitrary networks on your computer. 

I haven't used Firefox dev tools in a while. And to my delightful surprise, it's so much faster than Chrome. Discovered some weird differences between Firefox and Chrome.

    if (!window.performance) window.performance = {}
    window.performance = window.performance || {};

The second line is disallowed in Firefox because you can't modify native objects. As a general rule, the first one is better because it doesn't perform an assignment unless necessary. Firefox also used to have a bug where hitting ESC key on a page would cause all WebSocket connection to be closed. Related to that, I keep running into this error that prints out as "Firefox Connection interrupted", and I haven't figured out what's causing that.

Been working more with [WebSockets](https://developer.mozilla.org/en-US/docs/WebSockets/WebSockets_reference/WebSocket) a lot. Helpful to know the various exceptions that can be thrown by WebSockets. INVALID_STATE_ERR is an exception thrown when the connection is not currently OPEN. Running `JSON.Parse` multiple times on the server-side is one of the most common errors. Know when you get JSON objects and when you get strings. APIs aren't always very clear on this.

Client-side browser detection can be done [easily](http://www.quirksmode.org/js/detect.html). But since we want to reduce code size, we have to detect the browser on the server. So, we use https://github.com/tobie/ua-parser. For WebSockets using this [node module](https://github.com/Worlize/WebSocket-Node), there's no access to the HTTP WebSocket connection request so the easiest way is to send `navigator.userAgent` and parse on the server. (Instead of doing the simpler thing by taking the ua, I initially went to clone and modify the web socket module. There's always a simpler way to do things.)

