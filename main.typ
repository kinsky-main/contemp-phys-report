// cSpell: disable
#import "@local/phys-reports:0.1.0": phys-report
#import "@preview/physica:0.9.5": *
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

// cSpell: enable

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
    #lorem(150)
    \
  ]]

= Introduction

From the first commercially available microprocessor in 1971, the Intel 4004 with 2250 transistors operating at a peak of 740 kHz @wiki-chip-llc-4004-2013, to Apple's M2 Ultra chip in 2022 with 134 billion transistors operating at up to 3.7 GHz @apple-m2-ultra-2023, the semiconductor industry has seen exponential growth in computing power. With a doubling period of approximately 2 years, as postulated by Moore's Law @moore-law-1965. However, as the industry approaches limitations in transistor scaling and power density, the need for alternatives to Complementary Metal Oxide Semiconductor (CMOS) becomes increasingly apparent. Superconducting electronics, particularly those based on Josephson Junctions (JJs) producing Single Flux Quantum (SFQ) logic, present a promising avenue to continue this trend.

These computational architectures leverage the incredibly low energy dissipation and high-speed switching capabilities of superconducting materials to achieve performance metrics. These overcome the current power density thermal limitations that apply to traditional CMOS based devices @bunyk-rsfq-technology-2001. SFQs using JJs operate on voltage pulses with areas of magnetic flux quanta $Phi_0 = h "/" (2e) approx 2.07 times 10^(-15) "Tm"^2$, dramatically reducing non-cooling energy consumption @koki-super-npu-2020. In tandem the rapid voltage pulses allow for switching speeds in the order of 100s of GHz @przybysz-rapid-switching-2015, far exceeding the capabilities of CMOS transistors.

Although potentially impressive, superconducting electronics still face a long road to the reach the same level of integration and manufacturability as CMOS technology. Currently maximum Superconducting Integrated Circuit (SIC) densities are in the order of $10^6 "JJs per cm"^2$ @tolpygo-jj-densities-2020. This puts current chipsets with JJ counts in the tens of millions, combined with the need for Helium refrigeration to ~9K, makes current architectures unattractive to pursue commercially. However, the industry is beginning to reach the point where SFQ architectures are becoming well defined enough to soon warrant investment into the kind of design automation languages that have been the boon of the CMOS industry.

= Background

== Discovery of Superconductivity

The field of superconductivity was born accidentally in 1911 when Heike Kamerlingh Onnes @Onnes-superconductivity-discovery-1911 managed to liquefy helium, opening up temperatures down to 4.2 K, the lowest of any element at normal atmospheric pressure. In a traditional conductor as described by Drude theory @Annett-superconductivity-2004, the resistivity of a metal can be modelled by considering the the low density "gas" of conduction electrons, excited into empty states above the Fermi level $epsilon.alt_F$ for a given temperature $T$. Where the resistivity $rho$ is given by
$
  rho = m / (n e^2) (tau^(-1)_("imp") + tau^(-1)_("e-e") + tau^(-1)_("e-ph"))
$ <drude-resistivity>
where $m$ the effective mass of the conduction electrons, $n$ the density of conduction electrons, $e$ the electron charge, and $tau^(-1)_("imp")$ the scattering rate due to impurities are all fixed for a given metal. While the other two scattering processes $tau^(-1)_("e-e")$ and $tau^(-1)_("e-ph")$ depend on temperature. This leaves a minimum residual resistivity at low temperatures due to impurity scattering. However, this was not what Onnes observed as evident from his illustrations shown in Figure@onnes-experiment. This alluded to some structural or thermodynamic transition occurring in the metal. Four decades later, the first complete microscopic understanding of this transition was achieved with the Bardeen-Cooper-Schrieffer (BCS) theory @Bardeen-BCS-theory-1957.

#figure(
  image("figs/figure_1.png", fit: "contain"),
  caption: [From this illustration of Onnes' results @Onnes-superconductivity-discovery-1911, while first cooling down a mercury sample, the resistivity suddenly drops to the lower limit of the instrumentation at a critical temperature $T_C$ of around 4.2 K, indicating the onset of superconductivity.],
  placement: top,
) <onnes-experiment>

== BCS Theory

