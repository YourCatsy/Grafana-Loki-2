# Start from the official Go image
FROM golang:1.20 AS builder

# Set the working directory
WORKDIR /app

# Copy go.mod and go.sum files
COPY go.mod go.sum ./

# Download all dependencies
RUN go mod download

# Copy the source code
COPY . .

# Build the application
RUN go build -o webapp main.go

# Use a minimal base image for production
FROM debian:bookworm-slim

# Set the working directory
WORKDIR /app

# Copy the built application and public assets
COPY --from=builder /app/webapp /app/
COPY public /app/public

# Expose the application port
EXPOSE 8080

# Start the application
CMD ["./webapp"]
