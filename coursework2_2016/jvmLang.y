%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sglib.h"
/* Just for being able to show the line number were the error occurs.*/
extern int line;
extern FILE *yyout;

#define PARSER
#include "expr.h"
#undef PARSER


#define TYPEDESCRIPTOR(TYPE) ((TYPE == type_integer) ? "I" : "F")
#define ERR_VAR_DECL(VAR,LINE) printf("Variable :: %s on line %d. ",VAR,LINE); yyerror("Var already defined")
#define ERR_VAR_MISSING(VAR,LINE) printf("Variable %s NOT declared, on line %d.",VAR,LINE); yyerror("Variable Declation fault")

int current_stack_value = 1;

int addvar(char *,ParType);
ParType typeDefinition(ParType, ParType);
int lookup(char *);
ParType lookup_type(char *);
void create_preample(char *);
void printType(ParType );
int lookup_position(char *VariableName);


ST_TABLE symbolTable;
%}
/* Output informative error messages (bison Option) */
%error-verbose

/* Declaring the possible types of Symbols*/
%union{
    char * id;
    struct {
        char *info;
        ParType type;} se;
}


/* Token declarations and their respective types */

%token <se> T_num
%token <se> T_real
%token <id> T_id
%token T_inc
%token '('
%token ')'

%token T_program "program"
%token T_end_program "end_program"
%token T_print "print"

/* The type of non-terminal symbols*/
%type<se> expr
%type <se> asmt
%type <se> printcmd


%left '+'
%left '*'


%%

program: "program" T_id {create_preample($2);symbolTable=NULL; }
			 stmts "end_program"
            {fprintf(yyout,"return \n.end method\n\n");}

	;

stmts:  stmt  {/* nothing */}
     	|  stmt  stmts 	{/* nothing */}
	;

stmt: asmt	{/* nothing */}
	| printcmd {/* nothing */}
	;

printcmd: '(' "print" expr ')'
{$$.type=$3.type;fprintf(yyout,"getstatic java/lang/System/out Ljava/io/PrintStream;\n");
fprintf(yyout,"swap\n");
fprintf(yyout,"invokevirtual java/io/PrintStream/println(%s)V\n", TYPEDESCRIPTOR($$.type) ) ;}
	;


asmt: '(' T_id expr ')'
{if (!addvar($2,$3.type)){ERR_VAR_DECL($2,line);}
		$$.type = typeDefinition(lookup_type($2), $3.type);
        printType($3.type);fprintf(yyout,"store %d\n",lookup_position($2));
		}
	;



expr:  T_num 		{$$.type = type_integer;int x;x=atoi($1.info);x<=5? fprintf(yyout,"iconst_%d\n",x) : fprintf(yyout,"bipush %d\n",x) ; }
| T_real 	{$$.type = type_real; fprintf(yyout,"ldc %s\n",$1);}
| T_id 		{if (!($$.type = lookup_type($1))) {ERR_VAR_MISSING($1,line);}printType(lookup_type($1));fprintf(yyout,"load %d\n",lookup_position($1));}
| '(' expr ')' 	{$$.type = $2.type ;}
| expr expr '+'	{$$.type = typeDefinition($1.type, $2.type);printType($$.type);fprintf(yyout,"add\n");}
| expr expr '*'	{$$.type = typeDefinition($1.type, $2.type); printType($$.type);fprintf(yyout,"mul\n");}
|T_id T_inc {$$.type = lookup_type($1);if($$.type!=type_integer)fprintf(yyout,"Error:%s is not an integer\n",$1);printType(lookup_type($1));fprintf(yyout,"load %d\n",lookup_position($1));fprintf(yyout,"iinc %d 1\n",lookup_position($1));}
|T_inc T_id {$$.type = lookup_type($2);if($$.type!=type_integer)fprintf(yyout,"Error:%s is not an integer\n",$2);fprintf(yyout,"iinc %d 1\n",lookup_position($2)); printType(lookup_type($2));fprintf(yyout,"load %d\n",lookup_position($2));}
	;
