// cSpell: disable
#import "@local/phys-reports:0.1.0": phys-report
#import "@preview/physica:0.9.5": *
#import "@preview/wordometer:0.1.5": total-words, word-count
#let report-title = "Superconducting Single Flux Quanta to Further Moore's Law"
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
  This report examines superconducting integrated circuits (SICs) as a path to extend computational performance beyond CMOS power scaling limits @bunyk-rsfq-technology-2001. This is enabled by Josephson phase dynamics which provide a means Single Flux Quantum (SFQ) signalling with picosecond pulses and negligible static power. These principles have then allowed fo the establishment of circuit primitives @likharev-rsfq-1991, exemplified by Rapid SFQ (RSFQ) storage loops and clocked decision-making pairs. On the fabrication side ELASIC, a mixed-lithography, wafer-scale method stitching sixteen Deep-UV (DUV) reticles into an 88x88 mm carrier while preserving Josephson Junction (JJ) uniformity and superconducting continuity @das-elasic-2023. On the design side, new frameworks such as RustSFQ @oishi-rustsfq-2025, a domain-specific language whose linear usage of pulses enforces one-producer/one-consumer semantics enable the optimisation and design of more complex SFQ circuits. Together, the device physics, scalable fabrication, and language tooling indicate a route to multi-chip SFQ systems operating at 10-100 GHz with improved energy efficiency and reliability.
  \
]]

= Introduction

From the first commercially available microprocessor in 1971, the Intel 4004 with 2250 transistors operating at a peak of 740 kHz @wiki-chip-llc-4004-2013, to Apple's M2 Ultra chip in 2022 with 134 billion transistors operating at up to 3.7 GHz @apple-m2-ultra-2023, the semiconductor industry has seen exponential growth in computing power. With a doubling period of approximately 2 years, as postulated by Moore's Law @moore-law-1965 this is inevitably unsustainable. However, as the industry approaches limitations in transistor scaling and power density, the need for alternatives to Complementary Metal Oxide Semiconductor (CMOS) based microprocessors becomes increasingly apparent. Superconducting electronics, particularly those based on Josephson Junctions (JJs) producing Single Flux Quantum (SFQ) logic, present a promising avenue to continue this trend.

These computational architectures leverage the incredibly low energy dissipation and high-speed switching capabilities of superconducting materials to achieve performance metrics. These overcome the current power density thermal limitations that apply to traditional CMOS based devices @bunyk-rsfq-technology-2001. SFQs using JJs operate on voltage pulses with areas of magnetic flux quanta $Phi_0 = h "/" (2e) approx 2.07 times 10^(-15) "Tm"^2$, dramatically reducing non-cooling energy consumption @koki-super-npu-2020. In tandem the rapid voltage pulses allow for switching speeds in the order of 100s of GHz @przybysz-rapid-switching-2015, far exceeding the capabilities of CMOS transistors.

With the recent explosion of datacenter scaling, a potential avenue has been opened for SICs to be implemented commercially. As more compute moves to centralised datacenters the feasibility of cryogenically cooled SICs for large calculation intensive simulation or machine learning work has improved. This has the potential to reduce the extremely large energy consumption as well as dramatically improve non-parallelised computation times.

Although potentially impressive, superconducting electronics still face a long road to the reach the same level of integration and manufacturability as CMOS technology. Currently maximum Superconducting Integrated Circuit (SIC) densities are in the order of $10^6 "JJs per cm"^2$ @tolpygo-jj-densities-2020. Although this is not a significant physical limitation, scale will likely aid in higher densities as it did the CMOS industry. What K.K Likharev @likharev-rsfq-1991 describes as a main limiting factor were the degradation of the oxide layers used as Josephson Junction (JJ) barriers. These issues are being addressed with new fabrication techniques such as the use of Niobium Aluminium based alloys @tolpygo-jj-densities-2020.

However, the industry is beginning to reach the point where SFQ architectures are becoming well defined enough to soon warrant investment into the kind of design automation languages that have been the boon of the CMOS industry. This would enable the increases in gate optimisation and manufacturing scale required to bring substitute CMOS technology within certain fields.

= The Physics Behind Superconducting ICs

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

== BCS Theory <bcs-theory>

