clean:
	rm -rf docs

web: clean
	mkdir -p docs
	awk -v head='  <link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css">' \
            -f awkdown.awk README.md > docs/index.html
