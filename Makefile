.PHONY: generate clean

# Paths
PROTO_DIR := proto
OUT_DIR := gen

# Go output
GO_OUT := $(OUT_DIR)/go

# Swagger/OpenAPI output
SWAGGER_OUT := $(OUT_DIR)/swagger

# Protoc plugins (installed via go install)
PROTOC_GEN_GO := protoc-gen-go
PROTOC_GEN_GO_GRPC := protoc-gen-go-grpc
PROTOC_GEN_GATEWAY := protoc-gen-grpc-gateway
PROTOC_GEN_OPENAPIV2 := protoc-gen-openapiv2

# Only your service proto files (excludes third_party)
PROTO_FILES := $(shell find $(PROTO_DIR) -name "*.proto" -not -path "*/third_party/*")

generate: $(PROTO_FILES)
	@echo "Generating Go gRPC code..."
	protoc \
		-I=$(PROTO_DIR) \
		-I=$(PROTO_DIR)/third_party \
		--go_out=$(GO_OUT) \
		--go_opt=paths=source_relative \
		--go-grpc_out=$(GO_OUT) \
		--go-grpc_opt=paths=source_relative \
		--grpc-gateway_out=$(GO_OUT) \
		--grpc-gateway_opt=paths=source_relative \
		--grpc-gateway_opt=generate_unbound_methods=true \
		--openapiv2_out=$(SWAGGER_OUT) \
		--openapiv2_opt=logtostderr=true \
		$(PROTO_FILES)

	@echo "Generation complete."

clean:
	rm -rf $(OUT_DIR)
	@echo "Cleaned generated files."

install-tools:
	go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	go install google.golang.org/grpc/cmd/protoc-gen-go-grpc@latest
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-grpc-gateway@latest
	go install github.com/grpc-ecosystem/grpc-gateway/v2/protoc-gen-openapiv2@latest
