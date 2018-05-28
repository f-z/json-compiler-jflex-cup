package JSONCompiler;

import java_cup.runtime.SymbolFactory;

/*
JFLEX specification for JSON (w/ actions)
*/
%%
%cup
%class Scanner
%{
	public Scanner(java.io.InputStream r, SymbolFactory sf){
		this(r);
		this.sf=sf;
	}
	private SymbolFactory sf;
%}
%eofval{
    return sf.newSymbol("EOF",sym.EOF);
%eofval}

/* Macros */
WHITESPACE  = [\ \t\n\r\f]+

/*
LETTER = [A-Za-z]
DIGIT = [0-9]
ASCII_PUNCT = [\.,-\/!#$%&\'()*+,-:;<=>?@\[\]\^_`{}~]
SPACE = " "

STRING = "\""({LETTER}|{ASCII_PUNCT}|{DIGIT}|{SPACE})*"\""

CHARACTER = {LETTER}|{ASCII_PUNCT}|{DIGIT}|{SPACE}
*/

%%

<YYINITIAL>{
// String literals
"\""([^\"\\\b\f\n\r\t\uFFFF])*"\"" { return sf.newSymbol("String",sym.STR, new String(yytext())); } // or {STRING}

// Numbers
-?(0|([1-9][0-9]*))([\.][0-9]+)?([eE][+-]?[0-9]+)? { return sf.newSymbol("Number",sym.NUM, new String(yytext())); }

// Boolean literals
true | false { return sf.newSymbol("Bool Constant",sym.BOOL, new String(yytext())); }
// Null literal
null { return sf.newSymbol("Null",sym.NULL, new String(yytext())); }

// Separators
"," { return sf.newSymbol("Comma",sym.COMMA); }
":" { return sf.newSymbol("Colon",sym.COLON); }
"[" { return sf.newSymbol("Left Square Bracket",sym.LSQBRACKET); }
"]" { return sf.newSymbol("Right Square Bracket",sym.RSQBRACKET); }
"{" { return sf.newSymbol("Left Curly Bracket", sym.LCUBRACKET); }
"}" { return sf.newSymbol("Right Curly Bracket", sym.RCUBRACKET); }

// Whitespace
{WHITESPACE} { /* Ignore extra whitespace */ }

// Illegal characters
. { System.err.println("Illegal character: "+yytext()); }

/*
// These are actually not necessary
[eE]([\+\-][0-9]+|[0-9]*)? { return sf.newSymbol("Exponent",sym.EXP); }
[eE][+-]? { return sf.newSymbol("E",sym.E); }

"."[0-9]+ { return sf.newSymbol("Fractional",sym.FRAC); }
[0] | [-?][1-9]+ { return sf.newSymbol("Integer",sym.INT); }
[0-9] { return sf.newSymbol("Digit",sym.DIG); }
[1-9] { return sf.newSymbol("Digit 1-9",sym.DIG19); }
{CHARACTER} { return sf.newSymbol("Character",sym.CHAR); }
*/
}
