BEGIN {
    print "<!doctype html><html>"
    print "<head>"
    print "  <meta charset=\"utf-8\">"
    print "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
    print "</head>"
    print "<body>"
}

{ data[NR] = $0 }

END {
    for (i = 1; i <= NR; i++)
        render_line(data[i])

    # Flush any remaining open tags
    if (inq)
        render_line()

    print "</body>"
    print "</html>"
}

function render_line(line) {
    if (line ~ /^# /) {
        print "<h1>" substr(line, 3) "</h1>"
    } else if (line ~ /^## /) {
        print "<h2>" substr(line, 4) "</h2>"
    } else if (line ~ /^> /) {
        if (!inq) {
            print "<blockquote>"
            inq = 1
        }
        print substr(line, 3)
    } else if (line !~ /^> / && inq) {
        print "</blockquote>"
        inq = 0
    }
}
