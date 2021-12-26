workspace="build"
$(info workspace: $(workspace))
$(shell mkdir -p $(workspace))

bison="bison";
flex="flex";

all: egg

egg.tab.c egg.tab.h:	egg.y
	cd $(workspace) && bison -t -v -d ../egg.y

lex.yy.c: egg.l egg.tab.h
	cd $(workspace) && flex ../egg.l

egg: lex.yy.c egg.tab.c egg.tab.h
	cd $(workspace) && gcc -o egg egg.tab.c lex.yy.c
	./build/egg

clean:
	rm -rf $(workspace)