In order to properly describe superconductivity BCS theory @Bardeen-BCS-theory-1957 aimed to describe all the attributes of superconductors. This included the Meissner effect of $bold(B)=0$ inside the superconductor, the existence of an energy gap $Delta$ in the electronic density of states at the Fermi level, and the seeming infinite conductivity $bold(E)=0$.

The first step as described by J.F. Annett @Annett-superconductivity-2004 in achieving this was to consider the interaction between conduction electrons and the phonons of the ionic crystal lattice. To consider this electrons can be viewed as quasiparticles of a self-consistent field of surrounding particles as described by Landau's Fermi liquid theory @landau-fermi-liquid-1959. By considering the Coulomb interaction between quasiparticle excitations of electrons and the holes they leave behind, much of the repulsion can be screened out as
$
  V_("TF")(bold(r) - bold(r)') = e^2 / (4 pi epsilon.alt_0|bold(r) - bold(r)'|) e^(-|bold(r) - bold(r)'| "/" r_("TF")) ,
$
where $r_("TF")$ is the Thomas-Fermi screening length. This makes the effective repulsive interaction $V_"TF"$ short ranged vanishing for larger than inter-particle spacings $|bold(r) - bold(r)'| > r_("TF")$. This is combined with the attractive interaction mediated by phonons as shown by Annett in Figure @electron-phonon-interaction, to give an overall effective potential between electron quasiparticles.

#figure(
  image("figs/figure_2.png", fit: "contain"),
  caption: [An excited electron scattered from a state with crystal momentum $bold(k)_(1,2)$ creates a phonon with momentum $plus.minus bold(q)$ which is then absorbed by another electron with momentum $bold(k)_(2,1)$, resulting in an effective attractive transfer of momentum $planck.reduce bold(q)$ between the two electrons. The order of this operation is irrelevant to the interaction @Annett-superconductivity-2004.],
  placement: top,
) <electron-phonon-interaction>

Excluding the repulsive regime, where their frequencies $omega$ are greater than the average phonon (Debye) frequency $omega_D$. Then only looking at conduction electrons within $epsilon.alt_F plus.minus k_B T$ and in the superconducting regime $planck.reduce omega_D gt.double k_B T$, simplifying the interaction to
$
  V_("eff")(bold(q), omega) = -abs(g_"eff")^2 ,#h(25pt) abs(omega) lt omega_D
$
where $g_"eff"$ is an effective electron-phonon coupling constant. This effective attraction enables the proposition of two electrons outside the Fermi sea to form a bound state, known as a Cooper pair @Annett-superconductivity-2004 @Bardeen-BCS-theory-1957. By solving the two-particle Schrodinger equation over all available states around the Fermi level, BCS theory shows that the binding energy of the Cooper pair is given by
$
  -E = 2 planck.reduce omega_D e^(-1 "/" lambda) ,
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
  1=lambda integral_0^(planck.reduce omega_D) d epsilon.alt 1 / sqrt(epsilon.alt^2 + abs(Delta^2)) tanh(sqrt(epsilon.alt^2 + abs(Delta^2)) / (2 k_B T)) .
$
Taking the limit of $Delta arrow 0$ for the point of transition at $T=T_C$, yields
$
  k_B T_C = 1.13 planck.reduce omega_D e^(-1 "/" lambda) ,
$
where $lambda$ is as defined in Equation @cooper-pair-binding-energy. This gap in the density of states at the Fermi level is a defining feature of superconductors, as any scattering of electrons must have a high enough energy to break the Cooper pair binding energy.

== Josephson Effect <josephson-effect>

#figure(
  image("figs/figure_3.png", fit: "contain"),
  caption: [The IV characteristics of an overdamped Josephson junction @Annett-superconductivity-2004. Below the critical current $I_c$, a supercurrent $I_S$ can flow with zero voltage drop $V=0$ or dissipation. Above $I_c$, quasiparticle creation and annihilation occurs across the gap resulting in a voltage drop and a phase dependent oscillating current $I_N$.],
  placement: top,
) <jj-iv-characteristics>

Taking a step further, Brian D. Josephson considered the tunnelling of Cooper pairs between two superconductors isolated completely by a thin insulating barrier @josephson-effect-1962. This thin barrier can be crossed by a small supercurrent Cooper pairs via tunneling without any voltage drop @Annett-superconductivity-2004 @roseinnes-introduction-1978 as illustrated in Figure @jj-iv-characteristics, to a critical current $I_c$ shown to be
$
  I_S = I_c sin(theta_1 - theta_2) ,
