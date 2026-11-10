import RCProof
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 1024
namespace RCSearch
open Matrix RCProof
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
set_option maxHeartbeats 400000 in
theorem candidate (x : ℝ) : 0 ≤ x ^ 2 := by
  positivity
end RCSearch
open Lean Elab Command
run_cmd do
  let axioms ← Lean.collectAxioms ``RCSearch.candidate
  let allowed := [``propext, ``Classical.choice, ``Quot.sound]
  for ax in axioms do
    unless allowed.contains ax do
      throwError "Forbidden axiom {ax}"
  logInfo "RC_RESEARCH_ACCEPTED_d088bc47bd31d6206c7e6088c92d7d93aeac0112e92fb63fcbe422564e73d6e7"
