import RCProof
import Lean.Util.CollectAxioms
set_option autoImplicit false
set_option maxRecDepth 1024
namespace RCSearch
open Matrix RCProof
open scoped ComplexOrder MatrixOrder Matrix.Norms.L2Operator
set_option maxHeartbeats 400000 in
theorem candidate (X Y : Matrix (Fin 2) (Fin 2) ℂ) : traceNorm (X + Y) ≤ traceNorm X + traceNorm Y := by
  exact?
end RCSearch
open Lean Elab Command
run_cmd do
  let axioms ← Lean.collectAxioms ``RCSearch.candidate
  let allowed := [``propext, ``Classical.choice, ``Quot.sound]
  for ax in axioms do
    unless allowed.contains ax do
      throwError "Forbidden axiom {ax}"
  logInfo "RC_RESEARCH_ACCEPTED_23c84e871abde8bcf7ead5fb9ec4c1d6cba30cae17bf9a5c73202c53f6cefff5"
