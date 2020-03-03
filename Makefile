# PROTO_FILES is a space separated list of Protocol Buffers files.
PROTO_FILES += $(shell PATH="$(PATH)" git-find '*.proto')

# PROTO_INCLUDE_PATHS is a space separate list of include paths to use when
# building the .proto files from this repository.
PROTO_INCLUDE_PATHS += .

################################################################################

# This Makefile provides the recipes used to build each language's source files
# from the .proto files, but it does NOT automatically add these source files to
# the GENERATED_FILES list. This is the responsibility of each language-specific
# Makefile; otherwise any project that included the protobuf Makefile would
# attempt to build source files for every supported language.

%.pb.go: %.proto artifacts/protobuf/bin/protoc-gen-go
	PATH="$(MF_PROJECT_ROOT)/artifacts/protobuf/bin:$$PATH" protoc \
		--go_out=paths=source_relative,plugins=grpc:. \
		$(addprefix --proto_path=,$(PROTO_INCLUDE_PATHS)) \
		$(@D)/*.proto

artifacts/protobuf/bin/protoc-gen-go: go.mod
	GOBIN="$(MF_PROJECT_ROOT)/artifacts/protobuf/bin" go get github.com/golang/protobuf/protoc-gen-go
