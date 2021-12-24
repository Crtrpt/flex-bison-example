workspace="build"
$(info workspace: $(workspace))
$(shell mkdir -p $(workspace))

all: egg

egg.tab.c egg.tab.h:	egg.y
	cd $(workspace) && win_bison -t -v -d ../egg.y

lex.yy.c: egg.l egg.tab.h
	cd $(workspace) && win_flex ../egg.l

egg: lex.yy.c egg.tab.c egg.tab.h
	cd $(workspace) && gcc -o egg egg.tab.c lex.yy.c

clean:
	rm -rf $(workspace)
