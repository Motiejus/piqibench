-module(piqibench_impl).
-export([get/1]).

-include_lib("piqibench_rpc_piqi.hrl").

-spec get(piqibench_get_input()) -> {ok, piqibench_get_output()}.
get(#piqibench_get_input{a=A, b=B}) ->
    {ok, #piqibench_get_output{sum=A + B}}.
