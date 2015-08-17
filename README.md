# bookmark-advertiser
Advertise info about open Safari Tabs using Bonjour

Bookmark Advertiser reads the web pages currently opened in Safari and advertises the name and URL of each of them via Bonjour. Each bookmark is advertised as a Service of type `_urlbookmark._tcp` and the relevant information is contained in the Service’s TXT Record. This makes it easy to read the information. Due to the length limitations of TXT Records (read: programmer laziness), it will fail for very long URLs.

The main purpose of this tool is to send a web page that’s viewed in Safari on the Mac to Mobile Safari on the iOS without needing to type or send an e-mail. In fact, the [Flame Touch](https://github.com/tominsam/flametouch) application will do – among other things – just that and offers a handy button for opening the web pages advertised in this fashion.


Version 1.4 (7) and above requires at least Mac OS X.9 to run.
Please use earlier versions of Bookmark Advertiser to run on Mac OS X.5 through Mac OS X.8.
