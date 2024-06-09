docker build -t soul-mask-docker .
docker tag soul-mask-docker keepprogress/soul-mask-docker:latest
docker push keepprogress/soul-mask-docker:latest
