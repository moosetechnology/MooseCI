# stage 1: Build tree-sitter libraries
FROM ubuntu:latest AS treesitter-builder

RUN apt-get update && apt-get install -y \
    git \
    build-essential

# Build tree-sitter core
RUN git clone https://github.com/tree-sitter/tree-sitter
WORKDIR /tree-sitter
RUN make


# Build tree-sitter python bindings
WORKDIR /
RUN git clone https://github.com/tree-sitter/tree-sitter-python
WORKDIR /tree-sitter-python
RUN make


# Build tree-sitter typescript bindings
WORKDIR /
RUN git clone https://github.com/tree-sitter/tree-sitter-typescript
WORKDIR /tree-sitter-typescript
RUN make

# Stage 2: Main image
FROM ubuntu:latest

RUN apt-get update && apt-get install -y \
    bash \
    wget \
    unzip \
    git



# Download Pharo image
RUN wget -O- https://get.pharo.org | bash

# Download Moose image
RUN wget https://github.com/moosetechnology/Moose/releases/download/continuous/Moose13-development-Pharo64-13.zip

# Unzip Moose image and remove the zip file
RUN unzip Moose13-development-Pharo64-13.zip \
    && rm -rf Moose13-development-Pharo64-13.zip

RUN mv Moose13-development-Pharo64-13 Moose13

WORKDIR /Moose13

# Rename image and changes files to Moose13.image / Moose13.changes
RUN mv Moose13-development-Pharo64-13.image Moose13.image \
    && mv Moose13-development-Pharo64-13.changes Moose13.changes

WORKDIR /

# Copy built tree-sitter libraries from builder stage
COPY --from=treesitter-builder /tree-sitter/libtree-sitter.so /pharo-vm/lib/
COPY --from=treesitter-builder /tree-sitter-python/libtree-sitter-python.so /pharo-vm/lib/
COPY --from=treesitter-builder /tree-sitter-typescript/typescript/libtree-sitter-typescript.so /pharo-vm/lib/

# Install moose-ci package and save the image
RUN echo "Installing MooseCI package..."
COPY mooseci-install.sh /mooseci-install.sh
RUN chmod +x /mooseci-install.sh
RUN /mooseci-install.sh

COPY mooseci-docker.sh /mooseci-docker.sh
RUN chmod +x /mooseci-docker.sh

ENTRYPOINT ["/mooseci-docker.sh"]