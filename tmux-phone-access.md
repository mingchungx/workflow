# Connect to a tmux Session on Your Mac from Your Phone

## Prerequisites

1. **Install tmux** (if you haven't already):
   ```bash
   brew install tmux
   ```

2. **Enable Remote Login** on your Mac:
   - Go to **System Settings → General → Sharing → Remote Login** and toggle it on.

3. **Install Termius** on your phone from the App Store or Google Play.

4. **Find your Mac's local IP**:
   ```bash
   ifconfig | grep inet
   ```
   Look for the `inet` line on `en0` — it'll look something like `192.168.1.40`. This is the IP you'll use to connect.

5. **Find your Mac username**:
   ```bash
   whoami
   ```

## Setup

Start a tmux session on your Mac:

```bash
tmux new -s main
```

## Connect from Your Phone

1. Open Termius and create a new host:
   - **Hostname**: your Mac's IP (e.g. `192.168.1.40`)
   - **Username**: your Mac username
   - **Password**: your Mac login password
2. Connect. Accept the fingerprint prompt on first connection.
3. Attach to your tmux session:
   ```bash
   tmux attach -t main
   ```

## Useful tmux Commands

- `tmux ls` — list all sessions
- `tmux attach -t <name>` — attach to a session
- `tmux new -s <name>` — create a new named session
- `Ctrl+B, D` — detach from a session (leaves it running)

## Keeping Your Mac Awake

Your Mac will kill SSH connections when it sleeps, so you need to keep it awake. The simplest way is the built-in `caffeinate` command — run it inside your tmux session:

```bash
caffeinate -s            # stay awake indefinitely (Ctrl+C to stop)
caffeinate -s -t 3600    # stay awake for 1 hour
```

Since it's running inside tmux, it'll persist even after you disconnect.

For more control (e.g. staying awake only on certain networks or on a schedule), install [Amphetamine](https://apps.apple.com/us/app/amphetamine/id937984704) from the App Store.

## Notes

- Your phone and Mac must be on the same Wi-Fi network.
- If your connection drops, the tmux session keeps running — just SSH back in and reattach.
- To connect from outside your local network, look into [Tailscale](https://tailscale.com/) for a simple VPN setup.
