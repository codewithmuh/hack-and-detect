.PHONY: up attack detect verify fix down

up:      ## Start the vulnerable target
	docker compose up -d --build
	@echo "Target is up. Run 'make attack'."

attack:  ## Run the exploit
	bash attack/exploit.sh

detect:  ## Run the detection against the attack traffic/logs
	bash detect/detect.sh

verify:  ## Grade the lab: PASS/FAIL
	bash verify.sh

down:    ## Tear everything down
	docker compose down -v
