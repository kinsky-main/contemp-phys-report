#import "@local/phys-reports:0.1.0": phys-report
#import "@preview/wordometer:0.1.5": word-count, total-words
#let report-title = "Investigation Into the State of Superconducting Electronics"
#let main-author = "Candidate 23511"
#let publisher = "University of Bath"
#let publication = [Contemporary Physics Technical Report]
#let shortened-publication = [PH40024 Report (#datetime.today().year())]

#show: doc => phys-report(
  doc,
  report-title: report-title,
  main-author: main-author,
  publisher: publisher,
  publication: publication,
  shortened-publication: shortened-publication,
)

#show: body => {
  for elem in body.children {
    if elem.func() == math.equation and elem.block {
      let numbering = if "label" in elem.fields().keys() { "(1)" } else { none }
      set math.equation(numbering: numbering)
      elem
    } else {
      elem
    }
  }
}

#show: word-count

#place(
  top + center,
  float: true,
  scope: "parent",
)[
  #text(14pt)[*#report-title*]
]

#place(
  top + center,
  float: true,
  scope: "parent",
)[#box(width: 90%)[

    #text(size: 10pt, weight: "bold", main-author) \
    Department of Physics, University of Bath, Bath, BA2 7AY, United Kingdom \
    Date submitted: #datetime.today().display("[day] [month repr:short] [year]") \
    Word count of #total-words words
    #v(6pt)
    #text(size: 11pt, weight: "bold", "Abstract")
    #set align(left)
    #set par(first-line-indent: 0pt)
    Superconducting electronics are looking to be one of the most promising technologies to break the barriers present in traditional Metal-Oxide-Semiconductor Field Effect Transistor (MOSFET) based computing today. Superconducting Quantum Interference Devices (SQUIDS) are at the forefront of this technology, offering unparalleled sensitivity and speed for a wide range of applications.
    \
  ]]

= Introduction

= Background

== A bit of History

The field of superconductivity was born accidentally in 1911 when Heike Kamerlingh Onnes @Onnes-superconductivity-discovery-1911 was investigating the electr

== BCS Theory

== Computing

= Recent Developments

= Conclusion

= References

#bibliography(
  "bibliography.bib",
  style: "ieee",
  title: none,
)

#pagebreak()

#set page(columns: 1)

// Appendix heading style
#let appendix(body) = {
  set heading(numbering: "A", supplement: [appendix])
  counter(heading).update(0)
  body
}

#outline(target: heading.where(supplement: [appendix]), title: [Appendix])

#show: appendix
