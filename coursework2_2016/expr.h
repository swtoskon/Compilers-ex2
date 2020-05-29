#ifndef __EXPR_H__
#define __EXPR_H__
/* Definition of the supported types*/
typedef enum {type_error, type_integer, type_real} ParType;

#endif

#ifdef PARSER
#define MAX_VAR_LEN 80
/* The following is the element of the symbol table. For simpicity reasons the symbol table is a linked list.*/
typedef struct st_var {
	char *varname;
	ParType vartype;
    int position;
	struct st_var *next_st_var;
	} ST_ENTRY;

typedef ST_ENTRY *ST_TABLE;
/* definition required by the Lib (   sglib ) for the linked lists used in the symbol table.  */
#define ST_COMPARATOR(e1,e2) (strcmp(e1->varname,e2->varname))
	
#endif
