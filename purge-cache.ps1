# Purge Moodle caches inside container
docker compose exec web php admin/cli/purge_caches.php $args
