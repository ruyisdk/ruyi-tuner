
/*  A Bison parser, made from vas.y  */


#line 1 "vas.y"

/******************************************************************************
*******************************************************************************


                         VV    VV    AAAA     SSSSSS 
                         VV    VV   AAAAAA   SSSSSSSS
                         VV    VV  AA    AA  SS      
                         VV    VV  AAAAAAAA  SSSSSSS 
                         VV    VV  AA    AA        SS
                          VV  VV   AA    AA        SS
                           VVVV    AA    AA  SSSSSSSS
                            VV     AA    AA   SSSSSS 


*******************************************************************************
*******************************************************************************

				 VAM Assember
				 ============

   A simple assembler for VAM

   Modifications:
   ==============

   10 Mar 89 JPB:  First version
    9 May 91 JPB:  '"' changed to '\"' for ANSI consistency.

*******************************************************************************
******************************************************************************/

#include <stdio.h>

#define  MAXLAB  0x1000			 /* Number of labels */

/* The instruction set */

#define  I_HALT	 0 			 /* End of program */
#define  I_NOP   1 			 /* Do nothing */
#define  I_TRAP  2 			 /* Output a character */
#define  I_ADD   3 			 /* ADD Rx,Ry */
#define  I_SUB   4 
#define  I_MUL   5 
#define  I_DIV   6 
#define  I_STI   7			 /* STI Rx,offset(Ry) */
#define  I_LDI   8 			 /* LDI offset(Rx),Ry */
#define  I_LDA   9 			 /* LDA offset(Rx),Ry */
#define  I_LDR   10 			 /* LDR Rx,Ry */
#define  I_BZE   11 			 /* BZE offset */
#define  I_BNZ   12 
#define  I_BRA   13
#define  I_BAL   14 			 /* BAL Rx,Ry */
#define  I_MAX   15

/* Global variables */

int  pass ;				 /* Which pass */
int  pc ;				 /* Program counter */
int  labtab[MAXLAB] ;			 /* Offsets for labels */


/* Subsequent routines */

char  *decode_args( int   argc,
		    char *argv[] ) ;

void  setup_files( char *ifile,
		   char *ofile ) ;

void  pbyte( int  n ) ;

void  pword( int  n ) ;


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

#ifndef YYSTYPE
#define YYSTYPE unsigned long
#endif
#include <stdio.h>

#ifndef __STDC__
#define const
#endif



#define	YYFINAL		276
#define	YYFLAG		-32768
#define	YYNTBASE	100

#define YYTRANSLATE(x) ((unsigned)(x) <= 257 ? yytranslate[x] : 146)

static const char yytranslate[] = {     0,
     2,     2,     2,     2,     2,     2,     2,     2,    16,    99,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
     2,    15,    72,    73,    74,    75,    76,    77,    78,    18,
    19,    91,    89,    17,    80,    96,    98,     5,     6,     7,
     8,     9,    10,    11,    12,    13,    14,     3,    90,    94,
    79,    95,    97,    84,    21,    30,    63,    27,    35,    64,
    65,    20,    32,    66,    67,     4,    31,    23,    24,    25,
    68,    26,    28,    22,    29,    33,    69,    70,    71,    34,
    86,    36,    93,    82,    88,    87,    37,    38,    39,    40,
    41,    42,    43,    44,    45,    46,    47,    48,    49,    50,
    51,    52,    53,    54,    55,    56,    57,    58,    59,    60,
    61,    62,    85,    83,    92,    81,     2,     2,     2,     2,
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
     2,     2,     2,     2,     2,     1,     2
};