In order to properly describe superconductivity BCS theory @Bardeen-BCS-theory-1957 aimed to describe all the attributes of superconductors. This included the Meissner effect of $bold(B)=0$ inside the superconductor, the existence of an energy gap $Delta$ in the electronic density of states at the Fermi level, and the seeming infinite conductivity $bold(E)=0$.

The first step as described by J.F. Annett @Annett-superconductivity-2004 in achieving this was to consider the interaction between conduction electrons and the phonons of the ionic crystal lattice. To consider this electrons can be viewed as quasiparticles of a self-consistent field of surrounding particles as described by Landau's Fermi liquid theory @landau-fermi-liquid-1959. By considering the Coulomb interaction between quasiparticle excitations of electrons and the holes they leave behind, much of the repulsion can be screened out as
$
  V_("TF")(bold(r) - bold(r)') = e^2 / (4 pi epsilon.alt_0|bold(r) - bold(r)'|) e^(-|bold(r) - bold(r)'| "/" r_("TF")) ,
$
where $r_("TF")$ is the Thomas-Fermi screening length. This makes the effective repulsive interaction $V_"TF"$ short ranged vanishing for larger than inter-particle spacings $|bold(r) - bold(r)'| > r_("TF")$. This is combined with the attractive interaction mediated by phonons as shown by Annett in Figure @electron-phonon-interaction, to give an overall effective potential between electron quasiparticles.

#figure(
  image("figs/figure_2.png", fit: "contain"),
  caption: [An excited electron scattered from a state with crystal momentum $bold(k)_(1,2)$ creates a phonon with momentum $plus.minus bold(q)$ which is then absorbed by another electron with momentum $bold(k)_(2,1)$, resulting in an effective attractive transfer of momentum $planck bold(q)$ between the two electrons. The order of this operation is irrelevant to the interaction @Annett-superconductivity-2004.],
  placement: top,
) <electron-phonon-interaction>

Excluding the repulsive regime, where their frequencies $omega$ are greater than the average phonon (Debye) frequency $omega_D$. Then only looking at conduction electrons within $epsilon.alt_F plus.minus k_B T$ and in the superconducting regime $planck omega_D gt.double k_B T$ (@isotope-effect), simplifying the interaction to
$
  V_("eff")(bold(q), omega) = -abs(g_"eff")^2 ,#h(25pt) abs(omega) lt omega_D
$
where $g_"eff"$ is an effective electron-phonon coupling constant. This effective attraction enables the proposition of two electrons outside the Fermi sea to form a bound state, known as a Cooper pair @Annett-superconductivity-2004 @Bardeen-BCS-theory-1957. By solving the two-particle Schrodinger equation over all available states around the Fermi level, BCS theory shows that the binding energy of the Cooper pair is given by
$
  -E = 2 planck omega_D e^(-1 "/" lambda) ,
$ <cooper-pair-binding-energy>
where $lambda = abs(g_"eff")^2 g(epsilon.alt_F) lt.double 1$ is the dimensionless electron-phonon coupling constant and is assumed to be small.

To find the overall ground state and energy gap $Delta$, creation and annihilation operators can be defined for Cooper pairs as
$
  hat(P)^dagger_bold(k)=c^dagger_(bold(k)arrow.t)c^dagger_(-bold(k)arrow.b) #h(4pt) #text(sym.amp) #h(4pt) hat(P)_bold(k)=c_(bold(k)arrow.t)c_(-bold(k)arrow.b) #h(2pt)
$ <cooper-pair-operators>
respectively, where the operators commute with themselves as long as they are for different momenta $bold(k) eq.not bold(k)'$. Using these commutative operators Cooper pairs can be added sequentially to the ground state. By expanding and considering annihilation operators as available for hole Cooper pairs @Annett-superconductivity-2004 the BCS ground state can be written as
$
  ket(Psi_(B C S)) = product_bold(k) (u_bold(k)c_(-bold(k)arrow.b)+v_bold(k)c^dagger_(bold(k)arrow.t))ket(0) #h(2pt) #text[,]
$
where $abs(u_bold(k))^2$ and $abs(v_bold(k))^2$ are the probabilities that the measured excitation is a electron or hole respectively. As such they satisfy the normalization condition $abs(u_bold(k))^2 + abs(v_bold(k))^2 = 1$ @Annett-superconductivity-2004. By minimising the expectation value of the Hamiltonian with respect to these coefficients, the energy gap $Delta$ can be found through the BCS gap equation
$
  1=lambda integral_0^(planck omega_D) d epsilon.alt 1 / sqrt(epsilon.alt^2 + abs(Delta^2)) tanh(sqrt(epsilon.alt^2 + abs(Delta^2)) / (2 k_B T)) .
