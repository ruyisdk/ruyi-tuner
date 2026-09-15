
/*  A Bison parser, made from parser.y  */

#define	FUNC	258
#define	VARIABLE	259
#define	ASSIGN_SYMBOL	260
#define	INTEGER	261
#define	PRINT	262
#define	TEXT	263
#define	RETURN	264
#define	CONTINUE	265
#define	IF	266
#define	THEN	267
#define	ELSE	268
#define	FI	269
#define	WHILE	270
#define	DO	271
#define	DONE	272
#define	VAR	273
#define	UMINUS	274

#line 37 "parser.y"


/* We include the standard headers, but not "parser.h", since that will be
   produced by YACC when the YACC program is translated. */

#include <stdio.h>
#include <ctype.h>
#include "vc.h"

/* These are the prototypes of routines defined and used in the parser */

TAC   *do_program( TAC *c ) ;
TAC   *do_func( SYMB *func,
	      TAC  *args,
	      TAC  *code ) ;
TAC   *declare_var( SYMB *var ) ;
TAC   *do_assign( SYMB  *var,
		ENODE *expr ) ;
ENODE *do_bin(  int    binop,
		ENODE *expr1,
		ENODE *expr2 ) ;
ENODE *do_un(  int    unop,
	       ENODE *expr ) ;
ENODE *do_fnap( SYMB  *func,
		ENODE *arglist ) ;
TAC   *do_lib( int   rtn,
	     SYMB *arg ) ;
TAC   *do_if( ENODE *expr,
	    TAC   *stmt ) ;
TAC   *do_test( ENODE *expr,
	      TAC   *stmt1,
	      TAC   *stmt2 ) ;
TAC   *do_while( ENODE *expr,
	       TAC   *stmt ) ;
ENODE *mkenode( ENODE *next,
		SYMB  *res,
		TAC   *code ) ;
void  yyerror( char *str ) ;

/* "program_tac" is the complete TAC recognised by the parser, and set up by
   yyparse, when the sentence symbol, <program>, is recognised. We can't make
   use of "yyval", since that is not exported by the parser if you make use of
   Bison rather than YACC. */

TAC  *program_tac ;			 /* The complete program TAC */


#line 91 "parser.y"
typedef union
{
	SYMB   *symb ;		 /* For vars, consts and text */
	TAC    *tac ;		 /* For most things */
	ENODE  *enode ;		 /* For expressions */
} YYSTYPE;

#ifndef YYLTYPE
typedef
  struct yyltype
    {
      int timestamp;
      int first_line;
      int first_column;
      int last_line;
      int last_column;
      char *text;
   }
  yyltype;

#define YYLTYPE yyltype
#endif

#include <stdio.h>

#ifndef __STDC__
#define const
#endif



#define	YYFINAL		83
#define	YYFLAG		-32768
#define	YYNTBASE	29

#define YYTRANSLATE(x) ((unsigned)(x) <= 274 ? yytranslate[x] : 50)

static const char yytranslate[] = {     0,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,    24,
    25,    22,    20,    26,    21,     2,    23,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,    27,     2,    28,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     1,     2,     3,     4,     5,
     6,     7,     8,     9,    10,    11,    12,    13,    14,    15,
    16,    17,    18,    19
};

static const short yyprhs[] = {     0,
     0,     2,     4,     7,    14,    16,    18,    19,    21,    25,
    27,    29,    31,    33,    35,    37,    39,    41,    45,    49,
    53,    57,    61,    64,    68,    70,    72,    77,    79,    80,
    82,    84,    88,    91,    93,    97,    99,   101,   104,   106,
   112,   120,   126,   131,   132,   135,   138,   140
};

static const short yyrhs[] = {    30,
     0,    31,     0,    30,    31,     0,     3,     4,    24,    32,
    25,    34,     0,     1,     0,    33,     0,     0,     4,     0,
    33,    26,     4,     0,    35,     0,    42,     0,    39,     0,
    43,     0,    44,     0,    45,     0,    46,     0,     1,     0,
     4,     5,    36,     0,    36,    20,    36,     0,    36,    21,
    36,     0,    36,    22,    36,     0,    36,    23,    36,     0,
    21,    36,     0,    24,    36,    25,     0,     6,     0,     4,
     0,     4,    24,    37,    25,     0,     1,     0,     0,    38,
     0,    36,     0,    36,    26,    38,     0,     7,    40,     0,
    41,     0,    40,    26,    41,     0,    36,     0,     8,     0,
     9,    36,     0,    10,     0,    11,    36,    12,    34,    14,
     0,    11,    36,    12,    34,    13,    34,    14,     0,    15,
    36,    16,    34,    17,     0,    27,    47,    49,    28,     0,
     0,    47,    48,     0,    18,    33,     0,    34,     0,    49,
    34,     0
};

#if YYDEBUG != 0
static const short yyrline[] = { 0,
   163,   178,   179,   193,   198,   205,   206,   212,   216,   227,
   228,   229,   230,   231,   232,   233,   234,   241,   251,   255,
   259,   263,   267,   271,   275,   279,   299,   303,   310,   314,
   317,   318,   328,   334,   335,   344,   353,   363,   373,   382,
   386,   393,   399,   405,   409,   415,   421,   423
};

static const char * const yytname[] = {   "$",
"error","$illegal.","FUNC","VARIABLE","ASSIGN_SYMBOL","INTEGER","PRINT","TEXT","RETURN","CONTINUE",
"IF","THEN","ELSE","FI","WHILE","DO","DONE","VAR","UMINUS","'+'",
"'-'","'*'","'/'","'('","')'","','","'{'","'}'","program","function_list",
"function","parameter_list","variable_list","statement","assignment_statement","expression","argument_list","expression_list","print_statement","print_list",
"print_item","return_statement","null_statement","if_statement","while_statement","block","declaration_list","declaration","statement_list",""
};
#endif

