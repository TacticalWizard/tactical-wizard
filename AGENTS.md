# Project

Godot 4.7.1 multiplayer extraction-shooter prototype developed by two developers.

The project uses a dedicated-server architecture and is currently transitioning from third-person to first-person gameplay.

## Development Rules

- Inspect the existing implementation before modifying a system.
- Preserve existing behavior unless the task explicitly requires changing it.
- Prefer small, focused changes over broad refactors.
- Do not duplicate existing managers, systems, or networking logic.
- Do not overwrite or revert unrelated changes made by another developer.
- Before completing a task, inspect `git diff`.

## Multiplayer

- The dedicated server is authoritative for shared gameplay state.
- Multiplayer changes must consider both server and client behavior.
- Preserve dedicated-server compatibility.
- Do not assume a single-client environment.
- Keep local test player identities distinct.
- First-person changes must preserve existing multiplayer synchronization.

## Testing

For multiplayer-related changes, use:

`.\scripts\dev\run_local_multiplayer.ps1 -AutoMatch`

When applicable, verify:

- dedicated server starts
- both clients connect
- both players have distinct identities
- both players reach the expected session/raid
- the changed feature works for both clients
- no new Godot/networking errors appear

Never claim a test passed if it was not actually run.

## Git

- Do not develop features directly on `main`.
- Keep unrelated changes out of the same change.
- Do not commit or push unless explicitly requested.

## Completion

When finishing a task, report:

- what changed
- important files changed
- tests actually performed
- anything not tested or remaining risks