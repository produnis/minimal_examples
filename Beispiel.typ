// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = line(start: (25%,0%), end: (75%,0%))

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): set block(
    fill: luma(230),
    width: 100%,
    inset: 8pt,
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.abs
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == str {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == content {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

// Subfloats
// This is a technique that we adapted from https://github.com/tingerrr/subpar/
#let quartosubfloatcounter = counter("quartosubfloatcounter")

#let quarto_super(
  kind: str,
  caption: none,
  label: none,
  supplement: str,
  position: none,
  subrefnumbering: "1a",
  subcapnumbering: "(a)",
  body,
) = {
  context {
    let figcounter = counter(figure.where(kind: kind))
    let n-super = figcounter.get().first() + 1
    set figure.caption(position: position)
    [#figure(
      kind: kind,
      supplement: supplement,
      caption: caption,
      {
        show figure.where(kind: kind): set figure(numbering: _ => numbering(subrefnumbering, n-super, quartosubfloatcounter.get().first() + 1))
        show figure.where(kind: kind): set figure.caption(position: position)

        show figure: it => {
          let num = numbering(subcapnumbering, n-super, quartosubfloatcounter.get().first() + 1)
          show figure.caption: it => {
            num.slice(2) // I don't understand why the numbering contains output that it really shouldn't, but this fixes it shrug?
            [ ]
            it.body
          }

          quartosubfloatcounter.step()
          it
          counter(figure.where(kind: it.kind)).update(n => n - 1)
        }

        quartosubfloatcounter.update(0)
        body
      }
    )#label]
  }
}

// callout rendering
// this is a figure show rule because callouts are crossreferenceable
#show figure: it => {
  if type(it.kind) != str {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    block(below: 0pt, new_title_block) +
    old_callout.body.children.at(1))
}

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black, body_background_color: white) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      if(body != []){
        block(
          inset: 1pt, 
          width: 100%, 
          block(fill: body_background_color, width: 100%, inset: 8pt, body))
      }
    )
}

// Dies ist mein typst Template für "HSNR Aushang"
// Erstellt von Jörg große Schlarmann im November 2024
#let aushang(
  // welche Wert werden aus dem YAML-Header gelesen?
  title: none,
  logo: none,
  lang: none,
  font: none,
  font-size: none,
  title-size: none,
  body
) = {

  // Hier startet die eigentliche Funktion

  // Der Logo-Pfad muss escaped werden
  let logo_path = logo.replace("\\", "")
  let title = title.replace("~", " ")

  // Schriftart und Sprache einstellen
  set text(font: font,
           size: font-size,
           lang: lang,)
  // Blockschrift aktivieren
  set par(justify: true)
  set table(stroke: none,)
  
  // Farben definieren
  let HSNRblue1 = rgb("185191")
  let HSNRblue2 = rgb("07A1E2")

  // blaue Überschriften

  show heading.where(level: 1): it => block(
    // hellblau bei stufe 2
    text(HSNRblue1)[#it.body
                    #v(5mm)]
  )

  show heading.where(level: 2): it => block(
    // hellblau bei stufe 2
    text(HSNRblue2)[#it.body
                    #v(2mm)]
  )

  show heading.where(level: 3): it => block(
    // hellblau bei stufe 2
    text(HSNRblue2)[#it.body
                    #v(2mm)]
  )
  
  // Link-color
  show link: set text(fill: rgb("185191"))


  // Seitengröße und -ränder festlegen
  set page(width: 210mm,
           height: 297mm,
           margin: (top: 30mm, bottom: 30mm, left: 20mm, right: 20mm),
           numbering: "1",
           number-align: center,
           header: grid(
                        columns: (1fr, 1fr),
                        align: (left, right),
                          rect(fill: HSNRblue1,
                               width: 90%,
                               outset: (x: 54pt))[#text(white, title-size)[#title]],
                          image(logo_path, width: 70mm),
           ),
           footer: align(center)[#context counter(page).display("1 von 1",both: true,)]
  )

  // Abstand zwischen Header und Body
  v(5mm)

  // Hauptteil des Dokuments
  body

}

#set page(
  paper: "us-letter",
  margin: (x: 1.25in, y: 1.25in),
  numbering: "1",
)
#set page(background: align(left+top, box(inset: 0.75in, image("_extensions/hsnr-aushang/HSNRfb10s.png", width: 1.5in))))

#show: aushang.with(
    // Diese Werte kommen aus dem YAML
    title: "This is just a test",
    lang: "de",
    logo: "true",
    font: "Times New Roman",
    font-size: 12pt,
    title-size: 14pt,
)

= This does not work
<this-does-not-work>
I dont know why this wont work

= Logo problem
<logo-problem>
My extension provides a logo at `_extensions/hsnr-aushang/HSNRfb10s.png`. This worked just fine…. Now, after the summer break, I come back to see that is throws an error

#quote(block: true)[
]

The "logo" file path (see `_extension.yml`) is now overwritten to "`true`" instead.

If I set a "new" logo in the qmd-document, it throws the same error, and "logo" is TRUE.

If I set the "new" logo to some fantasy-filename, it throws:

#quote(block: true)[
]

So, the file name is "there". But if I state a "real" existing file name, it goes back to "TRUE".
