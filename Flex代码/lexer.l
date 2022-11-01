%option noyywrap					
%{
    /*							定义部分
    * You will need to comment this line in lab5.	noyywrap表示在该.l文件中不会调用yywrap()，而是假设生成的扫描器只扫描单个文件
    */
    #define ONLY_FOR_LEX
    
    #ifdef ONLY_FOR_LEX					/*条件编译*/
    #else
    #define YYSTYPE void *				/*YYSTYPE = void* */
    #include "parser.h"
    #endif

    #define YY_NO_UNPUT
    #define YY_NO_INPUT
    #include <string>

    #ifdef ONLY_FOR_LEX
    #include <ostream>
    #include <fstream>
    #include<stack>
    using namespace std;
    extern FILE *yyin; 					/*外部变量。IO重定向,使yyin指向具有yacc主要功能的文件*/
    extern FILE *yyout;
    int yycolumnno = 0;
    
    /*void DEBUG_FOR_LAB4(std::string s){
        std::string DEBUG_INFO = "[DEBUG LAB4]: \t" + s + "\n";
        fputs(DEBUG_INFO.c_str(), yyout);		向指定的文件写入一个字符串 
    }*/
    /*TODO*/
    
    // 符号表类
    class SymbolTable{
    	public:
    	    string symbol_name;
    	    string type;
    	    string* scope;
    	public:
    	    SymbolTable();
    	    SymbolTable(string n, string t, string* s);
    }symbols[200];

    SymbolTable::SymbolTable(){
        symbol_name = "";
        type = "";
        scope = nullptr;
    }

    SymbolTable::SymbolTable(string n, string t, string* s){
        symbol_name = n;
        type = t;
        scope = s;
    }

    // 使用stack来追踪作用域，用栈top元素的地址来标识
    stack<string*> scope_stack;
    //符号的数量
    int symbol_num = 0;
    
    void DEBUG_FOR_LAB4(std::string s){
    	char *temp = new char[100];
    	sprintf(temp,"[DEBUG LAB4]: \t%s\t\t%d\t%d\n",s.c_str(),yylineno,yycolumnno);
    	fputs(temp,yyout);
    	yycolumnno += strlen(yytext);
    	delete temp;
    }
    
    void printid(std::string s,string x){
        char *temp = new char[100];
        sprintf(temp,"[DEBUG LAB4]: \t%s\t  %s\t\t%d\t%d\t%s\n",s.c_str(),yytext,yylineno,yycolumnno,x.c_str());
        fputs(temp,yyout);
        yycolumnno += strlen(yytext);
        delete temp;
    }
    void dec(std::string s){					/*十进制*/
    	char *temp = new char[100];
    	sprintf(temp,"[DEBUG LAB4]: \t%s\t  %s\t\t%d\t%d\n",s.c_str(),yytext,yylineno,yycolumnno);
    	fputs(temp,yyout);
    	yycolumnno += strlen(yytext);
    	delete temp;
    }
    
    void hex2dec(std::string s){				/*十六进制*/
    	int res = 0;
    	for(int i=2;yytext[i]!='\0';i++){
    		res = res * 16;
    		if(yytext[i]>='a' && yytext[i]<='f'){
    			res = res + (yytext[i]-'a'+10);
    		}
    		if(yytext[i]>='A' && yytext[i]<='F'){
    			res = res + (yytext[i]-'A'+10);
    		}
    		else{
    			res = res + yytext[i]-'0';
    		}
    	}
    	char *temp = new char[100];
    	sprintf(temp,"[DEBUG LAB4]: \t%s\t  %d\t\t%d\t%d\n",s.c_str(),res,yylineno,yycolumnno);
    	fputs(temp,yyout);
    	yycolumnno += strlen(yytext);
    	delete temp;
    }
    
    void oct2dec(std::string s){
    	int res = 0;
    	for(int i=1;yytext[i]!='\0';i++){
    		res = res * 8;
    		res = res + yytext[i]-'0';
    	}
    	char *temp = new char[100];
    	sprintf(temp,"[DEBUG LAB4]: \t%s\t  %d\t\t%d\t%d\n",s.c_str(),res,yylineno,yycolumnno);
    	fputs(temp,yyout);
    	yycolumnno += strlen(yytext);
    	delete temp;
    }
    #endif
%}

