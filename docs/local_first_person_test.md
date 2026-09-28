# Windows local first person multiplayer test

Run from the `feature/first-person` branch with a Godot 4.7.1 debug/editor build.
The existing ENet server listens on UDP 7000. Oracle deployment is unchanged.

```powershell
.\scripts\dev\run_local_multiplayer.ps1 -AutoMatch
```

The script starts one headless dedicated server and two visible clients. Without
`-AutoMatch`, use the lobby matchmaking button in both clients. You can also
start each process separately:

```powershell
& 'C:\Program Files\Godot\Godot.exe' --headless --path . -- --server
& 'C:\Program Files\Godot\Godot.exe' --path . -- --client --server-address=127.0.0.1 --player-id=test_player_01
& 'C:\Program Files\Godot\Godot.exe' --path . -- --client --server-address=127.0.0.1 --player-id=test_player_02
```

The two debug aliases map to distinct valid UUIDs, so the existing duplicate
identity check remains active. An editor Run Multiple Instances launch without
these arguments uses the same persisted `user://player_identity.json` on both
instances and the second connection is rejected. Configure per-instance launch
arguments or use the script. No Run Multiple Instances setting is tracked in
this project. The CLI identity and server-address overrides, as
well as `--client` and `--auto-match`, are debug-build only.

Once both clients enter the Raid, check mouse yaw and pitch (limited to about
77 degrees), W/A/S/D relative to view, each client's own camera, remote body
yaw, crosshair versus projectile path, near-wall shots, damage/HP, Escape and
inventory capture, and a return to lobby followed by re-entry. Headless runs
can verify connection, session creation, player replication and camera owner
logs; mouse, visuals and actual hit behavior require visible-client checks.
