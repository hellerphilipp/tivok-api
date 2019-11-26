FROM swift:5.1 as builder
RUN apt-get -qq update && apt-get install -y libssl-dev libicu-dev \
  && rm -r /var/lib/apt/lists/*
WORKDIR /api
COPY . .
RUN mkdir -p /build/lib && cp -R /usr/lib/swift/linux/*.so /build/lib
RUN swift build -c release && mv `swift build -c release --show-bin-path` /build/bin
RUN chmod -R 755 /build/bin

# Production image
# Wanted to use Ubuntu:18.04 with libicu60 libxml2 libbsd0 libcurl3 libatomic1 tzdata, but libicui18nswift caused troubles
FROM swift:5.1
RUN apt-get -qq update && apt-get install -y postgresql-client \
  && rm -r /var/lib/apt/lists/*
WORKDIR /api
COPY --from=builder /build/bin/tivok-api .
COPY --from=builder /build/lib /usr/lib
COPY pg_health.sh .
RUN chmod +x pg_health.sh
EXPOSE 23450
ENTRYPOINT ./pg_health.sh
