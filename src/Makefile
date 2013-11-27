ifdef REBAR_DEPS_DIR
	DEPS_DIR ?= $(REBAR_DEPS_DIR)
else
	DEPS_DIR ?= ../deps
endif

export PATH := ${PATH}:${DEPS_DIR}/piqi/priv/bin
export PATH := ${PATH}:${DEPS_DIR}/piqi_rpc/priv/bin
export ERL_LIBS := ${DEPS_DIR}

piqibench_RPC = piqibench_rpc_piqi.erl \
				piqibench_rpc_piqi_rpc.erl \
				../include/piqibench_rpc_piqi.hrl

PIQI_ALL = $(piqibench_RPC)
PIQI_ARG = -I ../priv --normalize-names false

.PHONY: all clean

all: $(PIQI_ALL)

$(piqibench_RPC): ../priv/piqibench-rpc.piqi
	piqic-erlang-rpc $(PIQI_ARG) $<
	rm piqibench_rpc_piqi_impl.hrl
	rm piqibench_rpc_piqi_default_impl.erl
	mv piqibench_rpc_piqi.hrl ../include

clean:
	rm -f $(PIQI_ALL)