static const short yyprhs[] = {     0,
     0,     2,     5,     8,    13,    20,    25,    28,    31,    33,
    35,    37,    39,    41,    43,    45,    47,    49,    51,    53,
    55,    58,    60,    62,    64,    66,    68,    70,    72,    74,
    76,    78,    80,    82,    84,    86,    88,    90,    92,    94,
    96,    98,   100,   106,   112,   118,   124,   133,   139,   148,
   154,   163,   169,   175,   179,   183,   187,   191,   195,   199,
   205,   209,   214,   218,   223,   227,   231,   235,   239,   243,
   247,   251,   255,   259,   263,   267,   271,   274,   277,   279,
   281,   284,   285,   288,   290,   292,   294,   296,   298,   300,
   302,   304,   306,   308,   310,   312,   314,   316,   318,   320,
   322,   324,   326,   328,   330,   332,   334,   336,   338,   340,
   342,   344,   346,   348,   350,   352,   354,   356,   358,   360,
   362,   364,   366,   368,   370,   372,   374,   376,   378,   380,
   382,   384,   386,   388,   390,   392,   394,   396,   398,   400,
   402,   404,   406,   408,   410,   412,   414,   416,   418,   420,
   422,   424,   426,   428,   430,   432,   434,   436,   438,   440,
   442,   444,   446,   448,   450,   452,   454,   456,   458,   460,
   462,   464,   466,   468,   470,   472,   474,   476,   478,   480
};

static const short yyrhs[] = {   101,
     0,   100,   101,     0,   142,   145,     0,   102,     3,   142,
   145,     0,   102,     3,   105,   107,   142,   145,     0,   105,
   107,   142,   145,     0,     4,   103,     0,   103,   104,     0,
   104,     0,     5,     0,     6,     0,     7,     0,     8,     0,
     9,     0,    10,     0,    11,     0,    12,     0,    13,     0,
    14,     0,   106,     0,   105,   106,     0,    15,     0,    16,
     0,   108,     0,   109,     0,   110,     0,   111,     0,   112,
     0,   113,     0,   114,     0,   115,     0,   116,     0,   117,
     0,   118,     0,   119,     0,   120,     0,   121,     0,   122,
     0,   123,     0,   124,     0,   125,     0,   126,     0,   127,
   105,   140,    17,   140,     0,   128,   105,   140,    17,   140,
     0,   129,   105,   140,    17,   140,     0,   130,   105,   140,
    17,   140,     0,   131,   105,   140,    17,   141,    18,   140,
    19,     0,   131,   105,   140,    17,   102,     0,   132,   105,
   141,    18,   140,    19,    17,   140,     0,   132,   105,   102,
    17,   140,     0,   133,   105,   141,    18,   140,    19,    17,
   140,     0,   133,   105,   102,    17,   140,     0,   134,   105,
   140,    17,   140,     0,   135,   105,   141,     0,   135,   105,
   102,     0,   136,   105,   141,     0,   136,   105,   102,     0,
   137,   105,   141,     0,   137,   105,   102,     0,   138,   105,
   140,    17,   140,     0,   139,   105,   103,     0,    20,    21,
     4,    22,     0,    23,    24,    25,     0,    22,    26,    21,
    25,     0,    21,    27,    27,     0,    28,    29,    30,     0,
    31,    29,     4,     0,    27,    32,    33,     0,    28,    22,
    32,     0,     4,    27,    32,     0,     4,    27,    21,     0,
     4,    27,    26,     0,    30,    34,    35,     0,    30,    23,
    34,     0,    30,    26,    21,     0,    30,    21,     4,     0,
    27,    30,     0,    26,   103,     0,   103,     0,   143,     0,
   105,   143,     0,     0,   143,   144,     0,    36,     0,   106,
     0,    37,     0,    38,     0,    39,     0,    40,     0,    41,
     0,    42,     0,    43,     0,    44,     0,    45,     0,    46,
     0,    47,     0,    48,     0,    49,     0,    50,     0,    51,
     0,    52,     0,    53,     0,    54,     0,    55,     0,    56,
     0,    57,     0,    58,     0,    59,     0,    60,     0,    61,
     0,    62,     0,    21,     0,    30,     0,    63,     0,    27,
     0,    35,     0,    64,     0,    65,     0,    20,     0,    32,
     0,    66,     0,    67,     0,     4,     0,    31,     0,    23,
     0,    24,     0,    25,     0,    68,     0,    26,     0,    28,
     0,    22,     0,    29,     0,    33,     0,    69,     0,    70,
     0,    71,     0,    34,     0,     5,     0,     6,     0,     7,
     0,     8,     0,     9,     0,    10,     0,    11,     0,    12,
     0,    13,     0,    14,     0,    72,     0,    73,     0,    74,
     0,    75,     0,    76,     0,    77,     0,    78,     0,    18,
     0,    19,     0,    79,     0,    80,     0,    81,     0,    82,
     0,    36,     0,    83,     0,    84,     0,    85,     0,    86,
     0,    87,     0,    88,     0,    89,     0,    90,     0,     3,
     0,    91,     0,    92,     0,    93,     0,    94,     0,    17,
     0,    95,     0,    96,     0,    97,     0,    98,     0,    99,
     0
};

