# Lean progress on sharpness and joint asymptotics

Date: 1 November 2026. This extends the
[194-theorem frozen result](LEAN_FROZEN_THEOREM_2026-11-01.md).
It does not change the frozen paper or claim novelty or external review.

## Verified result

The later **canonical joint diamond upper bound** and its **uniform upper
remainder** are now machine checked. These are operator/channel statements
about the constructed POVM, not scalar inequalities supplied with the desired
channel estimate as a premise.

Let `c=1-delta`, let `alpha` be the implemented least singular value of the
canonical sector synthesis, and define

```text
epsilon = 1 - alpha^2 c
h = max(1-alpha, 1/sqrt(c)-1) + 1-sqrt(c)
s = 1-alpha^2+delta.
```

For `0<c<1`, nonempty canonical sector index and injective synthesis,
[`canonical_joint_diamond_upper`](../lean/RCProof/JointUpper.lean) proves

```text
diamondSize(M_E - M_F)
  <= min(2, 2 sqrt(epsilon)/sqrt(4-epsilon) + 2h).
```

There is no width assumption. The estimate holds on **every complex input and
every finite ancilla**. The definition of `diamondSize` takes their supremum
and has no factor of one half. The explicit per-input theorem precedes the
supremum theorem in the same file.

[`canonical_joint_uniform_diamond_upper`](../lean/RCProof/JointAsymptotic.lean)
then proves `diamondSize(M_E-M_F) <= sqrt(s)+5s` whenever `s<=1/4`, under
the same canonical hypotheses. This formalizes the upper side of the uniform
sandwich in [the joint asymptotic proof](../theory/joint_small_error_asymptotics.md).
It does not assert that an arbitrary POVM attains this bound.

## Proof chain

1. **Signed Kraus contraction.**
   [`SignedKraus`](../lean/RCProof/SignedKraus.lean) proves that
   `sum_i sign_i A_i X A_i*` has trace norm at most `B ||X||_1` if
   `sum_i A_i* A_i <= B I` and each sign squares to one. The proof uses the
   combined Gram operator, trace-norm duality and an explicit stacked map.
2. **Residual estimate.**
   For Hermitian `D`, a projection `R`, `DR=0` and `D^2<=epsilon(I-R)`,
   [`SharpResidual`](../lean/RCProof/SharpResidual.lean) proves the bound
   `2 sqrt(epsilon)/sqrt(4-epsilon)` for
   `(R+D)X(R+D)*-RXR*`, including arbitrary finite ancillas.
   Put `A=(1/2+k)D+R`, `C=(1/2-k)D+R`. Then the difference is
   `(AXA*-CXC*)/(2k)` and the combined Gram operator is at most `2I`
   when `(1/4+k^2)epsilon=1`. Choosing
   `k=sqrt(4-epsilon)/(2 sqrt(epsilon))` gives the stated constant directly
   for complex inputs. No pure-state/input-reduction assumption is introduced.
3. **Constructed positive remainder factorization.**
   [`PositiveFamily`](../lean/RCProof/PositiveFamily.lean) factors any finite
   family of positive effects through the square root of their sum and an
   explicit trace-nonincreasing Kraus map. The rectangular contraction polar
   factorization works even when the sum is singular. Its amplified
   trace-norm contraction is proved, rather than assumed.
4. **Canonical decomposition and selected correction.**
   [`CanonicalSplit`](../lean/RCProof/CanonicalSplit.lean) and
   [`CanonicalRemainder`](../lean/RCProof/CanonicalRemainder.lean) construct
   `A_j=P_j E_j P_j`, positive `B_j=E_j-A_j`, and a positive `G` with
   `GR=0`, `G^2<=epsilon(I-R)`, `sum B_j=(R+G)^2`, and `R A_j R=0`.
   [`SelectedCorrection`](../lean/RCProof/SelectedCorrection.lean) derives
   `||DH-I||<=h` from canonical packing and spectral bounds.
   [`SelectedMeasurement`](../lean/RCProof/SelectedMeasurement.lean) transfers
   it to the selected-effect channel with error at most `2h`.
5. **Assembly and uniform remainder.**
   [`RemainderMap`](../lean/RCProof/RemainderMap.lean) applies the residual
   estimate through the constructed positive-family factorization.
   `JointUpper` combines the remainder and selected errors, then applies the
   universal measurement distance bound two. `JointAsymptotic` proves
   `epsilon<=s`, `h<=2s` and the residual estimate at most `sqrt(s)+s` in the
   small-error regime, obtaining `sqrt(s)+5s` for the actual channel.

