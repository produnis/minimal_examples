// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

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
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
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
  if type(it.kind) != "string" {
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
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
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
          block(fill: white, width: 100%, inset: 8pt, body))
      }
    )
}

// Pfade escapen
//------------------------------------------
#let logo_path = "\_extensions/hsnr-article/HSNRfb10.png"
#let logo_path = logo_path.replace("\\", "")

#let signature = ""
#let signature = signature.replace("\\", "")

#let csl = "\_extensions/hsnr-article/apa-single-spaced.csl"
#let csl = csl.replace("\\", "")
//------------------------------------------


// Farben definieren
#let HSNRblue1 = rgb("185191")
#let HSNRblue2 = rgb("07A1E2")
//------------------------------------------



// blaue Überschriften
#show heading.where(level: 1): it => block(
    // hellblau bei stufe 2
    text(HSNRblue1)[#it.body
                    #v(5mm)]
  )

#show heading.where(level: 2): it => block(
    // hellblau bei stufe 2
    text(HSNRblue2)[#it.body
                    #v(2mm)]
  )

#show heading.where(level: 3): it => block(
    // hellblau bei stufe 2
    text(HSNRblue2)[#it.body
                    #v(2mm)]
  )
//------------------------------------------


// Schriftart und Sprache
#set text(font: "Times New Roman",
          size: 11pt,
          lang: "de",)

#set par(justify: true)
//------------------------------------------

// TURNED OF TO DEMONSTRATE THAT QUARTO INSERTS ITS OWN set bibliography
//#set bibliography(style: csl)


// Korrespondenzautor heraussuchen und in Variable speichern
//----------------------------------------------------------
#let korrespondent ="Jörg große Schlarmann, joerg.grosseschlarmann\@hs-niederrhein.de"
#let korrespondent = korrespondent.replace("\\", "")
//----------------------------------------------------------




//------------------------------------------------------------
//     Los gehts
//------------------------------------------------------------
#let hsnr-article(

  body
) = {
    // Seitengröße und -ränder festlegen
  set page(paper: "a4",
           margin: (top: 35mm,
                    bottom: 30mm,
                    left: 20mm,
                    right: 20mm),
                      numbering: "1.",
                                 number-align: center,
                       columns: 1,
           header: locate(
                   loc => if [#loc.page()] == [1] {
                   text(1pt)[]
                   } else{

                    grid(
                        columns: (1fr, 1fr),
                        align: (left, right),
                          text(10pt, style: "italic")[Bewertung von RCT-Studienpublikationen],
                          text(10pt)[Modul 10 EBN1],
                          v(4pt),v(4pt),
                          line(length: 100%, stroke: 0.5pt),
                          line(length: 100%, stroke: 0.5pt),
                        )
                    }
                  ),

           footer: align(center)[#text(8pt)[Seite #context counter(page).display("1 von 1",both: true,)]]
  )

align(center)[

// Logo, Titel, Subtitel
//-----------------------
      #v(-30mm)
      #image(logo_path, width: 100mm)
      #text(16pt)[Bewertung von RCT-Studienpublikationen]
      #v(-4mm)
      #text(14pt)[Hinweise zur Krefelder Ampel]
//--------------------------------------------

      #v(1mm)

// Autoren und Affiliation
      #text()[
              Jörg große Schlarmann
              #h(-3pt)#super[1]#h(-2pt)
              ,
              Matthias Mertin
              #h(-3pt)#super[1]#h(-2pt)
              ,
              Clarissa Besoffen
              #h(-3pt)#super[2]#h(-2pt)
              
      ]

      #v(-2mm)

      #text(8pt)[
                            #super[1]#h(-1pt) Hochschule Niederrhein, Fachbereich Gesundheitswesen
              |               #super[2]#h(-1pt) Evelyn Burdecki Institut, Fachbereich Alleswissenschaft
                            #v(-3pt)
              Kontakt: #korrespondent
              ]
//--------------------------------------------
] // ende align(cemter)


  v(2mm)

// Abstract
  align(center)[#text(weight: "bold")[Abstrakt]
                #v(-2mm)
                #text()[In diesem Text werden Hinweise zur Bewertung von Studienpublikationen gegeben. Dabei wird der Schwerpunkt auf randomisiert kontrollierten Studien (RCTs) gelegt. Anhand der Fragen der Krefelder Ampel wird ausgeführt, welche Informationen in der Pubikation enthalten sein sollten, und welche Auswirkungen diese Informationen auf die Studienergebnisse sowie deren Glaubwürdigkeit haben.

]
               ]
//--------------------------------------------

v(1mm)

// Journal und Datum
  grid(columns: (1fr, 1fr),
       align: (left, right),
       text(11pt)[Modul 10 EBN1],
       text(11pt)[13.02.2024],)
//--------------------------------------------

v(-4mm)

// Hauptteil ----
  line(length: 100%, stroke: 0.5pt)

  v(4mm)

  // umschalten auf 2spaltig
  show: columns.with(2)

  // Hauptteil des Dokuments
  body

}
#import "@preview/fontawesome:0.1.0": *

#show: hsnr-article.with(
)

= Einleitung
<einleitung>
#block[
#callout(
body: 
[
Achtung, bei diesem Artikel handelt es sich um #emph[graue Literatur];. Er ist für Ihre Vor- und Nachbereitung gedacht. Dieser Artikel sollte #strong[auf keinen Fall] zitiert werden!

]
, 
title: 
[
Nicht zitieren!!!
]
, 
background_color: 
rgb("#f7dddc")
, 
icon_color: 
rgb("#CC1914")
, 
icon: 
fa-exclamation()
)
]
== Hintergrund
<hintergrund>
Zitationstest #cite(<grSchlR>, form: "prose") und #cite(<Arnold09>, form: "prose")

 #lorem(50)
= Methode
<methode>
 #lorem(50)
= Ergebnisse
<ergebnisse>
Siehe #strong[?\@tbl-zweispaltig]

 #lorem(50)
= Diskussion
<diskussion>
Und siehe @tbl-einspaltig

#figure([
#table(
  columns: 4,
  align: (auto,left,right,center,),
  table.header([Default], [Left], [Right], [Center],),
  table.hline(),
  [12], [12], [12], [12],
  [123], [123], [123], [123],
  [1], [1], [1], [1],
)
], caption: figure.caption(
position: top, 
[
Einspaltige Tabelle
]), 
kind: "quarto-float-tbl", 
supplement: "Tabelle", 
)
<tbl-einspaltig>


 #lorem(50)
== Implikationen
<implikationen>
#figure([
#box(image("_extensions/hsnr-article/HSNRfb10.png"))
], caption: figure.caption(
separator: "", 
position: bottom, 
[
]), 
kind: "quarto-float-fig", 
supplement: "Abbildung", 
)
<fig-zweispaltig>


siehe @fig-zweispaltig

 #lorem(50)
== Forschungsbedarf
<forschungsbedarf>
 #lorem(50)
= Fazit
<fazit>
 #lorem(50)
#block[
#heading(
level: 
1
, 
numbering: 
none
, 
[
Literatur
]
)
]


 
  
#set bibliography(style: "\_extensions/hsnr-article/apa-single-spaced.csl") 


#bibliography("literatur.bib")

