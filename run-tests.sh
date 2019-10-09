#!/usr/bin/sh

SHELLS="ksh bash zsh ash dash"
SCRIPT='./readme-tagline.sh'
TEST_DIR="tests"

has_executable() {
    command -v "$1" >/dev/null
}

runcheck() {
    expect="$3"
    input="$2"
    sh="$1"

    out="$("$sh" "$SCRIPT" "$TEST_DIR/$input")"
    if [ "$expect" != "$out" ]; then
        echo "[FAIL] shell='$sh', input='$input', output='$out', expect='$expect'"
    fi
}

if has_executable "shellcheck"; then
    echo "[INFO] linting..."
    shellcheck --color=auto --shell=sh "$SCRIPT"
    echo "[INFO] done"
else
    echo "[WARN] couldn't find shellcheck, skipping linting step"
fi

for sh in $SHELLS; do
    if has_executable "$sh"; then
        upper_sh="$(echo "$sh" | tr '[:lower:]' '[:upper:]')"

        version="$(echo "echo \$${upper_sh}_VERSION" | "$sh" 2>&1)"
        if [ -z "$version" ]; then
            version="$("$sh" --version 2>&1 | head -n1)"
            if [ -z "$version" ] || [ $? != 0 ]; then
                version="not found"
            fi
        fi
        
        echo "[INFO] testing $sh, version = $version"

        runcheck "$sh" "search" "Found the right one..."
        for fmt in md org txt; do
            runcheck "$sh" "test-readme.$fmt" "Lorem Ipsum, italics end of sentence."
        done
    else
        echo "[WARN] couldn't find $sh, skipping..."
    fi
done