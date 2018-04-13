## Running marvambass/apache2-ssl-secure Container

This Dockerfile is not really made for direct usage. It should be used as base-image for your apache2 project. But you can run it anyways.

You should overwrite the _/etc/apache2/external/_ with a folder, containing your apache2 __\*.conf__ files (VirtualHosts etc.), certs and a __dh.pem__.   
_If you forget the dh.pem file, it will be created at the first start - but this can/will take a long time!_

    docker run -d \
    -p 80:80 -p 443:443 \
    -v $EXT_DIR:/etc/apache2/external/ \
    marvambass/apache2-ssl-secure

## Based on

This Dockerfile is based on the [/_/ubuntu:14.04/](https://registry.hub.docker.com/_/ubuntu/) Official Image.