/* 规则部分 */
OCT (0([1-7][0-7]*|0))
HEX ((0x|0X)([1-9A-Fa-f][0-9A-Fa-f]*|0))
DECIMIAL ([1-9][0-9]*|0)	
FDECIMAL ([1-9][0-9]*|0)("."[0-9]*)?(("E"|"e")("+"|"-")?[0-9]+)?			
ID [[:alpha:]_][[:alpha:][:digit:]_]*
EOL (\r\n|\n|\r)
WHITE [\t|" "]+
COMMENTBEGIN "/*"
COMMENTELE .
COMMENTEOL \r\n|\n|\r
COMMENTEND "*/"
LINECOMMENT \/\/[^\n]*
%x BLOCKCOMMENT

/*TODO:补全缺失的词素正则式,如八进制数字、十六进制数字、行注释的定义*/
%%
{COMMENTBEGIN} {BEGIN BLOCKCOMMENT;}
<BLOCKCOMMENT>{COMMENTELE} {}
<BLOCKCOMMENT>{COMMENTEOL} {yylineno++;}
<BLOCKCOMMENT>{COMMENTEND} {BEGIN INITIAL;}
"int" {
    /*TODO:定义识别到这些词素进行的语义动作  */
    /*optional:SymbolTable*/
    /*
    * Questions: 
    *   Q1: Why we need to return INT in further labs?
    *   Q2: What is "INT" actually?
    */
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("INT\t  int");			/*DEBUG_FOR_LAB4 将我们传递的字符串由 yyout 输出。*/
    #else
        return INT;
    #endif
}
"float" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("FLOAT\t  float");
    #else
        return FLOAT;
    #endif
}
"double" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("DOUBLE\t  double");
    #else
        return DOUBLE;
    #endif
}
"char" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CHAR\t  char");
    #else
        return CHAR;
    #endif
}
"long" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LONG\t  long");
    #else
        return LONG;
    #endif
}
"short" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SHORT\t  short");
    #else
        return SHORT;
    #endif
}
"signed" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SIGNED\t  signed");
    #else
        return SIGNED;
    #endif
}
"unsigned" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("UNSIGNED\t  unsigned");
    #else
        return UNSIGNED;
    #endif
}
"void" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("VOID\t  void");
    #else
        return VOID;
    #endif 
}
"do" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("DO\t  do");
    #else
        return DO;
    #endif
}
"while" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("WHILE\t  while");
    #else
        return WHILE;
    #endif
}
"for" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("FOR\t  for");
    #else
        return FOR;
    #endif
}
"if" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("IF\t  if");
    #else
        return IF;
    #endif
}
"else" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ELSE\t  else");
    #else
        return ELSE;
    #endif
}
"return" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RETURN\t  return");
    #else
        return RETURN;
    #endif
}
"const" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CONST\t  const");
    #else
        return CONST;
    #endif
}
"auto" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("AUTO\t  auto");
    #else
        return AUTO;
    #endif
}
"break" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("BREAK\t  break");
    #else
        return BREAK;
    #endif
}
"case" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CASE\t  case");
    #else
        return CASE;
    #endif
}
"continue" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("CONTINUE\t  continue");
    #else
        return CONTINUE;
    #endif
}
"default" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("DEFAULT\t  default");
    #else
        return DEFAULT;
    #endif
}
"enum" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ENUM\t  enum");
    #else
        return ENUM;
    #endif
}
"extern" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("EXTERN\t  extern");
    #else
        return EXTERN;
    #endif
}
"goto" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("GOTO\t  goto");
    #else
        return GOTO;
    #endif
}
"register" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("REGISTER\t  register");
    #else
        return REGISTER;
    #endif
}
"sizeof" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SIZEOF\t  sizeof");
    #else
        return SIZEOF;
    #endif
}
"static" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("STATIC\t  static");
    #else
        return LONG;
    #endif
}
"struct" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("STRUCT\t  struct");
    #else
        return STRUCT;
    #endif
}
"switch" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SWITCH\t  switch");
    #else
        return SWITCH;
    #endif
}
"typedef" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("TYPEDEF\t  typedef");
    #else
        return TYPEDEF;
    #endif
}
"union" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("UNION\t  union");
    #else
        return UNION;
    #endif
}
"volatile" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("VOLATILE\t  volatile");
    #else
        return VOLATILE;
    #endif
}

