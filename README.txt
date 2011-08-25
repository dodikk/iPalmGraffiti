A PalmOS-like textual gestures recognition.
It implements a custom gesture recognizer which records all the points the touch goes through and analyzes them.
The first version should support only English alphabet ( just as the original graffiti did ).
-------------------

At the moment it contains a simple implementation from the JS-Canvas example :
http://home.comcast.net/~urbanjost/canvas/graffiti/graffiti.html

The curve is split to 10 segments. The points are linearry interpolated and normalized to the 10X10 space.
After that an MSE (mean square error) is computed on all pairs of the user input and memorized samples.



License                : BSD
iOS deployment version : iOS 4.0
ARC enabled            : NO
--------------------


--------------------
The project is packaged as a static library.
On the static libraries usage please consider the following manuals :
   * https://github.com/EmbeddedSources/iOS-articles/blob/master/3-iContiniousIntegration/ciPresentation.pdf?raw=true
   * https://github.com/EmbeddedSources/iOS-articles/blob/master/3-iContiniousIntegration/iContiniousIntegration.pdf?raw=true
--------------------



