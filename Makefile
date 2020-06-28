.PHONY: build check-aws check-dev check-env check-project clean deploy help invalidate serve sync

ifneq (,$(wildcard .env))
	include .env
	export
endif

default: help

help:
	@echo "Makefile commands:"
	@echo ""
	@echo "- 'make check-aws' - Ensure required AWS variables are set."
	@echo "- 'make check-dev' - Ensure required development variables are set."
	@echo "- 'make check-env' - Ensure required environment variables are set."
	@echo "- 'make check-project' - Ensure required project variables are set."
	@echo "- 'make clean' - Remove build artifacts."
	@echo "- 'make deploy' - Deploy to Production."
	@echo "- 'make help' - Display list of available commands."
	@echo "- 'make invalidate' - Invalidate Cloudfront caches."
	@echo "- 'make serve' - Serve blog locally."
	@echo "- 'make sync' - Sync to S3."

build: clean
	@echo "Running: hugo"
	@hugo

check-env: check-aws check-dev check-project

check-aws:
ifndef AWS_CLOUDFRONT_DISTRIBUTION_ID
	$(error AWS_CLOUDFRONT_DISTRIBUTION_ID is undefined)
endif
ifndef AWS_PROFILE
	$(error AWS_PROFILE is undefined)
endif
ifndef AWS_S3_BUCKET_ID
	$(error AWS_S3_BUCKET_ID is undefined)
endif

check-dev:
ifndef DEVELOPMENT_BASE_URL
	$(error DEVELOPMENT_BASE_URL is undefined)
endif
ifndef DEVELOPMENT_BIND_INTERFACE
	$(error DEVELOPMENT_BIND_INTERFACE is undefined)
endif

check-project:
ifndef PROJECT_WEBROOT
	$(error PROJECT_WEBROOT is undefined)
endif

clean: check-project
	@echo "Removing built artifacts"
	@rm -rf "$$PROJECT_WEBROOT"
	@find . -type f -name .DS_Store -delete

deploy: build sync invalidate

invalidate: check-aws
	@echo "Running: aws cloudfront create-invalidation"
	@aws cloudfront create-invalidation --paths '/*' --distribution-id $$AWS_CLOUDFRONT_DISTRIBUTION_ID --profile $$AWS_PROFILE

serve: check-dev clean
	@echo "Serving blog locally"
	@hugo serve --bind "$$DEVELOPMENT_BIND_INTERFACE" -D -b "$$DEVELOPMENT_BASE_URL"

sync: check-aws check-project
	@echo "Running: aws s3 sync"
	@aws s3 sync $$PROJECT_WEBROOT s3://$$AWS_S3_BUCKET_ID/ --profile $$AWS_PROFILE

# https://stackoverflow.com/a/6273809/1826109
%:
	@:
