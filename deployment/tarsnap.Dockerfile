FROM ubuntu

RUN apt-get update && apt-get install -y --no-install-recommends cron curl ca-certificates gnupg lsb-release
# https://www.tarsnap.com/pkg-deb.html
RUN curl -OL https://pkg.tarsnap.com/tarsnap-deb-packaging-key.asc && apt-key add tarsnap-deb-packaging-key.asc
RUN echo "deb http://pkg.tarsnap.com/deb/$(lsb_release -s -c) ./" | tee -a /etc/apt/sources.list.d/tarsnap.list
RUN apt-get update && apt-get install -y --no-install-recommends tarsnap

# https://stackoverflow.com/a/37458519
COPY deployment/tarsnap.cron /etc/cron.d/tarsnap.cron
RUN chmod 0644 /etc/cron.d/tarsnap.cron

CMD cron && touch /tmp/tarsnap-stdout.log /tmp/tarsnap-stderr.log && tail -f /tmp/tarsnap-stdout.log /tmp/tarsnap-stderr.log