static const short yyr1[] = {     0,
    29,    30,    30,    31,    31,    32,    32,    33,    33,    34,
    34,    34,    34,    34,    34,    34,    34,    35,    36,    36,
    36,    36,    36,    36,    36,    36,    36,    36,    37,    37,
    38,    38,    39,    40,    40,    41,    41,    42,    43,    44,
    44,    45,    46,    47,    47,    48,    49,    49
};

static const short yyr2[] = {     0,
     1,     1,     2,     6,     1,     1,     0,     1,     3,     1,
     1,     1,     1,     1,     1,     1,     1,     3,     3,     3,
     3,     3,     2,     3,     1,     1,     4,     1,     0,     1,
     1,     3,     2,     1,     3,     1,     1,     2,     1,     5,
     7,     5,     4,     0,     2,     2,     1,     2
};

static const short yydefact[] = {     0,
     5,     0,     0,     2,     0,     3,     7,     8,     0,     6,
     0,     0,    17,     0,     0,     0,    39,     0,     0,    44,
     4,    10,    12,    11,    13,    14,    15,    16,     9,     0,
    28,    26,    25,    37,     0,     0,    36,    33,    34,    38,
     0,     0,     0,    18,     0,    23,     0,     0,     0,     0,
     0,     0,     0,     0,     0,    47,    45,     0,    31,     0,
    30,    24,    19,    20,    21,    22,    35,     0,     0,    46,
    43,    48,     0,    27,     0,    40,    42,    32,     0,    41,
     0,     0,     0
};

static const short yydefgoto[] = {    81,
     3,     4,     9,    10,    21,    22,    37,    60,    61,    23,
    38,    39,    24,    25,    26,    27,    28,    43,    57,    58
};

static const short yypact[] = {    46,
-32768,     1,    40,-32768,    13,-32768,     4,-32768,    23,    26,
    54,    22,-32768,    55,    72,    66,-32768,    66,    66,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,    66,
-32768,    42,-32768,-32768,    66,    66,    87,    33,-32768,    87,
    77,     2,    35,    87,    50,-32768,    81,    66,    66,    66,
    66,    72,    54,    54,     4,-32768,-32768,     0,    62,    43,
-32768,-32768,   -10,   -10,-32768,-32768,-32768,    17,    60,    26,
-32768,-32768,    66,-32768,    54,-32768,-32768,-32768,    65,-32768,
    86,    91,-32768
};

static const short yypgoto[] = {-32768,
-32768,    89,-32768,    39,   -37,-32768,   -16,-32768,    32,-32768,
-32768,    59,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768
};


#define	YYLAST		111


static const short yytable[] = {    40,
    13,    41,    42,    14,     5,    56,    15,     8,    16,    17,
    18,    50,    51,    44,    19,    68,    69,    54,    46,    47,
    72,    48,    49,    50,    51,    29,    20,    71,    59,    75,
    76,    63,    64,    65,    66,    13,     7,    79,    14,    -1,
     1,    15,     2,    16,    17,    18,     1,    11,     2,    19,
    31,    12,    55,    32,    13,    33,    59,    14,    52,    30,
    15,    20,    16,    17,    18,    45,    31,    74,    19,    32,
    35,    33,    31,    36,   -29,    32,    77,    33,    80,    34,
    20,    48,    49,    50,    51,    82,    35,    73,    53,    36,
    83,     6,    35,    70,     0,    36,    48,    49,    50,    51,
    48,    49,    50,    51,    78,    62,    48,    49,    50,    51,
    67
};

static const short yycheck[] = {    16,
     1,    18,    19,     4,     4,    43,     7,     4,     9,    10,
    11,    22,    23,    30,    15,    53,    54,    16,    35,    36,
    58,    20,    21,    22,    23,     4,    27,    28,    45,    13,
    14,    48,    49,    50,    51,     1,    24,    75,     4,     0,
     1,     7,     3,     9,    10,    11,     1,    25,     3,    15,
     1,    26,    18,     4,     1,     6,    73,     4,    26,     5,
     7,    27,     9,    10,    11,    24,     1,    25,    15,     4,
    21,     6,     1,    24,    25,     4,    17,     6,    14,     8,
    27,    20,    21,    22,    23,     0,    21,    26,    12,    24,
     0,     3,    21,    55,    -1,    24,    20,    21,    22,    23,
    20,    21,    22,    23,    73,    25,    20,    21,    22,    23,
    52
};
/* -*-C-*-  Note some compilers choke on comments on `#line' lines.  */
#line 3 "bison.simple"

/* Skeleton output parser for bison,
   Copyright (C) 1984, 1989, 1990 Bob Corbett and Richard Stallman

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 1, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.  */


#ifndef alloca
#ifdef __GNUC__
#define alloca __builtin_alloca
#else /* Not GNU C.  */
#if (!defined (__STDC__) && defined (sparc)) || defined (__sparc__)
#include <alloca.h>
#else /* Not sparc */
#ifdef MSDOS
#include <malloc.h>
#endif /* MSDOS */
#endif /* Not sparc.  */
#endif /* Not GNU C.  */
#endif /* alloca not defined.  */

/* This is the parser code that is written into each bison parser
  when the %semantic_parser declaration is not specified in the grammar.
  It was written by Richard Stallman by simplifying the hairy parser
  used when %semantic_parser is specified.  */

/* Note: there must be only one dollar sign in this file.
   It is replaced by the list of actions, each action
   as one case of the switch.  */

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		-2
#define YYEOF		0
#define YYACCEPT	return(0)
#define YYABORT 	return(1)
#define YYERROR		goto yyerrlab1
/* Like YYERROR except do call yyerror.
   This remains here temporarily to ease the
   transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */
