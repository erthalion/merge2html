vimhtml() {
    [[ -f "$1" ]] || return 1; vim +'syn on | set filetype=cpp | set foldmethod=syntax | set nowrap | run! syntax/2html.vim | wq | q' "$1" > /dev/null;
}

DIRECTORY=merging-$(date +%F-%T)
FILES=$(grep -lr '<<<<<<<' *.cpp)

mkdir $DIRECTORY

for file in $FILES; do
    awk -f convert.awk $file >> $file.conflicts
    vimhtml $file
    vimhtml $file.conflicts
    rm $file.conflicts

    mv $file.html $DIRECTORY
    mv $file.conflicts.html $DIRECTORY
done

cat > $DIRECTORY/index.html << EOF
    <html>
    <head>
        <title>Merge information</title>
    </head>

    <body>
    <h1>Merge information</h1>
EOF

for file in $FILES; do
cat >> $DIRECTORY/index.html << EOF
    <p><a href="./$file.conflicts.html">$file merging conflicts</a></p>
    <p><a href="./$file.html">$file</a></p>
EOF
done

cat >> $DIRECTORY/index.html << EOF
    </body>
    </html>
EOF
