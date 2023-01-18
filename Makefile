ROOT_DIR:=./
SRC_DIR:=./src
VENV_BIN_DIR = venv/Scripts

CMD_FROM_VENV = ". $(VENV_BIN_DIR)/activate; which"
PYTHON = $(shell "$(CMD_FROM_VENV)" "python")

PIP = "$(VENV_BIN_DIR)/pip"

define create-venv
python -m venv venv
endef

args = `arg="$(filter-out $@,$(MAKECMDGOALS))" && echo $${arg:-${1}}`

.PHONY: install
install: clean venv

.PHONY: venv
venv:
	@$(create-venv)
	@$(PIP) install -r requirements.txt
	./venv/bin/spacy download en_core_web_sm

check-py:
	$(PYTHON) -m autopep8 --in-place --aggressive --aggressive notebooks/main.py notebooks/num.py

freeze: venv
	@$(PIP) freeze > requirements.txt

run:
	$(PYTHON) ./notebooks/num.py

clean:
	@rm -rf venv

uninstall:
	@python3 -m pip freeze | xargs python3 -m pip uninstall -y