#if YYDEBUG != 0
static const short yyrline[] = { 0,
    79,    80,    83,    84,    88,    92,    95,    98,   102,   105,
   106,   107,   108,   109,   110,   111,   112,   113,   114,   116,
   117,   120,   121,   124,   125,   126,   127,   128,   129,   130,
   131,   132,   133,   134,   135,   136,   137,   138,   139,   142,
   145,   148,   151,   158,   165,   172,   179,   185,   193,   199,
   207,   213,   221,   228,   233,   240,   245,   252,   257,   264,
   271,   277,   280,   283,   286,   289,   292,   295,   298,   301,
   304,   307,   310,   313,   316,   319,   322,   325,   328,   331,
   332,   333,   336,   337,   340,   341,   342,   343,   344,   345,
   346,   347,   348,   349,   350,   351,   352,   353,   354,   355,
   356,   357,   358,   359,   360,   361,   362,   363,   364,   365,
   366,   367,   368,   369,   370,   371,   372,   373,   374,   375,
   376,   377,   378,   379,   380,   381,   382,   383,   384,   385,
   386,   387,   388,   389,   390,   391,   392,   393,   394,   395,
   396,   397,   398,   399,   400,   401,   402,   403,   404,   405,
   406,   407,   408,   409,   410,   411,   412,   413,   414,   415,
   416,   417,   418,   419,   420,   421,   422,   423,   424,   425,
   426,   427,   428,   429,   430,   431,   432,   433,   434,   437
};

static const char * const yytname[] = {   "$",
"error","$illegal.","':'","'L'","'0'","'1'","'2'","'3'","'4'","'5'",
"'6'","'7'","'8'","'9'","' '","'\\t'","','","'('","')'","'H'",
"'A'","'T'","'N'","'O'","'P'","'R'","'D'","'S'","'U'","'B'",
"'M'","'I'","'V'","'Z'","'E'","'\\\\'","'a'","'b'","'c'","'d'",
"'e'","'f'","'g'","'h'","'i'","'j'","'k'","'l'","'m'","'n'",
"'o'","'p'","'q'","'r'","'s'","'t'","'u'","'v'","'w'","'x'",
"'y'","'z'","'C'","'F'","'G'","'J'","'K'","'Q'","'W'","'X'",
"'Y'","'!'","'\"'","'#'","'$'","'%'","'&'","'\\''","'='","'-'",
"'~'","'^'","'|'","'@'","'{'","'['","'`'","'_'","'+'","';'",
"'*'","'}'","']'","'<'","'>'","'.'","'?'","'/'","'\\n'","program",
"statement","label","number","digit","ws","separator","instruction","halt_instr","nop_instr","trap_instr",
"add_instr","sub_instr","mul_instr","div_instr","sti_instr","ldi_instr","lda_instr","ldr_instr","bze_instr","bnz_instr",
"bra_instr","bal_instr","db_instr","halt_op","nop_op","trap_op","add_op","sub_op","mul_op","div_op",
"sti_op","ldi_op","lda_op","ldr_op","bze_op","bnz_op","bra_op","bal_op","db_op","reg",
"offset","comment","text_comment","char","return",""
};
#endif

