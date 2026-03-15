# Connect to a tmux Session on Your Mac from Your Phone

## Prerequisites

1. **Install tmux** (if you haven't already):
   ```bash
   brew install tmux
   ```

2. **Enable Remote Login** on your Mac:
   - Go to **System Settings → General → Sharing → Remote Login** and toggle it on.

3. **Install Termius** on your phone from the App Store or Google Play.

4. **Install Tailscale** on both devices so you can connect from anywhere:
   - **Mac**: Download from [tailscale.com/download/mac](https://tailscale.com/download/mac) (use the standalone variant).
   - **Phone**: Download the Tailscale app from the App Store.
   - Sign into both with the same account (Google, GitHub, etc.).

5. **Find your Mac's Tailscale IP**:
   ```bash
   tailscale ip
   ```
   This gives you a `100.x.y.z` address that works from anywhere and never changes.

6. **Find your Mac username**:
   ```bash
   whoami
   ```

## Setup

Start a tmux session on your Mac:

```bash
tmux new -s main
```

## Keeping Your Mac Awake

Your Mac will kill SSH connections when it sleeps (including when the lid is closed). To disable sleep entirely:

```bash
sudo pmset disablesleep 1
```

To auto re-enable sleep after 24 hours, run this in your tmux session:

```bash
sudo bash -c 'pmset disablesleep 1 && sleep 86400 && pmset disablesleep 0'
```

To manually re-enable sleep at any time:

```bash
sudo pmset disablesleep 0
```

> **Warning**: While sleep is disabled, your Mac stays fully awake even with the lid closed. Don't put it in a bag — it can overheat.

## Connect from Your Phone

1. Make sure Tailscale is active on both your Mac and phone.
2. Open Termius and create a new host:
   - **Hostname**: your Mac's Tailscale IP (e.g. `100.97.31.48`)
   - **Username**: your Mac username
   - **Password**: your Mac login password
3. Connect. Accept the fingerprint prompt on first connection.
4. Attach to your tmux session:
   ```bash
   tmux attach -t main
   ```

## Useful tmux Commands

- `tmux ls` — list all sessions
- `tmux attach -t <name>` — attach to a session
- `tmux new -s <name>` — create a new named session
- `Ctrl+B, D` — detach from a session (leaves it running)

## Notes

- Tailscale works from any network — same Wi-Fi, cellular, or a completely different location.
- If your connection drops, the tmux session keeps running — just SSH back in and reattach.
- Your Tailscale IP never changes, so you only need to set up the Termius host once.
