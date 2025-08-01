FROM openresty/openresty:1.27.1.2-alpine-apk as base

FROM base as buildauth

RUN apk add git
RUN cd /tmp \
  && git clone https://github.com/jkeys089/lua-resty-hmac.git\
  && git clone https://github.com/k8scat/lua-resty-jwt.git\
  && git clone https://github.com/k8scat/lua-resty-http.git\
  && git clone https://github.com/k8scat/lua-resty-feishu-auth.git\
  && cd /usr/local/openresty/lualib/resty\
  && cp -r /tmp/lua-resty-jwt/lib/resty/* ./ \
  && cp -r /tmp/lua-resty-hmac/lib/resty/hmac.lua ./ \
  && cp -r /tmp/lua-resty-http/lib/resty/* ./ \
  && cp -r /tmp/lua-resty-feishu-auth/lib/resty/* ./

FROM base as runner
COPY --from=buildauth /usr/local/openresty/lualib/resty /usr/local/openresty/lualib/resty
ADD nginx.conf /usr/local/openresty/nginx/conf/nginx.conf
ADD public /var/www/html