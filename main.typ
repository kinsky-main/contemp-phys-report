#import "@local/phys-reports:0.1.0": phys-report
#import "@preview/wordometer:0.1.5": word-count, total-words
#let report-title = "Superconducting Integrated Circuits to Further Moore's Law"
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

From the first commercially available microprocessor in 1971, the Intel 4004 with 2250 transistors operating at a peak of 740 kHz @wiki-chip-llc-4004-2013, to Apple's M2 Ultra chip in 2022 with 134 billion transistors operating at up to 3.7 GHz @apple-m2-ultra-2023, the semiconductor industry has seen exponential growth in computing power. With a doubling period of approximately 2 years, as postulated by Moore's Law @moore-law-1965. However, as the industry approaches limitations in transistor scaling and power density, the need for alternatives to Complementary Metal Oxide Semiconductor (CMOS) becomes increasingly apparent. Superconducting electronics, particularly those based on Josephson Junctions (JJs) producing Single Flux Quantum (SFQ) logic, present a promising avenue to continue this trend.

These computational architectures leverage the incredibly low energy dissipation and high-speed switching capabilities of superconducting materials to achieve performance metrics. These overcome the current power density thermal limitations that apply to traditional CMOS based devices @bunyk-rsfq-technology-2001. The first property of superconductors that makes them appealing for electronics is their zero DC resistance below a critical temperature $T_C$, allowing for near lossless current flow, drastically reducing heat dissipation in chips.



= Background

== Discovery of Superconductivity

The field of superconductivity was born accidentally in 1911 when Heike Kamerlingh Onnes @Onnes-superconductivity-discovery-1911 managed to liquefy helium, opening up temperatures down to 4.2 K, the lowest of any element at normal atmospheric pressure. In a traditional conductor as described by Drude theory @Annett-superconductivity-2004, the resistivity of a metal can be modelled by considering the the low density "gas" of conduction electrons, excited into empty states above the Fermi level $epsilon.alt_F$ for a given temperature $T$. Where the resistivity $rho$ is given by
$
  rho = m / (n e^2) (tau^(-1)_("imp") + tau^(-1)_("e-e") + tau^(-1)_("e-ph"))
$ <drude-resistivity>
where $m$ the effective mass of the conduction electrons, $n$ the density of conduction electrons, $e$ the electron charge, and $tau^(-1)_("imp")$ the scattering rate due to impurities are all fixed for a given metal. While the other two scattering processes $tau^(-1)_("e-e")$ and $tau^(-1)_("e-ph")$ depend on temperature. This leaves a minimum residual resistivity at low temperatures due to impurity scattering. However, this was not what Onnes observed as evident from his illustrations shown in Figure@onnes-experiment. This alluded to some structural or thermodynamic transition occurring in the metal. Four decades later, the first complete microscopic understanding of this transition was achieved with the Bardeen-Cooper-Schrieffer (BCS) theory @Bardeen-BCS-theory-1957.

#figure(
  image("figs/figure_1.png", fit: "contain"),
  caption: [From this illustration of Onnes' results @Onnes-superconductivity-discovery-1911, while first cooling down a mercury sample, the resistivity suddenly drops to practically zero at a critical temperature $T_C$ of around 4.2 K, indicating the onset of superconductivity.],
) <onnes-experiment>

== BCS Theory

In order to properly describe superconductivity BCS theory @Bardeen-BCS-theory-1957 aimed to describe all the attributes of superconductors. This included the Meissner effect of $bold(B)=0$ inside the superconductor, the existence of an energy gap $Delta$ in the electronic density of states at the Fermi level, and the seeming infinite conductivity $bold(E)=0$.

The first step as described by J.F. Annett @Annett-superconductivity-2004 in achieving this was to consider the interaction between conduction electrons and the phonons of the ionic crystal lattice. To consider this electrons can be viewed as quasiparticles of a self-consistent field of surrounding particles as described by Landau's Fermi liquid theory @landau-fermi-liquid-1959. By considering the Coulomb interaction between quasiparticle excitations of electrons and the holes they leave behind, much of the repulsion can be screened out as
$
  V_("TF")(bold(r) - bold(r)') = e^2 / (4 pi epsilon.alt_0|bold(r) - bold(r)'|) e^(-|bold(r) - bold(r)'| "/" r_("TF")) ,
$
where $r_("TF")$ is the Thomas-Fermi screening length. This makes the effective repulsive interaction $V_"TF"$ short ranged vanishing for larger than inter-particle spacings $|bold(r) - bold(r)'| > r_("TF")$. This is combined with the attractive interaction mediated by phonons as shown by Annett in Figure @electron-phonon-interaction, to give an overall effective potential between electron quasiparticles.

Excluding the repulsive regime, where their frequencies $omega$ are greater than the average phonon (Debye) frequency $omega_D$. Then only looking at conduction electrons within $epsilon.alt_F plus.minus k_B T$ and in the superconducting regime $planck omega_D gt.double k_B T$

#figure(
  image("figs/figure_2.png", fit: "contain"),
  caption: [An excited electron scattered from a state with crystal momentum $bold(k)_(1,2)$ creates a phonon with momentum $plus.minus bold(q)$ which is then absorbed by another electron with momentum $bold(k)_(2,1)$, resulting in an effective attractive transfer of momentum $planck bold(q)$ between the two electrons. The order of this operation is irrelevant to the interaction @Annett-superconductivity-2004.]
) <electron-phonon-interaction>

== Josephson Effect

Off diagonal long-range order (ODLRO) is a key feature of superconductivity, allowing for the coherent tunneling of Cooper pairs between superconductors. This phenomenon is exploited in Josephson junctions, which are crucial components in superconducting electronics.

== CMOS stuff

= Recent Developments

== SFQ logic stuff

== ELASIC

== SuperNPU

= Conclusion

- Consider why cuprates are not used in superconducting electronics despite their high $T_C$. Manufacturing difficulty / $I_C$ limited by inter-grain current flows due to current manufacturing processes.

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
