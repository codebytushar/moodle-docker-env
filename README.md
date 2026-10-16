# Moodle 5.3 Docker Development Environment

This repository contains a containerized development environment for **Moodle 5.3** on PHP 8.3 Apache, MariaDB 11.4, phpMyAdmin, and Mailpit.

---

## Prerequisites

- **Docker & Docker Compose**:
  - **Ubuntu**: Docker Engine + Docker Compose plugin (`sudo apt install docker-compose-v2`).
  - **Windows**: [Docker Desktop](https://www.docker.com/products/docker-desktop/) with WSL 2 backend enabled.
- **Git**

---

## 🚀 Setup on Ubuntu (Linux)

### 1. Clone this repository and the Moodle codebase
```bash
# Clone or create your project directory
mkdir -p MoodleCustomization && cd MoodleCustomization

# Clone your Moodle fork (MOODLE_503_STABLE branch)
git clone --branch MOODLE_503_STABLE --depth 1 https://github.com/codebytushar/moodle-custom.git moodle
cd moodle
git remote add upstream https://github.com/moodle/moodle.git
cd ..
```

### 2. Configure Environment
```bash
cp .env.example .env
mkdir -p moodledata && chmod 777 moodledata
```

### 3. Start Containers & Run Installer
```bash
chmod +x install.sh purge-cache.sh cli.sh
./install.sh
```

---

## 🪟 Setup on Windows

### Option A: Using WSL 2 (Recommended)
Open your **Ubuntu terminal inside WSL 2** and follow the exact same Ubuntu steps above. File mounts and shell scripts will work seamlessly with zero translation needed.

### Option B: Using Windows PowerShell / Command Prompt

1. **Clone Moodle fork**:
   ```powershell
   git clone --branch MOODLE_503_STABLE --depth 1 https://github.com/codebytushar/moodle-custom.git moodle
   cd moodle
   git remote add upstream https://github.com/moodle/moodle.git
   cd ..
   ```

2. **Copy `.env.example` to `.env` and create data folder**:
   ```powershell
   Copy-Item .env.example .env
   New-Item -ItemType Directory -Force -Path moodledata
   ```

3. **Start the containers**:
   ```powershell
   docker compose up -d
   ```

4. **Run Moodle CLI installation**:
   ```powershell
   docker compose exec web php admin/cli/install.php `
     --lang=en `
     --wwwroot="http://localhost:8080" `
     --dataroot=/var/www/moodledata `
     --dbtype=mariadb `
     --dbhost=db `
     --dbname=moodle `
     --dbuser=moodleuser `
     --dbpass=moodlepass `
     --dbport=3306 `
     --prefix=mdl_ `
     --fullname="Moodle Dev Environment" `
     --shortname="MoodleDev" `
     --adminuser=admin `
     --adminpass="Admin@12345" `
     --adminemail="triple5.kcs@gmail.com" `
     --agree-license `
     --non-interactive
   ```

---

## 🌐 URLs & Access

- **Moodle**: [http://localhost:8080](http://localhost:8080) (Admin: `admin` / `Admin@12345`)
- **phpMyAdmin**: [http://localhost:8081](http://localhost:8081) (User: `moodleuser` / `moodlepass`)
- **Mailpit Web UI**: [http://localhost:8025](http://localhost:8025)
