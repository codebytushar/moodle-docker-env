#!/usr/bin/env bash
docker compose exec web php admin/cli/purge_caches.php "$@"
