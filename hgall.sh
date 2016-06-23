#!/bin/bash
usage="Usage: $0 [-a|_] [ list | help | do | inc | out | fetch | cm '[message]' | push | sum | st | log [args] | update [args] | branch [args] | io | prompt | @ | ss ]\nUse: hgall do [command] to use any hg command not explicitly supported"
IFS="`printf '\n\t'`" # allow spaces in repo names
if [ $# -lt "1" ]
then
  echo -e $usage
  exit
fi  
 
# Find all the directories that are mercurial repos
case $1 in
    _)
    dirs=(`find .  -name ".hg" -depth 2 -wholename "*\_*"`)
    hgcmd="$2"
    hgargs="$3 $4 $5 $6 $7 $8"
    ;;
    -a)
    dirs=(`find . -name ".hg" -depth 2`)
    hgcmd="$2"
    hgargs="$3 $4 $5 $6 $7 $8"
    ;;
    *)
    dirs=(`find .  -name ".hg" -depth 2 -not -wholename "*\_*"`)
    hgcmd="$1"
    hgargs="$2 $3 $4 $5 $6 $7"
    ;;
esac

unset IFS
echo $hgargs
# Remove the /.hg from the path and that's the base repo dir
merc_dirs=( "${dirs[@]//\/.hg/}" )

case $hgcmd in
    list)
    for indir in "${merc_dirs[@]}"; do
        echo "$indir"
    done
    ;;
    inc)
    for indir in "${merc_dirs[@]}"; do
        echo "INCOMING for [${indir}]"
	echo "${indir}"
        hg -q -v -R "$indir" incoming --template '{rev} {node|short} | {date|isodatesec} | {author|user}: {desc|strip|firstline}\n' $hgargs
    done
    ;;
    out)
    for outdir in "${merc_dirs[@]}"; do
        echo "OUTGOING for [${outdir}]"
        hg -q -R "$outdir" outgoing --template '{rev} {node|short} | {date|isodatesec} | {author|user}: {desc|strip|firstline}\n' $hgargs
    done
    ;;
    fetch)
    for repdir in "${merc_dirs[@]}"; do
        echo "FETCH: [${repdir}]"
        hg -R "$repdir" fetch $hgargs 
    done
    ;;
    cm)
    for repdir in "${merc_dirs[@]}"; do
        echo "Commit: [${repdir}] -m '$hgargs'"
        hg -R "$repdir" commit -m "$hgargs" 
    done
    ;;
    push)
    for repdir in "${merc_dirs[@]}"; do
        echo "PUSH: [${repdir}]"
        hg -q -R "$repdir" push $hgargs 
    done
    ;;
    sum)
    for repdir in "${merc_dirs[@]}"; do
        echo "SUMMARY for [${repdir}]"
        hg -q -R "$repdir" sum $hgargs 
    done
    ;;
    st)
    for repdir in "${merc_dirs[@]}"; do
        echo "STATUS for [${repdir}]"
        hg  -R "$repdir" st $hgargs 
    done
    ;;
    log)
    for repdir in "${merc_dirs[@]}"; do
        echo "LOG $hgargs for [${repdir}]"
        hg  -R "$repdir" log $hgargs 
    done
    ;;
    slog)
    for repdir in "${merc_dirs[@]}"; do
        echo "slog $hgargs for [${repdir}]"
        hg  -R "$repdir" log --template '{rev} {node|short} | {date|isodatesec} | {author|user}: {desc|strip|firstline}\n' $hgargs 
    done
    ;;
    update)
    for repdir in "${merc_dirs[@]}"; do
        echo "UPDATE $hgargs for [${repdir}]"
        hg  -R "$repdir" update $hgargs 
    done
    ;;
    branch)
    for repdir in "${merc_dirs[@]}"; do
        echo "BRANCH $hgargs for [${repdir}]"
        hg  -R "$repdir" branch $hgargs 
    done
    ;;
    io)
    for outdir in "${merc_dirs[@]}"; do
	echo
        hg -R "$outdir" prompt "{root|basename}{  inc:{incoming|count}}{  out:{outgoing|count}}" 2> /dev/null
    done
    echo
    ;;
    prompt)
    for outdir in "${merc_dirs[@]}"; do
	echo
        hg -R "$outdir" prompt "{[{incoming|count}]->}[{root|basename}{/{branch}}]{->[{outgoing|count}]}{ at {bookmark}}{ {status}}{ {update} }" 2> /dev/null
    done
    echo
    ;;
    @)
    for outdir in "${merc_dirs[@]}"; do
	echo
        hg -R "$outdir" overview --hide-branch-overview
    done
    echo
    ;;
    ss)
    for outdir in "${merc_dirs[@]}"; do
    echo
        echo "======= SUPERSTATUS for [${outdir}] ==========";
        echo "------------------- STATUS -------------------";
        hg -R "$outdir" st;
        echo;
        echo "------------------- SUMMARY ------------------";
        hg -R "$outdir" sum;
        echo;
        echo "------------------- INCOMING -----------------";
        hg -R "$outdir" inc;
        echo;
        echo "------------------- OUTGOING -----------------";
        hg -R "$outdir" out;
    done
    echo
    ;;
    help)
    echo -e $usage 
    ;;
    do)
    for repdir in "${merc_dirs[@]}"; do
        echo "For [${repdir}] DO [$hgargs]"
        hg  -R "$repdir" $hgargs 
    done
    ;;
    *)
    echo "Unknown command: $1"
    echo -e $usage 
    ;;
esac
