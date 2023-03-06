%code top{
    #include <iostream>			//定义段，用于添加所需的头文件，函数定义以及全局变量等
    #include <assert.h>			//此时代码段只能是C/C++，将被放在实现文件的最开头。
    #include "parser.h"
    using namespace std;
    extern Ast ast;			//抽象语法树 ast
    Type* declType;                    //类型系统
    int yylex();			//词法分析器入口
    int yyerror( char const * );	//yyerror()是一个回调函数,原型为: void yyerror(const char* s) 当bison语法分析器检测到语法错误时,通过回调yyerror()来报告错误,参数为描述错误的字符串
}

%code requires {			//此时代码段只能是C/C++，将被放在声明文件（--defines）和实现文件（--output）中定义YYSTYPE、YYLTYPE之前。可以将包含的头文件放在这里。
    #include "Ast.h"			//使用 %code top不会将代码插入标题中，而只会插入源文件中。
    #include "SymbolTable.h"
    #include "Type.h"
}

%union {				//声明标识符号值的所有可能C类型(YYSTYPE)
    int itype;				//整数类型
    float ftype;                       //浮点数
    char* strtype;			//字符串类型
    StmtNode* stmttype;			//语句
    ExprNode* exprtype;			//表达式
    Type* type;
    IdList* Idlisttype;			//idlist
    FuncFParams* Fstype;		//函数形参
    FuncRParams* FRtype;		//函数实参
    ConstIdList* CIdstype;		//const id list
}

%start Program				//自定义开始符号Program，即语法树的根节点
%token <strtype> ID
%token <itype> INTEGER
%token <ftype> FLOATNUM
%token IF ELSE
%token WHILE
%token INT VOID CHAR FLOAT
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON LBRACKET RBRACKET COMMA
%token ADD SUB MUL DIV OR AND LESS ASSIGN BITAND BITOR BITNOT
%token EQ LESSEQ MOREEQ MORE NOTEQ MOL NOT
%token RETURN
%token CONST BREAK CASE CONTINUE
%token LINECOMMENT COMMENTBEIGN COMMENTELE COMMENTEOL COMMENTEND

%nterm <stmttype> Stmts Stmt AssignStmt BlockStmt IfStmt ReturnStmt DeclStmt FuncDef WhileStmt ConstDeclStmt SignleStmt
%nterm <exprtype> Exp UnaryExp AddExp Cond LOrExp PrimaryExp LVal RelExp LAndExp MulExp
%nterm <type> Type
%nterm <Idlisttype> Idlist 
%nterm <Fstype> FuncFParams
%nterm <FRtype> FuncRParams
%nterm <CIdstype> ConstIdList

%precedence THEN	//给终结符声明优先级，终结符 else 的优先级高于终结符 then
%precedence ELSE
%%
Program
    : Stmts {
        ast.setRoot($1);	//<Ast.h>设置语法树根节点
    }
    ;
Stmts					//语句块
    : Stmt {$$=$1;}
    | Stmts Stmt{
        $$ = new SeqNode($1, $2);	//<Ast.h>
    }
    ;
Stmt
    : AssignStmt {$$=$1;}		//赋值语句
    | BlockStmt {$$=$1;}		//块语句
    | IfStmt {$$=$1;}			//if语句
    | ReturnStmt {$$=$1;}		//return语句
    | DeclStmt {$$=$1;}			//声明语句
    | ConstDeclStmt {$$ = $1;}		//const声明语句
    | FuncDef {$$=$1;}			//函数定义语句
    | WhileStmt {$$ = $1;}		//while语句
    | SEMICOLON {$$ = new Empty();}	//空语句
    | BREAK SEMICOLON {$$ = new BreakStmt();}	//break语句
    | CONTINUE SEMICOLON {$$ = new ContinueStmt();}	//continue语句
    | SignleStmt {$$ = $1;}		//Exp;
    ;
SignleStmt
    :
    Exp SEMICOLON{			//Exp;
        $$ = new SignleStmt($1);
    }
    ;
