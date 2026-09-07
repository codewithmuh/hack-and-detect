.PHONY: up attack detect verify down

up:      ## Start the vulnerable target
	docker compose up -d --build
	@echo "Waiting for target to be healthy..."
	@for i in $$(seq 1 20); do \
	  curl -sf http://127.0.0.1:8080/healthz >/dev/null 2>&1 && break; \
	  sleep 1; \
	done
	@echo "Target up at http://127.0.0.1:8080  ->  run 'make attack'"

attack:  ## Run the XSS exploit
	bash attack/exploit.sh

detect:  ## Run the detection against the attack logs
	bash detect/detect.sh

verify:  ## Grade the lab: PASS/FAIL
	bash verify.sh

down:    ## Tear everything down
	docker compose down -v
