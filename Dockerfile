FROM python:3.8-alpine as builder

RUN apk --no-cache add g++ zeromq-dev libffi-dev file make gcc musl-dev
COPY . /src
WORKDIR /src
RUN pip install .

FROM python:3.8-alpine

RUN apk --no-cache add zeromq && adduser -s /bin/false -D locust
COPY --from=builder /usr/local/lib/python3.8/site-packages /usr/local/lib/python3.8/site-packages
COPY --from=builder /usr/local/bin/locust /usr/local/bin/locust

EXPOSE 8089 5557

USER locust
ENTRYPOINT ["locust"]

# turn off python output buffering
ENV PYTHONUNBUFFERED=1
