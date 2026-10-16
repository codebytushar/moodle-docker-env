# Moodle Dev Environment Installer for Windows PowerShell

# Copy .env from example if not already present
if (-not (Test-Path .env)) {
    Write-Host "Creating .env from .env.example..."
    Copy-Item .env.example .env
}

# Clone moodle codebase if not present
if (-not (Test-Path moodle)) {
    Write-Host "Cloning moodle-custom repository (branch MOODLE_503_STABLE)..."
    git clone --branch MOODLE_503_STABLE --depth 1 https://github.com/codebytushar/moodle-custom.git moodle
    Set-Location moodle
    git remote add upstream https://github.com/moodle/moodle.git 2>$null
    Set-Location ..
}

# Ensure moodledata exists
New-Item -ItemType Directory -Force -Path moodledata | Out-Null

Write-Host "Ensuring containers are up..."
docker compose up -d

Write-Host "Running Moodle CLI installation inside container..."
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

Write-Host "Configuring developer settings..."
docker compose exec web php -r '$config = file_get_contents("/var/www/html/config.php"); if (strpos($config, "DEVELOPER") === false) { $dev = "\n// Developer settings\n@ini_set(\x27display_errors\x27, \x271\x27);\n\$CFG->debug = (E_ALL | E_STRICT);\n\$CFG->debugdisplay = 1;\n"; $config = str_replace("require_once(__DIR__ . \x27/lib/setup.php\x27);", $dev . "require_once(__DIR__ . \x27/lib/setup.php\x27);", $config); file_put_contents("/var/www/html/config.php", $config); }'

Write-Host "=================================================="
Write-Host " Moodle Dev Environment is Ready!"
Write-Host " URL:         http://localhost:8080"
Write-Host " Admin User:  admin"
Write-Host " Admin Pass:  Admin@12345"
Write-Host " phpMyAdmin:  http://localhost:8081"
Write-Host " Mailpit:     http://localhost:8025"
Write-Host "=================================================="
