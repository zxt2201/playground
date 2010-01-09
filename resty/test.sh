#!/bin/bash

set -x
curl http://localhost:8888/resty/hello
curl http://localhost:8888/resty/hello/
curl http://localhost:8888/resty/java
curl http://localhost:8888/resty/java/
curl http://localhost:8888/resty/java/scala
curl http://localhost:8888/resty/scala
curl http://localhost:8888/resty/scala/
curl http://localhost:8888/resty/scala/java
curl http://localhost:8888/resty/scala/user/1
curl http://localhost:8888/resty/scala/user/2
curl http://localhost:8888/resty/scala/user/1/
curl http://localhost:8888/resty/scala/user/2/
