BEGIN {
    print "<!doctype html><html>"
    print "<head>"
    print "  <meta charset=\"utf-8\">"
    print "  <meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
    if (head) print head
    print "</head>"
    print "<body>"
}

{ data[NR] = $0 }

END {
    for (i = 1; i <= NR; i++)
        render(data[i])

    # Catch any trailing unclosed tags
    if (inq) render()

    print "</body>"
    print "</html>"
}

function render(line) {
    if (line !~ /^> / && inquote) {
        print "</blockquote>"
        inquote = 0
    }

    if (line !~ /^- / && inul) {
        print "</ul>"
        inul = 0
    }

    if (line !~ /^[0-9]+. / && inol) {
        print "</ol>"
        inol = 0
    }

    if (match(line, /_(.*)_/, pats)) {
        gsub(/_(.*)_/, sprintf("<em>%s</em>", pats[1]), line)
    }

    if (match(line, /\*(.*)\*/, pats)) {
        gsub(/\*(.*)\*/, sprintf("<strong>%s</strong>", pats[1]), line)
    }

    if (match(line, /(.*)\[(.+)\]\((.+)\)(.*)/, pats)) {
        gsub(/(.*)\[(.+)\]\((.+)\)(.*)/,
             sprintf("%s<a href='%s'>%s</a>%s", pats[1], pats[3], pats[2], pats[4]), line)
    }

    if (line ~ /^# /) {
        print "<h1>" substr(line, 3) "</h1>"
    } else if (line ~ /^## /) {
        print "<h2>" substr(line, 4) "</h2>"
    } else if (line ~ /^### /) {
        print "<h3>" substr(line, 5) "</h3>"
    } else if (line ~ /^#### /) {
        print "<h4>" substr(line, 6) "</h4>"
    } else if (line ~ /^- /) {
        if (!inul) {
            print "<ul>"
            inul = 1
        }
        print "<li>" substr(line, 3) "</li>"
    } else if (line ~ /^[0-9]+. /) {
        if (!inol) {
            print "<ol>"
            inol = 1
        }
        print "<li>" substr(line, 4) "</li>"
    } else if (line ~ /^> /) {
        if (!inquote) {
            print "<blockquote>"
            inquote = 1
        }
        print substr(line, 3)
    } else if (line ~ /^```/) {
        if (!inpre) {
            print "<pre>"
            inpre = 1
        } else {
            print "</pre>"
            inpre = 0
        }
    } else if (inpre) {
        print line
    } else if (line ~ /^---$/) {
        print "<hr />"
    } else if (line !~ /^$/) {
        print "<p>" line "</p>"
    }
}
