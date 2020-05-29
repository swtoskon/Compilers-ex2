/* 
Grammar with semantics and type checking.
Lexical Analyser
*/

%{
#include <stdlib.h>
#include <string.h>

int line = 1;
%}

D [0-9]
LETTER [a-zA-Z]
VARIABLE {LETTER}({LETTER}|{D})*
FLOAT {D}+\.{D}*
newline \n|\x0A|\x0D\x0A
%%
"program" {return T_program;}
"end_program" {return T_end_program;}
"print" {return T_print;}

"+" {return '+';}
"++" {return T_inc;}
"*" {return '*';}
"(" {return '(';}
")" {return ')';}
 
{D}+ {yylval.se.info = strdup(yytext); yylval.se.type = type_integer; return T_num;}
{FLOAT} {yylval.se.info = strdup(yytext); yylval.se.type = type_real; return T_real;}
{VARIABLE} {yylval.id = strdup(yytext); return T_id;}


{newline}  {line++;}
[ \t] { /* nothing */ }
. { 
	printf("Lexical Analysis: Unexpected String! :: %s. in line %d. \n",yytext,line); }
	
%%
