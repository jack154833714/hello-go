# ---------- build stage ----------
FROM golang:1.23-alpine AS builder

WORKDIR /app

# 先复制 go.mod / go.sum 利用缓存
COPY go.mod ./
RUN go mod download

# 再复制源码
COPY . .

# 编译（关闭 CGO，生成纯静态二进制）
RUN CGO_ENABLED=0 GOOS=linux GOARCH=arm64 go build -o hello-go

# ---------- runtime stage ----------
FROM alpine:latest

WORKDIR /app

# 复制编译好的二进制
COPY --from=builder /app/hello-go .

EXPOSE 8080

CMD ["./hello-go"]