LVal					//左值
    : ID {
        SymbolEntry *se;		//符号表节点
        se = identifiers->lookup($1);	//在当前符号表中寻找
        if(se == nullptr)		//没找到
        {
            fprintf(stderr, "identifier \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);	//触发断言
        }
        $$ = new Id(se);		//一个新的标识符，调用构造函数
        delete []$1;
    }
    ;
AssignStmt				//赋值语句
    :
    LVal ASSIGN Exp SEMICOLON {		//左值 = 表达式;
        $$ = new AssignStmt($1, $3);	//创建新的赋值节点
    }
    ;
BlockStmt				//块语句
    :   LBRACE 
        {identifiers = new SymbolTable(identifiers);} 	//创建一个新的符号表
        Stmts RBRACE 
        {
            $$ = new CompoundStmt($3);			//复合语句
            SymbolTable *top = identifiers;		//top为指向当前符号表identifiers的指针
            identifiers = identifiers->getPrev();	//前一个（即返回前一个作用域内）
            delete top;
        }
    ;
IfStmt							//if语句
    : IF LPAREN Cond RPAREN Stmt %prec THEN {		//%prec THEN 是为了解决悬空-else 文法的二义性问题.使用%prec 关键字，将终结符then 的优先级赋给产生式
        $$ = new IfStmt($3, $5);			//$3为条件，$5为then语句
    }
    | IF LPAREN Cond RPAREN LBRACE RBRACE{		//if(cond){}
        $$ = new IfStmt($3, new Empty());
    }
    | IF LPAREN Cond RPAREN Stmt ELSE Stmt {
        $$ = new IfElseStmt($3, $5, $7);		//$7为else语句
    }
    ;
WhileStmt						//while语句
    : WHILE LPAREN Cond RPAREN Stmt {
        $$ = new WhileStmt($3, $5);
    }
    ;
ReturnStmt						//return语句
    :
    RETURN Exp SEMICOLON{
        $$ = new ReturnStmt($2);
    }
    ;
Exp							//Exp -> AddExp
    :
    AddExp {$$ = $1;}
    ;
Cond							//条件
    :
    LOrExp {$$ = $1;}					//逻辑或表达式
    ;
PrimaryExp						//基本表达式    PrimaryExp->LVal | integer
    :
    LVal {
        $$ = $1;
    }
    | INTEGER {
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, $1);	//Constant类型 符号表节点，继承符号表节点   <SymbolTable.h>
        $$ = new Constant(se);							//Constant <Ast.h>
    }
    | FLOATNUM{
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::floatType, $1);
        $$ = new Constant(se);
    }
    |  LPAREN Exp RPAREN{$$ = $2;}
    ;
