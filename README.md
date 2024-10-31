# minimal_examples
In this repo, I collect my minimal examples for QA in forums

Each example lives in its own branch

## longlist
This is the minimal example for my problem with long lists in callout boxes and PDF
<https://github.com/quarto-dev/quarto-cli/discussions/11212>

The problem was that the content does not break across pages; instead, any content that reaches the page end is not displayed in the PDF output.

My dirty hack:  Instead of using the built-in `:::{callout}` syntax, I created a new `:::{.longlistcallout}` class and added a Lua filter to style it for LaTeX and HTML output.

This looks just nice and works for me.
