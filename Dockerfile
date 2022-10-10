FROM python:3.8

ENV LC_ALL=C.UTF-8 LANG=C.UTF-8

ADD ./ /app

WORKDIR /app

RUN set -e; \
    apt-get update; \
    cd /app; \
    python -m venv env; \
    pip install -r requirements.txt; \
    # cleanup
    apt-get purge -y --autoremove; \
    rm -rf /root/.cache  /var/lib/apt/lists/* /tmp/*;

EXPOSE 9000

CMD ["python", "manage.py", "runserver","0.0.0.0:9000"]
