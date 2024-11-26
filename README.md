# minimal_examples
In this repo, I collect my minimal examples for QA in forums

Each example lives in its own branch

## quartotypstcsl

if you declared a cls in your YAML, quarto will insert a #set bibliography(style: csl) without giving you the chance to #let csl = csl.replace("\\", ""), leaving you with wrong "\" inside the path.

My workaround is to declare my own variable, like mycsl. This way, quarto won't trigger a #set bibliography() and I can replace the "\\" and call #set bibliography(style: mycsl) on my own.

<https://github.com/quarto-dev/quarto-cli/discussions/11364#discussioncomment-11388382>
