-module(piqibench_app).

-behaviour(application).

-export([ensure_all_started/1, start/2, stop/1]).

start(_StartType, _StartArgs) ->
    Defn = {piqibench_impl, piqibench_rpc_piqi_rpc,
        "piqibench", []},
    ok = piqi_rpc:add_service(Defn),
    piqibench_sup:start_link().

stop(_State) ->
    remove_service(piqibench_rpc_piqi_rpc).


%% @doc Remove piqi-rpc service based on Rpc Module
%
% Webmachine changes application environment when removing service, so removing
% a piqi-rpc service in stop call is not possible. Work around that.
-spec remove_service(module()) -> ok.
remove_service(RpcMod) ->
    case lists:keyfind(RpcMod, 2, piqi_rpc:get_services()) of
        ServiceDefn when is_tuple(ServiceDefn) ->
            {Ref, Parent} = {make_ref(), self()},
            spawn(
                fun() ->
                        % This process is designed to be executed when the
                        % application master is stopped. That means group leader
                        % will be dead too. So change it to something more
                        % permanent.
                        erlang:group_leader(whereis(init), self()),
                        Parent ! Ref,
                        erlang:yield(),
                        ok = piqi_rpc:remove_service(ServiceDefn)
                end),
            % Wait until child process changes the group leader before dying.
            receive Ref -> ok end;
        false -> ok
    end.

%% @doc Starts dependencies and Application. Copied from R16B02 OTP application.erl
ensure_all_started(Application) ->
    ensure_all_started(Application, temporary).

ensure_all_started(Application, Type) ->
    case ensure_all_started(Application, Type, []) of
	{ok, Started} ->
	    {ok, lists:reverse(Started)};
	{error, Reason, Started} ->
	    [stop(App) || App <- Started],
	    {error, Reason}
    end.

ensure_all_started(Application, Type, Started) ->
    case application:start(Application, Type) of
	ok ->
	    {ok, [Application | Started]};
	{error, {already_started, Application}} ->
	    {ok, Started};
	{error, {not_started, Dependency}} ->
	    case ensure_all_started(Dependency, Type, Started) of
		{ok, NewStarted} ->
		    ensure_all_started(Application, Type, NewStarted);
		Error ->
		    Error
	    end;
	{error, Reason} ->
	    {error, {Application, Reason}, Started}
    end.
