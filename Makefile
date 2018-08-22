.PHONY: chef-server test testacc repl env dep
CHEF_KEY_FILE="admin.pem"
CHEF_KEY_MATERIAL=`cat $(CHEF_KEY_FILE)`
CHEF_SERVER_URL="https://chef-server:444/organizations/my_org/"
CHEF_CLIENT_NAME="admin"
CHEF_VERIFY_SSL="1"
VERSION_FILE=VERSION
VERSION=`cat $(VERSION_FILE)`
TEST?=./...
CURRENT_REV=`git rev-parse --short HEAD`

dep:
	@dep ensure -v || echo "dep failed or is missing. Try `brew install dep`"

vet:
	@go vet $(go list ./... | grep -v /vendor/)

.hostmap:
	@set -xe; \
		ping -c 1 chef-server 

chef-server: .hostmap
	@docker-compose up -d --force-recreate
	@/bin/sh -c "./chef-server-wait.sh"
	@bundle check || bundle --quiet
	@bundle exec knife ssl fetch -c ./config.rb -V

stop:
	@docker-compose down
	@rm -rf trusted_certs/

testacc:
	@ACC=1 \
		CHEF_SERVER_URL=$(CHEF_SERVER_URL) \
		CHEF_CLIENT_NAME=$(CHEF_CLIENT_NAME) \
		CHEF_KEY_MATERIAL=$(CHEF_KEY_MATERIAL) \
		go test $(TEST) -v $(TESTARGS)

test:
	@go test $(TEST) $(TESTARGS)

repl:
	@CHEF_SERVER_URL=$(CHEF_SERVER_URL) \
		CHEF_CLIENT_NAME=$(CHEF_CLIENT_NAME) \
		CHEF_KEY_MATERIAL=$(CHEF_KEY_MATERIAL) \
		gore

env:
	@echo export CHEF_KEY_MATERIAL="\`cat admin.pem\`"
	@echo export CHEF_CLIENT_NAME=admin
	@echo export CHEF_SERVER_URL=$(CHEF_SERVER_URL)
