# Verified progress after the laptop audit

Date: 31 October 2026. These are analytic improvements to this repository,
independently cross-checked within the AI-assisted workflow and tested
numerically. They are not claims of external specialist verification or
literature novelty. The new analytic channel bounds are not Lean proofs.

## 1. The same-label constant drops from 4 to 2

Under the existing hypotheses, the constructed completion satisfies

\[
\nu_{\rm meas}\le2\min\{1,\sqrt{1-\alpha^2}+\sqrt\delta\}.
\]

The proof bounds the Hermitian part of the dilation overlap, handling
noncommuting positive matrices explicitly. There is also a stronger joint
bound under a stated sufficient condition. Coefficient 2 is **not** claimed
optimal. [Proof](../theory/BOUND_CANDIDATE_2026-10-31.md).

Checks: 1,982 admissible abstract matrix pairs among 6,000 generated pairs;
136 physical POVMs; a negative control showing why the matrix condition cannot
be omitted; rechecks of the 408 previously retained ancilla witnesses and 12
previous SDP values. Those 12 SDPs were reused, not newly solved.

## 2. A certificate that can give a useful guarantee

Writing \(D=\max_j\|\Phi(\sigma_j)-\sigma_j\|_1\) and
\(e=\max_j(1-\lambda_{\max}(E_j))<1/2\), the sharp relation is

\[
(1-2e)D\le\eta\le D.
\]

The lower coefficient has an exact saturating binary example. In particular,
when every label has a unit sector, \(e=0\) and \(\eta=D\): individual record
residuals determine the idempotence defect without a diamond-norm optimization.

Applying accessibility to the original records before moving the measurement
gives an exactly idempotent channel with

\[
\|\Phi-\Pi\|_\diamond\le
\min\left\{2,4\sqrt{1-\alpha^2}+2\sqrt\delta+
\sqrt{\frac{2\eta}{\kappa\delta(1-2\delta)}}\right\}.
\]

This removes measurement movement from the spectral-gap denominator. For the
explicit binary noise level \(10^{-4}\), using threshold \(\delta=0.01\),
the old coarse composed bound is **15.893224**, hence only 2 after clipping;
the repaired coefficient-two bound is **0.402010**. The actual distance in this
example is **0.0002**. Thus the new guarantee is nontrivial but still loose.
[Full proof and construction](CERTIFICATE_PROGRESS_2026-10-31.md).

Checks: seven exact binary cases, twelve random complex quantum cases and 26
primal/dual channel SDP problems (including two normalization anchors). All
twelve random cases have nontrivial coefficient-two certificates. The largest
SDP gap is about \(7.54\times10^{-10}\), and largest feasibility violation is
about \(8.81\times10^{-9}\). These are numerical diagnostics, not rigorous
interval bounds.

## 3. The residual coupling explains a change of rate

If the total packed space reduces every effect (in particular if it fills the
whole Hilbert space), then

\[
\nu_{\rm meas}\le\min\{2,4(1-\alpha)+5\delta\}.
\]

The threshold dependence is linear in this restricted class. A symmetric-noise
PVM family has exact distance \(2t(1-1/m)\), so the linear order cannot be
improved uniformly to \(o(t)\). The general square-root obstruction involves
coupling to the residual space and is unaffected.

The proof also gives an instance-dependent bound that accounts explicitly for
that coupling. [Proof](../theory/RESIDUAL_COUPLING_RATES_2026-10-31.md).

Checks: 79 reducing/general cases, nine exact linear-family cases and 20
primal/dual SDPs. Largest SDP gap: \(3.60\times10^{-10}\); largest feasibility
violation: \(3.67\times10^{-10}\). Individual high-part identities are checked,
as well as their sum. Random seeds are retained, including the seed of the
imported POVM generator.

## 4. Five more operator lemmas are machine-checked

`lean/RCProof/Gap.lean` proves residual projection properties, positivity of
compressed effects, compression of a supplied spectral envelope to
\(RER\le(1-\delta)R\), and hybrid isometry from fewer explicit assumptions.
The full project builds. An axiom audit of the five lemmas reports only Lean's
standard `propext`, `Classical.choice`, and `Quot.sound`, with no `sorryAx`.

Constructing the spectral envelope from spectral functional calculus, deriving
all typed sector identities, and formalizing the channel-distance and new
accessibility proofs remain open. See [Lean scope](../lean/README.md).

## Reproduction and evidence

```powershell
.venv\Scripts\python.exe experiments\run_local_validation.py --only test_constant_two_bound test_record_accessibility test_residual_coupling_rates --output research\progress_validation
```

[Run manifest](progress_validation/summary.json) retains source hashes,
arguments, exit codes and timings; adjacent logs and the Python dependency
lock preserve the environment. [Lean build log](progress_validation/lean-build.log)
and [axiom audit](progress_validation/lean-axioms.log) retain formal checks.
Detailed results:

- [Constant-two checks](local_validation/constant_two.json).
- [Accessibility and certificate checks](local_validation/record_accessibility.json).
- [Residual coupling checks](progress_validation/residual_coupling.json).

The optional PyTorch smoke test remains blocked by its missing C++ runtime;
it was not required by or rerun for these mathematical results. The original
suite's prior passes remain recorded separately. No claim of an experimentally
measured quantum advantage or a complete formal theorem follows from these runs.

The next useful targets are an external reconstruction of these short proofs,
a focused literature check of the accessibility/certificate combination, and
formalization of the positive-matrix overlap lemma. The underlying CP-map norm,
trace-norm and channel-discrimination tools are standard; see the primary
references linked from the proofs.
