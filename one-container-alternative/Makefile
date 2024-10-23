build:
	docker build --target app_setup --platform linux/$$(uname -m | sed 's/arm64/arm64/g' | sed 's/x86_64/amd64/g') -t yangsuite-one-container .

run:
	$(MAKE) clean
	docker run -itd --rm --name yangsuite-one-container -v yangsuite-one-container-data:/ys-data -p 80:80 -p 443:443 -p 3000:3000 -p 8080:8080 -p 8086:8086 -p 8443:8443 -p 8480:8480 -p 9339:9339 -p 50052:50052 -p 50051:50051 -p 57344:57344 -p 57345:57345 -u developer yangsuite-one-container

clean: 
	docker rm -f yangsuite-one-container

clean-volumes:
	docker volume rm yangsuite-one-container-data

follow:
	docker logs --follow yangsuite-one-container

cli:
	docker exec -it yangsuite-one-container /bin/bash