#define YYFAIL		goto yyerrlab
#define YYRECOVERING()  (!!yyerrstatus)
#define YYBACKUP(token, value) \
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    { yychar = (token), yylval = (value);			\
      yychar1 = YYTRANSLATE (yychar);				\
      YYPOPSTACK;						\
      goto yybackup;						\
    }								\
  else								\
    { yyerror ("syntax error: cannot back up"); YYERROR; }	\
while (0)

#define YYTERROR	1
#define YYERRCODE	256

#ifndef YYPURE
#define YYLEX		yylex()
#endif

#ifdef YYPURE
#ifdef YYLSP_NEEDED
#define YYLEX		yylex(&yylval, &yylloc)
#else
#define YYLEX		yylex(&yylval)
#endif
#endif

/* If nonreentrant, generate the variables here */

#ifndef YYPURE

int	yychar;			/*  the lookahead symbol		*/
YYSTYPE	yylval;			/*  the semantic value of the		*/
				/*  lookahead symbol			*/

#ifdef YYLSP_NEEDED
YYLTYPE yylloc;			/*  location data for the lookahead	*/
				/*  symbol				*/
#endif

int yynerrs;			/*  number of parse errors so far       */
#endif  /* not YYPURE */

#if YYDEBUG != 0
int yydebug;			/*  nonzero means print parse trace	*/
/* Since this is uninitialized, it does not stop multiple parsers
   from coexisting.  */
#endif

/*  YYINITDEPTH indicates the initial size of the parser's stacks	*/

#ifndef	YYINITDEPTH
#define YYINITDEPTH 200
#endif

/*  YYMAXDEPTH is the maximum size the stacks can grow to
    (effective only if the built-in stack extension method is used).  */

#if YYMAXDEPTH == 0
#undef YYMAXDEPTH
#endif

#ifndef YYMAXDEPTH
#define YYMAXDEPTH 10000
#endif

#ifndef __cplusplus

/* This is the most reliable way to avoid incompatibilities
   in available built-in functions on various systems.  */
static void
__yy_bcopy (from, to, count)
     char *from;
     char *to;
     int count;
{
  register char *f = from;
  register char *t = to;
  register int i = count;

  while (i-- > 0)
    *t++ = *f++;
}

#else /* __cplusplus */

/* This is the most reliable way to avoid incompatibilities
   in available built-in functions on various systems.  */
static void
__yy_bcopy (char *from, char *to, int count)
{
  register char *f = from;
  register char *t = to;
  register int i = count;

  while (i-- > 0)
    *t++ = *f++;
}

#endif

#line 160 "bison.simple"
int
yyparse()
{
  register int yystate;
  register int yyn;
  register short *yyssp;
  register YYSTYPE *yyvsp;
  int yyerrstatus;	/*  number of tokens to shift before error messages enabled */
  int yychar1;		/*  lookahead token as an internal (translated) token number */

  short	yyssa[YYINITDEPTH];	/*  the state stack			*/
  YYSTYPE yyvsa[YYINITDEPTH];	/*  the semantic value stack		*/

  short *yyss = yyssa;		/*  refer to the stacks thru separate pointers */
  YYSTYPE *yyvs = yyvsa;	/*  to allow yyoverflow to reallocate them elsewhere */

#ifdef YYLSP_NEEDED
  YYLTYPE yylsa[YYINITDEPTH];	/*  the location stack			*/
  YYLTYPE *yyls = yylsa;
  YYLTYPE *yylsp;

#define YYPOPSTACK   (yyvsp--, yysp--, yylsp--)
#else
#define YYPOPSTACK   (yyvsp--, yysp--)
#endif

  int yystacksize = YYINITDEPTH;

#ifdef YYPURE
  int yychar;
  YYSTYPE yylval;
  int yynerrs;
#ifdef YYLSP_NEEDED
  YYLTYPE yylloc;
#endif
#endif

  YYSTYPE yyval;		/*  the variable used to return		*/
				/*  semantic values from the action	*/
				/*  routines				*/

  int yylen;

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Starting parse\n");
#endif

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.  */

  yyssp = yyss - 1;
  yyvsp = yyvs;
#ifdef YYLSP_NEEDED
  yylsp = yyls;
#endif

/* Push a new state, which is found in  yystate  .  */
/* In all cases, when you get here, the value and location stacks
   have just been pushed. so pushing a state here evens the stacks.  */
yynewstate:

  *++yyssp = yystate;

  if (yyssp >= yyss + yystacksize - 1)
    {
      /* Give user a chance to reallocate the stack */
      /* Use copies of these so that the &'s don't force the real ones into memory. */
      YYSTYPE *yyvs1 = yyvs;
      short *yyss1 = yyss;
#ifdef YYLSP_NEEDED
      YYLTYPE *yyls1 = yyls;
#endif

      /* Get the current used size of the three stacks, in elements.  */
      int size = yyssp - yyss + 1;

#ifdef yyoverflow
      /* Each stack pointer address is followed by the size of
	 the data in use in that stack, in bytes.  */
      yyoverflow("parser stack overflow",
		 &yyss1, size * sizeof (*yyssp),
		 &yyvs1, size * sizeof (*yyvsp),
#ifdef YYLSP_NEEDED
		 &yyls1, size * sizeof (*yylsp),
#endif
		 &yystacksize);

      yyss = yyss1; yyvs = yyvs1;
#ifdef YYLSP_NEEDED
      yyls = yyls1;
#endif
#else /* no yyoverflow */
      /* Extend the stack our own way.  */
      if (yystacksize >= YYMAXDEPTH)
	{
	  yyerror("parser stack overflow");
	  return 2;
	}
      yystacksize *= 2;
      if (yystacksize > YYMAXDEPTH)
	yystacksize = YYMAXDEPTH;
      yyss = (short *) alloca (yystacksize * sizeof (*yyssp));
      __yy_bcopy ((char *)yyss1, (char *)yyss, size * sizeof (*yyssp));
      yyvs = (YYSTYPE *) alloca (yystacksize * sizeof (*yyvsp));
      __yy_bcopy ((char *)yyvs1, (char *)yyvs, size * sizeof (*yyvsp));
#ifdef YYLSP_NEEDED
      yyls = (YYLTYPE *) alloca (yystacksize * sizeof (*yylsp));
      __yy_bcopy ((char *)yyls1, (char *)yyls, size * sizeof (*yylsp));
#endif
#endif /* no yyoverflow */

      yyssp = yyss + size - 1;
      yyvsp = yyvs + size - 1;
#ifdef YYLSP_NEEDED
      yylsp = yyls + size - 1;
#endif

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Stack size increased to %d\n", yystacksize);
#endif

      if (yyssp >= yyss + yystacksize - 1)
	YYABORT;
    }

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Entering state %d\n", yystate);
#endif

 yybackup:

/* Do appropriate processing given the current state.  */
/* Read a lookahead token if we need one and don't already have one.  */
/* yyresume: */

  /* First try to decide what to do without reference to lookahead token.  */

  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yydefault;

  /* Not known => get a lookahead token if don't already have one.  */

  /* yychar is either YYEMPTY or YYEOF
     or a valid token in external form.  */

  if (yychar == YYEMPTY)
    {
#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Reading a token: ");
#endif
      yychar = YYLEX;
    }

  /* Convert token to internal form (in yychar1) for indexing tables with */

  if (yychar <= 0)		/* This means end of input. */
    {
      yychar1 = 0;
      yychar = YYEOF;		/* Don't call YYLEX any more */

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Now at end of input.\n");
#endif
    }
  else
    {
      yychar1 = YYTRANSLATE(yychar);

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Next token is %d (%s)\n", yychar, yytname[yychar1]);
#endif
    }

  yyn += yychar1;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != yychar1)
    goto yydefault;

  yyn = yytable[yyn];

  /* yyn is what to do for this token type in this state.
     Negative => reduce, -yyn is rule number.
     Positive => shift, yyn is new state.
       New state is final state => don't bother to shift,
       just return success.
     0, or most negative number => error.  */

  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrlab;

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Shift the lookahead token.  */

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Shifting token %d (%s), ", yychar, yytname[yychar1]);
#endif

  /* Discard the token being shifted unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  *++yyvsp = yylval;
#ifdef YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

  /* count tokens shifted since error; after three, turn off error status.  */
  if (yyerrstatus) yyerrstatus--;

  yystate = yyn;
  goto yynewstate;

