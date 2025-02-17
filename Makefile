.PHONY: lint test

IMAGE_HELM_UNITTEST=docker.io/helmunittest/helm-unittest:3.11.2-0.3.1
IMAGE_CHART_TESTING=quay.io/helmpack/chart-testing:v3.7.1

traefik/tests/__snapshot__:
	@mkdir traefik/tests/__snapshot__

test: traefik/tests/__snapshot__
	docker run ${DOCKER_ARGS} --entrypoint /bin/sh --rm -v $(CURDIR):/charts -w /charts $(IMAGE_HELM_UNITTEST) /charts/hack/test.sh

lint:
	docker run ${DOCKER_ARGS} --env GIT_SAFE_DIR="true" --entrypoint /bin/sh --rm -v $(CURDIR):/charts -w /charts $(IMAGE_CHART_TESTING) /charts/hack/lint.sh

changelog:
	@echo "== Updating Changelogs..."
	@docker run -it --rm -v $(CURDIR):/data ghcr.io/mloiseleur/helm-changelog:v0.0.2
	@./hack/changelog.sh
	@echo "== Updating finished"
