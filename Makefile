
.PHONY: all quick test clean release go
all:
	rebar get-deps compile

quick:
	rebar compile skip_deps=true

test:
	rebar eunit skip_deps=true

clean:
	rebar clean

release:
	rebar generate

go:
	erl -config rel/files/sys -pz ebin deps/*/ebin -s piqibench
