# http://clarkgrubb.com/makefile-style-guide

MAKEFLAGS += --warn-undefined-variables --no-print-directory
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.DEFAULT_GOAL := test
.DELETE_ON_ERROR:
.SUFFIXES:

$(eval NAME := $(shell python setup.py --name))
$(eval PY_NAME := $(shell python setup.py --name | sed 's/-/_/g'))
$(eval VERSION := $(shell python setup.py --version))

SOURCE := $(shell find bin libfaketimefs_ctl -type f) setup.py
SDIST := dist/$(NAME)-$(VERSION).tar.gz
WHEEL := dist/$(PY_NAME)-$(VERSION)-py2.py3-none-any.whl

$(SDIST): $(SOURCE)
	python setup.py sdist

$(WHEEL): $(SOURCE)
	python setup.py bdist_wheel

.PHONY: test
test:
	python -m doctest libfaketimefs_ctl/__init__.py
	flake8 bin/libfaketimefs-ctl libfaketimefs_ctl/__init__.py setup.py

.PHONY: build
build: $(SDIST) $(WHEEL)

.PHONY: upload
upload: $(SDIST) $(WHEEL)
	twine upload $(SDIST) $(WHEEL)

.PHONY: clean
clean:
	rm -rf build dist *.egg-info
