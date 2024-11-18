if status is-interactive
    set fish_greeting
    set -lx SHELL fish
    keychain --eval --agents ssh --quiet -Q id_rsa | source
    alias vim="vim -X"
end