UnaryExp						//一元表达式
    :
    PrimaryExp {$$ = $1;}
    |  ID LPAREN RPAREN{				//无参函数
        SymbolEntry *se;				//符号表节点
        se = identifiers->lookup($1);			//寻找是否有该id
        if(se == nullptr)				//没有
        {
            fprintf(stderr, "Function \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        if(se->getisfunc()){
            $$ = new FunctionCall(se, nullptr);		//调用该函数
        }
        else{
            fprintf(stderr, "Function \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se->getisfunc());
        }
        delete []$1;
    }
    |  ID LPAREN FuncRParams RPAREN{			//含参函数
        SymbolEntry *se;
        se = identifiers->lookup($1);
        if(se == nullptr)
        {
            fprintf(stderr, "Function \"%s\" is undefined\n", (char*)$1);
            delete [](char*)$1;
            assert(se != nullptr);
        }
        $$ = new FunctionCall(se, $3);			//函数调用 $3为实参
        delete []$1;
    }
    |  SUB UnaryExp {					//-UnaryExp
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SignleExpr(se, SignleExpr::SUB, $2);
    }
    |  NOT UnaryExp{					//!UnaryExp
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SignleExpr(se, SignleExpr::NOT, $2);
    }
    |  ADD UnaryExp{					//+UnaryExp
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SignleExpr(se, SignleExpr::ADD, $2);
    }
    |  BITAND UnaryExp{					//+UnaryExp
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SignleExpr(se, SignleExpr::BITAND, $2);
    }
    |  BITOR UnaryExp{					//+UnaryExp
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SignleExpr(se, SignleExpr::BITOR, $2);
    }
    |  BITNOT UnaryExp{					//+UnaryExp
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new SignleExpr(se, SignleExpr::BITNOT, $2);
    }
    ;
MulExp							//乘除表达式
    :
    UnaryExp {$$ = $1;}					//一元表达式
    | MulExp MUL UnaryExp {
    /*
        SymbolEntry* se;
	    se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
	    $$ = new BinaryExpr(se, BinaryExpr::MUL, $1, $3);*/
	SymbolEntry *se;
        if ($1->symbolEntry->getType()->isFloat() || $3->symbolEntry->getType()->isFloat()) {
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::MUL, $1, $3);
        } else if ($1->symbolEntry->getType()->isInt() || $3->symbolEntry->getType()->isInt())
        {
            se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::MUL, $1, $3);
        } else if ($1->symbolEntry->getType()->isInt() || $3->symbolEntry->getType()->isFloat())
        {
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::MUL, $1, $3);
        } else
        {
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::MUL, $1, $3);
        }
    }
    | MulExp DIV UnaryExp {
    /*
        SymbolEntry* se;
            se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::DIV, $1, $3);*/
        SymbolEntry *se;
        if ($1->symbolEntry->getType()->isFloat() || $3->symbolEntry->getType()->isFloat()) {
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::DIV, $1, $3);
        } else if ($1->symbolEntry->getType()->isInt() || $3->symbolEntry->getType()->isInt())
        {
            se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::DIV, $1, $3);
        } else if ($1->symbolEntry->getType()->isInt() || $3->symbolEntry->getType()->isFloat())
        {
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::DIV, $1, $3);
        } else
        {
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::DIV, $1, $3);
        }
    }
    |
    MulExp MOL UnaryExp{				//%
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MOL, $1, $3);
    }
    ;    
AddExp							//加减表达式
    :
    MulExp {$$ = $1;}				//乘除表达式
    | AddExp ADD MulExp				//+
    {
    /*
        SymbolEntry *se;
            se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::ADD, $1, $3);
        				//<Ast.h> 二元运算表达式的节点
        				*/
        SymbolEntry *se;
        if ($1->symbolEntry->getType()->isFloat() || $3->symbolEntry->getType()->isFloat()) {
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::ADD, $1, $3);
        } else if ($1->symbolEntry->getType()->isInt() || $3->symbolEntry->getType()->isInt())
        {
            se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::ADD, $1, $3);
        } else if ($1->symbolEntry->getType()->isInt() || $3->symbolEntry->getType()->isFloat())
        {
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::ADD, $1, $3);
        } else
        {
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::ADD, $1, $3);
        }
    }
    | AddExp SUB MulExp				//-
    {
    /*
        SymbolEntry *se;
            se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::SUB, $1, $3);*/
        SymbolEntry *se;
        if ($1->symbolEntry->getType()->isFloat() || $3->symbolEntry->getType()->isFloat()) {
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::SUB, $1, $3);
        } else if ($1->symbolEntry->getType()->isInt() || $3->symbolEntry->getType()->isInt())
        {
            se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::SUB, $1, $3);
        } else if ($1->symbolEntry->getType()->isInt() || $3->symbolEntry->getType()->isFloat())
        {
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::SUB, $1, $3);
        } else
        {
            se = new TemporarySymbolEntry(TypeSystem::floatType, SymbolTable::getLabel());
            $$ = new BinaryExpr(se, BinaryExpr::SUB, $1, $3);
        }
    }
    ;
RelExp
    :
    AddExp {$$ = $1;}
    |
    RelExp LESS AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESS, $1, $3);
    }
    |
    RelExp MORE AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MORE, $1, $3);
    }
    |
    RelExp MOREEQ AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::MOREEQ, $1, $3);
    }
    |
    RelExp LESSEQ AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::LESSEQ, $1, $3);
    }
    |
    RelExp EQ AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::EQ, $1, $3);
    }
    |
    RelExp NOTEQ AddExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::NOTEQ, $1, $3);
    }
    ;
