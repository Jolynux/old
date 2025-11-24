FROM debian:10

ENV container docker
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL C

# Install packages
RUN apt-get update && apt-get -y install --no-install-recommends openssh-server sudo systemd python3 bash net-tools openssh-client python3-apt

RUN sed -i 's/PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
&& sed -i 's/#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config
RUN rm -rf /lib/systemd/system/multi-user.target.wants/* /etc/systemd/system/*.wants/* /lib/systemd/system/local-fs.target.wants/* /lib/systemd/system/sockets.target.wants/*udev* /lib/systemd/system/sockets.target.wants/*initctl* /lib/systemd/system/sysinit.target.wants/systemd-tmpfiles-setup* /lib/systemd/system/systemd-update-utmp* /sbin/init && ln -s /lib/systemd/system /sbin/init

ADD set_root_pw.sh /set_root_pw.sh
ADD run.sh /run.sh
RUN chmod +x /*.sh && systemctl set-default multi-user.target
ENV init /lib/systemd/systemd

CMD ["/run.sh"]
# Expose ports for services
EXPOSE 22 80