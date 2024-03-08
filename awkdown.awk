BEGIN {
    print "<!doctype html><html>"
    print "<head>"
    print "  <meta charset=\"utf-8\">"
    print "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
    if (head) print head
    print "</head>"
    print "<body>"
}

/^# /               { print "<h1>" substr($0, 3) "</h1>"; next }
/^## /              { print "<h2>" substr($0, 4) "</h2>"; next }
/^### /             { print "<h3>" substr($0, 5) "</h3>"; next }
/^#### /            { print "<h4>" substr($0, 6) "</h4>"; next }
/^---$/             { print "<hr />"; next }
inpre && /^```/     { print "</pre>"; inpre = 0; next }
/^```/              { print "<pre>"; inpre = 1; next }
/^-/                { if (!inul) print "<ul>"; inul = 1; print "<li>" substr($0, 3) "</li>"; next }
inul && !/^-/       { print "</ul>"; inul = 0; next }
/^[0-9]+./          { if (!inol) print "<ol>"; inol = 1; print "<li>" substr($0, length($1)+2) "</li>"; next }
inol && !/^[0-9]+./ { print "</ol>"; inol = 0; next }
/^> /               { if (!inquote) print "<blockquote>"; inquote = 1; print substr($0, 3); next }
inquote && !/^> /   { print "</blockquote>"; inquote = 0; next }
/./                 { for (i=1; i<=NF; i++) collect($i) }
/^$/                { flushp() }
END                 { flushp(); flushtags() }

END {
    print "</body>"
    print "</html>"
}

function collect(v) {
    line = line sep v
    sep = " "
}

function flushp() {
    if (line) {
        print "<p>" render(line) "</p>"
        line = sep = ""
    }
}

function render(line) {
    if (match(line, /_(.*)_/)) {
        gsub(/_(.*)_/, sprintf("<em>%s</em>", substr(line, RSTART+1, RLENGTH-2)), line)
    }

    if (match(line, /\*(.*)\*/)) {
        gsub(/\*(.*)\*/, sprintf("<strong>%s</strong>", substr(line, RSTART+1, RLENGTH-2)), line)
    }

#     if (match(line, /(.*)\[(.+)\]\((.+)\)(.*)/, pats)) {
#         gsub(/(.*)\[(.+)\]\((.+)\)(.*)/,
#              sprintf("%s<a href='%s'>%s</a>%s", pats[1], pats[3], pats[2], pats[4]), line)
#     }

    return line
}

function flushtags() {
    if (inquote) print "</blockquote>"
    if (inol) print "</ol>"
    if (inul) print "</ul>"
    if (inpre) print "</pre>"
}