LAndExp							//逻辑与表达式
    :
    RelExp {$$ = $1;}
    |
    LAndExp AND RelExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::AND, $1, $3);
    }
    ;
LOrExp							//逻辑或表达式
    :
    LAndExp {$$ = $1;}
    |
    LOrExp OR LAndExp
    {
        SymbolEntry *se = new TemporarySymbolEntry(TypeSystem::intType, SymbolTable::getLabel());
        $$ = new BinaryExpr(se, BinaryExpr::OR, $1, $3);
    }
    ;
Type							//类型（int,void）
    : INT {
        $$ = TypeSystem::intType;
    }
    | VOID {
        $$ = TypeSystem::voidType;
    }
    | CHAR {
        $$ = TypeSystem::charType;
    }
    | FLOAT {
        $$ = TypeSystem::floatType;
        declType = TypeSystem::floatType;
    }
    ;
DeclStmt			//声明语句    
    :
    Type Idlist SEMICOLON {
        $$ = new DeclStmt($2);	//$2:idlist
    }
    ;
ConstDeclStmt			//const声明语句
    :
    CONST Type ConstIdList SEMICOLON{
        $$ = new ConstDeclStmt($3);	//$3:const idlist
    }
    ;
ConstIdList			//const idlist
    :
    ID ASSIGN Exp {		//id = Exp
        std::vector<ConstId*> ConstIds;			//ConstId* 类型的动态数组 ConstIds
        std::vector<AssignStmt*> Assigns;		//AssignStmt* 类型的动态数组 Assigns
        ConstIdList* temp = new ConstIdList(ConstIds, Assigns);
        SymbolEntry* se = new IdentifierSymbolEntry(TypeSystem::intType, $1, identifiers -> getLevel());	//变量类型符号表节点 $1:ID
        identifiers->install($1, se);		//插入当前作用域的符号表
        ConstId *t = new ConstId(se);
        temp -> CIds.push_back(t);
        temp -> Assigns.push_back(new AssignStmt(t, $3));
        $$ = temp;
        delete []$1;
    }
    |
    ConstIdList COMMA ID ASSIGN Exp {		//constidlist,id = Exp
        ConstIdList *temp = $1;
        SymbolEntry *se;			//符号表节点
        se = new IdentifierSymbolEntry(TypeSystem::intType, $3, identifiers->getLevel());	//变量类型符号表节点
        identifiers->install($3, se);		//插入
        ConstId *t = new ConstId(se);
        temp -> CIds.push_back(t);
        temp -> Assigns.push_back(new AssignStmt(t, $5));
        $$ = temp;
        delete []$3;
    }
    ;    
Idlist			//idlist
    :
    ID {
        std::vector<Id*> Ids;
        std::vector<AssignStmt*> Assigns;
        IdList *temp = new IdList(Ids, Assigns);
        SymbolEntry *se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $1, identifiers->getLevel());
        identifiers->install($1, se);
        temp -> Ids.push_back(new Id(se));
        $$ = temp;
        delete []$1;
    } 
    |
    Idlist COMMA ID{
        IdList *temp = $1;
        SymbolEntry *se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $3, identifiers->getLevel());
        identifiers->install($3, se);
        temp -> Ids.push_back(new Id(se));
        $$ = temp;
        delete []$3;
    }
    |
    ID ASSIGN Exp {
        std::vector<Id*> Ids;
        std::vector<AssignStmt*> Assigns;
        IdList *temp = new IdList(Ids, Assigns);
        SymbolEntry *se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $1, identifiers->getLevel());
        identifiers->install($1, se);
        Id *t = new Id(se);
        temp -> Ids.push_back(t);
        temp -> Assigns.push_back(new AssignStmt(t, $3));
        $$ = temp;
        delete []$1;
    }
    |
    Idlist COMMA ID ASSIGN Exp {
        IdList *temp = $1;
        SymbolEntry *se;
        se = new IdentifierSymbolEntry(TypeSystem::intType, $3, identifiers->getLevel());
        identifiers->install($3, se);
        Id *t = new Id(se);
        temp -> Ids.push_back(t);
        temp -> Assigns.push_back(new AssignStmt(t, $5));
        $$ = temp;
        delete []$3;
    }
    ;
