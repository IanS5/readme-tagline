#!/usr/bin/env sh

set -e

has_executable() {
    command -v "$1" >/dev/null
}

echo_err() {
    echo "$@" 1>&2
}

find_readme_in_directory() {
    ls -A1 "$1"         | \
    grep -i '^readme\.' | \
    head -n1
}

find_readme() {
    if test -z "$1"; then
        echo_err "expecting at least one argument"
        exit 1
    fi
    
    if test -f "$1"; then
        echo "$1"
    elif test -d "$1"; then
        readme="$(find_readme_in_directory "$1")"
        if test -z "$readme"; then
            echo_err "could not find README in directory"
            exit 1
        fi
        echo "$1/$readme"
    else
        echo_err "no such file or directory"
        exit 1
    fi
}

html_extract_first_sentance() {
    # Steps:
    #  1. grab the all paragraphs
    #  2. repalce newlines with spaces
    #  3. delete everything after the first end paragraph tag
    #  4. remove html tags
    #  5. delete empty lines
    #  6. remove everything after the first period
    #  7. if the line doesn't end in a period and isn't empty, insert an elipse

    sed -ne '/^<p>/,/<\/p>/p' | \
    tr '\n' ' '               | \
    sed -e 's/<\/p>.*$//g'      \
        -e 's/<[^>]*>//g'       \
        -e '/^[[:space:]]*$/d'  \
        -e 's/\..*$/./'         \
        -e '/[^\.]$/s/$/.../'
}

if has_executable 'pandoc'; then
    readme="$(find_readme "$1")"
    pandoc --standalone --quiet --to html --output - "$readme" | html_extract_first_sentance
else
    echo_err "please install pandoc (https://pandoc.org)"
    exit 1
fi