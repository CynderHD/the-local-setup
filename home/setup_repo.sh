if [ -z "$1" ]; then
    echo "You have to pass your github username as the first argument! For example, './setup_repo.sh jane-doe the-website'"
    exit 1
fi

if [ -z "$2" ]; then
    echo "You have to pass the repo name as the second argument! For example, './setup_repo.sh jane-doe the-website'"
    exit 1
fi

(
    mkdir -p ~/pv
    cd ~/pv

    if [ "$1" != "Progressive-Victory" ]; then
        mkdir -p "$1"
        cd $1
    fi

    if [ -d "$2" ]; then
        cd "$2"
        git pull
    else
        git clone "git@github.com:$1/$2" "$2" || exit 1
        cd "$2"
    fi

    pnpm install
)
