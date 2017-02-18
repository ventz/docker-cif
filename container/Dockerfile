FROM ubuntu:16.04
LABEL developer="Wes Young <wes@csirtgadgets.org>"
LABEL docker_maintainer="Ventz Petkov <ventz@vpetkov.net"

EXPOSE 443 5000

VOLUME /etc/cif
VOLUME /var/log/cif
VOLUME /var/lib/cif

ENV CIF_VERSION 3.0.0a16
ENV CIF_RUNTIME_PATH /var/lib/cif
ENV SUDO_USER root
ENV DEBIAN_FRONTEND=noninteractive

COPY supervisord.conf /usr/local/etc/supervisord.conf
COPY entrypoint /

RUN apt-get update && apt-get install -y git sudo ; \
    cd /tmp && git clone https://github.com/csirtgadgets/bearded-avenger.git

WORKDIR /tmp/bearded-avenger
RUN sed -i "s/- include: firewall.yml//" deployment/ubuntu16/roles/ubuntu16/tasks/main.yml ; \
    sed -i "s/  tags: firewall//" deployment/ubuntu16/roles/ubuntu16/tasks/main.yml ; \
    mkdir -p /etc/resolvconf/resolv.conf.d ; \
    # Override for Docker - don't need anything related to systemd; \
    echo "---" > deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "- name: copy supervisord configs" >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "  copy: src=\"{{ item }}\" dest=/etc/cif/ mode=0660 owner=\"{{ app_user }}\" group=\"{{ app_user }}\"" >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "  with_items:" >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "    - cif-router.conf" >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "    - cif-httpd.conf" >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "    - csirtg-smrt.conf" >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "" >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "- name: systemd env file" >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "  template: src=cif.env.j2 dest=/etc/cif.env mode=0660 owner=\"{{ app_user }}\" group=\"{{ app_user }}\" " >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "  tags: configuration" >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "" >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "- name: copy /etc/defaults/cif" >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    echo "  template: src=defaults.j2 dest=/etc/default/cif mode=0660 owner=\"{{ app_user }}\" group=\"{{ app_user }}\"" >> deployment/ubuntu16/roles/ubuntu16/tasks/services.yml; \
    # Override for Docker - don't need anything related to systemd/on-startup
    echo "---" > deployment/ubuntu16/localhost.yml; \
    echo "- name: Install bearded-avenger" >> deployment/ubuntu16/localhost.yml; \
    echo "  hosts: localhost" >> deployment/ubuntu16/localhost.yml; \
    echo "  environment:" >> deployment/ubuntu16/localhost.yml; \
    echo "    LANG: C" >> deployment/ubuntu16/localhost.yml; \
    echo "    LC_ALL: C" >> deployment/ubuntu16/localhost.yml; \
    echo "    LC_MESSAGES: C" >> deployment/ubuntu16/localhost.yml; \
    echo "  become: True" >> deployment/ubuntu16/localhost.yml; \
    echo "  roles:" >> deployment/ubuntu16/localhost.yml; \
    echo "    - { role: ubuntu16, tags: role-ubuntu16 }" >> deployment/ubuntu16/localhost.yml; \
    echo "    - { role: bearded-avenger, tags: role-bearded-avenger }" >> deployment/ubuntu16/localhost.yml; \
    # We can't have a run-state while building container - exit cleanly after build!
    sed -i "s/bash ..\/test.sh/exit 0/" deployment/ubuntu16/bootstrap.sh ; \
    chmod 755 /entrypoint ; \
    cd deployment/ubuntu16 && bash bootstrap.sh ; \
    rm -Rf /tmp/bearded-avenger

WORKDIR /root
ENTRYPOINT ["/entrypoint", "-n"]
