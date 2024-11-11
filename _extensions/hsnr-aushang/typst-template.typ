// Logo-Pfad escapen
#let logo_path = "$logo$"
#let logo_path = logo_path.replace("\\", "")

// Schriftart und Sprache
#set text(font: "Times New Roman",
          lang: "$lang$",)


// Los gehts
#let layout(
  // Hauptinhalt des Dokuments
  body
) = {
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
                               width: 70%,
                               outset: (x: 54pt))[#text(white, 18pt)[$title$]],
                          image(logo_path, width: 70mm),
           ),
           footer: align(center)[#context counter(page).display("1 von 1",both: true,)]
  )

  // Abstand zwischen Header und Body
  v(5mm)

  // Hauptteil des Dokuments
  body

  // Abstand zwischen Body und Footer
  v(3mm)

}