$
Taking the limit of $Delta arrow 0$ for the point of transition at $T=T_C$, yields
$
  k_B T_C = 1.13 planck omega_D e^(-1 "/" lambda) ,
$
where $lambda$ is as defined in Equation @cooper-pair-binding-energy. This gap in the density of states at the Fermi level is a defining feature of superconductors, as any scattering of electrons must have a high enough energy to break the Cooper pair binding energy.

== Josephson Effect

Taking a step further, Brian D. Josephson considered the tunnelling of Cooper pairs between two superconductors isolated completely by a thin insulating barrier @josephson-effect-1962. This thin barrier can be crossed by a small supercurrent Cooper pairs via tunneling without any voltage drop @Annett-superconductivity-2004 @roseinnes-introduction-1978 as illustrated in Figure @jj-iv-characteristics, to a critical current $I_c$ shown to be
$
  I_S = I_c sin(theta_1 - theta_2) ,
$ <josephson-dc-current-relationship>
where $theta_1$ and $theta_2$ are the macroscopic quantum phases of the two superconductors either side of the junction. When driven beyond this critical current $I_c$, a finite voltage $V$ appears across the junction resulting in a time varying phase difference occurs
$
  phi = (2e V_0) / planck t ,
$ <josephson-frequency-relationship>
Where $phi = theta_1 - theta_2$ and is the Josephson phase. Substituting this time varying phase difference back into Equation @josephson-dc-current-relationship results in an oscillating current across the junction with frequency
$
  f = 2e V_0 / h .
$
This makes JJs act as extremely sensitive voltage to frequency converters. As described by Krylov and Rose-Innes @krylov-sic-design-2024 @roseinnes-introduction-1978, this behaviour is analogous to a damped pendulum when looking at the full JJ solution for current
$
  I = I_c sin(phi) + Phi_0 / (2 pi) G_N (d phi) / (d t) + C (Phi_0 / (2 pi)) (d^2 phi) / (d t^2) ,
$
where $G_N$ is an approximation for the non-linear conductance of the JJ and $C$ is the capacitance. In this analogy $phi$ the phase difference is the angle of the pendulum, $I_c$ corresponds to the mass and length of the pendulum, the conductance $G_N$ is proportional to the damping coefficient, the moment of inertia is proportional to the capacitance $C$, and any dc bias ($V_0$) can be thought of as the driving torque applied to the pendulum.

#figure(
  image("figs/figure_3.png", fit: "contain"),
  caption: [The IV characteristics of an overdamped Josephson junction @Annett-superconductivity-2004. Below the critical current $I_c$, a supercurrent $I_S$ can flow with zero voltage drop $V=0$ or dissipation. Above $I_c$, quasiparticle creation and annihilation occurs across the gap resulting in a voltage drop and a phase dependent oscillating current $I_N$.],
  placement: top,
) <jj-iv-characteristics>

= Building Superconducting Integrated Circuits

== Basics of Single Flux Quantum Logic

In Superconducting Integrated Circuits (SICs), information is encoded in very short Single Flux Quantum (SFQ) voltage pulses $V(t)$. As such most operations are clocked where a logical 1 (logical 0) is defined as a given timestep where is (is not) SFQ pulse is present within a clock period @krylov-sic-design-2024.

SICs will typically use critically damped JJs where the transition from supercurrent to voltage state is almost instantaneous at $I_c$. In the underdamped example of Figure @jj-iv-characteristics, which is importantly single valued, it was shown by K.K. Likharev @likharev-rsfq-1991 that after a current pulse $I$ the junction should self-reset to its original superconducting state. However, if the bias current $I_b$ is high enough such that $I_b lt.tilde I_c$, the push from the pulse can can drive a full $2 pi$ phase rotation.



== Extremely Large Area SIC

== Super Neural Processing Unit

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

= Trivia

== Isotope Effect <isotope-effect>

This is what defines the isotope effect as the band of available states around the Fermi sea thickens with decreasing ionic mass $M$, as $omega_D tilde sqrt(k "/" M)$.