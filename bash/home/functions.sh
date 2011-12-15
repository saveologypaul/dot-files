# Functions

eman() {
  man "$1" | col -b | vim -
}

newldir() {

  if [ -z $1 ]
  then
    ldirpath=`pwd`
  else
    ldirpath=$*
  fi
  # v4.0 ( 72)
	ls -lphS $ldirpath | awk '{$7=$5;$1=$2=$3=$4=$5=$6="";$8="\t";print substr($0,7)}'

	# v3.0 ( 75)
	# ls -lphS | awk '{$1=$2=$3=$4=$6="";$7=$5;$5="";$8="\t";print substr($0,7)}'

	# v2.0 ( 87) 
	# ls -lphS | awk '{$1="";$2="";$3="";$4="";$6="";$7=$5;$5="";$8="\t";print substr($0,7)}'

	# v1.0 (119) 
	# ls -lphS | awk '{print $5,"\t",$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30}'

  #  87 - 72 = 15 characters smaller than v2
  # 119 - 72 = 47 characters smaller than v1

}

ldir() {
  if [ -z $1 ]
  then
    ldirpath=`pwd`
  else
    ldirpath=$*
  fi
	ls -lphS $ldirpath | awk '{print $5,"\t",$9,$10,$11,$12,$13,$14,$15,$16,$17,$18,$19,$20,$21,$22,$23,$24,$25,$26,$27,$28,$29,$30}'
}

old_list() {
	case $1 in

		'') ls -1 ~/reminders;;
		-e) vim ~/reminders/$2;;
		*) clear; remind ~/reminders/$1;;

	esac
}

myips () {
  echo
  for a in $(ifconfig -l)
  do
    ips=$(ifconfig "$a" | egrep -o '[0-9]{1,3}(\.[0-9]{1,3}){3}')
    if [[ "${#ips}" -gt 0 ]]
    then
      echo "$a"
      echo "$ips" | sed 's/^/  /'
      echo
    fi
  done

  echo
  echo "Remote IP:"
  echo "----------"
  whatismyip
  echo
}

backupiphone-now () {
  ls -al
  bkupdir=iPhone.`date +"%Y.%m%d-%H:%M:%S"`
  echo
  echo "$bkupdir"
  mkdir "$bkupdir"
  echo
  echo "mv 2010.0603-03:44:39 to iPhone...2010-02-13-18:09pm"
  rsync -avz --exclude "/private/var" --delete --backup --backup-dir="$bkupdir" iphone:/ iPhone/ 2>&1
}

backupiphone () {
  ls -al
  bkupdir=iPhone.`date +"%Y.%m%d-%H:%M:%S"`
  echo
  echo "$bkupdir"
  mkdir "$bkupdir"
  echo
  echo "mv 2010.0603-03:44:39 to iPhone...2010-02-13-18:09pm"
  rsync -avzn --exclude "/private/var" --delete --backup --backup-dir="$bkupdir" iphone:/ iPhone/ 2>&1
}

who2 () {
  who -ma
  echo
  who -ma 2>&1 | sed 's/	/    /g;s/./-/g'
  echo
  who -a
}

export MYBASHHISTORY='/var/log/bash_history.josh.CreatedOn.2010-0713.00.log'

## other stuff

function seconds_to_ymd() { date -jr $1 +'%Y-%m-%d %H:%M:%S'; }

function rofl()
{
  echo
  cat <<"LOL"
ROFL:ROFL:LOL:ROFL:ROFL
           |
  L   /---------
 LOL===       []\
  L    \         \
        \_________\
          |     |
       -------------/
LOL
  echo
}

function lol() { yes "$(rofl;sleep 1; clear)"; }


## List the git repos on my machine that changed

