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