$ <josephson-dc-current-relationship>
where $theta_1$ and $theta_2$ are the macroscopic quantum phases of the two superconductors either side of the junction. When driven beyond this critical current $I_c$, a finite voltage $V$ appears across the junction resulting in a time varying phase difference occurs
$
  (d phi) / (d t) = (2e V_0) / planck.reduce ,
$ <josephson-phase-relationship>
Where $phi = theta_1 - theta_2$ and is the Josephson phase. Substituting the integral of this time varying phase difference back into Equation @josephson-dc-current-relationship results in an oscillating current across the junction with frequency
$
  f = 2e V_0 / h .
$ <josephson-frequency-relationship>
This makes JJs act as extremely sensitive voltage to frequency converters. As described by Krylov and Rose-Innes @krylov-sic-design-2024 @roseinnes-introduction-1978, this behaviour is analogous to a damped pendulum when looking at the full JJ solution for current
$
  I = I_c sin(phi) + Phi_0 / (2 pi) G_N (d phi) / (d t) + C (Phi_0 / (2 pi)) (d^2 phi) / (d t^2) ,
$
where $G_N$ is an approximation for the non-linear conductance of the JJ and $C$ is the capacitance. In this analogy $phi$ the phase difference is the angle of the pendulum, $I_c$ corresponds to the mass and length of the pendulum, the conductance $G_N$ is proportional to the damping coefficient, the moment of inertia is proportional to the capacitance $C$, and any dc bias ($V_0$) can be thought of as the driving torque applied to the pendulum.

= Building Superconducting Integrated Circuits

== Basics of Single Flux Quantum Logic

#figure(
  image("figs/figure_4.png", fit: "contain"),
  caption: [A Rapid Single Flux Quantum (RSFQ) Destructive Flip-Flop (DFF) circuit comprising three JJs and an inductor $L$ capable of storing a single flux quantum $Phi_0$ @krylov-sic-design-2024.],
  placement: top,
) <rsfq-dff-circuit>

In Superconducting Integrated Circuits (SICs), information is encoded in very short Single Flux Quantum (SFQ) voltage pulses $V(t)$. As such most operations are clocked where a logical 1 (logical 0) is defined as a given timestep where is (is not) SFQ pulse is present within a clock period @krylov-sic-design-2024.

SICs will typically use critically damped JJs where the transition from supercurrent to voltage state is almost instantaneous at $I_c$. In the underdamped example of Figure @jj-iv-characteristics, which is importantly single valued, it was shown by K.K. Likharev @likharev-rsfq-1991 that after a current pulse $I$ the junction should self-reset to its original superconducting state. However, if the bias current $I_b$ is high enough such that $I_b lt.tilde I_c$, the push from the pulse can drive a full $2 pi$ phase rotation. Similar to how a driving force on a highly damped pendulum at the critical angle can cause exactly one full rotation before coming to rest again. When timed correctly this results in a voltage pulse across the junction following Equation @josephson-phase-relationship, yielding a pulse of exactly one flux quantum $Phi_0$.

One of the most simple circuit components described by K.K. Likharev @likharev-rsfq-1991 @krylov-sic-design-2024 that can be assembled (see Figure @rsfq-dff-circuit), would be a Rapid Single Flux Quantum (RSFQ) Destructive Flip-Flop (DFF). It comprises a storage loop (J3-$L$-J2) and a clock junction J1, with $L gt Phi_0"/"I_c$ so the loop can store a single flux quantum. In the idle "0" state, the bias current prefers the lower-inductance path through J3. Arrival of an input SFQ pulse switches J3 and injects one $Phi_0$ into the loop, establishing a persistent circulating current $I_s approx Phi_0/L$ whose direction encodes the "1" state (equivalently, the bias redistributes toward J2). Readout and reset are driven by a clock pulse at J1: J1 and J2 act as a decision-making pair (balanced comparator) so that, depending on the stored circulation, the junction closer to $I_c$ switches first, emitting an SFQ to the output and simultaneously clearing the stored flux i.e. a destructive readout that returns the cell to "0" unless the input refreshes it on the same cycle.

