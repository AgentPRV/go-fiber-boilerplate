# Step 1: Build Stage
FROM golang:1.22-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN CGO_ENABLED=0 GOOS=linux go build -o main .

# Step 2: Runtime Stage
FROM alpine:latest
WORKDIR /root/
# Copy only the compiled binary from the builder
COPY --from=builder /app/main .
# Copy .env if your app requires it
COPY --from=builder /app/.env.example ./.env 

EXPOSE 3000
CMD ["./main"]