#!/usr/bin/env bash
set -e

# Copy .env from example if not already present
if [ ! -f .env ]; then
  echo "Creating .env from .env.example..."
  cp .env.example .env
fi

# Load .env
export $(grep -v '^#' .env | xargs)

# Clone moodle codebase if not present
if [ ! -d "moodle" ]; then
  echo "Cloning moodle-custom repository (branch MOODLE_503_STABLE)..."
  git clone --branch MOODLE_503_STABLE --depth 1 https://github.com/codebytushar/moodle-custom.git moodle
  cd moodle && git remote add upstream https://github.com/moodle/moodle.git 2>/dev/null || true
  cd ..
fi

# Ensure moodledata exists with full permissions
mkdir -p moodledata
chmod -R 777 moodledata 2>/dev/null || true

echo "Ensuring docker containers are running..."
docker compose up -d

echo "Running Moodle CLI installation..."
docker compose exec web php admin/cli/install.php \
  --lang=en \
  --wwwroot="${MOODLE_WWWROOT:-http://localhost:8080}" \
  --dataroot=/var/www/moodledata \
  --dbtype=mariadb \
  --dbhost=db \
  --dbname="${DB_NAME:-moodle}" \
  --dbuser="${DB_USER:-moodleuser}" \
  --dbpass="${DB_PASSWORD:-moodlepass}" \
  --dbport=3306 \
  --prefix=mdl_ \
  --fullname="${MOODLE_FULLNAME:-Moodle Dev Environment}" \
  --shortname="${MOODLE_SHORTNAME:-MoodleDev}" \
  --adminuser="${MOODLE_ADMIN_USER:-admin}" \
  --adminpass="${MOODLE_ADMIN_PASS:-Admin@12345}" \
  --adminemail="${MOODLE_ADMIN_EMAIL:-triple5.kcs@gmail.com}" \
  --agree-license \
  --non-interactive

echo "Configuring developer settings in config.php..."
docker compose exec web php -r '
$config = file_get_contents("/var/www/html/config.php");
if (strpos($config, "DEVELOPER") === false) {
    $devsettings = "\n// Developer settings\n@ini_set(\x27display_errors\x27, \x271\x27);\n\$CFG->debug = (E_ALL | E_STRICT);\n\$CFG->debugdisplay = 1;\n";
    $config = str_replace("require_once(__DIR__ . \x27/lib/setup.php\x27);", $devsettings . "require_once(__DIR__ . \x27/lib/setup.php\x27);", $config);
    file_put_contents("/var/www/html/config.php", $config);
}
'

echo "Fixing permissions on moodle/config.php and moodledata..."
chmod 666 moodle/config.php 2>/dev/null || true
chmod -R 777 moodledata 2>/dev/null || true

echo "=================================================="
echo " Moodle Dev Environment is Ready!"
echo " URL:         ${MOODLE_WWWROOT:-http://localhost:8080}"
echo " Admin User:  ${MOODLE_ADMIN_USER:-admin}"
echo " Admin Pass:  ${MOODLE_ADMIN_PASS:-Admin@12345}"
echo " phpMyAdmin:  http://localhost:${PMA_PORT:-8081}"
echo " Mailpit:     http://localhost:${MAILPIT_WEB_PORT:-8025}"
echo "=================================================="
