FROM sebastianhutter/ffmpeg:latest

# set workdir
WORKDIR /

# install requirements
RUN apt-get update \
  && apt-get install -y python python-pip curl unrar-free p7zip-full par2 git \
     gcc libssl-dev libffi-dev python-dev \
  && pip install --upgrade pip \
  && pip install --upgrade appdirs cffi pyparsing Cheetah pydbus pyOpenSSL j2cli sabyenc \
  && apt-get remove --purge -y gcc libssl-dev libffi-dev python-dev \
  && rm -rf /var/lib/apt/lists/*

# download sabnzbd and nzbtomedia
RUN git clone https://github.com/sabnzbd/sabnzbd.git && \
    git clone https://github.com/clinton-hall/nzbToMedia.git

# copy the sabnzbd configuration file
ADD build/sabnzbd.ini /sabnzbd/sabnzbd.ini
# copy the nzbtomedia configuration file
ADD build/autoProcessMedia.cfg /nzbToMedia/autoProcessMedia.cfg
# add the entry script
ADD build/docker-entrypoint.sh /
RUN chmod +x /docker-entrypoint.sh

# run the docker entrypoint script
ENTRYPOINT ["/docker-entrypoint.sh"]