/* Do the default action for the current state.  */
yydefault:

  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;

/* Do a reduction.  yyn is the number of a rule to reduce with.  */
yyreduce:
  yylen = yyr2[yyn];
  yyval = yyvsp[1-yylen]; /* implement default value of the action */

#if YYDEBUG != 0
  if (yydebug)
    {
      int i;

      fprintf (stderr, "Reducing via rule %d (line %d), ",
	       yyn, yyrline[yyn]);

      /* Print the symboles being reduced, and their result.  */
      for (i = yyprhs[yyn]; yyrhs[i] > 0; i++)
	fprintf (stderr, "%s ", yytname[yyrhs[i]]);
      fprintf (stderr, " -> %s\n", yytname[yyr1[yyn]]);
    }
#endif


  switch (yyn) {

case 1:
#line 164 "parser.y"
{
				  	program_tac = yyvsp[0].tac ;
				;
    break;}
case 3:
#line 180 "parser.y"
{
					yyval.tac = join_tac( yyvsp[-1].tac, yyvsp[0].tac ) ;
				;
    break;}
case 4:
#line 195 "parser.y"
{
					yyval.tac = do_func( yyvsp[-4].symb, yyvsp[-2].tac, yyvsp[0].tac ) ;
				;
    break;}
case 5:
#line 199 "parser.y"
{
					error( "Bad function syntax" ) ;
					yyval.tac = NULL ;
				;
    break;}
case 7:
#line 207 "parser.y"
{
					yyval.tac = NULL ;
				;
    break;}
case 8:
#line 213 "parser.y"
{
					yyval.tac = declare_var( yyvsp[0].symb ) ;
				;
    break;}
case 9:
#line 217 "parser.y"
{
                                        /* If we get a duplicate declaration,
                                           t will be NULL. join_tac handles
                                           this correctly. */

                                        yyval.tac = join_tac( declare_var( yyvsp[0].symb ),
                                                       yyvsp[-2].tac ) ;
				;
    break;}
case 17:
#line 235 "parser.y"
{
					error( "Bad statement syntax" ) ;
					yyval.tac = NULL ;
				;
    break;}
case 18:
#line 242 "parser.y"
{

					yyval.tac = do_assign( yyvsp[-2].symb, yyvsp[0].enode ) ;
				;
    break;}
case 19:
#line 252 "parser.y"
{
					yyval.enode = do_bin( TAC_ADD, yyvsp[-2].enode, yyvsp[0].enode ) ;
				;
    break;}
case 20:
#line 256 "parser.y"
{
					yyval.enode = do_bin( TAC_SUB, yyvsp[-2].enode, yyvsp[0].enode ) ;
				;
    break;}
case 21:
#line 260 "parser.y"
{
					yyval.enode = do_bin( TAC_MUL, yyvsp[-2].enode, yyvsp[0].enode ) ;
				;
    break;}
case 22:
#line 264 "parser.y"
{
					yyval.enode = do_bin( TAC_DIV, yyvsp[-2].enode, yyvsp[0].enode ) ;
				;
    break;}
case 23:
#line 268 "parser.y"
{
					yyval.enode = do_un( TAC_NEG, yyvsp[0].enode ) ;
				;
    break;}
case 24:
#line 272 "parser.y"
{
					yyval.enode = yyvsp[-1].enode ;
				;
    break;}
case 25:
#line 276 "parser.y"
{
					yyval.enode = mkenode( NULL, yyvsp[0].symb, NULL ) ;
				;
    break;}
case 26:
#line 280 "parser.y"
{
                                        /* Check the variable is declared. If
                                           not we subsitute constant zero, or
                                           we get all sorts of problems later
                                           on. */

                                        if( yyvsp[0].symb->type != T_VAR )
                                        {
                                                error( "Undeclared variable in"
                                                     " expression" ) ;

                                                yyval.enode = mkenode( NULL,
                                                              mkconst( 0 ),
                                                              NULL ) ;
                                        }
                                        else
                                                yyval.enode = mkenode( NULL, yyvsp[0].symb,
                                                              NULL ) ;
				;
    break;}
case 27:
#line 300 "parser.y"
{
					yyval.enode = do_fnap( yyvsp[-3].symb, yyvsp[-1].enode ) ;
				;
    break;}
case 28:
#line 304 "parser.y"
{
					error( "Bad expression syntax" ) ;
					yyval.enode = mkenode( NULL, NULL, NULL ) ;
				;
    break;}
case 29:
#line 311 "parser.y"
{
					yyval.enode = NULL ;
				;
    break;}
case 32:
#line 319 "parser.y"
{

					/* Construct a list of expr nodes */

					yyvsp[-2].enode->next = yyvsp[0].enode ;
					yyval.enode       = yyvsp[-2].enode ;
				;
    break;}
case 33:
#line 329 "parser.y"
{
					yyval.tac = yyvsp[0].tac ;
				;
    break;}
case 35:
#line 336 "parser.y"
{
					yyval.tac = join_tac( yyvsp[-2].tac, yyvsp[0].tac ) ;
				;
    break;}
case 36:
#line 345 "parser.y"
{

					/* Call printn library routine */

					yyval.tac = join_tac( yyvsp[0].enode->tac,
						       do_lib( LIB_PRINTN,
						       yyvsp[0].enode->res )) ;
				;
    break;}
case 37:
#line 354 "parser.y"
{

					/* Call prints, passing the address of
					   the string */

					yyval.tac = do_lib( LIB_PRINTS, yyvsp[0].symb ) ;
				;
    break;}
case 38:
#line 364 "parser.y"
{
					TAC *t = mktac( TAC_RETURN, yyvsp[0].enode->res,
							NULL, NULL ) ;
					t->prev = yyvsp[0].enode->tac ;
					free_enode( yyvsp[0].enode ) ;
					yyval.tac      = t ;
				;
    break;}
case 39:
#line 374 "parser.y"
{
					yyval.tac = NULL ;
				;
    break;}
case 40:
#line 383 "parser.y"
{
					yyval.tac = do_if( yyvsp[-3].enode, yyvsp[-1].tac ) ;
				;
    break;}
case 41:
#line 388 "parser.y"
{
					yyval.tac = do_test( yyvsp[-5].enode, yyvsp[-3].tac, yyvsp[-1].tac ) ;
				;
    break;}
case 42:
#line 394 "parser.y"
{
					yyval.tac = do_while( yyvsp[-3].enode, yyvsp[-1].tac ) ;
				;
    break;}
case 43:
#line 400 "parser.y"
{
					yyval.tac = join_tac( yyvsp[-2].tac, yyvsp[-1].tac ) ;
				;
    break;}
case 44:
#line 406 "parser.y"
{
					yyval.tac = NULL ;
				;
    break;}
case 45:
#line 410 "parser.y"
{
					yyval.tac = join_tac( yyvsp[-1].tac, yyvsp[0].tac ) ;
				;
    break;}
case 46:
#line 416 "parser.y"
{
					yyval.tac = yyvsp[0].tac ;
				;
    break;}
case 48:
#line 424 "parser.y"
{
					yyval.tac = join_tac( yyvsp[-1].tac, yyvsp[0].tac ) ;
				;
    break;}
}
   /* the action file gets copied in in place of this dollarsign */
#line 423 "bison.simple"

  yyvsp -= yylen;
  yyssp -= yylen;
#ifdef YYLSP_NEEDED
  yylsp -= yylen;
#endif

#if YYDEBUG != 0
  if (yydebug)
    {
      short *ssp1 = yyss - 1;
      fprintf (stderr, "state stack now");
      while (ssp1 != yyssp)
	fprintf (stderr, " %d", *++ssp1);
      fprintf (stderr, "\n");
    }
#endif

  *++yyvsp = yyval;

#ifdef YYLSP_NEEDED
  yylsp++;
  if (yylen == 0)
    {
      yylsp->first_line = yylloc.first_line;
      yylsp->first_column = yylloc.first_column;
      yylsp->last_line = (yylsp-1)->last_line;
      yylsp->last_column = (yylsp-1)->last_column;
      yylsp->text = 0;
    }
  else
    {
      yylsp->last_line = (yylsp+yylen-1)->last_line;
      yylsp->last_column = (yylsp+yylen-1)->last_column;
    }
#endif

  /* Now "shift" the result of the reduction.
     Determine what state that goes to,
     based on the state we popped back to
     and the rule number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTBASE] + *yyssp;
  if (yystate >= 0 && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTBASE];

  goto yynewstate;

yyerrlab:   /* here on detecting error */

  if (! yyerrstatus)
    /* If not already recovering from an error, report this error.  */
    {
      ++yynerrs;

#ifdef YYERROR_VERBOSE
      yyn = yypact[yystate];

      if (yyn > YYFLAG && yyn < YYLAST)
	{
	  int size = 0;
	  char *msg;
	  int x, count;

	  count = 0;
	  for (x = 0; x < (sizeof(yytname) / sizeof(char *)); x++)
	    if (yycheck[x + yyn] == x)
	      size += strlen(yytname[x]) + 15, count++;
	  msg = (char *) xmalloc(size + 15);
	  strcpy(msg, "parse error");

	  if (count < 5)
	    {
	      count = 0;
	      for (x = 0; x < (sizeof(yytname) / sizeof(char *)); x++)
		if (yycheck[x + yyn] == x)
		  {
		    strcat(msg, count == 0 ? ", expecting `" : " or `");
		    strcat(msg, yytname[x]);
		    strcat(msg, "'");
		    count++;
		  }
	    }
	  yyerror(msg);
	  free(msg);
	}
      else
#endif /* YYERROR_VERBOSE */
	yyerror("parse error");
    }

