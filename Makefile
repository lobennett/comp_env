# 
# PURPOSE: Makefile for podman, support rootless mode
# 
# DESC: Uses podman to build images and push them to a remote registry
# The images are built from the containerfile directory and extend the base image
# The base image is defined in the base.cf file
# The py_env image is used to create an environment with uv and contains python
# packages that are commonly used in the Poldrack Lab.
# 
# ACKNOWLEDGEMENTS: The structure of this repository was largely inspired by
# Paul Nuyujukian's comp-env repository, which can be found here:
# https://code.stanford.edu/bil-public/comp-env/-/tree/main?ref_type=heads

IMAGES = base py_env py_r
TARGET = py_r

# Load the environment variables from the .env file
-include .env
DST ?= $(CE_DST)
PAT ?= $(CE_PAT)

all: $(IMAGES)

$(IMAGES):
	podman build --format docker -t $@ -f $@.cf --build-arg SETUP_SCRIPT=src/setup.sh ./containerfile

github-login:
	echo $(PAT) | podman login ghcr.io -u $(GITHUB_USER) --password-stdin

push-prod: github-login
	podman tag $(TARGET) $(DST)/$(TARGET)
	podman push --remove-signatures $(DST)/$(TARGET)

push-dev: github-login
	podman tag $(TARGET) $(DST)/$(TARGET)-dev
	podman push --remove-signatures $(DST)/$(TARGET)-dev

prune:
	podman image prune -f
