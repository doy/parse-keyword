#include "EXTERN.h"
#include "perl.h"
#include "callparser1.h"
#include "XSUB.h"

static OP *parser_callback(pTHX_ GV *namegv, SV *psobj, U32 *flagsp)
{
    dSP;
    SV *args_generator;

    // call the parser callback
    // it should take no arguments and return a coderef which, when called,
    // produces the arguments to the keyword function
    // the optree we want to generate is for something like
    //   mykeyword($code->())
    // where $code is the thing returned by the parser function

    PUSHMARK(SP);
    call_sv(psobj, G_SCALAR);
    SPAGAIN;
    args_generator = SvREFCNT_inc(POPs);
    PUTBACK;

    if (!SvROK(args_generator) || SvTYPE(SvRV(args_generator)) != SVt_PVCV) {
        croak("The parser function for %s must return a coderef, not %"SVf,
              GvNAME(namegv), args_generator);
    }

    return newUNOP(OP_ENTERSUB, OPf_STACKED,
                   newCVREF(0,
                            Perl_scalar(newSVOP(OP_CONST, 0,
                                                args_generator))));
}

// we will need helper functions for
// - lexer functions
//   - lex_read_space
//   - lex_peek_unichar
//   - lex_stuff_sv
// - parser functions (OP* return values should become coderefs)
//   - parse_arithexpr
//   - parse_barestmt
//   - parse_block
//   - parse_fullexpr
//   - parse_fullstmt
//   - parse_label
//   - parse_listexpr
//   - parse_stmtseq
//   - parse_termexpr
// - random other things
//   - "read a variable name"
//   - "read a quoted string"
//   - "create a new lexical variable" (should return a reference to it)

MODULE = Parse::Keyword  PACKAGE = Parse::Keyword

PROTOTYPES: DISABLE

void
install_keyword_handler(keyword, handler)
    SV *keyword
    SV *handler
  CODE:
    cv_set_call_parser((CV*)SvRV(keyword), parser_callback, handler);
