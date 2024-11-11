// Logopfad escapen
#let logo_name = "$logo$"
#let logopath = logo_name.replace("\\", "")

// Schriftart
#set text(font: "Times New Roman")

// Los gehts
#let layout(
  // Hauptinhalt des Dokuments
  body
) = {
  // Farben definieren
  let HSNRblue1 = rgb("185191")
  let HSNRblue2 = rgb("07A1E2")
  
  show heading: set text(HSNRblue1)
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
                          image(logopath, width: 70mm),
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