FuncRParams		//函数实参
    :
    Exp
    {
        std::vector<ExprNode*> t;
        t.push_back($1);
        FuncRParams *temp = new FuncRParams(t);
        $$ = temp;
    }
    |
    FuncRParams COMMA Exp
    {
        FuncRParams *temp = $1;
        temp -> Exprs.push_back($3);
        $$ = temp;
    }
    ;
FuncFParams		//函数形参
    :
    Type ID
    {
        std::vector<FuncFParam*> FPs;
        std::vector<AssignStmt*> Assigns;
        FuncFParams *temp = new FuncFParams(FPs, Assigns);
        SymbolEntry *se;
        se = new IdentifierSymbolEntry($1, $2, identifiers->getLevel());
        identifiers->install($2, se);
        temp -> FPs.push_back(new FuncFParam(se));
        $$ = temp;
        delete []$2;
    }
    |
    FuncFParams COMMA Type ID
    {
        FuncFParams *temp = $1;
        SymbolEntry *se;
        se = new IdentifierSymbolEntry($3, $4, identifiers->getLevel());
        identifiers->install($4, se);
        temp -> FPs.push_back(new FuncFParam(se));
        $$ = temp;
        delete []$4;
    }
    |
    Type ID ASSIGN Exp
    {
        std::vector<FuncFParam*> FPs;
        std::vector<AssignStmt*> Assigns;
        FuncFParams *temp = new FuncFParams(FPs, Assigns);
        SymbolEntry *se;
        se = new IdentifierSymbolEntry($1, $2, identifiers->getLevel());
        identifiers->install($2, se);
        FuncFParam* t = new FuncFParam(se);
        temp -> FPs.push_back(t);
        temp -> Assigns.push_back(new AssignStmt(t, $4));
        $$ = temp;
        delete []$2;
    }
    |
    FuncFParams COMMA Type ID ASSIGN Exp
    {
        FuncFParams *temp = $1;
        SymbolEntry *se;
        se = new IdentifierSymbolEntry($3, $4, identifiers->getLevel());
        identifiers->install($4, se);
        FuncFParam* t = new FuncFParam(se);
        temp -> FPs.push_back(t);
        temp -> Assigns.push_back(new AssignStmt(t, $6));
        $$ = temp;
        delete []$4;
    }
    ;
FuncDef							//函数定义
    :
    Type ID LPAREN {
        Type *funcType;
        funcType = new FunctionType($1,{});		
        SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getLevel());	//创建符号表节点se
        se->setisfunc();
        identifiers->install($2, se);			//插入
        identifiers = new SymbolTable(identifiers);	//传入前向指针，创建新的符号表。即开启一个新的作用域
    }
    RPAREN
    BlockStmt
    {
        SymbolEntry *se;				//符号表节点
        se = identifiers->lookup($2);			//寻找函数名
        assert(se != nullptr);
        $$ = new FunctionDef(se, nullptr,$6);
        SymbolTable *top = identifiers;			//top为指向当前符号表的指针
        identifiers = identifiers->getPrev();		//跳出当前作用域，转移到前一个符号表中
        delete top;
        delete []$2;
    }
    |
    Type ID LPAREN {
        Type *funcType;
        funcType = new FunctionType($1,{});
        SymbolEntry *se = new IdentifierSymbolEntry(funcType, $2, identifiers->getLevel());	//符号表节点
        se->setisfunc();
        identifiers->install($2, se);			//插入
        identifiers = new SymbolTable(identifiers);
    }
    FuncFParams RPAREN
    BlockStmt
    {
        SymbolEntry *se;				//符号表节点
        se = identifiers->lookup($2);			//在符号表中寻找函数名
        assert(se != nullptr);
        $$ = new FunctionDef(se, $5 ,$7);
        SymbolTable *top = identifiers;			//top为指向当前符号表的指针
        identifiers = identifiers->getPrev();		//跳出当前作用域，即指向前一个符号表
        delete top;
        delete []$2;
    }
    ;
%%

int yyerror(char const* message)
{
    std::cerr<<message<<std::endl;
    return -1;
}
