# Lean Formalisation Status

**Date:** 31 October 2026  
**Build:** Successful for both Hybrid.lean and HybridExtended.lean

## Formalised and building

- `hybrid_is_isometry`: Sum of partial isometries with vanishing cross terms and complementary supports is an isometry.
- `implements_completion`: Implementation identity.
- `residual_orthogonal`: Residual projector is orthogonal to the packed subspace.
- `residual_idempotent`: Residual is idempotent.

## Still open for full end-to-end

- Polar residual estimate controlling ||V - W|| (analytic).
- Spectral-gap argument for gamma_F >= delta (functional calculus).
- Stinespring continuity step from isometry distance to diamond norm.
- Composition with Record-Margin Stability.

## Honest assessment

The algebraic and residual-projector core is formalised. The remaining open areas are analytic estimates and the composition with an external theorem. Full end-to-end formalisation is a multi-day effort beyond the current session; the core identities that can be stated purely algebraically are done and build.