repo_changed () {
  last_dir=`pwd` ### my change 2011-12-06 11:11:17
  cd $1 ### my change 2011-12-06 11:11:17
  local g="$(git rev-parse --git-dir 2>/dev/null)"
  if [ -n "$g" ]; then
    local r
    local b
    local d
    local s
    # Rebasing
    if [ -d "$g/rebase-apply" ] ; then
      if test -f "$g/rebase-apply/rebasing" ; then
        r="|REBASE"
      fi
      b="$(git symbolic-ref HEAD 2>/dev/null)"
    # Interactive rebase
    elif [ -f "$g/rebase-merge/interactive" ] ; then
      r="|REBASE-i"
      b="$(cat "$g/rebase-merge/head-name")"
    # Merging
    elif [ -f "$g/MERGE_HEAD" ] ; then
      r="|MERGING"
      b="$(git symbolic-ref HEAD 2>/dev/null)"
    else
      if [ -f "$g/BISECT_LOG" ] ; then
        r="|BISECTING"
      fi
      if ! b="$(git symbolic-ref HEAD 2>/dev/null)" ; then
        if ! b="$(git describe --exact-match HEAD 2>/dev/null)" ; then
          b="$(cut -c1-7 "$g/HEAD")..."
        fi
      fi
    fi

    # Dirty Branch
    local newfile='?? '
    if [ -n "$ZSH_VERSION" ]; then
      newfile='\?\? '
    fi
    d=''
    s=$(git status --porcelain 2> /dev/null)
    [[ $s =~ "$newfile" ]] && d+='+'
    [[ $s =~ "M " ]] && d+='*'
    [[ $s =~ "D " ]] && d+='-'

    [[ -z $r && -z $d ]] || echo -n "| ${1/$HOME/~} (${r}${d}) " ### my change 2011-12-06 11:11:02 
  fi
  cd $last_dir ### my change 2011-12-06 11:10:56
}

list_repos() {
  for repo in ${repos//:/ }
  do
    echo "$repo"
  done
}

gcd () {
  cd $(list_repos | grep -i "$1")
}

list_changes() {
  for repo in ${repos//:/ }
  do
    repo_changed "$repo"
  done
  echo "|"
}


## Run and rerun the test suite automagically

fail() {
  echo "Running:"
  echo '--------------------------------'
  declare -f fail
  the_date=$(date +"%Y%m%d%H%M%S")
  log_file="fail.${the_date}.log"
  echo '--------------------------------'
  echo 'log_file: [tmp/'$log_file'] the_date: ['$the_date']'
  echo '--------------------------------'
  echo
  rake db:migrate db:test:prepare
  bundle exec specjour | tee "tmp/$log_file"
  [[ -r "tmp/fail.log" ]] && rm "tmp/fail.log"
  ln -s "$(pwd)/tmp/$log_file" "tmp/fail.log"
}

failed_tests() {
  sed -n '/Failing Scenarios/,$p' "tmp/fail.log" | grep -o 'features[/][^#]*' | sed 's/ *$//' | sed 's/.*//'
}

unfail() {
  the_date=$(date +"%Y%m%d%H%M%S")
  log_file="fail.${the_date}.log"
  bundle exec cucumber -f progress $(failed_tests) | tee "tmp/$log_file"
  [[ -r "tmp/fail.log" ]] && rm "tmp/fail.log"
  ln -s "$(pwd)/tmp/$log_file" "tmp/fail.log"
}

## Have a searchable/parsable list of the files that have changed

function gs() {

  gst | sed "s/...//" | grep "$1" | sort -u

  #re='/Untracked/,$s/#[[:space:]]*([^ ]*$)/\1/p;s/.*: *//p'
  #case $1 in
  #  -h)
  #    cont='s/app.controllers.(.*)_controller.rb/Controller: \1/'
  #    view='s/app.views.(.*)[.]html.*/View: \1/'
  #    feat='s/features.(.*).feature/Test: \1/'
  #    git status | sed -En "$re" | grep "$2" | sed -E "/^$/d;$cont;$view;$feat" | sort -u ;;
  #  '' | *)
  #    git status | sed -En "$re" | grep "$1" | sed '/^$/d' | sort -u ;;
  #esac

  #git status | sed -n 's/.*:[^a-z]*//'
  #git status | grep -o ': .*' | sed 's/[^a-z]*//' | grep "$1" | sort -u
  #git status | sed -n 's/.*: *//p' | grep "$1" | sort -u
}

_man () {
  if (man $1 | grep '^BUILTIN'); then
    man bash | col -b | sed -n '/^SHELL BUILTIN/,$p' | less +/$1
  else
    man $1
  fi
}

