FROM java:jre
MAINTAINER Florent Daigniere <nextgens@freenetproject.org>

ENV USER_ID 1000
ENV GROUP_ID 1000
ENV BUILD 1470

# install ssh server
RUN apt-get install -y openssh-server
RUN mkdir /var/run/sshd

RUN echo 'root:root' |chpasswd

RUN sed -ri 's/^PermitRootLogin\s+.*/PermitRootLogin yes/' /etc/ssh/sshd_config
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config

RUN addgroup --system --gid $GROUP_ID freenet && adduser --system --uid=$USER_ID --gid=$GROUP_ID --home /freenet --shell /bin/bash --gecos "Freenet" freenet

WORKDIR /freenet

RUN apt-get update && apt-get install --no-install-recommends -y \
  gnupg2 \
  wget \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN mkdir -p data && chown -R freenet:freenet /freenet

USER freenet

ADD release-managers.asc /release-managers.asc
ADD ./run /freenet/run


EXPOSE 8888 9481 22
VOLUME ["/freenet/data"]
CMD ["/freenet/run"]
