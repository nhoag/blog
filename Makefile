.PHONY: build check-env clean deploy help invalidate serve sync

include .env
export

default: help

help:
	@echo "Makefile commands:"
	@echo ""
	@echo "- 'make check-env' - Ensure required variables are set."
	@echo "- 'make clean' - Remove build artifacts."
	@echo "- 'make deploy' - Deploy to Production."
	@echo "- 'make help' - Display list of available commands."
	@echo "- 'make invalidate' - Invalidate Cloudfront caches."
	@echo "- 'make serve' - Serve blog locally."
	@echo "- 'make sync' - Sync to S3."

build: clean
	@echo "Running: hugo"
	@hugo

check-env:
ifndef AWS_CLOUDFRONT_DISTRIBUTION_ID
	$(error AWS_CLOUDFRONT_DISTRIBUTION_ID is undefined)
endif
ifndef AWS_PROFILE
	$(error AWS_PROFILE is undefined)
endif
ifndef AWS_S3_BUCKET_ID
	$(error AWS_S3_BUCKET_ID is undefined)
endif
ifndef DEVELOPMENT_BASE_URL
	$(error DEVELOPMENT_BASE_URL is undefined)
endif
ifndef DEVELOPMENT_BIND_INTERFACE
	$(error DEVELOPMENT_BIND_INTERFACE is undefined)
endif
ifndef DEVELOPMENT_WEBROOT
	$(error DEVELOPMENT_WEBROOT is undefined)
endif

clean: check-env
	@echo "Removing built artifacts"
	@rm -rf "$$DEVELOPMENT_WEBROOT"
	@find . -type f -name .DS_Store -delete

deploy: build sync invalidate

invalidate: check-env
	@echo "Running: aws cloudfront create-invalidation"
	@aws cloudfront create-invalidation --paths '/*' --distribution-id $$AWS_CLOUDFRONT_DISTRIBUTION_ID --profile $$AWS_PROFILE

serve: check-env clean
	@echo "Serving blog locally"
	@hugo serve --bind "$$DEVELOPMENT_BIND_INTERFACE" -D -b "$$DEVELOPMENT_BASE_URL"

sync: check-env
	@echo "Running: aws s3 sync"
	@aws s3 sync $$DEVELOPMENT_WEBROOT s3://$$AWS_S3_BUCKET_ID/ --profile $$AWS_PROFILE

# https://stackoverflow.com/a/6273809/1826109
%:
	@:
