// Pfade escapen
//------------------------------------------
#let logo_path = "$logo$"
#let logo_path = logo_path.replace("\\", "")

#let signature = "$signature$"
#let signature = signature.replace("\\", "")

#let csl = "$csl$"
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
#set text(font: "$font$",
          size: $font-size$,
          lang: "$lang$",)

#set par(justify: true)
//------------------------------------------

// Zitationsstil
#set bibliography(style: csl)


// Korrespondenzautor heraussuchen und in Variable speichern
//----------------------------------------------------------
$for(by-author)$
$if(by-author.attributes.corresponding)$
#let korrespondent ="$by-author.name.literal$, $by-author.email$"
#let korrespondent = korrespondent.replace("\\", "")
$endif$
$endfor$
//----------------------------------------------------------




//------------------------------------------------------------
//     Los gehts
//------------------------------------------------------------
#let hsnr-article(

  body
) = {
    // Seitengröße und -ränder festlegen
  set page(paper: "$paper$",
           margin: (top: $margin.top$,
                    bottom: $margin.bottom$,
                    left: $margin.left$,
                    right: $margin.right$),
           $if(numbering)$
           numbering: "$numbering$",
           $endif$
           $if(number-align)$
           number-align: $number-align$,
           $endif$
            columns: 1,
           header: locate(
                   loc => if [#loc.page()] == [1] {
                   text(1pt)[]
                   } else{

                    grid(
                        columns: (1fr, 1fr),
                        align: (left, right),
                          text(10pt, style: "italic")[$title$],
                          text(10pt)[$journal.name$],
                          v(4pt),v(4pt),
                          line(length: 100%, stroke: 0.5pt),
                          line(length: 100%, stroke: 0.5pt),
                        )
                    }
                  ),

           footer: align(center)[#text(8pt)[$footer-pre$ #context counter(page).display("1 $site-of$ 1",both: true,)]]
  )

align(center)[

// Logo, Titel, Subtitel
//-----------------------
      #v(-30mm)
      #image(logo_path, width: 100mm)
      #text(16pt)[$title$]
      #v(-4mm)
      #text(14pt)[$subtitle$]
//--------------------------------------------

      #v(1mm)

// Autoren und Affiliation
      #text()[
              $for(by-author)$$by-author.name.literal$
              $for(by-author.affiliations)$#h(-3pt)#super[$it.number$]#h(-2pt)$sep$,$endfor$
              $sep$,
              $endfor$
      ]

      #v(-2mm)

      #text(8pt)[
              $for(by-affiliation)$
              #super[$it.number$]#h(-1pt) $it.name$$if(it.department)$, $it.department$$endif$
              $sep$| $endfor$
              #v(-3pt)
              Kontakt: #korrespondent
              ]
//--------------------------------------------
] // ende align(cemter)


  v(2mm)

// Abstract
  align(center)[#text(weight: "bold")[Abstrakt]
                #v(-2mm)
                #text()[$abstract$]
               ]
//--------------------------------------------

v(1mm)

// Journal und Datum
  grid(columns: (1fr, 1fr),
       align: (left, right),
       text(11pt)[$journal.name$],
       text(11pt)[$date$],)
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
