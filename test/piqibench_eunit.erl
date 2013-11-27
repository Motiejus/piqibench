-module(piqibench_eunit).

-include_lib("eunit/include/eunit.hrl").
-include_lib("piqibench_rpc_piqi.hrl").

simple_get_test_() ->
    {setup,
        fun() ->
                error_logger:tty(false),
                application:load(piqibench),
                application:start(piqibench)
        end,
        fun(_) -> application:stop(piqibench) end,
        [
            {"get: native over pb", fun pb_get/0}
        ]
    }.


pb_get() ->
    Q = #piqibench_get_input{a=1, b=2},
    In = iolist_to_binary(piqibench_rpc_piqi:gen_get_input(Q)),
    {ok, Ret} = piqibench:get(In),
    Resp = piqibench_rpc_piqi:parse_get_output(Ret),
    ?assertEqual(#piqibench_get_output{sum=3}, Resp).
