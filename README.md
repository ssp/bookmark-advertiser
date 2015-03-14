# bookmark-advertiser
Advertise info about open Safari Tabs using Bonjour

An application which reads the web pages currently opened in Safari and advertises the name and URL of each of them via Bonjour. Each bookmark is advertised as a Service of type `_urlbookmark._tcp` and the relevant information is contained in the Service’s TXT Record. This makes it easy to read the information and due to the length limitations of TXT Records (read: programmer laziness) means it will fail for very long URLs.

The main purpose of this tool is to send a web page that’s viewed in Safari on the Mac to Mobile Safari on the iPod touch or iPhone without needing to type or send an e-mail. In fact, the [Flame Touch](https://github.com/tominsam/flametouch) application will do – among other things – just that and offers a handy button for opening the web pages advertised in this fashion.
