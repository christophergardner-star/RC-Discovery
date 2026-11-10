import RCProof
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 1024
namespace RCSearch
open Matrix RCProof
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
set_option maxHeartbeats 400000 in
theorem candidate (x y : ℝ) : 0 ≤ (x * y) ^ 2 := by
  positivity
end RCSearch
open Lean Elab Command
run_cmd do
  let axioms ← Lean.collectAxioms ``RCSearch.candidate
  let allowed := [``propext, ``Classical.choice, ``Quot.sound]
  for ax in axioms do
    unless allowed.contains ax do
      throwError "Forbidden axiom {ax}"
  logInfo "RC_RESEARCH_ACCEPTED_689f68cb3fbdd1e22e654e9248ba13d9a31e5d00d5422e711c9bc18dff66c830"