static const short yyr1[] = {     0,
   100,   100,   101,   101,   101,   101,   102,   103,   103,   104,
   104,   104,   104,   104,   104,   104,   104,   104,   104,   105,
   105,   106,   106,   107,   107,   107,   107,   107,   107,   107,
   107,   107,   107,   107,   107,   107,   107,   107,   107,   108,
   109,   110,   111,   112,   113,   114,   115,   115,   116,   116,
   117,   117,   118,   119,   119,   120,   120,   121,   121,   122,
   123,   124,   125,   126,   127,   128,   129,   130,   131,   132,
   133,   134,   135,   136,   137,   138,   139,   140,   141,   142,
   142,   142,   143,   143,   144,   144,   144,   144,   144,   144,
   144,   144,   144,   144,   144,   144,   144,   144,   144,   144,
   144,   144,   144,   144,   144,   144,   144,   144,   144,   144,
   144,   144,   144,   144,   144,   144,   144,   144,   144,   144,
   144,   144,   144,   144,   144,   144,   144,   144,   144,   144,
   144,   144,   144,   144,   144,   144,   144,   144,   144,   144,
   144,   144,   144,   144,   144,   144,   144,   144,   144,   144,
   144,   144,   144,   144,   144,   144,   144,   144,   144,   144,
   144,   144,   144,   144,   144,   144,   144,   144,   144,   144,
   144,   144,   144,   144,   144,   144,   144,   144,   144,   145
};

static const short yyr2[] = {     0,
     1,     2,     2,     4,     6,     4,     2,     2,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     2,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     5,     5,     5,     5,     8,     5,     8,     5,
     8,     5,     5,     3,     3,     3,     3,     3,     3,     5,
     3,     4,     3,     4,     3,     3,     3,     3,     3,     3,
     3,     3,     3,     3,     3,     3,     2,     2,     1,     1,
     2,     0,     2,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1,
     1,     1,     1,     1,     1,     1,     1,     1,     1,     1
};

static const short yydefact[] = {    82,
     0,    22,    23,    84,    82,     1,     0,     0,    20,     0,
    80,    10,    11,    12,    13,    14,    15,    16,    17,    18,
    19,     7,     9,     2,    82,     0,     0,     0,     0,     0,
     0,     0,     0,     0,    21,    82,    24,    25,    26,    27,
    28,    29,    30,    31,    32,    33,    34,    35,    36,    37,
    38,    39,    40,    41,    42,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,    81,   180,
     3,   170,   123,   138,   139,   140,   141,   142,   143,   144,
   145,   146,   147,   175,   155,   156,   119,   112,   131,   125,
   126,   127,   129,   115,   130,   132,   113,   124,   120,   133,
   137,   116,   161,    86,    87,    88,    89,    90,    91,    92,
    93,    94,    95,    96,    97,    98,    99,   100,   101,   102,
   103,   104,   105,   106,   107,   108,   109,   110,   111,   114,
   117,   118,   121,   122,   128,   134,   135,   136,   148,   149,
   150,   151,   152,   153,   154,   157,   158,   159,   160,   162,
   163,   164,   165,   166,   167,   168,   169,   171,   172,   173,
   174,   176,   177,   178,   179,    85,    83,     8,     0,     0,
     0,     0,     0,     0,     0,    77,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     0,     0,     0,     0,     0,     0,     0,    82,
     4,    71,    72,    70,     0,    65,     0,    63,    68,    69,
    66,    76,    74,    75,    73,    67,     6,     0,     0,     0,
     0,     0,     0,     0,    79,     0,     0,     0,     0,    55,
    54,    57,    56,    59,    58,     0,    61,     0,    62,    64,
    78,     0,     0,     0,     0,     0,     0,     0,     0,     0,
     0,     0,     5,    43,    44,    45,    46,    48,     0,    50,
     0,    52,     0,    53,    60,     0,     0,     0,     0,     0,
     0,    47,    49,    51,     0,     0
};

