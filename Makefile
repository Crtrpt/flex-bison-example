workspace="build"
$(info workspace: $(workspace))
$(shell mkdir -p $(workspace))

all: calc

calc.tab.c calc.tab.h:	calc.y
	cd $(workspace) && win_bison -t -v -d ../calc.y

lex.yy.c: calc.l calc.tab.h
	cd $(workspace) && win_flex ../calc.l

calc: lex.yy.c calc.tab.c calc.tab.h
	cd $(workspace) && gcc -o calc calc.tab.c lex.yy.c
	build\calc.exe

clean:
	rm -rf $(workspace)
