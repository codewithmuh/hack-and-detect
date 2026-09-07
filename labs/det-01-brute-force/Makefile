.PHONY: up attack detect verify down

up:      ## Start the login service
	docker compose up -d --build
	@echo "Waiting for target to be healthy..."
	@for i in $$(seq 1 20); do \
	  curl -sf http://127.0.0.1:8080/healthz >/dev/null 2>&1 && break; \
	  sleep 1; \
	done
	@echo "Target up at http://127.0.0.1:8080  ->  run 'make attack'"

attack:  ## Brute-force the admin login
	bash attack/exploit.sh

detect:  ## Run the brute-force detection against the auth log
	bash detect/detect.sh

verify:  ## Grade the lab: PASS/FAIL
	bash verify.sh

down:    ## Tear everything down
	docker compose down -v
