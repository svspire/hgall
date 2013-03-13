hgall
====
Script that allows maintaining multiple hg repo's at once.

I can't take full credit - this script is a highly modified adaption of an equivalent script for SVN, the origins of which I have unfortunately forgotten, and been unable to trace.

Install
========
Suggestion:
1. Download the script or clone the repo to whatever location you see fit.
2. Symlink the hgall.sh script to e.g. /usr/local/bin/hgall  
3. Make it executable with chmod u+x
4. Profit

Usage summary: 
=====
hgall [-a|_] [ list | help | do | inc | out | fetch | cm '[message]' | push | sum | st | log [args] | update [args] | branch [args] | io | prompt | @ | ss ]
Use: hgall do [command] to use any hg command not explicitly supported

More
======
The script will check your local dir for any hg-repositories (dir's that have a .hg file). It will then run the specified command on each of these. 
The current strategy is that most of the commands I regularly use are explicitly supported, in order to provide custom output or parameters.
In the case where you want to use unsupported hg commands, there is a "hgall do <command>" option that allows you to do anything supported by hg.

To suite my own preferences, the script by default ignores any repo's starting with underscore. This allows me to have short or long term local clones of repo's for 
testing dangerous operations. I.e. I will just do a (nearly instant) local 'hg clone myrepo _myrepo' and test any crazy stuff on the copy (e.g. big branch merges). If the test goes well, 
I either discard and repeat on the real repo or push to the "real" repo i cloned from.

As said, the default is to ignore underscore-repos. Use 'hgall -a ...' to use all repo's, or 'hgall _ ...' to do operations on just the "hidden" repo's. 

Extensions
===========
The script supports some commands that are provided by official and 3rd-party extensions. If you want to use these, you need the following:

Native extensions that must be enabled in hgrc: 
--------------
    [extensions]
    fetch = 
    graphlog =

3rd-party extensions
----------------------
You will need to get the following two extensions:
(http://bitbucket.org/sjl/hg-prompt/)
(https://bitbucket.org/obensonne/hg-compass)

both have to be enabled in your hgrc file:
    [extensions]
    prompt = ~/hgextensions/hg-prompt/prompt.py
    compass = ~/hgextensions/hg-compass/compass.py
(or whereever you choose to place them)



Examples:
============
hgall list
 - just lists the found repositories

hgall inc
 - Shows incoming changesets for all repos using a custom compact (single-line) template for the output

hgall fetch
 - does a fetch for each (provided that fetch extension is enabled)

hgall cm "my commit message"
 - commits all repo's with the provided message.

hgall ss
 - shows a "super summary" for the repositories (i.e. a nicely formatted combination of status, summary, incoming and outgoing)

hgall @
 - uses the hg-compass extension to show a nice bookmark and branch summary for each repo


