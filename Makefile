PACKAGE="Pulla"
PACKAGE_LOWER=$(shell echo $(PACKAGE) | sed 's/.*/\L&/')
VERSION = $(shell python -c 'import $(PACKAGE_LOWER); print($(PACKAGE_LOWER).__version__)')
TEST_FILES = $(wildcard tests/test_*.py)
TESTS = $(subst .py,,$(subst /,.,$(TEST_FILES)))

all.PHONY: nosetests_3 nosetests_2

nosetests_2:
	@echo "Running python2 tests"
	@python2.7 `which nosetests`

nosetests_3:
	@echo "Running python3 tests"
	@python3 `which nosetests`

install:
	@echo "Creating distribution package for version $(VERSION)"
	@echo "-----------------------------------------------"
	python setup.py sdist
	@echo "Installing package using pip"
	@echo "----------------------------"
	pip install --upgrade dist/$(PACKAGE)-$(VERSION).tar.gz

coverage:
	@coverage run `which nosetests`
	@coverage report

test:
	@- $(foreach TEST,$(TESTS), \
		echo === Running test: $(TEST); \
		python -m $(TEST) $(PYFLAGS); \
		)

test2:
	@- $(foreach TEST,$(TESTS), \
		echo === Running python2 test: $(TEST); \
		python2 -m $(TEST) $(PYFLAGS); \
		)
test3:
	@- $(foreach TEST,$(TESTS), \
		echo === Running python3 test: $(TEST); \
		python3 -m $(TEST) $(PYFLAGS); \
		)
