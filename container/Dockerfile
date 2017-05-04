FROM ubuntu:16.04
LABEL developer="Wes Young <wes@csirtgadgets.org>"
LABEL docker_maintainer="Ventz Petkov <ventz@vpetkov.net>"

EXPOSE 443 5000

ENV CIF_VERSION 3.0.0a1
ENV CIF_RUNTIME_PATH /var/lib/cif
ENV SUDO_USER root
ENV DEBIAN_FRONTEND=noninteractive

COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY entrypoint /

RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections

RUN apt-get update && apt-get install -y git sudo resolvconf ; \
    cd /tmp && git clone https://github.com/csirtgadgets/bearded-avenger-deploymentkit

WORKDIR /tmp/bearded-avenger-deploymentkit
# Override for Docker - don't need anything related to systemd; \
RUN git checkout tags/$CIF_VERSION ; \
    sed -i "s/- include: firewall.yml//" ubuntu16/roles/ubuntu16/tasks/main.yml ; \
    sed -i "s/  tags: firewall//" ubuntu16/roles/ubuntu16/tasks/main.yml ; \
    mkdir -p /etc/resolvconf/resolv.conf.d ; \
    # Override for Docker - don't need anything related to systemd/on-startup
    head -n -7 ubuntu16/roles/ubuntu16/tasks/services.yml > /tmp/services.yml && mv -f /tmp/services.yml ubuntu16/roles/ubuntu16/tasks/services.yml ; \
    head -n -8 ubuntu16/site.yml > /tmp/site.yml && mv -f /tmp/site.yml ubuntu16/site.yml ; \
    sed -i "s/    - reload journald//" ubuntu16/roles/ubuntu16/tasks/services.yml ; \
    sed -i "s/    - reload systemd//" ubuntu16/roles/ubuntu16/tasks/services.yml ; \
    echo "" > ubuntu16/roles/ubuntu16/handlers/main.yml ; \
    echo "---" > ubuntu16/localhost.yml; \
    echo "- name: Install bearded-avenger" >> ubuntu16/localhost.yml; \
    echo "  hosts: localhost" >> ubuntu16/localhost.yml; \
    echo "  environment:" >> ubuntu16/localhost.yml; \
    echo "    LANG: C" >> ubuntu16/localhost.yml; \
    echo "    LC_ALL: C" >> ubuntu16/localhost.yml; \
    echo "    LC_MESSAGES: C" >> ubuntu16/localhost.yml; \
    echo "  become: True" >> ubuntu16/localhost.yml; \
    echo "  roles:" >> ubuntu16/localhost.yml; \
    echo "    - { role: ubuntu16, tags: role-ubuntu16 }" >> ubuntu16/localhost.yml; \
    echo "    - { role: bearded-avenger, tags: role-bearded-avenger }" >> ubuntu16/localhost.yml; \
    cp -f test.sh /root/test.sh ; \
    ln -s /home/cif/.cif.yml /root/.cif.yml ; \
    ln -s /home/cif/.cifrc /root/.cifrc ; \
    chmod 755 /root/test.sh ; \
    chmod 755 /entrypoint ; \
    cd ubuntu16 && bash bootstrap.sh ; \
    rm -Rf ../../bearded-avenger-deploymentkit


# This has to be last/post volume dir work.
# See NOTE at: https://docs.docker.com/engine/reference/builder/#volume
VOLUME /etc/cif
VOLUME /var/log/cif
VOLUME /var/lib/cif

WORKDIR /home/cif

ENTRYPOINT ["/entrypoint", "-n"]
