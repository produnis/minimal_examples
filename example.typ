#let rcode(content) = block(
    inset: 4mm,
    fill: rgb("#eff2ff"),
    width: 100%,
    radius: 4pt,
    content
)

This is my example

#rcode(
```
x <- data.frame(x=c(2:4),
                y= c(4:6))
```
)

everything works

#rcode(
```r
x$y is now corrupt
```
)

Now it is corrupt

If you put it #strong[here `x$x`] everything works again.