static const short yydefgoto[] = {     5,
     6,     7,   225,    23,     8,     9,    36,    37,    38,    39,
    40,    41,    42,    43,    44,    45,    46,    47,    48,    49,
    50,    51,    52,    53,    54,    55,    56,    57,    58,    59,
    60,    61,    62,    63,    64,    65,    66,    67,    68,   219,
   226,    10,    11,   167,    71
};

static const short yypact[] = {    13,
   160,-32768,-32768,-32768,     4,-32768,    28,    89,-32768,   -47,
   217,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,   160,-32768,-32768,    -1,    27,    32,    29,    33,    37,
   -14,    26,    24,    48,-32768,    -1,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,    21,    21,    21,    21,    21,
    21,    21,    21,    21,    21,    21,    21,    21,   217,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,    89,   -47,
    25,    58,    55,    68,    66,-32768,    61,    63,    67,    92,
    64,    78,    65,    97,    -1,   -47,    -3,    -3,    -3,    -3,
    -3,   122,   122,    -3,   122,   122,   122,    -3,   134,    -1,
-32768,-32768,-32768,-32768,    81,-32768,    83,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,   160,    96,    98,
   101,   104,   105,   106,   160,   144,   107,   157,   159,-32768,
-32768,-32768,-32768,-32768,-32768,   161,   160,   -47,-32768,-32768,
   160,    88,    88,    88,    88,   147,    88,    88,    88,    88,
    88,    88,-32768,-32768,-32768,-32768,-32768,-32768,   176,-32768,
   158,-32768,   178,-32768,-32768,    88,   181,   183,   182,    88,
    88,-32768,-32768,-32768,   195,-32768
};

static const short yypgoto[] = {-32768,
   197,  -186,     0,   -22,     8,    -6,    35,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,
-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,-32768,  -164,
  -154,    -4,    -5,-32768,  -148
};


#define	YYLAST		315


static const short yytable[] = {   168,
    22,    35,    69,   275,   166,   224,   227,     1,   230,   232,
   234,     2,     3,     2,     3,   176,     1,   177,     2,     3,
   170,   201,   218,   220,   221,   222,   223,     2,     3,   229,
    25,   186,   169,   236,     4,     2,     3,   217,   228,     4,
   231,   233,   235,   185,   180,   202,   181,   178,     4,   182,
   203,    70,   172,   171,   179,   173,   204,   183,   174,   258,
   175,   205,   166,   187,   188,   189,   190,   191,   192,   193,
   194,   195,   196,   197,   198,   199,   184,   254,   255,   256,
   257,   206,   260,   261,   262,   263,   264,   265,   207,   253,
   208,   259,    26,   209,   210,   212,   211,   213,   214,   215,
   216,   269,   239,     2,     3,   273,   274,   240,    27,    28,
    29,    30,   242,   218,   243,    31,    32,   244,    33,    34,
   245,   246,   247,   249,     4,     1,    12,    13,    14,    15,
    16,    17,    18,    19,    20,    21,     2,     3,    12,    13,
    14,    15,    16,    17,    18,    19,    20,    21,     2,     3,
     1,    12,    13,    14,    15,    16,    17,    18,    19,    20,
    21,   248,    35,    69,    12,    13,    14,    15,    16,    17,
    18,    19,    20,    21,   250,   251,   267,   252,    35,    69,
    35,    35,    35,    35,    35,    35,    35,    35,    35,    35,
    35,    35,    35,   266,   276,   238,   268,   270,   237,   271,
   272,    24,   168,   200,     0,     0,     0,   185,     0,     0,
     0,     0,     0,     0,   168,     0,     0,   241,   168,    72,
    73,    74,    75,    76,    77,    78,    79,    80,    81,    82,
    83,     2,     3,    84,    85,    86,    87,    88,    89,    90,
    91,    92,    93,    94,    95,    96,    97,    98,    99,   100,
   101,   102,   103,   104,   105,   106,   107,   108,   109,   110,
   111,   112,   113,   114,   115,   116,   117,   118,   119,   120,
   121,   122,   123,   124,   125,   126,   127,   128,   129,   130,
   131,   132,   133,   134,   135,   136,   137,   138,   139,   140,
   141,   142,   143,   144,   145,   146,   147,   148,   149,   150,
   151,   152,   153,   154,   155,   156,   157,   158,   159,   160,
   161,   162,   163,   164,   165
};

