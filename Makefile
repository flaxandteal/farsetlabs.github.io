# Docker parameters
RUN_CONTAINER = fslweb-jekyll-run
RUN_IMAGE =	jekyll/jekyll
RUN_PARAMS =	-t -i
RUN_VOLUMES =	--volume="$(CURDIR):/srv/jekyll"
RUN_PORTS =	-p 0.0.0.0:4000:4000

.PHONY: run
run:
	@EXISTS=$$(docker ps -a | grep "$(RUN_CONTAINER)" | awk '{ print $$1}'); \
	if [ $$EXISTS ]; then \
		echo "Reusing existing run container..."; \
		docker start -t -i $$EXISTS; \
	else \
		echo "Starting a new run container..."; \
		docker run \
		    $(RUN_PARAMS) \
		    $(RUN_PORTS) \
		    $(RUN_VOLUMES) \
		    --name $(RUN_CONTAINER) \
		    $(RUN_IMAGE) \
		    jekyll s; \
	fi

.PHONY: build
build: clean
	docker run \
		$(RUN_PARAMS) --rm \
		$(RUN_PORTS) \
		$(RUN_VOLUMES) \
		$(RUN_IMAGE) \
		jekyll build
	@echo "Built Farset site successfully!"

.PHONY: clean
clean:
	-rm -rf _site/

.PHONY: serve
serve: run
