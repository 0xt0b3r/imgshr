IMGSHR
======

[![Dependency Status](https://img.shields.io/gemnasium/nning/imgshr.svg)](https://gemnasium.com/nning/imgshr)
[![Code Climate](https://img.shields.io/codeclimate/github/nning/imgshr.svg)](https://codeclimate.com/github/nning/imgshr)

Simple image gallery sharing application. Galleries are creatable by everyone
and available with a token in the URL. Everyone with the correct URL can change
the gallery name, upload images and set their title. On creation, a boss token
is generated, which can be used to delete the whole gallery, single pictures or
make the gallery read-only later on.

You can test this at https://imgshr.orgizm.net!

Features
--------

* Galleries are shared via secret token in URL. Like in
  [https://imgshr.orgizm.net/!Njg4NThi](https://imgshr.orgizm.net/!Njg4NThi).
* Galleries are editable by everyone or -- when they are configured to be
  read-only -- with a boss token (URL).
* Pictures can be shared with token URLs to prevent giving away a gallery's
  token.
* EXIF data is read and shown.
* Pictures can be rated.
* Infinite scrolling on gallery page.
* Lazy image loading.
* Responsive design.

License
-------

Copyright © 2014-2015 [henning mueller](http://henning.orgizm.net/), released
under the terms of [GNU AGPL 3.0](http://www.gnu.org/licenses/agpl-3.0.html).
