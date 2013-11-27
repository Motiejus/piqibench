-module(piqibench).

-export([start/0]).

-export([get/1]).

-include("piqibench_rpc_piqi.hrl").

%% =============================================================================
%% Application API
%% =============================================================================
start() ->
    piqibench_app:ensure_all_started(?MODULE).

%% =============================================================================
%% Interface shortcuts
%% =============================================================================

get(Pb) when is_binary(Pb) ->
    In = piqibench_rpc_piqi:parse_get_input(Pb),
    {ok, Out} = piqibench_impl:get(In),
    {ok, iolist_to_binary(piqibench_rpc_piqi:gen_get_output(Out))};

get(#piqibench_get_input{} = Input) ->
    piqibench_impl:get(Input).
