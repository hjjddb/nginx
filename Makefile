PROJECT_PATH=$(shell pwd)
version=1.25.3
image=nginx
container=nginx
http_port=5080
https_port=5081

.PHONY: all
all: deploy

.PHONY: remove-container
remove-container:
	-docker rm -f $(container)

.PHONY: build
build:
	docker build \
	-t $(image):$(version) \
	-t $(image) \
	$(PROJECT_PATH)

.PHONY: deploy
deploy: remove-container build
	docker run \
	--name $(container) \
	-p $(http_port):80 \
	-p $(https_port):443 \
	-v $(PROJECT_PATH)/configs/default.conf:/etc/nginx/conf.d/default.conf \
	-v $(PROJECT_PATH)/configs/nginx.conf:/etc/nginx/nginx.conf \
	-d \
	$(image)

.PHONY: git-push
git-push:
	@for remote in $$(git remote); do \
		echo "Pushing to $$remote"; \
        git push $$remote; \
	done