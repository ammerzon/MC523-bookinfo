# CI/CD with the Istio Bookinfo sample

Final project for the subject MC523 SS21 at FH OÖ Campus Hagenberg based on the Istio sample application [bookinfo](https://github.com/istio/istio/tree/master/samples/bookinfo).

See: <https://istio.io/docs/examples/bookinfo/>

## 📝 Requirements

- `docker`
- `kubectl`
- `skaffold`

## 🚀 Get started

```bash
skaffold run
```

### Build docker images without pushing

```bash
skaffold build
# or 
src/build-services.sh <version>
```

### Push docker images to Github container registry

```bash
skaffold run
# or
build_push_update_images.sh <version>
```

## ✅ Tests

The Bookinfo e2e test is in [tests/e2e/tests/bookinfo](https://github.com/istio/istio/tree/master/tests/e2e/tests/bookinfo), make target `e2e_bookinfo`.


## 🏗 Architecture

The Bookinfo application is broken into four separate microservices:

* **productpage**: The ``productpage`` microservice calls the ``details`` and ``reviews`` microservices to populate the page.
* **details**: The ``details`` microservice contains book information.
* **reviews**: The ``reviews`` microservice contains book reviews. It also calls the ``ratings`` microservice.
* **ratings**: The ``ratings`` microservice contains book ranking information that accompanies a book review.
* **ratings-admin**: The ``ratings-admin`` microservice offers an REST API to maintain the ratings.

![](.github/architecture.png)