yyerrlab1:   /* here on error raised explicitly by an action */

  if (yyerrstatus == 3)
    {
      /* if just tried and failed to reuse lookahead token after an error, discard it.  */

      /* return failure if at end of input */
      if (yychar == YYEOF)
	YYABORT;

#if YYDEBUG != 0
      if (yydebug)
	fprintf(stderr, "Discarding token %d (%s).\n", yychar, yytname[yychar1]);
#endif

      yychar = YYEMPTY;
    }

  /* Else will try to reuse lookahead token
     after shifting the error token.  */

  yyerrstatus = 3;		/* Each real token shifted decrements this */

  goto yyerrhandle;

yyerrdefault:  /* current state does not do anything special for the error token. */

#if 0
  /* This is wrong; only states that explicitly want error tokens
     should shift them.  */
  yyn = yydefact[yystate];  /* If its default is to accept any token, ok.  Otherwise pop it.*/
  if (yyn) goto yydefault;
#endif

yyerrpop:   /* pop the current state because it cannot handle the error token */

  if (yyssp == yyss) YYABORT;
  yyvsp--;
  yystate = *--yyssp;
#ifdef YYLSP_NEEDED
  yylsp--;
#endif

#if YYDEBUG != 0
  if (yydebug)
    {
      short *ssp1 = yyss - 1;
      fprintf (stderr, "Error: state stack now");
      while (ssp1 != yyssp)
	fprintf (stderr, " %d", *++ssp1);
      fprintf (stderr, "\n");
    }
#endif

yyerrhandle:

  yyn = yypact[yystate];
  if (yyn == YYFLAG)
    goto yyerrdefault;

  yyn += YYTERROR;
  if (yyn < 0 || yyn > YYLAST || yycheck[yyn] != YYTERROR)
    goto yyerrdefault;

  yyn = yytable[yyn];
  if (yyn < 0)
    {
      if (yyn == YYFLAG)
	goto yyerrpop;
      yyn = -yyn;
      goto yyreduce;
    }
  else if (yyn == 0)
    goto yyerrpop;

  if (yyn == YYFINAL)
    YYACCEPT;

#if YYDEBUG != 0
  if (yydebug)
    fprintf(stderr, "Shifting error token, ");
#endif

  *++yyvsp = yylval;
#ifdef YYLSP_NEEDED
  *++yylsp = yylloc;
#endif

  yystate = yyn;
  goto yynewstate;
}
#line 429 "parser.y"


/* These are the routines to support the various YACC rules. It is invariably
   clearer to put anything but the simplest semantic action in a routine,
   because the layout of YACC bunches code to the right so much. */


TAC *do_func( SYMB *func,	 		 /* Function */
	      TAC  *args,	 		 /* Its args */
	      TAC  *code )	 		 /* Its code */

/* For a function we must add TAC_BEGINFUNC and TAC_ENDFUNC quadruples
   around it, and a new label at the start. We then enter the name of the
   function in the symbol table. It should not have been declared as a variable
   or function elsewhere, and so should still have type T_UNDEF.

   The function may already be the subject of function calls. The address of
   the quadruples for these calls are held in the LABEL2 field of its symbol
   table entry, ready for backpatching. We run down this list backpatching in
   the address of the starting label, and then replace the field with the
   address of the starting label, also updating the type to T_FUNC.

   Note that there is a fault in the compiler at this point. If we never
   declare a function that is used, then its address will never be backpatched.
   This is a semantic check that needs to be added at the end of parsing. */

{
	TAC *tlist ;			 /* The backpatch list */

	TAC *tlab ;			 /* Label at start of function */
	TAC *tbegin ;			 /* BEGINFUNC marker */
	TAC *tend ;			 /* ENDFUNC marker */

	/* Add this function to the symbol table. If its already there its been
	   used before, so backpatch the address into the call opcodes. If
	   declared already we have a semantic error and give up. Otherwise
	   patch in the addresses and declare as a function */

	if( func->type != T_UNDEF )
	{
		error( "function already declared" ) ;
		return NULL ;
	}

	tlab   = mktac( TAC_LABEL,     mklabel( next_label++ ), NULL, NULL ) ;
	tbegin = mktac( TAC_BEGINFUNC, NULL, NULL, NULL ) ;
	tend   = mktac( TAC_ENDFUNC,   NULL, NULL, NULL ) ;

	tbegin->prev = tlab ;
	code         = join_tac( args, code ) ;
	tend->prev   = join_tac( tbegin, code ) ;

	tlist = func->LABEL2 ;			 /* List of addresses if any */

	while( tlist != NULL )
	{
		TAC *tnext = tlist->LB ;  	 /* Next on list */

		tlist->LB  = tlab ;
		tlist      = tnext ;
	}

	func->type   = T_FUNC ;		 /* And declare as func */
	func->LABEL2 = tlab ;

	return tend ;

}	/* TAC *do_func( SYMB *func,
		     	 TAC  *args,
			 TAC  *code ) */


