# Lean 4 formalization

Locally checked on 31 October 2026 using Lean 4.35.0 and pinned Mathlib
`56a005855ea17e0b0958f73ec801ae140b0a1679`.

## Checked content

`RCProof/Core.lean` contains four scalar theorems: `projector_const_one`,
`polar_residual_le`, `near_orthonormal_overlap`, and `rank1_core_package`.

`RCProof/Hybrid.lean` contains rectangular complex-matrix proofs:

- `spectral_cross_zero`: commutation and annihilation imply a zero cross term.
- `hybrid_cross_zero`: the explicit overlap factorization and `U*U=I` imply
  `J* W (I-U U*)=0`.
- `hybrid_isometry`: the stated cross-zero, complement and isometry hypotheses
  imply `V*V=I` for the hybrid dilation.
- `hybrid_compression`: the stated label compression and cross-zero hypotheses
  give `V* L V=U C U*+R E R`.

`RCProof/Gap.lean` adds five matrix lemmas: range projection idempotence;
Hermitian, idempotent and positive residual projection; positivity of compressed
effects; compression of the spectral envelope to `R E R <= (1-delta) R`; and
assembly of the hybrid isometry with the residual properties derived from `U`.

All assumptions are explicit; no `sorry` or additional axioms are used.
The five new lemmas were also checked with `#print axioms` and depend only on
Lean's standard `propext`, `Classical.choice`, and `Quot.sound`.
This is partial operator formalization. Spectral functional calculus and the
construction of the sector overlap identities remain explicit hypotheses.
The final spectral interpretation, the channel norm bound, and the new
coefficient-two and accessibility proofs are not formalized. The whole
same-label theorem is not machine-checked.

## Reproduce on Windows

From this `lean` directory:

```powershell
$env:PATH = "$env:USERPROFILE\.elan\bin;$env:PATH"
$env:MATHLIB_CACHE_DIR = Join-Path (Get-Location) '.lake\mathlib-cache'
lake update
lake exe cache get
lake build
```

The local cache setting avoids the unwritable default cache location encountered
on this laptop. `lake-manifest.json` pins transitive dependencies. The build can
emit module-system and unused-variable warnings; these do not invalidate proofs.
See [the local run report](../research/LOCAL_VALIDATION_2026-10-31.md) for scope
and numerical evidence.