Following these logical operations all the required basic gates for conventional computing were defined by Likharev @likharev-rsfq-1991. These include the AND, OR, NOT, and XOR gates. This has become the foundation for the modern SIC industry.


== Extremely Large Area Superconducting IC

#place(
  figure(
    image("figs/figure_5.png", fit: "contain"),
    caption: [ELASIC fabrication process stitching sixteen 22 mm x 22 mm DUV reticles into an 88 mm x 88 mm active carrier using mixed lithography @das-elasic-2023. Then ELASIC attached to copper plate and mounted into cryostat for testing.],
  ),
  top + center,
  float: true,
  scope: "parent",
) <elasic-fabrication-process>

Addressing the need for large area superconducting integrated circuits (SICs), R.N. Bolkhovsky et al. @das-elasic-2023 created a wafer-scale "Extremely Large Area Superconducting Integrated Circuit" (ELASIC) that interconnects sixteen 22 mm x 22 mm Deep-UV (DUV) into an 88 mm x 88 mm active carrier. Their mixed-lithography flow keeps all Josephson-junction-critical layers within high-resolution DUV fields while using courser i-line only for inter-reticle (single ray etching area) wiring and stitching. This provided

Room-temperature junction resistance measurements show junction normal resistance $R_n$ uniformity comparable to MIT-LL's SFQ5ee baselines @semenov-jj-ram-2019; indicating consistent $I_c$ and $R_n$ at 4.2 K, preserving the Josephson phase-voltage dynamics that underpin SFQ pulse formation derived from Equation @josephson-phase-relationship. Superconducting continuity across stitch interfaces is supported by 0.8 $mu$m testing "snake-and-comb" lines carrying 30-40 mA at 4.2 K, consistent with low added series resistance at stitches. The process integrates Nb/Al-AlO/Nb trilayer JJs (target $J_c approx 10$ kA/cm), multilayer Nb wiring, sub-micron DUV vias, and stitched i-line interconnects into a 13-mask, 200 mm flow.

Linking fabrication to circuit-level operation @das-elasic-2023, data currents are transmitted of order 5-10 $mu$A across stitched regions and setting an upper bound of $approx 2 mu Omega$ on stitch-boundary series resistance from low-frequency operation. Maintaining uniform critical Josephson currents $I_c$ and low-loss Nb interconnects ensures that Cooper-pair transport within the BCS gap ($Delta$) (See @bcs-theory) and proceeds with minimal quasiparticle dissipation @krylov-sic-design-2024, while well-controlled junction parameters stabilize the Josephson phase evolution needed for reliable SFQ-style signaling (See @josephson-effect). The manufacturing methods used are critical to ensure macroscopic superconducting behavior ($bold(E)=0$, $bold(B)=0$ interior, stable $I_c R_n$).

== Domain Specific Languages

To address the issues of design and move towards CMOS competitiveness, Oishi et al. have recently developed RustSFQ @oishi-rustsfq-2025. A domain-specific language embedded in Rust that formalizes SFQ's pulse-driven semantics at the language level by enforcing input-output consistency through Rust's ownership model: each emitted pulse (a single $Phi_0$ packet as per Equation @josephson-phase-relationship) must be consumed exactly once by a downstream gate. In RustSFQ, gates are methods on a `Circuit`, and wires are linear (single-use) values; the compiler prevents fan-out without an explicit `SPLIT`, guards against unconsumed pulses, and statically checks port counts when composing subcircuits. The Domain Specific Language (DSL) produces gate-level descriptions (netlists) and automatically emits SPICE @analog-ltspice-2024 and Verilog @williams-verilog-2024 with deterministic net naming, reducing manual bookkeeping that is error-prone in pulse logic. These abstractions built on K.K. Likharev's architecture @likharev-rsfq-1991 allows far more complex circuits to be produced. While the one-pulse/one-consumer rule respects the indivisibility of flux quanta in JJ logic.

