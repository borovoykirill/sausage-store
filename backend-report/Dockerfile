FROM openjdk:16-jdk-alpine
ARG VERSION=${VERSION}
WORKDIR .

RUN apk --no-cache add curl
RUN curl https://storage.yandexcloud.net/cloud-certs/CA.pem -o YandexInternalRootCA.crt && \
    keytool -importcert -file YandexInternalRootCA.crt -alias yandex -cacerts -storepass changeit -noprompt && \
    rm -f YandexInternalRootCA.crt

RUN addgroup --system jaruser \
    && adduser -S -s /bin/false -G jaruser jaruser -D -H \
    && apk add --no-cache dumb-init==1.2.5-r0

COPY --chown=jaruser:jaruser sausage-store-report*.jar ./sausage-store-report.jar

EXPOSE 8081
USER jaruser
ENTRYPOINT ["dumb-init", "java", "-jar", "./sausage-store-report.jar", "--service.port=8081"]
