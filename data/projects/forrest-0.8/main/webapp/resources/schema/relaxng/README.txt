This directory contains XML schemas which describe the various XML formats used
in Forrest.

The schemas are written in RELAX NG, a schema language devised by James Clark,
SGML boffin, XML inventor and all-round smart guy.

RELAX NG is widely regarded to be the simplest, most powerful, and easy to
learn schema language available.

Relevant URLs:

The RELAX NG "home page" at the OASIS RELAX NG Technical Committee:
http://www.oasis-open.org/committees/relax-ng/

The RELAX NG tutorial:
	http://www.oasis-open.org/committees/relax-ng/tutorial.html

The RELAX NG Compact Syntax spec (definition of the non-XML syntax
used here *.rnx files):
  http://www.oasis-open.org/committees/relax-ng/compact-20021121.html

Jing RELAX NG validator in Java:
	http://www.thaiopensource.com/relaxng/

Trang Multi-format XML schema converter based on RELAX NG
Trang converts between different schema languages for XML.
	http://www.thaiopensource.com/relaxng/trang.html

To run an XML file against a .rng schema using Jing, see the
"validate-config" target in xml-forrest/build.xml or do this:

java -jar $FORREST_HOME/WEB-INF/lib/jing.jar [.rng file] [.xml file]

If you're running JDK 1.3.x or lower, you'll need to add
$FORREST_HOME/lib/endorsed/*.jar to your classpath first.
