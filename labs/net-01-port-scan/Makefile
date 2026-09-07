.PHONY: up attack detect verify down

up:      ## Start the sensor target
	docker compose up -d --build
	@echo "Waiting for the sensor to bind its ports..."
	@for i in $$(seq 1 20); do \
	  (exec 3<>/dev/tcp/127.0.0.1/9020) 2>/dev/null && exec 3<&- 3>&- && break; \
	  sleep 1; \
	done
	@echo "Sensor up on 127.0.0.1:9000-9020  ->  run 'make attack'"

attack:  ## Run the port scan + banner grab
	bash attack/exploit.sh

detect:  ## Run the port-scan detection against the sensor log
	bash detect/detect.sh

verify:  ## Grade the lab: PASS/FAIL
	bash verify.sh

down:    ## Tear everything down
	docker compose down -v