%%
ParType typeDefinition(ParType Arg1, ParType Arg2)
{
    if (Arg1 == type_integer && Arg2 == type_integer) {return type_integer;}
    if (Arg1 == type_real && Arg2 == type_real) {return type_real;}
    yyerror("Type missmatch"); return type_error;
}
/* Adding a Variable entry to the symbol table.
 If the variable already exists, it will return an error. */
int addvar(char *VariableName,ParType TypeDecl)
{
    ST_ENTRY *newVar;
    
    if (!lookup(VariableName))
    {
        newVar = malloc(sizeof(ST_ENTRY));
        newVar->varname = VariableName;
        newVar->vartype = TypeDecl;
        newVar->position = current_stack_value;
        SGLIB_LIST_ADD(ST_ENTRY, symbolTable, newVar, next_st_var);
        current_stack_value++;
        return 1;
    }
    else return 0; /* error */
}

/* Looking up a symbol in the symbol table. Returns 0 (false) if symbol was not found. */

int lookup(char *VariableName){
    ST_ENTRY *var, *result;
    var = malloc(sizeof(ST_ENTRY));
    var->varname = strdup(VariableName);
    SGLIB_LIST_FIND_MEMBER(ST_ENTRY,symbolTable,var,ST_COMPARATOR,next_st_var, result);
    free(var);
    if (result == NULL) {return 0;}
    else {return 1;}
}

/* Looking up a symbol type in the symbol table. Returns 0 if symbol was not found. */

ParType lookup_type(char *VariableName)
{
    ST_ENTRY *var, *result;
    var = malloc(sizeof(ST_ENTRY));
    var->varname = strdup(VariableName);
    SGLIB_LIST_FIND_MEMBER(ST_ENTRY,symbolTable,var,ST_COMPARATOR,next_st_var, result);
    free(var);
    if (result == NULL) {return 0;}
    else {return result->vartype;}
    
}
/* Printing the complete Symbol Table */
void print_symbol_table(void)
{
    ST_ENTRY *var;
    printf("\n Symbol Table Generated \n");
    SGLIB_LIST_MAP_ON_ELEMENTS(ST_ENTRY, symbolTable, var, next_st_var, {
        printf("ST:: Name %s Type %d Position %d\n", var->varname,var->vartype,var->position);
    });
}

void printType(ParType Arg1)
{
    if (Arg1 == type_integer) {fprintf(yyout,"i");}
    if (Arg1 == type_real) {fprintf(yyout,"f");}
}

void create_preample(char *className){
    fprintf(yyout,".class public %s \n",className);
    fprintf(yyout,".super java/lang/Object\n\n");
    fprintf(yyout,".method public static main([Ljava/lang/String;)V\n");

    fprintf(yyout," .limit locals 20 \n .limit stack 20\n");
}

int lookup_position(char *VariableName)
{
    ST_ENTRY *var, *result;
    var = malloc(sizeof(ST_ENTRY));
    var->varname = strdup(VariableName);
    SGLIB_LIST_FIND_MEMBER(ST_ENTRY,symbolTable,var,ST_COMPARATOR,next_st_var, result);
    free(var);
    if (result == NULL) {return 0;}
    else {return result->position;}
}



int yyerror (const char * msg)
{
  printf("Error: %s in line : %d\n", msg,line);
}

/* Other error Functions*/
/* The lexer... */
#include "jvmLang.lex.c"

/* Main */
main(int argc, char **argv ){

   ++argv, --argc;  /* skip over program name */
   if ( argc > 0 )
       yyin = fopen( argv[0], "r" );
   else
       yyin = stdin;
   if ( argc > 1)
       yyout = fopen( argv[1], "w");
   else
	yyout = stdout;

   int result = yyparse();
   if (result == 0)
   printf("Syntax OK!\n");
   else
   printf("Failure!\n ");

   print_symbol_table();

  return result;
  
  
}
