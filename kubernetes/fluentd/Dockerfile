FROM fluent/fluentd:v1.12.4-debian-1.0
USER root
RUN apt-get update && apt-get install -y --no-install-recommends gettext && \
    fluent-gem install fluent-plugin-s3 --no-document && \
    apt-get clean && rm -rf /var/lib/apt/lists/*
