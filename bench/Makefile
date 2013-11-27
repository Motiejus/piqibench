URL ?= http://127.0.0.1:8090/piqibench/get

T ?= 300
C ?= 10
N ?= 1000000

test:
	ab -c $(C) -t $(T) -p ab.xml -T application/xml $(URL)
