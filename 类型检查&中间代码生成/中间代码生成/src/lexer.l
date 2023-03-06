%option noyywrap
%{
    #define YY_NO_UNPUT
    #define YY_NO_INPUT

    #include "parser.h"
    #include <ostream>
    #include <fstream>
    #include <iostream>
    #include <string>
    #include <math.h>
    using namespace std;

    extern FILE *yyin; 
    extern FILE *yyout;
    extern bool dump_tokens;

    void DEBUG_FOR_LAB4(std::string s){
        std::string DEBUG_INFO = "[DEBUG LAB4]: \t" + s + "\n";
        fputs(DEBUG_INFO.c_str(), yyout);
    }
%}


DECIMIAL ([1-9][0-9]*|0)
HEX (0x[1-9|A-F|a-f][0-9|A-F|a-f]*|0x0)
OCT (0[1-7][0-7]*|00)	
FDECIMIAL ([1-9][0-9]*|0)("."[0-9]*)?(("E"|"e")("+"|"-")?[0-9]+)?
ID [[:alpha:]_][[:alpha:][:digit:]_]*
EOL (\r\n|\n|\r)
WHITE [\t|" "]
COMMENTBEGIN "/*"
COMMENTELE .
COMMENTEOL \r\n|\n|\r
COMMENTEND "*/"
LINECOMMENT \/\/[^\n]*
%x BLOCKCOMMENT

%%
{COMMENTBEGIN} {BEGIN BLOCKCOMMENT;}
<BLOCKCOMMENT>{COMMENTELE} {}
<BLOCKCOMMENT>{COMMENTEOL} {yylineno++;}
<BLOCKCOMMENT>{COMMENTEND} {BEGIN INITIAL;}
"int" {
    /*
    * Questions: 
    *   Q1: Why we need to return INT in further labs?
    *   Q2: What is "INT" actually?
    */
    if(dump_tokens)
        DEBUG_FOR_LAB4("INT\tint");
    return INT;
}
"float" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("FLOAT\tfloat");
    return FLOAT;
}
"char" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("CHAR\tchar");
    return CHAR;
}
"void" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("VOID\tvoid");
    return VOID;
}
"while" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("WHILE\twhile");
    return WHILE;
}
"if" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("IF\tif");
    return IF;
};
"else" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ELSE\telse");
    return ELSE;
};
"return" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RETURN\treturn");
    return RETURN;
}
"const" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("CONST\tconst");
    return CONST;
}
"break" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("BREAK\tbreak");
    return BREAK;
}
"continue" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("CONTINUE\tcontinue");
    return CONTINUE;
}
"=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ASSIGN\t=");
    return ASSIGN;
}
"==" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("EQ\t==");
    return EQ;
}
"<=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LESSEQ\t<=");
    return LESSEQ;
}
">=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("MOREEQ\t>=");
    return MOREEQ;
}
"!=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("NOTEQ\t!=");
    return NOTEQ;
}
">" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("MORE\t>");
    return MORE;
}
"<" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LESS\t<");
    return LESS;
}
"+" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ADD\t+");
    return ADD;
}
"-" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("SUB\t-");
    return SUB;
}
"*" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("MUL\t*");
    return MUL;
}
"/" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("DIV\t/");
    return DIV;
}
"%" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("MOL\t%");
    return MOL;
}
"&" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("BITAND\t+");
    return ADD;
}
"|" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("BITOR\t+");
    return ADD;
}
"^" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("BITNOT\t+");
    return ADD;
}
"&&" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("AND\t&&");
    return AND;
}
"||" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("OR\t||");
    return OR;
}
"!" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("NOT\t!");
    return NOT;
}
";" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("SEMICOLON\t;");
    return SEMICOLON;
}
"," {
    if(dump_tokens)
        DEBUG_FOR_LAB4("COMMA\t,");
    return COMMA;
}
"(" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LPAREN\t(");
    return LPAREN;
}
")" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RPAREN\t)");
    return RPAREN;
}
"[" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LBRACKET\t[");
    return LBRACKET;
}
"]" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RBRACKET\t]");
    return RBRACKET;
}
"{" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LBRACE\t{");
    return LBRACE;
}
"}" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RBRACE\t}");
    return RBRACE;
}



{DECIMIAL} {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    yylval.itype = atoi(yytext);	//atoi() 把字符串转换成整型数
    return INTEGER;
}
{HEX} {
    if(dump_tokens)  
        DEBUG_FOR_LAB4(yytext);
    int all = 0;
    string a  = yytext;
    int len = a.length() - 2;
    for(int i = 0; i < len; i++)
    {
        int temp1 = (pow(16, (len - i - 1)));
        int temp2;
        if(a[i + 2] >= '0' && a[i + 2] <= '9'){
            temp2 = (a[i + 2] - '0');
        }
        else if(a[i + 2] >= 'A' && a[i + 2] <= 'F'){
            temp2 = a[i + 2] - 'A' + 10;
        }
        else if(a[i + 2] >= 'a' && a[i + 2] <= 'f'){
            temp2 = a[i + 2] - 'a' + 10;
        }
        all = all + temp1 * temp2;         
    }
    yylval.itype = all;
    return INTEGER;
}

{OCT} {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    string a  = yytext;
    int len = a.length() - 1;
    int all = 0;
    for(int i = 0; i < len; i++)
    {
        int temp1 = (pow(8, (len - i - 1)));
        int temp2 = (a[i + 1] - '0');
        all = all + temp1 * temp2;         
    }
    yylval.itype = all;
    return INTEGER;
} 
{FDECIMIAL} {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    string result = yytext;
    yylval.ftype = stof(result);
    return FLOATNUM;
}

{ID} {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    return ID;
}
{EOL} yylineno++;
{LINECOMMENT} {}
{WHITE}
%%
