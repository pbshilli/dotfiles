function keyring-is-unlocked ()
{
    lockedprop=$(busctl --user get-property org.freedesktop.secrets \
                                            /org/freedesktop/secrets/collection/login \
                                            org.freedesktop.Secret.Collection Locked)
    return $([ "$lockedprop" == "b false" ])
}

function keyring-status ()
{
    if keyring-is-unlocked; then
        echo -e "\e[32mGNOME Keyring is unlocked\e[0m"
    else
        echo -e "\e[33mGNOME Keyring is locked\e[0m"
    fi
}

function keyring-status-login ()
{
    echo
    if keyring-is-unlocked; then
        echo "GNOME Keyring is unlocked"
    else
        echo "GNOME Keyring is locked, use \`unlock-keyring\` to unlock"
    fi
}

function unlock-keyring ()
{
    read -rsp "GNOME Keyring password: " pass
    echo ""
    export $(echo -n "$pass" | gnome-keyring-daemon --replace --unlock)
    unset pass
    keyring-status
}
