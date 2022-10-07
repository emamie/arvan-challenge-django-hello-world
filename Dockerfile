FROM python:3.8

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

RUN set -e; \
    apt-get update; \
    mkdir /www; \ 
    cd /www && \
    # get only requirements.txt
#    curl --user $USERNAME:$PERSONALACCESSTOKEN -o requirements.txt https://bitbucket.itc.razavi.ir/projects/SOFT/repos/ghesmat/raw/requirements.txt?at=refs/heads/master && \
    curl --user $USERNAME:$PERSONALACCESSTOKEN -o requirements.txt https://bitbucket.itc.razavi.ir/projects/SOFT/repos/ghesmat/raw/requirements.txt?at=$BRANCH && \
    cat requirements.txt  && \

    # install uwsgi / ipython
    pip3 install -r requirements.txt uwsgi ipython && \
    pip3 freeze && \

    # cleanup
    apt-get purge -y --autoremove libpq-dev libpcre3-dev && \
    rm -rf /root/.cache  /var/lib/apt/lists/* /tmp/*

ARG CODE_ONLY_REVISION
RUN set -x && \
    # clone ghesmat repo
    cd /app && git clone https://$USERNAME:$PERSONALACCESSTOKEN@bitbucket.itc.razavi.ir/scm/soft/ghesmat.git --depth 1 -b $BRANCH && \
    # generate .mo files
    python3 /app/ghesmat/manage.py compilemessages && \
    # static files
    python3 /app/ghesmat/manage.py collectstatic --no-input

VOLUME /etc/ghesmat.ini
VOLUME /etc/ghesmat.yml
ENV GHESMAT_CONFIG=/etc/ghesmat.yml

EXPOSE 9001

ENTRYPOINT ["/usr/bin/dumb-init", "-cv"]

CMD ["gosu", "daemon", "uwsgi", "--die-on-term", "--ini", "/app/ghesmat/uwsgi.ini", "--ini", "/etc/ghesmat.ini"]
WORKDIR /app/ghesmat/