TAC *declare_var( SYMB *var )

/* All variable names may be used only once throughout a program. We check here
   that they have not yet been declared and if so declare them, setting their
   stack offset to -1 (an invalid offset) and marking their address descriptor
   empty. Note that this is a fault in the compiler. We really do need to mark
   the beginning and end of blocks in which variables are declared, so that
   scope can be checked. */

{
	if( var->type != T_UNDEF )
	{
		error( "variable already declared" ) ;
		return NULL ;
	}

	var->type  = T_VAR ;
	var->ADDR2 = -1 ;		 /* Unset address */

	/* TAC for a declaration */

	return  mktac( TAC_VAR, var, NULL, NULL ) ;

}	/* TAC *declare_var( SYMB *var ) */


TAC *do_assign( SYMB  *var,	 /* Variable to be assigned */
		ENODE *expr )	 /* Expression to assign */

/* An assignment statement shows the use of expression nodes. We construct a
   copy node to take the result of the expression and copy it into the
   variable, having performed suitable semantic checks. Note that if we
   discover that the variable has not been declared, we declare it, to prevent
   further non-declaration errors each time it is referenced. */

{
	TAC  *code ;

	/* Warn if variable not declared, then build code */

	if( var->type != T_VAR )
		error( "assignment to non-variable" ) ;

	code       = mktac( TAC_COPY, var, expr->res, NULL ) ;
	code->prev = expr->tac ;
	free_enode( expr ) ;		 /* Expression now finished with */

	return code ;

}	/* TAC *do_assign( SYMB  *var,
			   ENODE *expr ) */


ENODE *do_bin(  int    binop,		 /* TAC binary operator */
		ENODE *expr1,		 /* Expressions to operate on */
		ENODE *expr2 )

/* We then have the first of the arithmetic routines to handles binary
   operators.  We carry out one of the few optimisations in the compiler here,
   constant folding. We might think of reusing one of the expression nodes for
   efficiency. However because constants up to CONST_MAX are held in shared
   symbols, we risk altering the value of such constants in future use. For
   simplicity we just create a new constant node for the result, rather than
   sorting out if we can reuse the node. If we can't do folding we generate the
   result into a temporary variable, which we first declare, returning an
   expression node for the TAC with the temporary in the result field. */

{
	TAC  *temp ;			 /* TAC code for temp symbol */
	TAC  *res ;			 /* TAC code for result */

	/* Do constant folding if possible. Calculate the constant into newval
	   and make a new constant node for the result. Free up expr2. */

	if(( expr1->ETYPE == T_INT ) && ( expr2->ETYPE == T_INT ))
	{
		int   newval;		 /* The result of constant folding */

		switch( binop )		 /* Chose the operator */
		{
		case TAC_ADD:

			newval = expr1->EVAL1 + expr2->EVAL1 ;
			break ;

		case TAC_SUB:

			newval = expr1->EVAL1 - expr2->EVAL1 ;
			break ;

		case TAC_MUL:

			newval = expr1->EVAL1 * expr2->EVAL1 ;
			break ;

		case TAC_DIV:

			newval = expr1->EVAL1 / expr2->EVAL1 ;
			break ;
		}

                expr1->res = mkconst(newval);  /* New space for result */
		free_enode( expr2 ) ;	       /* Release space in expr2 */

		return expr1 ;		   /* The new expression */
	}

	/* Not constant, so create a TAC node for a binary operator, putting
	   the result in a temporary. Bolt the code together, reusing expr1 and
	   freeing expr2. */

	temp       = mktac( TAC_VAR, mktmp(), NULL, NULL ) ;
	temp->prev = join_tac( expr1->tac, expr2->tac ) ;
	res        = mktac( binop, temp->VA, expr1->res, expr2->res ) ;
	res->prev  = temp ;

	expr1->res = temp->VA ;
	expr1->tac = res ;
	free_enode( expr2 ) ;

	return expr1 ;	

}	/* ENODE *do_bin(  int    binop,
	 		   ENODE *expr1,
			   ENODE *expr2 ) */


ENODE *do_un(  int    unop,		 /* TAC unary operator */
	       ENODE *expr )		 /* Expression to operate on */

/* This is an analagous routine to deal with unary operators. In the interests
   of generality it has been written to permit easy addition of new unary
   operators, although there is only one at present. */


{
	TAC  *temp ;			 /* TAC code for temp symbol */
	TAC  *res ;			 /* TAC code for result */

	/* Do constant folding if possible. Calculate the constant into expr */

	if( expr->ETYPE == T_INT )
	{
		switch( unop )		 /* Chose the operator */
		{
		case TAC_NEG:

			expr->EVAL1 = - expr->EVAL1 ;
			break ;
		}

		return expr ;		   /* The new expression */
	}

	/* Not constant, so create a TAC node for a unary operator, putting
	   the result in a temporary. Bolt the code together, reusing expr. */

	temp       = mktac( TAC_VAR, mktmp(), NULL, NULL ) ;
	temp->prev = expr->tac ;
	res        = mktac( unop, temp->VA, NULL, expr->res ) ;
	res->prev  = temp ;

	expr->res = temp->VA ;
	expr->tac = res ;

	return expr ;	

}	/* ENODE *do_un(  int    unop,
	 		  ENODE *expr ) */


ENODE *do_fnap( SYMB  *func,		 /* Function to call */
		ENODE *arglist )	 /* Its argument list */

/* Construct a function call to the given function. If the function is not yet
   defined, then we must add this call to the backpatching list. Return the
   result of the function in a temporary. Note the qualication about
   backpatching above in the definition of "do_func()"

   When constructing a function call we put the result in a temporary. We join
   all the TAC for the expressions first, then join the code for the TAC_ARG
   instructions, since arg instructions must appear consecutively. */

