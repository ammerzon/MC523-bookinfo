# CI/CD with the Istio Bookinfo sample

Final project for the subject MC523 SS21 at FH OÖ Campus Hagenberg based on the Istio sample application [bookinfo](https://github.com/istio/istio/tree/master/samples/bookinfo).

See: <https://istio.io/docs/examples/bookinfo/>

## Build docker images without pushing

```bash
src/build-services.sh <version>
```

The bookinfo versions are different from Istio versions since the sample should work with any version of Istio.

## Update docker images in the yaml files

```bash
sed -i "s/\(istio\/examples-bookinfo-.*\):[[:digit:]]\.[[:digit:]]\.[[:digit:]]/<your docker image with tag>/g" */bookinfo*.yaml
```

## Push docker images to docker hub

One script to build the docker images, push them to docker hub and to update the yaml files

```bash
build_push_update_images.sh <version>
```

## Tests

The Bookinfo e2e test is in [tests/e2e/tests/bookinfo](https://github.com/istio/istio/tree/master/tests/e2e/tests/bookinfo), make target `e2e_bookinfo`.

The reference productpage HTML files are in [tests/apps/bookinfo/output](https://github.com/istio/istio/tree/master/tests/apps/bookinfo/output). If the productpage HTML produced by the app is changed, remember to regenerate the reference HTML files and commit them with the same PR.

## Architecture

The Bookinfo application is broken into four separate microservices:

* **productpage**: The ``productpage`` microservice calls the ``details`` and ``reviews`` microservices to populate the page.
* **details**: The ``details`` microservice contains book information.
* **reviews**: The ``reviews`` microservice contains book reviews. It also calls the ``ratings`` microservice.
* **ratings**: The ``ratings`` microservice contains book ranking information that accompanies a book review.
* **ratings-admin**: The ``ratings-admin`` microservice offers an REST API to maintain the ratings.

![](.github/architecture.png)