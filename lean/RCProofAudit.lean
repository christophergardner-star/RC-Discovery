import RCProof
import Lean.Util.CollectAxioms

/-! Fail the build if any declaration in the project namespace depends on
anything beyond Lean's three standard logical axioms. This checks transitive
dependencies, not merely the absence of placeholder text in source files. -/
open Lean Elab Command

set_option maxHeartbeats 0 in
run_cmd do
  let env ← getEnv
  let names := env.constants.toList.filterMap fun (name, _) =>
    if (`RCProof).isPrefixOf name then some name else none
  let allowed := [``propext, ``Classical.choice, ``Quot.sound]
  let mut theoremCount : Nat := 0
  for name in names do
    let axioms ← Lean.collectAxioms name
    for ax in axioms do
      unless allowed.contains ax do
        throwError "Forbidden axiom {ax} in {name}"
    if (env.find? name).any (fun ci => ci matches .thmInfo _) then
      theoremCount := theoremCount + 1
      logInfo m!"AXIOMS {name}: {axioms}"
  logInfo m!"AXIOM AUDIT PASSED: {theoremCount} theorems; {names.length} total declarations checked."
