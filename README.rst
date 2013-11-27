ROAR for labels
===============

Piqi-rpc benchmark application. This takes two numbers: a, b, and returns their
sum.


REQUIREMENTS
------------

1. At least Erlang R15B.
2. ``piqi`` binary in ``$PATH``.
3. ``rebar`` in ``$PATH``.

User guide
----------

1. Clone
2. ``make``
3. ``make go``
4. Talk to it::

    curl -H 'Content-Type: application/json' \
        --data '{"a":1, "b":2}' \
        http://127.0.0.1:8090/piqibench/get
    {"sum": 3}

