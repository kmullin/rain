# syntax=docker/dockerfile:1

FROM --platform=$BUILDPLATFORM golang:1.25 AS builder

WORKDIR /src

COPY go.mod go.sum ./
RUN go mod download

COPY . .

ARG VERSION=dev
ARG TARGETOS
ARG TARGETARCH

RUN CGO_ENABLED=0 \
    GOOS=$TARGETOS \
    GOARCH=$TARGETARCH \
    go build -ldflags="-s -w -X github.com/cenkalti/rain/v2/torrent.Version=${VERSION}" -o /out/rain .

FROM alpine:3.22

RUN apk add --no-cache ca-certificates

COPY --from=builder /out/rain /usr/local/bin/rain

ENTRYPOINT ["/usr/local/bin/rain"]