"=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ASSIGN\t  =");
    #else
        return ASSIGN;
    #endif
}
"==" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("EQ\t  ==");
    #else
        return EQ;
    #endif
}
"<=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LESSEQ\t  <=");
    #else
        return LESSEQ;
    #endif
}
">=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MOREEQ\t  >=");
    #else
        return MOREEQ;
    #endif
}
"!=" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("NOTEQ\t  !=");
    #else
        return NOTEQ;
    #endif
}
">" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MORE\t  >");
    #else
        return MORE;
    #endif
}
"<" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LESS\t  <");
    #else
        return LESS;
    #endif
}
"+" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ADD\t  +");
    #else
        return ADD;
    #endif
}
"++" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("ADD1\t  ++");
    #else
        return ADD1;
    #endif
}
"-" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SUB\t  -");
    #else
        return SUB;
    #endif
}
"--" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SUB1\t  --");
    #else
        return SUB1;
    #endif
}
"*" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MUL\t  *");
    #else
        return MUL;
    #endif
}
"/" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("DIV\t  /");
    #else
        return DIV;
    #endif
}
"%" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("MOL\t  %");
    #else
        return MOL;
    #endif
}
"&&" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("AND\t  &&");
    #else
        return AND;
    #endif
}
"||" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("OR\t  ||");
    #else
        return OR;
    #endif
}
"!" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("NOT\t  !");
    #else
        return NOT;
    #endif
}
";" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("SEMIC\t  ;");
    #else
        return SEMICOLON;
    #endif
}
"," {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("COMMA\t  ,");
    #else
        return COMMA;
    #endif
}
":" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("COLON\t  ,");
    #else
        return COLON;
    #endif
}
"(" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LPAREN\t  (");
    #else
        return LPAREN;
    #endif
}
")" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RPAREN\t  )");
    #else
    return RPAREN;
    #endif
}
"[" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LBRACK\t  [");
    #else
        return LBRACK;
    #endif
}
"]" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RBRACK\t  ]");
    #else
        return RBRACK;
    #endif
}
"{" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("LBRACE\t  {");
        string* sign = new string; 
	*sign = "local"; 
	scope_stack.push(sign); 
    #else
        return LBRACE;
    #endif
}
"}" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("RBRACE\t  }");
        scope_stack.pop();
    #else
        return RBRACE;
    #endif
}
"#" {
    #ifdef ONLY_FOR_LEX
        DEBUG_FOR_LAB4("WELL\t  #");
    #else
        return WELL;
    #endif
}


{HEX} {hex2dec("NUMBER");}
{OCT} {oct2dec("NUMBER");}
{DECIMIAL} {dec("NUMBER");}
{FDECIMAL} {dec("FNUMBER");}
{ID} {
    #ifdef ONLY_FOR_LEX 
 	string name = yytext; 
 	string ID_type=" ";
 	symbols[symbol_num] = SymbolTable(name, ID_type, scope_stack.top()); 
 	string* back = scope_stack.top(); 
	char temp1[100]; 
	sprintf(temp1, "%#lx", long(back)); 
	string hex_scope = temp1; 
	printid("ID",hex_scope); 
	symbol_num++; 
    #else 
	return ID; 
    #endif 
 } 
{EOL} {yylineno++;yycolumnno=0;}
{LINECOMMENT} {}
{WHITE} {yycolumnno++;}
%%

#ifdef ONLY_FOR_LEX
int main(int argc, char **argv){
    if(argc != 5){
        fprintf(stderr, "Argument Not Enough");
        exit(EXIT_FAILURE);
    }

    if(!(yyin = fopen(argv[1], "r"))){					/*yyin 和 yyout 分别由命令行传递的参数 (argv) 捕获输入文件和输出文件名称*/
        fprintf(stderr, "No such file or directory: %s", argv[1]);	/*这也解释了最开始如何进行批量测试的问题。 */
        exit(EXIT_FAILURE);
    }

    if(!(yyout = fopen(argv[3], "w"))){
        fprintf(stderr, "No such file or directory: %s", argv[3]);
        exit(EXIT_FAILURE);
    }
    
    string start = "global"; 
    scope_stack.push(&start); 
    yylex();
    return 0;
}
#endif
