FROM rust:1.90-trixie AS builder

ARG ANTE_REPOSITORY=https://github.com/jfecher/ante.git
ARG ANTE_REF=0f58d008a787a917362cbc77b4a621f6856103b1

RUN apt-get update \
    && apt-get install --yes --no-install-recommends build-essential git ca-certificates \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --recurse-submodules "${ANTE_REPOSITORY}" /opt/ante \
    && git -C /opt/ante checkout "${ANTE_REF}" \
    && git -C /opt/ante submodule update --init --recursive \
    && cargo build --manifest-path /opt/ante/Cargo.toml --release --no-default-features

WORKDIR /app
COPY . .

RUN test -f deps/antest/ante.toml \
    || (echo >&2 "deps/antest is missing; initialize submodules before docker build" && exit 1)
RUN make native \
    && /opt/ante/target/release/ante build \
        --release \
        --backend c \
        --bin main.an \
        -L build \
        -l ante_http_socket

FROM debian:trixie-slim AS runtime

RUN apt-get update \
    && apt-get install --yes --no-install-recommends ca-certificates \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY --from=builder /app/AnteHttp /usr/local/bin/ante-http

EXPOSE 8080
CMD ["ante-http"]
