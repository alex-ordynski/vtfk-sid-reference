# Капсула С.І.Д. — багатоетапна збірка (ніч 2).
# Збирати з кореня vtfk-sid:  docker build -f core/capsule/Dockerfile -t sid-capsule core
FROM rust:1.79 AS build
WORKDIR /src
COPY sid/ .
RUN cargo build --release

FROM debian:12-slim
COPY --from=build /src/target/release/sid /usr/local/bin/sid
CMD ["sid"]
