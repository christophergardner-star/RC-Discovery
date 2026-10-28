# Research Status Ledger

Updated: 28 October 2026

| Item | Status | Notes |
|---|---|---|
| Almost-idempotent UCP maps induce approximate \(C^*\)-algebra structure | **Known** | Kitaev (2024). |
| Dimension-independent exact rounding fails for general almost-idempotent quantum channels | **Known / 2026 preprint** | Explicit bistochastic entanglement-breaking counterexamples. |
| Exact rounding can be restored under bounded slow rank in quantum metastability | **Known / 2026 preprint** | QMSM construction; constants depend on slow rank. |
| A discrete POVM admits repeatable implementation only when each nonzero effect has eigenvalue \(1\) | **Known** | Standard repeatable-measurement theory; Busch–Grabowski–Lahti and later treatments. |
| RC sharp Record-Margin bound \(\|\Phi-\Pi\|_\diamond\le\sqrt{2\eta/\kappa}\) | **Internally proved; provisionally novel** | Full proof in theory/record_margin_stability.md. |
| Original qubit family saturates the sharp Record-Margin bound | **Internally proved** | Exponent and prefactor are sharp in that class. |
| POVM spectral-gap extension \(\|\Phi-\Pi\|_\diamond\le\sqrt{2\eta/(\kappa\gamma)}\) | **Internally proved; provisionally novel** | Same readout POVM; proof in theory/povm_spectral_gap_stability.md. |
| Qutrit family saturates the POVM \(\gamma^{-1/2}\) factor | **Internally proved** | Equality for \(E_0=\mathrm{diag}(1,c,0)\), \(E_1=I-E_0\). |
| Two pure independent records obey \(\kappa_R=\sqrt{1-s^{2R}}\) | **Known state-discrimination math / derived RC corollary** | The new part is its insertion into the RC rounding certificate, not the trace-distance identity. |
| Multi-record discriminator error \(\epsilon\) implies \(\kappa\ge1-2\epsilon\) | **Derived elementary lemma** | Operational bridge from record classification to margin. |
| More fragments always improve stability | **Refuted as stated** | Perfectly correlated record noise can keep \(\kappa_R\) constant for all \(R\). |
| Record-structured metastability transfer bound | **Internally proved corollary** | No bounded phase count appears, but the channel must be close to a classical record structure. |
| Bounded slow rank is unnecessary for arbitrary quantum metastability | **Not established / false as a general inference** | 2026 QMSM obstruction still applies generally. |
| Bounded slow rank is unnecessary for the RC record-structured classical subclass | **Derived conditional result** | Constants depend on \(\eta,\delta,\kappa,\gamma\), not phase count. |
| Objective record geometry is the maximal positive subclass restoring rounding | **Open classification problem** | Moving-POVM boundary remains unresolved. |
| RC is a fundamental physical theory | **Not established** | No such claim is made here. |

## Language policy

- **Known** — supported by existing literature.
- **Derived** — follows from known mathematics or an internally checked argument.
- **Provisionally novel** — precise result with internal proof, but no independent novelty confirmation.
- **Open** — conjecture or research question.
- **Refuted** — false statement retained to prevent regression.
