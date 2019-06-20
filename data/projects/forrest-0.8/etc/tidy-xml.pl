#!/usr/bin/perl -w

# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

##########################################################
#
# Find all xml type files and run 'tidy' on each.
# Intended to be run occasionally by committers.
#
# Developed only for UNIX, YMMV.
#
# Procedure:
# Run the script. It will descend the directory tree.
# Run with no parameters or -h to show usage.
#
##########################################################

use strict;
use vars qw($opt_h $opt_v);
use Getopt::Std;
use File::Basename;
use File::Find;

#--------------------------------------------------
# ensure proper usage
getopts("hv");
if ((scalar @ARGV < 2) || defined($opt_h)) {
  ShowUsage();
  exit;
}
my $startDir = shift;
if (!-e $startDir) {
  print STDERR "\nThe start directory '$startDir' does not exist.\n";
  ShowUsage();
  exit;
}
my $configFile = shift;
if (!-e $configFile) {
  print STDERR "\nThe configuration file '$configFile' does not exist.\n";
  ShowUsage();
  exit;
}

#--------------------------------------------------
# configuration
my $command = "tidy -config $configFile";
my @xmlFileTypes = (
  ".xml", ".xsl", ".xslt", ".xmap", ".xcat",
  ".xmap", ".xconf", ".xroles", ".roles", ".xsp", ".rss",
  ".xlog", ".xsamples", ".xtest", ".xweb", ".xwelcome",
  ".samplesxconf", ".samplesxpipe", ".svg", ".xhtml", ".jdo", ".gt", ".jx", ".jm
x",
  ".jxt", ".meta", ".pagesheet", ".stx", ".xegrm", ".xgrm", ".xlex", ".xmi",
  ".xsd", ".rng", ".rdf", ".rdfs", ".xul", ".tld", ".xxe", ".ft", ".fv",
);
my $countTotal = 0;

chdir "$startDir" or die "Cannot cd to '$startDir': $!\n";

#--------------------------------------------------
sub process_file {
  return unless -f && -T; # process only text files
  my $fileName = $File::Find::name;
  my ($file, $dir, $ext) = fileparse($fileName, qr/\.[^.]*/);
  return if ($dir =~ /\/\.svn\//); # skip SVN directories
  return if ($dir =~ /\/CVS\//); # skip CVS directories
  return if ($dir =~ /\/build\//); # skip build directories
  return if ($file =~ /^\./); # skip hidden files
  return unless isXmlType($ext); # process only xml files
  $fileName =~ s/^\.\///; # strip leading ./
  my $pathName = $startDir . "/" . $fileName;
  $countTotal++;
  if ($opt_v) { print "$fileName : \n"; }
  open (TIDY, "$command $fileName |") or die "Cannot run 'tidy': $!";
  while (<TIDY>) {
    print;
  }
  close TIDY;
}
find(\&process_file, ".");

#--------------------------------------------------
# report some statistics
print qq!
Processed $countTotal xml-type files.
!;
print "\n";

#==================================================
# isXmlType
#==================================================

sub isXmlType {
  my ($extension) = @_;
  foreach my $e (@xmlFileTypes) {
    return 1 if $extension eq $e;
  }
  return 0;
}

#==================================================
# ShowUsage
#==================================================

sub ShowUsage {
  print STDERR qq!
Usage: $0 [-h] [-v] startDir configFile > logfile

  where:
  startDir = The directory (pathname) to start processing. Will descend.
  configFile = Pathname for configuration file for 'tidy'

  option:
  h = Show this help message.
  v = Be verbose.

Note: It will skip directories with name /build/

!;
}
