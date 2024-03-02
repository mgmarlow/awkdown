web:
	awk -v head='  <link rel="stylesheet" href="https://cdn.simplecss.org/simple.min.css">' -f awkdown.awk README.md > demo.html
