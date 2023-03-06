%option noyywrap
%{
    #define YY_NO_UNPUT
    #define YY_NO_INPUT
    
    #include "parser.h"
    #include <ostream>
    #include <fstream>
    #include <iostream>
    #include <math.h>
    using namespace std;
    
    extern FILE *yyin; 
    extern FILE *yyout;
    extern bool dump_tokens;
    int chars = 0;
    
    void DEBUG_FOR_LAB4(std::string s){
        std::string DEBUG_INFO = "[DEBUG LAB4]: \t" + s + "\n";
        fputs(DEBUG_INFO.c_str(), yyout);
    }
    #include <iostream>
%}

DECIMIAL ([1-9][0-9]*|0)
FDECIMAL ((([0-9]*[.][0-9]*([eE][+-]?[0-9]+)?)|([0-9]+[eE][+-]?[0-9]+))[fLlL]?)
OCT (0[1-7][0-7]*|00)
HEX (0x[1-9|A-F|a-f][0-9|A-F|a-f]*|0x0)
ID [[:alpha:]_][[:alpha:][:digit:]_]*
EOL (\r\n|\n|\r)
WHITE [\t ]
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
    if(dump_tokens)
        DEBUG_FOR_LAB4("INT\tint");
    return INT;
}
"float" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("FLOAT\tfloat");
    //chars += strlen("float");
    return FLOAT;
}
"void" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("VOID\tvoid");
    return VOID;
}
"const" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("CONST\tconst");
    return CONST;
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
"while" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("WHILE\twhile");
    return WHILE;
}
"continue" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("CONTINUE\tcontinue");
    return CONTINUE;
}
"break" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("BREAK\tbreak");
    return BREAK;
}
"return" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RETURN\treturn");
    return RETURN;
}
"==" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("EQ\t==");
    return EQ;
}
"!=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("NOTEQ\t!=");
    return NOTEQ;
}
"=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("ASSIGN\t=");
    return ASSIGN;
}
"<" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LESS\t<");
    return LESS;
}
"<=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LESSEQ\t<=");
    return LESSEQ;
}
">" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("MORE\t>");
    return MORE;
}
">=" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("MOREEQ\t>=");
    return MOREEQ;
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
"!" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("NOT\t!");
    return NOT;
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
        DEBUG_FOR_LAB4("MOD\t%");
    return MOD;
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
"," {
    if(dump_tokens)
        DEBUG_FOR_LAB4("COMMA\t,");
    return COMMA;
}
";" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("SEMICOLON\t;");
    return SEMICOLON;
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
"{" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("LBRACE\t{");
    return LBRACE;
}
"}" {
    if(dump_tokens)
        DEBUG_FOR_LAB4("RPAREN\t)");
    return RBRACE;
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
{DECIMIAL} {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    chars += strlen(yytext);
    yylval.itype = atoi(yytext);
    return INTEGER;
}
{FDECIMAL} {
    float temp;
    sscanf(yytext, "%f", &temp);
    if (dump_tokens)
        DEBUG_FOR_LAB4(string("NUMBER\t") + to_string(temp));
    //yylval.numtype = (double)temp;
    string result = yytext;
    yylval.ftype = stof(result);
    return FLOATNUM;
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

"putint" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec1;
    vec.push_back(TypeSystem::intType);
    Type* funcType = new FunctionType(TypeSystem::voidType, vec,vec1);
    SymbolTable* st = identifiers;
    while(st->getPrev())
        st = st->getPrev();
    SymbolEntry* se = new IdentifierSymbolEntry(funcType, yytext, st->getLevel(), -1, true);
    st->install(yytext, se);
    return ID;
}

"getint" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec1;
    Type* funcType = new FunctionType(TypeSystem::intType, vec,vec1);
    SymbolTable* st = identifiers;
    while(st->getPrev())
        st = st->getPrev();
    SymbolEntry* se = new IdentifierSymbolEntry(funcType, yytext, st->getLevel(), -1, true);
    st->install(yytext, se);
    return ID;
}
"putch" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec1;
    vec.push_back(TypeSystem::intType);
    Type* funcType = new FunctionType(TypeSystem::voidType, vec,vec1);
    SymbolTable* st = identifiers;
    while(st->getPrev())
        st = st->getPrev();
    SymbolEntry* se = new IdentifierSymbolEntry(funcType, yytext, st->getLevel(), -1, true);
    st->install(yytext, se);
    return ID;
}
"getch" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec1;
    Type* funcType = new FunctionType(TypeSystem::intType, vec,vec1);
    SymbolTable* st = identifiers;
    while(st->getPrev())
        st = st->getPrev();
    SymbolEntry* se = new IdentifierSymbolEntry(funcType, yytext, st->getLevel(), -1, true);
    st->install(yytext, se);
    return ID;
}
"putfloat" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec1;
    vec.push_back(TypeSystem::floatType);
    Type* funcType = new FunctionType(TypeSystem::voidType, vec, vec1);
    SymbolTable* st = identifiers;
    while(st->getPrev())
        st = st->getPrev();
    SymbolEntry* se = new IdentifierSymbolEntry(funcType, yytext, st->getLevel(), -1, true);
    //((IdentifierSymbolEntry*)se)->setIntParamNo(0);
    //((IdentifierSymbolEntry*)se)->setFloatParamNo(1);
    st->install(yytext, se);
    return ID;
}

