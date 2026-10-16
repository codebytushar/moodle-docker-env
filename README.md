# Moodle 5.3 Docker Development Environment

This repository contains the complete Docker development environment for **Moodle 5.3** running on PHP 8.3 Apache, MariaDB 11.4, phpMyAdmin, and Mailpit.

---

## ⚡ Quick Start (Any Machine)

### On Ubuntu / Linux / WSL 2:
```bash
git clone https://github.com/codebytushar/moodle-docker-env.git
cd moodle-docker-env
chmod +x install.sh purge-cache.sh cli.sh
./install.sh
```

### On Windows PowerShell:
```powershell
git clone https://github.com/codebytushar/moodle-docker-env.git
cd moodle-docker-env
.\install.ps1
```

> **Note:** The `install.sh` / `install.ps1` script automatically handles everything: creating `.env`, cloning your forked Moodle repository (`codebytushar/moodle-custom` on `MOODLE_503_STABLE`), setting directory permissions, starting the Docker containers, and installing Moodle.

---

## 🌐 URLs & Access

| Service | URL | Credentials / Notes |
| :--- | :--- | :--- |
| **Moodle 5.3 Web** | [http://localhost:8080](http://localhost:8080) | Username: `admin`<br>Password: `Admin@12345` |
| **phpMyAdmin** | [http://localhost:8081](http://localhost:8081) | User: `moodleuser` / Pass: `moodlepass` |
| **Mailpit** (Local Email Inbox) | [http://localhost:8025](http://localhost:8025) | Captures all outgoing Moodle emails |
| **MariaDB 11.4** | `localhost:3307` | Database: `moodle` |

---

## 🛠️ Utility Commands

- **Purge Caches**:
  - Linux/WSL: `./purge-cache.sh`
  - Windows: `.\purge-cache.ps1`
- **Run Moodle CLI**:
  - `./cli.sh admin/cli/cron.php`
- **Stop / Start Docker Stack**:
  - `docker compose stop` / `docker compose start`
