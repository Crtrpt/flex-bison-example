workspace="build"
$(info workspace: $(workspace))
$(shell mkdir -p $(workspace))

bison="bison";
flex="flex";

all: monkey

monkey.tab.c monkey.tab.h:	monkey.y
	cd $(workspace) && bison -t -v -d ../monkey.y

lex.yy.c: monkey.l monkey.tab.h
	cd $(workspace) && flex ../monkey.l

monkey: lex.yy.c monkey.tab.c monkey.tab.h
	cd $(workspace) && gcc -o monkey monkey.tab.c lex.yy.c
	./build/monkey

clean:
	rm -rf $(workspace)
