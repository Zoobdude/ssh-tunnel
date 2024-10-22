FROM alpine:latest AS builder

# Build base provides the C compiler
RUN apk update && \
    apk add --no-cache git build-base openssh

# Clone and build the latest repository
RUN git clone https://github.com/Autossh/autossh /autossh

WORKDIR /autossh

RUN ./configure && make

# Build the runtime container
FROM alpine:latest

RUN apk update && \
    apk add --no-cache openssh openssl

# Copy the built autossh binary from the builder stage
COPY --from=builder /autossh/autossh /ssh/autossh

WORKDIR /ssh

CMD sh -c './autossh -M 0 -o StrictHostKeyChecking=no -N -F /ssh/config/$SSH_CONFIG_FILE -o "IdentityFile=/ssh/config/$SSH_KEY_FILE" $HOSTNAME'