static const short yycheck[] = {    22,
     1,     8,     8,     0,    11,   192,   193,     4,   195,   196,
   197,    15,    16,    15,    16,    30,     4,    32,    15,    16,
    25,   170,    26,   188,   189,   190,   191,    15,    16,   194,
     3,    36,    25,   198,    36,    15,    16,   186,   193,    36,
   195,   196,   197,    36,    21,    21,    23,    22,    36,    26,
    26,    99,    21,    27,    29,    27,    32,    34,    26,   246,
    24,     4,    69,    56,    57,    58,    59,    60,    61,    62,
    63,    64,    65,    66,    67,    68,    29,   242,   243,   244,
   245,    27,   247,   248,   249,   250,   251,   252,    21,   238,
    25,   246,     4,    33,    32,     4,    30,    34,    21,    35,
     4,   266,    22,    15,    16,   270,   271,    25,    20,    21,
    22,    23,    17,    26,    17,    27,    28,    17,    30,    31,
    17,    17,    17,    17,    36,     4,     5,     6,     7,     8,
     9,    10,    11,    12,    13,    14,    15,    16,     5,     6,
     7,     8,     9,    10,    11,    12,    13,    14,    15,    16,
     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
    14,    18,   169,   169,     5,     6,     7,     8,     9,    10,
    11,    12,    13,    14,    18,    17,    19,    17,   185,   185,
   187,   188,   189,   190,   191,   192,   193,   194,   195,   196,
   197,   198,   199,    18,     0,   200,    19,    17,   199,    17,
    19,     5,   225,   169,    -1,    -1,    -1,   200,    -1,    -1,
    -1,    -1,    -1,    -1,   237,    -1,    -1,   218,   241,     3,
     4,     5,     6,     7,     8,     9,    10,    11,    12,    13,
    14,    15,    16,    17,    18,    19,    20,    21,    22,    23,
    24,    25,    26,    27,    28,    29,    30,    31,    32,    33,
    34,    35,    36,    37,    38,    39,    40,    41,    42,    43,
    44,    45,    46,    47,    48,    49,    50,    51,    52,    53,
    54,    55,    56,    57,    58,    59,    60,    61,    62,    63,
    64,    65,    66,    67,    68,    69,    70,    71,    72,    73,
    74,    75,    76,    77,    78,    79,    80,    81,    82,    83,
    84,    85,    86,    87,    88,    89,    90,    91,    92,    93,
    94,    95,    96,    97,    98
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

case 4:
#line 85 "vas.y"
{
			labtab[yyvsp[-3]] = pc ;
		;
    break;}
case 5:
#line 89 "vas.y"
{
			labtab[yyvsp[-5]] = pc ;
		;
    break;}
case 7:
#line 95 "vas.y"
{ yyval = yyvsp[0] ; ;
    break;}
case 8:
#line 99 "vas.y"
{
			yyval = yyvsp[-1] * 10 + yyvsp[0] ;
		;
    break;}
case 10:
#line 105 "vas.y"
{ yyval = 0x0 ; ;
    break;}
case 11:
#line 106 "vas.y"
{ yyval = 0x1 ; ;
    break;}
case 12:
#line 107 "vas.y"
{ yyval = 0x2 ; ;
    break;}
case 13:
#line 108 "vas.y"
{ yyval = 0x3 ; ;
    break;}
case 14:
#line 109 "vas.y"
{ yyval = 0x4 ; ;
    break;}
case 15:
#line 110 "vas.y"
{ yyval = 0x5 ; ;
    break;}
case 16:
#line 111 "vas.y"
{ yyval = 0x6 ; ;
    break;}
case 17:
#line 112 "vas.y"
{ yyval = 0x7 ; ;
    break;}
case 18:
#line 113 "vas.y"
{ yyval = 0x8 ; ;
    break;}
case 19:
#line 114 "vas.y"
{ yyval = 0x9 ; ;
    break;}
case 40:
#line 142 "vas.y"
{ pbyte( I_HALT ) ; ;
    break;}
case 41:
#line 145 "vas.y"
{ pbyte( I_NOP ) ; ;
    break;}
case 42:
#line 148 "vas.y"
{ pbyte( I_TRAP ) ; ;
    break;}
case 43:
#line 152 "vas.y"
{
			pbyte( I_ADD ) ;
			pbyte( (yyvsp[-2] << 4) | yyvsp[0] ) ;
		;
    break;}
case 44:
#line 159 "vas.y"
{
			pbyte( I_SUB ) ;
			pbyte( (yyvsp[-2] << 4) | yyvsp[0] ) ;
		;
    break;}
case 45:
#line 166 "vas.y"
{
			pbyte( I_MUL ) ;
			pbyte( (yyvsp[-2] << 4) | yyvsp[0] ) ;
		;
    break;}
case 46:
#line 173 "vas.y"
{
			pbyte( I_DIV ) ;
			pbyte( (yyvsp[-2] << 4) | yyvsp[0] ) ;
		;
    break;}
case 47:
#line 180 "vas.y"
{
			pbyte( I_STI ) ;
			pbyte( (yyvsp[-5] << 4) | yyvsp[-1] ) ;
			pword( yyvsp[-3] ) ;
		;
    break;}
case 48:
#line 186 "vas.y"
{
			pbyte( I_STI ) ;
			pbyte( yyvsp[-2] << 4 ) ;
			pword( labtab[yyvsp[0]] ) ;
		;
    break;}
case 49:
#line 194 "vas.y"
{
			pbyte( I_LDI ) ;
			pbyte( (yyvsp[-3] << 4) | yyvsp[0] ) ;
			pword( yyvsp[-5] ) ;
		;
    break;}
case 50:
#line 200 "vas.y"
{
			pbyte( I_LDI ) ;
			pbyte( yyvsp[0] ) ;
			pword( labtab[yyvsp[-2]] ) ;
		;
    break;}
case 51:
#line 208 "vas.y"
{
			pbyte( I_LDA ) ;
			pbyte( (yyvsp[-3] << 4) | yyvsp[0] ) ;
			pword( yyvsp[-5] ) ;
		;
    break;}
case 52:
#line 214 "vas.y"
{
			pbyte( I_LDA ) ;
			pbyte( yyvsp[0] ) ;
			pword( labtab[yyvsp[-2]] ) ;
		;
    break;}
case 53:
#line 222 "vas.y"
{
			pbyte( I_LDR ) ;
			pbyte( (yyvsp[-2] << 4) | yyvsp[0] ) ;
		;
    break;}
case 54:
#line 229 "vas.y"
{
			pbyte( I_BZE ) ;
			pword( yyvsp[0] ) ;
		;
    break;}
case 55:
#line 234 "vas.y"
{
			pbyte( I_BZE ) ;
			pword( labtab[yyvsp[0]] - pc + 1 ) ;
		;
    break;}
case 56:
#line 241 "vas.y"
{
			pbyte( I_BNZ ) ;
			pword( yyvsp[0] ) ;
		;
    break;}
case 57:
#line 246 "vas.y"
{
			pbyte( I_BNZ ) ;
			pword( labtab[yyvsp[0]] - pc + 1 ) ;
		;
    break;}
case 58:
#line 253 "vas.y"
{
			pbyte( I_BRA ) ;
			pword( yyvsp[0] ) ;
		;
    break;}
case 59:
#line 258 "vas.y"
{
			pbyte( I_BRA ) ;
			pword( labtab[yyvsp[0]] - pc + 1 ) ;
		;
    break;}
case 60:
#line 265 "vas.y"
{
			pbyte( I_BAL ) ;
			pbyte( (yyvsp[-2] << 4) | yyvsp[0] ) ;
		;
    break;}
case 61:
#line 272 "vas.y"
{
			pbyte( yyvsp[0] ) ;
		;
    break;}
case 78:
#line 325 "vas.y"
{ yyval = yyvsp[0] ; ;
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
#line 440 "vas.y"


void  main( int   argc,
	    char *argv[] )

/* Takes a single argument, the file to assemble, which must end in ".vas".
   Send the output to the corresponding file, but ending in ".vam". */

{
	char *ifile ;
	char *ofile ;

	/* Decode the arguments, and setup stdin and stdout accordingly */

	ofile = decode_args( argc, argv ) ;
	ifile = argv[1] ;			/* Do after decode has checked
						   number of file is OK */
	setup_files( ifile, ofile ) ;

	/* First pass sets up labels */

	pass = 1 ;
	yyparse() ;

	/* Second pass generates code */

	rewind( stdin ) ;
	pc   = 0 ;
	pass = 2 ;
	yyparse() ;

}	/* void  main( void ) */


char  *decode_args( int   argc,
		    char *argv[] )

/* There should be a single argument, ending in ".vas". Construct a result
   ending in ".vam". */

{
  	char *ofile ;			/* Constructed output file */
	int   len ;			/* Length of input file */

	/* Should be a single argument */

	if( argc != 2 )
	{
	  	fprintf( stderr, "vas: single argument expected\n" ) ;
		exit( 0 ) ;
	}

	/* Find suffix, which must be ".vas" */

	len = strlen( argv[1] ) - strlen( ".vas" ) ;

	if( (len < 1) || (strcmp( argv[1] + len, ".vas" ) != 0) )
	{
	  	fprintf( stderr, "vas: source file must end in \".vas\".\n" ) ;
		exit( 0 ) ;
	}

	/* Allocate for ofile */

	ofile = (char *)malloc( len + strlen( ".vas" ) + 1 ) ;

	if( ofile == NULL )
	{
	  	fprintf( stderr, "vas: decode_args: malloc failed\n" ) ;
		exit( 0 ) ;
	}

	/* Construct the new output file */

	strncpy( ofile, argv[1], len + 1 ) ;	/* Root + '.' */
	strcat( ofile, "vam" ) ;

	return  ofile ;

}	/* decode_args() */


void  setup_files( char *ifile,
		   char *ofile )

/* Substitute the given files for stdin and stdout, remembering that stdout
   should be a binary file */

{
  	/* Input is text. This is the default for DJGPP anyway */

  	if( freopen( ifile, "r", stdin ) == NULL )
	{
	  	perror( "vas: setup_files: freopen( ifile )" ) ;
		exit( 0 ) ;
	}

	/* Output is binary. Force this for DOS using DJGPP with the b flag to
	   freopen. */

#ifdef DJGPP
  	if( freopen( ofile, "wb", stdout ) == NULL )
#else
  	if( freopen( ofile, "w", stdout ) == NULL )
#endif
	{
	  	perror( "vas: setup_files: freopen( ofile )" ) ;
		exit( 0 ) ;
	}

}	/* setup_files() */


int  yylex( void )
{
	return getchar() ;

}	/* int  yylex( void ) */


int   yyerror( char *s )

{
	fprintf( stderr, "yyerror: %s\n", s ) ;
	return  0 ;

}	/* void  yyerror( char *s ) */


void  pbyte( int  n )

/* Put out the single byte n (on pass 2), advancing pc */

{
	if( pass == 2 )
		putchar( n ) ;

	pc++ ;

}	/* void  pbyte( int  n ) */


void  pword( int  n )

/* Put out the word n (on pass 2), advancing pc */

{
	if( pass == 2 )
	{
		putchar( n >> 24 ) ;
		putchar( n >> 16 ) ;
		putchar( n >>  8 ) ;
		putchar( n       ) ;
	}

	pc += 4 ;

}	/* void  pword( int  n ) */
