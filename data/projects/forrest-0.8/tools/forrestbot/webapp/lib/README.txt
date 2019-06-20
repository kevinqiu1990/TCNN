This directory is *ONLY* for dependencies that are not in a maven repository.

If you need to put a .jar file here, then you need to specify something like this in project.properties

maven.jar.override = on
maven.jar.osuser = ${basedir}/lib/osuser-1.0-dev.jar
