MAKEFLAGS=--no-builtin-rules --no-builtin-variables --always-make
ROOT := $(realpath $(dir $(lastword $(MAKEFILE_LIST))))

gen:
	npx apollo service:download --endpoint=https://works-api.akiho.app/graphql ./Works/Infra/GraphQL/schema.json
	npx apollo client:codegen ./Works/Infra/GraphQL/API.swift --target=swift --queries=./Works/Infra/GraphQL/app.graphql --localSchemaFile=./Works/Infra/GraphQL/schema.json --namespace=GraphQL