FROM nginx:1.21.6-alpine
ARG VERSION=${VERSION}
WORKDIR .
RUN rm /etc/nginx/conf.d/default.conf
COPY sausage-store-${VERSION}/public_html /usr/share/nginx/html
##COPY ./sausage.conf /etc/nginx/conf.d/sausage.conf
EXPOSE 80
