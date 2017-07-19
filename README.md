# Latest Version: 3.0.0a22 (tag: 3.0.0a5 = new deploymentkit)
CIFv3 Ubuntu 16.04 Docker Container (Bearded Avenger)

https://github.com/csirtgadgets/bearded-avenger-deploymentkit/wiki

https://github.com/csirtgadgets/bearded-avenger-deploymentkit/releases

# How to run CIFv3 Docker Container?
```
C=$(docker run --name cifv3 -it -d \
-p 443:443 \
-p 5000:5000 \
ventz/docker-cif)
```

# Get an interactive shell onto the container:
```
docker exec -it $C /bin/bash
```

# Test Setup
Once you have a shell, become the cif user:
```
# su cif
```

and do a sanity check to verify that everything works:
```
$ cif -p
```

You can do this as "root" too, but it's not recommended.

For a full suite of tests, you can also run:
```
/root/test.sh
```



# Docker Volumes/Overrides
```
Configuration Data:
/etc/cif
```

```
Log Files:
/var/log/cif
```

```
SQLite DB:
/var/lib/cif
```

# Docker Maintainer:

Ventz Petkov <ventz@vpetkov.net>

# COPYRIGHT AND LICENSE

Copyright (C) 2017 [the CSIRT Gadgets Foundation](http://csirtgadgets.org)

See: [LICENSE](https://github.com/ventz/docker-cif/blob/master/LICENSE)