{
	ENODE  *alt ;			 /* For counting args */
	SYMB   *res ;			 /* Where function result will go */
	TAC    *code ;			 /* Resulting code */
	TAC    *temp ;			 /* Temporary for building code */

	/* Check that this is a valid function. In this case it must either be
	   T_UNDEF or T_FUNC. If it is declare the result, run down the
	   argument list, joining up the code for each argument, then generate
	   a sequence of arg instructions and finally a call instruction */

	if(( func->type != T_UNDEF ) && ( func->type != T_FUNC ))
	{
		error( "function declared other than function" );
		return NULL ;
	}

	res   = mktmp() ;		             /* For the result */
	code  = mktac( TAC_VAR, res, NULL, NULL ) ;

	for( alt = arglist ; alt != NULL ; alt = alt->next )  /* Join args */
		code = join_tac( code, alt->tac ) ;

	while( arglist != NULL )	 /* Generate ARG instructions */
	{
		temp       = mktac( TAC_ARG, arglist->res, NULL, NULL ) ;
		temp->prev = code ;
		code       = temp ;

		alt = arglist->next ;
		free_enode( arglist ) ;	 /* Free the space */
		arglist = alt ;
	} ;

	temp       = mktac( TAC_CALL, res, (SYMB *)func->LABEL2, NULL ) ;
	temp->prev = code ;
	code       = temp ;

	/* If the function is undefined update its backpatching list with the
	   address of this instruction and then return an expression node for
	   the result */

	if( func->type == T_UNDEF )
		func->LABEL2 = code ;

	return mkenode( NULL, res, code ) ;

}	/* ENODE *do_fnap( SYMB  *func,
		           ENODE *arglist ) */


TAC *do_lib( int   rtn,			 /* Routine to call */
	     SYMB *arg )		 /* Argument to pass */

/* PRINT items are handled by calls to library routines. These take as their
   argument the libary routine to call and the symbol to pass as argument.
   This routine constructs a call to a libary routine with a single argument.
*/

{
	TAC *a = mktac( TAC_ARG, arg, NULL, NULL ) ;
	TAC *c = mktac( TAC_CALL, NULL, (SYMB *)library[rtn], NULL ) ;

	c->prev = a ;

	return c ;

}	/* TAC *do_lib( int   rtn,
	   		SYMB *arg ) */


TAC *do_if( ENODE *expr,		 /* Condition */
	    TAC   *stmt )		 /* Statement to execute */

/* For convenience we have two routines to handle IF statements, "do_if()"
   where there is no ELSE part and "do_test()" where there is. We always
   allocate TAC_LABEL instructions, so that the destinations of all branches
   will appear as labels in the resulting TAC code. */

{
	TAC *label = mktac( TAC_LABEL, mklabel( next_label++ ), NULL, NULL ) ;
	TAC *code  = mktac( TAC_IFZ, (SYMB *)label, expr->res, NULL ) ;

	code->prev  = expr->tac ;
	code        = join_tac( code, stmt ) ;
	label->prev = code ;

	free_enode( expr ) ;		 /* Expression finished with */

	return label ;

}	/* TAC *do_if( ENODE *expr,
	    	       TAC   *stmt ) */


TAC *do_test( ENODE *expr,		 /* Condition */
	      TAC   *stmt1,		 /* THEN part */
	      TAC   *stmt2 )		 /* ELSE part */

/* Construct code for an if statement with else part */

{
	TAC *label1 = mktac( TAC_LABEL, mklabel( next_label++ ), NULL, NULL ) ;
	TAC *label2 = mktac( TAC_LABEL, mklabel( next_label++ ), NULL, NULL ) ;
	TAC *code1  = mktac( TAC_IFZ, (SYMB *)label1, expr->res, NULL ) ;
	TAC *code2  = mktac( TAC_GOTO, (SYMB *)label2, NULL, NULL ) ;

	code1->prev  = expr->tac ;		        /* Join the code */
	code1        = join_tac( code1, stmt1 ) ;
	code2->prev  = code1 ;
	label1->prev = code2 ;
	label1       = join_tac( label1, stmt2 ) ;
	label2->prev = label1 ;

	free_enode( expr ) ;		 /* Free the expression */

	return label2 ;

}	/* TAC *do_test( ENODE *expr,
	      		 TAC   *stmt1,
	      		 TAC   *stmt2 ) */


TAC *do_while( ENODE *expr,		 /* Condition */
	       TAC   *stmt )		 /* Body of loop */

/* Do a WHILE loop. This is the same as an IF statement with a jump back at the
   end. We bolt a goto on the end of the statement, call do_if to construct the
   code and join the start label right at the beginning */

{
	TAC *label = mktac( TAC_LABEL, mklabel( next_label++ ), NULL, NULL ) ;
	TAC *code  = mktac( TAC_GOTO, (SYMB *)label, NULL, NULL ) ;

	code->prev = stmt ;		 /* Bolt on the goto */

	return join_tac( label, do_if( expr, code )) ;

}	/* TAC *do_while( ENODE *expr,
	       		  TAC   *stmt ) */


ENODE *mkenode( ENODE *next,
		SYMB  *res,
		TAC   *code )

/* The routine to make an expression node. We put this here rather than with
   the other utilities in "main.c", since it is only used in the parser. */

{
	ENODE *expr = get_enode() ;

	expr->next = next ;
	expr->res  = res ;
	expr->tac  = code ;

	return expr ;

}	/* ENODE *mkenode( ENODE *next,
			   SYMB  *res,
			   TAC   *code ) */


void  yyerror( char *str )

/* The Yacc default error handler. This just calls our error handler */

{
	error( str ) ;

}	/* void  yyerror( char *str ) */
