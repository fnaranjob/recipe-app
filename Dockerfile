FROM python:3.9-alpine3.15
LABEL maintainer="fnbdevtest@gmail.com"

ENV PYTHONUNBUFFERED=1 \
    POETRY_VIRTUALENVS_IN_PROJECT=true \
    POETRY_NO_INTERACTION=1

ARG DEV=false
RUN apk add --no-cache \
        curl \
        gcc \
        libressl-dev \
        musl-dev \
        libffi-dev && \
    curl -sSL https://install.python-poetry.org | python - && \
    apk del \
      curl \
      gcc \
      libressl-dev \
      musl-dev

ENV PATH /root/.local/bin:$PATH

RUN mkdir /app

COPY ./poetry.lock /app
COPY ./pyproject.toml /app
COPY ./recipe_app /app

WORKDIR /app
EXPOSE 8000

RUN if [[ $DEV = "true" ]] ; \
      then poetry install ; \
      else poetry install --no-dev ; \
    fi

