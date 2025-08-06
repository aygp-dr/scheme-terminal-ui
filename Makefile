# Guile Scheme Terminal UI Framework Makefile

GUILE = guile
GUILD = guild

# Project metadata
PROJECT_NAME = scheme-terminal-ui
PROJECT_ROOT = $(shell pwd)
VERSION = 0.1.0

# Directories
SRC_DIR = src
EXAMPLES_DIR = examples
TEST_DIR = tests
BUILD_DIR = build
INSTALL_DIR = $(PREFIX)/share/guile/site/$(shell $(GUILE) -c "(display (effective-version))")

# Source files
SOURCES = $(shell find $(SRC_DIR) -name "*.scm" 2>/dev/null || echo "")
COMPILED = $(SOURCES:.scm=.go)

# Default target
.PHONY: all
all: check-deps

# Check dependencies
.PHONY: check-deps
check-deps:
	@echo "Checking dependencies..."
	@$(GUILE) experiments/000-deps-check/check.scm

# Compile source files (when they exist)
.PHONY: compile
compile: $(COMPILED)

%.go: %.scm
	$(GUILD) compile -o $@ $<

# Run examples
.PHONY: run-examples
run-examples: check-deps
	@echo "Running examples..."
	@if [ -d "$(EXAMPLES_DIR)" ]; then \
		for example in $(EXAMPLES_DIR)/*.scm; do \
			if [ -f "$$example" ]; then \
				echo "Running $$example..."; \
				$(GUILE) "$$example"; \
			fi; \
		done; \
	else \
		echo "No examples directory found. Creating basic example..."; \
		$(MAKE) create-example; \
	fi

# Create a basic example
.PHONY: create-example
create-example:
	@mkdir -p $(EXAMPLES_DIR)
	@echo '#!/usr/bin/env guile' > $(EXAMPLES_DIR)/hello.scm
	@echo '!#' >> $(EXAMPLES_DIR)/hello.scm
	@echo ';; Basic Terminal UI Example' >> $(EXAMPLES_DIR)/hello.scm
	@echo '' >> $(EXAMPLES_DIR)/hello.scm
	@echo '(use-modules (ice-9 format))' >> $(EXAMPLES_DIR)/hello.scm
	@echo '' >> $(EXAMPLES_DIR)/hello.scm
	@echo '(define (main)' >> $(EXAMPLES_DIR)/hello.scm
	@echo '  (format #t "Hello from Scheme Terminal UI Framework v$(VERSION)!~%")' >> $(EXAMPLES_DIR)/hello.scm
	@echo '  (format #t "This is a placeholder example.~%"))' >> $(EXAMPLES_DIR)/hello.scm
	@echo '' >> $(EXAMPLES_DIR)/hello.scm
	@echo '(main)' >> $(EXAMPLES_DIR)/hello.scm
	@chmod +x $(EXAMPLES_DIR)/hello.scm
	@echo "Created basic example at $(EXAMPLES_DIR)/hello.scm"

# Run tests
.PHONY: test
test: check-deps
	@echo "Running tests..."
	@if [ -d "$(TEST_DIR)" ]; then \
		for test in $(TEST_DIR)/*.scm; do \
			if [ -f "$$test" ]; then \
				echo "Running test $$test..."; \
				$(GUILE) "$$test"; \
			fi; \
		done; \
	else \
		echo "No tests directory found."; \
	fi

# Clean compiled files
.PHONY: clean
clean:
	@echo "Cleaning compiled files..."
	@find . -name "*.go" -delete 2>/dev/null || true
	@rm -rf $(BUILD_DIR) 2>/dev/null || true

# Install (placeholder for future implementation)
.PHONY: install
install:
	@echo "Install target not yet implemented"
	@echo "This would install to: $(INSTALL_DIR)"

# Uninstall (placeholder for future implementation)
.PHONY: uninstall
uninstall:
	@echo "Uninstall target not yet implemented"

# Development helpers
.PHONY: repl
repl:
	@echo "Starting Guile REPL with project loaded..."
	@$(GUILE)

# Tmux session for development with Emacs
.PHONY: dev-session
dev-session:
	@echo "Starting tmux development session for $(PROJECT_NAME)..."
	@if tmux has-session -t $(PROJECT_NAME) 2>/dev/null; then \
		echo "Session $(PROJECT_NAME) already exists. Attaching..."; \
		tmux attach-session -t $(PROJECT_NAME); \
	else \
		echo "Creating new tmux session $(PROJECT_NAME) with Emacs..."; \
		tmux new-session -d -s $(PROJECT_NAME) -c $(PROJECT_ROOT) "emacs -nw -Q -l $(PROJECT_ROOT)/$(PROJECT_NAME).el"; \
		tmux split-window -h -t $(PROJECT_NAME) -c $(PROJECT_ROOT); \
		tmux send-keys -t $(PROJECT_NAME):0.1 "make repl" Enter; \
		tmux select-pane -t $(PROJECT_NAME):0.0; \
		echo "Session created. Attaching..."; \
		tmux attach-session -t $(PROJECT_NAME); \
	fi

# Get TTY of tmux pane
.PHONY: get-tty
get-tty:
	@if tmux has-session -t $(PROJECT_NAME) 2>/dev/null; then \
		echo "TTY devices for $(PROJECT_NAME) session:"; \
		tmux list-panes -t $(PROJECT_NAME) -F "Pane ##{pane_index}: #{pane_tty}"; \
	else \
		echo "No tmux session '$(PROJECT_NAME)' found."; \
		echo "Run 'make dev-session' to create one."; \
	fi

# Kill tmux session
.PHONY: kill-session
kill-session:
	@if tmux has-session -t $(PROJECT_NAME) 2>/dev/null; then \
		echo "Killing tmux session $(PROJECT_NAME)..."; \
		tmux kill-session -t $(PROJECT_NAME); \
		echo "Session killed."; \
	else \
		echo "No tmux session '$(PROJECT_NAME)' found."; \
	fi

.PHONY: version
version:
	@echo "$(PROJECT_NAME) version $(VERSION)"
	@$(GUILE) --version

# Help target
.PHONY: help
help:
	@echo "Available targets:"
	@echo "  all          - Default target (runs check-deps)"
	@echo "  check-deps   - Check system dependencies"
	@echo "  compile      - Compile source files"
	@echo "  run-examples - Run example applications"
	@echo "  create-example - Create a basic example"
	@echo "  test         - Run test suite"
	@echo "  clean        - Remove compiled files"
	@echo "  install      - Install system-wide (not implemented)"
	@echo "  uninstall    - Remove system installation (not implemented)"
	@echo "  repl         - Start Guile REPL"
	@echo "  dev-session  - Start tmux session with Emacs for development"
	@echo "  get-tty      - Get TTY devices of tmux panes"
	@echo "  kill-session - Kill the development tmux session"
	@echo "  version      - Show version information"
	@echo "  help         - Show this help message"