
export my_home="/Users/jtoyota"

## Paths: ~/lists and ~/.listrc
export l="$my_home/lists"  # export l="$HOME/lists"
export list_dir="$my_home/lists"  # export list_dir="$HOME/lists"
export lists_dir="$my_home/lists"  # export lists_dir="$HOME/lists"
export mylistrc="$my_home/.listrc"  # export mylistrc="$HOME/.listrc"

## Paths: ~/bin
export bin="$my_home/bin"  # export bin="$HOME/bin"
export mybin="$my_home/bin"  # export mybin="$HOME/bin"

## s3 / s3sync env(s)
export AWS_ACCESS_KEY_ID="1JGCQN7DF0SFABE4DBG2"
export AWS_SECRET_ACCESS_KEY="mSp5FMTN0t7QBKqRS7vEFRHeN+tALyelTiv7MIVo"

export rgvpn="173.203.44.236"


################## rails paths ##################

v="app/views"
m="app/models"
c="app/controllers"
t="features"

export v m c t 

##################### repos #####################

saveology="$HOME/Sites/saveology"
iterator="$HOME/Sites/iterat.org"
kikin="$HOME/Sites/kikin/"
clit="$HOME/Sites/cli-tracker"
funding="$HOME/Sites/funding"

export saveology iterator kikin clit funding


################## heroku apps ##################

staging="saveology-admin-staging"
admin="saveology-admin-production"
deals="saveology-deals-production"
production="$deals"

export staging admin deals production


# BC ENVIRONMENT ARGS

export BC_ENV_ARGS="-l"

