# minimal_examples
In this repo, I collect my minimal examples for QA in forums

Each example lives in its own branch



## Logo problem

discussed here: <https://github.com/quarto-dev/quarto-cli/discussions/13491>



My extension provides a logo at `_extensions/hsnr-aushang/HSNRfb10s.png`.
This worked just fine....

Now, after the summer break, I come back to see that is throws an error:

> [typst]: Compiling Beispiel.typ to Beispiel.pdf...error: file not found (searched at /home/produnis/minimal_examples/true)

The "logo" file path (see `_extension.yml`) is now overwritten to "`true`" instead.

If I set a "new" logo in the qmd-document, it throws the same error, and "logo" is TRUE.

If I set the "new" logo to some fantasy-filename, it throws:

> [typst]: Compiling Beispiel.typ to Beispiel.pdf...error: file not found (searched at /home/produnis/Dokumente/Programmierung/minimal_examples/HSNRfb10s.pngr)

So, the file name is "there". But if I state a "real" existing file name, it goes back to "TRUE".