Beyond straight-line pipelines, the authors add constructs needed for JJ-based systems: explicit loop annotation for feedback circuits and a `CounterWire` type to express counter-flow clocking, where the clock travels opposite to data to hide loop delays-an established technique for reaching high operating frequencies in SFQ pipelines @koki-super-npu-2020. They also codify clockless pulse gating using Non-Destructive ReadOut (NDRO) elements, whose internal state is toggled by set/reset pulses and read by data-as-clock, avoiding the need for a clocked AND when simple gating is required @oishi-rustsfq-2025. The paper illustrates these ideas with a half-adder and then a case study: a pipelined SFQ Reed-Solomon (RS) encoder, commonly used in QR codes and communications protocols @dayal-reed-solomon-fpga-2013. To verify this digital (Icarus Verilog @williams-verilog-2024) and superconducting analog (JoSIM @joeydelp-josim-2023) simulations confirmed correct operation at 10 GHz. Excluding input buffering, the computation completes in 48 cycles (4.8 ns at 100 ps per clock cycle). The implementation demonstrates practical productivity benefits (e.g., 796 nets of which $approx$ 70 % named automatically) while preserving the timing discipline required for SFQ gates that are inherently clock-synchronous and phase-coherent @krylov-sic-design-2024, thus connecting software-level invariants to the Josephson-phase dynamics and low-loss superconducting transport emphasized in the background.

#figure(
  image("figs/figure_6.png", fit: "contain"),
  caption: [Results of analog simulation of RustSFQ Reed-Solomon RS(12,8) encoder at 10 GHz @oishi-rustsfq-2025. The raw SFQ pulses are shown by each voltage reading with the corresponding encoding output given for each clock cycle below.],
  placement: top,
) <rustsfq-examples>

= Looking to the Future

Superconducting integrated circuits (SICs) exploit microscopic features of the BCS ground state-an excitation gap $Delta$ suppressing quasiparticle dissipation and a well-defined Josephson phase-to realize energy-efficient, picosecond-scale switching. In the logic regime, SFQ pulses derived from Equation @josephson-phase-relationship provide a quantized signaling primitive whose integrity ultimately depends on uniform $I_c$, stable $I_c R_n$ @krylov-sic-design-2024, and low-loss superconducting wiring. It is important to highlight how these microscopic physical constraints, imposed by BCS-Theory, propagate to device and system design, from elementary RSFQ storage loops to reticle-scale integration.

On the fabrication side, ELASIC demonstrates @das-elasic-2023 that mixed-lithography stitching can extend JJ-based systems beyond single-reticle limits while preserving junction uniformity and superconducting continuity across stitch interfaces. This addresses a key physical-to-manufacturing translation: maintaining phase-coherent, dissipationless transport over centimeter scales without degrading the JJ parameters that set SFQ pulse timing. Such results indicate a credible path to assembling multi-chip SFQ systems where wire delay, bias distribution, and clock skew remain compatible with \~10-100 GHz and beyond.

On the design side, RustSFQ illustrates how domain-specific languages can encode pulse-conservation and timing discipline as compile-time invariants @oishi-rustsfq-2025. By tying netlist generation to linear usage of pulses and explicit fan-out/synchronization, the language mirrors the underlying physics-each $Phi_0$ pulse is indivisible and must be consumed exactly once-while reducing design errors that would otherwise manifest as metastable states or lost quanta. Together with analog/digital co-simulation @williams-verilog-2024 @joeydelp-josim-2023, such tools begin to close the gap between device physics, circuit timing, and system-level verification.

Looking ahead, three priorities emerge. First, density and yield: further improvements in JJ critical-layer control, via/via-stack resistance, and wafer-scale stitching are needed to push beyond today's JJ/cm$""^2$ while sustaining uniform $I_c$ and $R_n$. Second, power and interconnect: voltage bias ($V_0$) distribution networks, clock trees, and cryogenic I/O must be co-optimized to minimize dynamic bias losses and latency, including exploration of multi-tier (3D) integration and low-loss cryogenic to room temperature links. Third, design automation and verification: standard cell libraries, timing/power sign-off models for SFQ families, and DSL to netlist (gate-description) toolchains should mature together, enabling hierarchical composition without violating pulse-level invariants. In the near term, SICs are well-positioned for cryogenic control, readout, and domain-specific accelerators. In the longer term, continued progress at the junction, interconnect, and language levels will determine whether SICs can complement or surpass CMOS for selected high-throughput, energy-constrained workloads.

= References

#bibliography(
  "bibliography.bib",
  style: "ieee",
  title: none,
)