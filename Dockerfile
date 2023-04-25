FROM python:3.11.3-alpine3.17
LABEL mantainer="plche.dev"

ENV PYTHONUNBUFFERED 1

COPY ./requirements.txt /tmp/requirements.txt
COPY ./requirements.dev.txt /tmp/requirements.dev.txt

COPY ./ /app
WORKDIR /app
EXPOSE 8000

ARG DEV=false
RUN python -m venv /py_ve && \
    /py_ve/bin/pip install --upgrade pip setuptools wheel && \
    apk add --update --no-cache postgresql-client && \
    apk add --update --no-cache --virtual .tmp-build-deps \
        build-base postgresql-dev musl-dev && \
    /py_ve/bin/pip install -r /tmp/requirements.txt && \
    if [ $DEV = "true" ]; then \
        /py_ve/bin/pip install -r /tmp/requirements.dev.txt; \
    fi && rm -rf /tmp/ && \
    apk del .tmp-build-deps && \
    adduser --disabled-password django-user

ENV PATH="/py_ve/bin:$PATH"

USER django-user
