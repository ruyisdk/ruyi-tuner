This is the distribution directory with the source files for the vc compiler
for VSL, the vas assembler and the VAM interpreter. A make file is provided for
each of these systems, so for example to make the vc compiler use the command

   make -f Makefile-vc

All three make files assume the use of an ANSI C compiler. I have used the GNU
C compiler, gcc, on a SUN-4/260 in developing this system. You may need to edit
the make files if you are using a different compiler (change all occurrences of
gcc to the name of your compiler).

The compiler and assembler are both implemented as filters. The interpreter
takes a single argument, which is the file to interpret.

Recommended usage is thus something like:

   vc < file.vsl > file.vas
   vas < file.vas > file.vam
   vam -t file.vam > file.trace.output

The vc code generator picks up standard prologue and library files. The
directory where these are found is set by the line

   #define  LIB_DIR  "/home/jpb/book/distrib/"  /* Library directory */

in vc.h. This should be modified to refer to the directory with the vc source.
Note the / at the end.

Finally some ANSI compilers are likely to need #include <stdlib.h> in
appropriate places.

For reference you may like to note that the minimal VSL program is:

   FUNC main ()
   {
           CONTINUE
   }


The files in this directory are as follows:

BUGS             Reported bugs
CORRECTIONS      Known corrections in the text of the book
HELP             Instructions on how to obtain these files by Email
INDEX            Index of files available
Makefile-vam     Make file for the VAM interpreter
Makefile-vas     Make file for the vas assembler
Makefile-vc      Make file for the vc compiler
README           This file
all.shar         Shell archive of all vc, vas and vam files
cg.c             ANSI C code generator for the vc compiler
header           VAM Header for compiled VSL
lib              VAM Library for compiled VSL
main.c           ANSI C driver routines for the vc compiler
opt-1.shar       opt.shar split into 2 smaller pieces for mailers that
opt-2.shar       don't like files over 100K
opt-ex.shar      Examples for the optimiser
opt.shar         Shell archive of optimising code generator
parser.y         YACC parser for the vc compiler
scanner.l        LEX scanner for the vc compiler
vam.c            ANSI C source for the VAM interpreter
vam.doc          Documentation for the VAM interpreter
vas.y            YACC source for the VAS assembler
vc.h             C Header for the vc compiler

These files are available in the UK by Email from the School of Mathematical
Sciences at Bath University. To find out how to obtain them send a message to
jpb=compiler-request@uk.ac.bath.maths with two lines as follows:

   help:
   end:

These files are supplied strictly on an "as is" basis. I am always pleased to
hear about bugs and suggested improvements, but make no promises about fixing
them. Please send any comments/questions you may have electronically to
jpb=compiler-bugs@uk.ac.bath.maths

The optimiser (added spring 1991) was written as a final year dissertation by
Jonathan R Johnson of Carleton University, USA. My thanks for his efforts. The
shell archives (opt.shar and opt-ex.shar) include the modified files. Any
questions about this optimiser should be sent to him direct,
johnsonj@mathcs.carleton.edu

The VAX MACRO code generator (added summer 1991) was written by Ken Schweller
of Buena Vista College, Iowa. My thanks also for his work. The shell archive
(vaxmacro.shar) includes all the modified files. Any questions about this code
generator should be sent to him direct, schweller@bvc.edu

There is also now an experimental anonymous ftp service from
axiom.maths.bath.ac.uk where the files may be found in the directory
pub/comp-tech/jpb-book.

Happy programming,

Jeremy Bennett                          Tel:   (0225) 826891
School of Mathematical Sciences         Telex: 449097 UOBATH G
University of Bath                      Fax:   (0225) 826492 (Group 3)
Bath, BA2 7AY                           Email: jpb@uk.ac.bath.maths
