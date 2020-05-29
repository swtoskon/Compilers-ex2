.PHONY: default

default: jvmLang

jvmLang: jvmLang.tab.c
	gcc -o jvmLang jvmLang.tab.c -lfl

jvmLang.lex.c: jvmLang.l
	flex -s -ojvmLang.lex.c jvmLang.l

jvmLang.tab.c: jvmLang.y jvmLang.lex.c jvmLang.h
	bison -v jvmLang.y

cleanWindows: 
	cmd /c erase jvmLang.lex.c  
	cmd /c erase jvmLang.tab.c jvmLang jvmLang.exe jvmLang.output


cleanLinux: 
	rm jvmLang.lex.c 
	rm jvmLang.tab.c jvmLang jvmLang.output



