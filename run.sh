#!/bin/bash
C=$(docker run --name cifv3 -it -d -p 443:443 -p 5000:5000 ventz/docker-cif)

echo "Getting a shell into the container..."
docker exec -it $C /bin/bash