"getfloat" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec1;
    Type* funcType = new FunctionType(TypeSystem::floatType, vec, vec1);
    SymbolTable* st = identifiers;
    while(st->getPrev())
        st = st->getPrev();
    SymbolEntry* se = new IdentifierSymbolEntry(funcType, yytext, st->getLevel(), -1, true);
    //((IdentifierSymbolEntry*)se)->setIntParamNo(0);
    //((IdentifierSymbolEntry*)se)->setFloatParamNo(0);
    st->install(yytext, se);
    return ID;
}
"putarray" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec1;
    vec.push_back(TypeSystem::intType);
    ArrayType* arr = new ArrayType(TypeSystem::intType, -1);
    vec.push_back(arr);
    Type* funcType = new FunctionType(TypeSystem::voidType, vec, vec1);
    SymbolTable* st = identifiers;
    while(st->getPrev())
        st = st->getPrev();
    SymbolEntry* se = new IdentifierSymbolEntry(funcType, yytext, st->getLevel(), -1, true);
    //((IdentifierSymbolEntry*)se)->setIntParamNo(2);
    //((IdentifierSymbolEntry*)se)->setFloatParamNo(0);
    st->install(yytext, se);
    return ID;
}
"getarray" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec1;
    ArrayType* arr = new ArrayType(TypeSystem::intType, -1);
    vec.push_back(arr);
    Type* funcType = new FunctionType(TypeSystem::intType, vec, vec1);
    SymbolTable* st = identifiers;
    while(st->getPrev())
        st = st->getPrev();
    SymbolEntry* se = new IdentifierSymbolEntry(funcType, yytext, st->getLevel(), -1, true);
    //((IdentifierSymbolEntry*)se)->setIntParamNo(1);
    //((IdentifierSymbolEntry*)se)->setFloatParamNo(0);
    st->install(yytext, se);
    return ID;
}
"putfarray" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec1;
    vec.push_back(TypeSystem::intType); // param 1 is int
    ArrayType* arr = new ArrayType(TypeSystem::floatType, -1);
    vec.push_back(arr);
    Type* funcType = new FunctionType(TypeSystem::voidType, vec, vec1);
    SymbolTable* st = identifiers;
    while(st->getPrev())
        st = st->getPrev();
    SymbolEntry* se = new IdentifierSymbolEntry(funcType, yytext, st->getLevel(), -1, true);
    //((IdentifierSymbolEntry*)se)->setIntParamNo(2);
    //((IdentifierSymbolEntry*)se)->setFloatParamNo(0);
    st->install(yytext, se);
    return ID;
}

"getfarray" {
    if(dump_tokens)
        DEBUG_FOR_LAB4(yytext);
    char *lexeme;
    lexeme = new char[strlen(yytext) + 1];
    strcpy(lexeme, yytext);
    yylval.strtype = lexeme;
    std::vector<Type*> vec;
    std::vector<SymbolEntry*> vec1;
    ArrayType* arr = new ArrayType(TypeSystem::floatType, -1);
    vec.push_back(arr);
    // return length so shall be int
    Type* funcType = new FunctionType(TypeSystem::intType, vec, vec1); 
    SymbolTable* st = identifiers;
    while(st->getPrev())
        st = st->getPrev();
    SymbolEntry* se = new IdentifierSymbolEntry(funcType, yytext, st->getLevel(), -1, true);
    //((IdentifierSymbolEntry*)se)->setIntParamNo(1);
    //((IdentifierSymbolEntry*)se)->setFloatParamNo(0);
    st->install(yytext, se);
    return ID;
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

<*>{EOL} {
    chars += strlen(yytext);
    yylineno++;
    chars = 0;
}

{WHITE}
{LINECOMMENT} {}



%%
