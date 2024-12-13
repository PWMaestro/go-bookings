# Start with a lightweight Go image
FROM golang:1.23.4-alpine AS builder

# Set the working directory inside the container
WORKDIR /app

# Copy the source code
COPY . .

# Download Go module dependencies
RUN go mod download

# Build the Go app
RUN go build -o ./cmd/web/main ./cmd/web

# Use a minimal image to run the application
FROM alpine:3.21

# Set the working directory in the second stage
WORKDIR /app

# Copy the compiled binary from the builder
COPY --from=builder /app/cmd/web/main .
COPY --from=builder /app/static ./static
COPY --from=builder /app/templates ./templates

# Expose the port that the app listens on
EXPOSE 8080

# Command to run the application
CMD ["./main"]