## Scalar sharpness and limit results

[`EnvelopeAnalysis`](../lean/RCProof/EnvelopeAnalysis.lean) also proves:

- For `0<b<1`, the maximum over `0<=p<=1` of
  `b^2 p + sqrt(b^4 p^2+4b^2 p(1-p))` is `B(b)=2b/(2-b)`, with equality
  at `p=1/(2-b)`.
- The exact expansion `B(b)=b+b^2/2+b^3/[2(2-b)]`; on `0<=b<=1` its
  remainder lies between zero and `b^3/2`.
- For nonzero `b`, `B(b)/b=2/(2-b)`, whose limit at zero is one.
- A joint-limit transfer lemma: any sequences with `s_n>0`,
  `0<=delta_n<=s_n`, `s_n->0` and
  `(1-2delta_n)sqrt(s_n)<=W_n<=sqrt(s_n)+5s_n` satisfy
  `W_n/sqrt(s_n)->1`.

The maximizing scalar is **not** an implemented attaining POVM. The sequence
lemma is explicitly conditional; it does **not** supply the lower bound or
identify `W_n` with the actual worst-case supremum. Consequently neither the
complete exact perfect-packing theorem nor the complete sharp joint asymptotic
theorem is represented as Lean formalized.

## Validation

The pinned Lean/Mathlib build contains **256 written lemmas/theorems**, up from
194. Its namespace-wide audit checks **428 kernel theorem declarations**
including generated helpers, and **504 declarations in total**. The only
permitted transitive axioms are `propext`, `Classical.choice` and `Quot.sound`.
The new proof files disable implicit declaration of undeclared variables.
No custom axiom or unfinished proof is accepted.

Reproduce from the repository root:

```powershell
python experiments/test_lean_formalization.py --negative-controls --out research/local_validation/sharp_asymptotic
python experiments/test_repository_claim_discipline.py
git diff --check
```

The retained [manifest](lean_sharp_asymptotic_2026-11-01/manifest.json) records
the scope, source-byte hashes, required declarations and rejection controls.
The [build log](lean_sharp_asymptotic_2026-11-01/build.log) contains the
transitive audit. Separate
[extra-axiom](lean_sharp_asymptotic_2026-11-01/extra_axiom.log) and
[unfinished-proof](lean_sharp_asymptotic_2026-11-01/unfinished_proof.log) logs
record the two intentionally failing controls. Counts do not count downloaded
Mathlib sources. Hashes describe this local source snapshot, including its
line endings; a fresh checkout's Git line-ending conversion can change byte hashes.
The saved run passes both rejection controls. An independent manifest check
matched all 45 recorded source/configuration hashes. The repository
claim-discipline check passed, an additional check resolved all 129 local links
in the five updated documentation files, and `git diff --check` passed.

The prior numerical certificates and frozen paper are unchanged; this report
does not represent their historical tests as newly rerun.

## Outstanding work

The remaining **formalization** targets for the later sharpness/asymptotic
results are concrete:

1. The perfect-packing **operator upper bound** `2 sqrt(delta)/(2-sqrt(delta))`,
   including the selected defect term. The residual estimate and scalar
   optimization alone do not prove this full statement.
2. The six-dimensional, five-outcome **attaining family**: positivity,
   normalization, exact full threshold sectors, `alpha=1`, and its measured
   distance. This is needed to turn the scalar maximum into operator sharpness.
3. The growing coupled-simplex **joint lower family**: exact packing parameter,
   spectral thresholds, admissible parameter choice and matching distance.
4. The **worst-case supremum definition and bridge**, including nonemptiness
   of the admissible classes and instantiation of the limit-transfer lemma
   with their upper and lower bounds.

Other project formalization targets remain: record correction, accessibility,
and the computer-assisted comparison/reference-advantage certificates. The
frozen theorem's principal-angle, repeatable-instrument and all-input diamond
steps were already completed and remain checked in this build.

Separate **mathematical/review** questions remain: the general imperfect-packing
finite-error optimum and subleading term, crossover uniqueness, definitive
novelty assessment and independent external review. Formalizing the results
above would not by itself settle those questions.
