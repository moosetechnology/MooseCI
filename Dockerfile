FROM ubuntu:latest
RUN apt-get update && apt-get install -y \
    bash \
    wget \
    unzip

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

COPY mooseci-docker.sh /mooseci-docker.sh
RUN chmod +x /mooseci-docker.sh

WORKDIR /

ENTRYPOINT ["/mooseci-docker.sh"]


