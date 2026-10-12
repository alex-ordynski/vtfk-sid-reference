#!/usr/bin/env bash
# Капсула С.І.Д. — ідемпотентне розгортання (ніч 1).
# Запуск без аргументів; повторний запуск не падає.
#   HOST_PORT  порт хоста, що пробивається на :80 капсули (за замовчуванням 8080)
#   SUFFIX     суфікс імені контейнера за варіантом (за замовчуванням alpha)
set -euo pipefail

HOST_PORT="${HOST_PORT:-8080}"
SUFFIX="${SUFFIX:-alpha}"
NAME="capsule-${SUFFIX}"
IMAGE="ubuntu:24.04"

docker info >/dev/null 2>&1 || { echo "Docker недоступний" >&2; exit 1; }

# Ідемпотентність: стара капсула з тим самим іменем прибирається перед новою.
docker rm -f "$NAME" >/dev/null 2>&1 || true

docker run -d --name "$NAME" -p "${HOST_PORT}:80" "$IMAGE" sleep infinity >/dev/null

docker exec "$NAME" bash -c \
  'export DEBIAN_FRONTEND=noninteractive; apt-get update -qq && apt-get install -y -qq curl git procps iproute2 >/dev/null'

# Капсула мусить лишитися запущеною.
[ "$(docker inspect -f '{{.State.Running}}' "$NAME")" = "true" ] || { echo "капсула $NAME не піднялася" >&2; exit 1; }

echo "капсула $NAME працює: localhost:${HOST_PORT} -> :80, образ $IMAGE"
