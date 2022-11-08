#ifndef __AST_H__		//if not define
#define __AST_H__

#include <fstream>
#include<vector>
#include "Type.h"
using namespace std;

class SymbolEntry;

//TODO:需要根据在预备工作 2 中定义的 SysY 语言特性设计其他结点类型，如 while 语句、函数调用等

class Node		//Node 为 AST 结点的抽象基类
{
private:
    static int counter;
    int seq;
public:
    Node();					//构造函数
    int getSeq() const {return seq;};		//获取 seq
    virtual void output(int level) = 0;		//纯虚函数 output，用于输出语法树信息, 派生出的具体子类均需要对其进行实现
};

class ExprNode : public Node		//ExprNode 为表达式结点的抽象
{
    
public:
    SymbolEntry *symbolEntry;		//符号表节点
    ExprNode(SymbolEntry *symbolEntry) : symbolEntry(symbolEntry){};	//构造函数
    
};

class BinaryExpr : public ExprNode	//二元运算表达式的节点
{
private:
    int op;				//运算符
    ExprNode *expr1, *expr2;		//操作表达式
public:
    enum {ADD, SUB, AND, OR, LESS, MORE, MOREEQ, LESSEQ, EQ, NOTEQ, MUL, DIV, MOL};	//+ - && || <
    BinaryExpr(SymbolEntry *se, int op, ExprNode *expr1, ExprNode *expr2) : ExprNode(se), op(op), expr1(expr1), expr2(expr2){};	//构造函数
    void output(int level);		//输出语法树信息
};

class SignleExpr : public ExprNode 
{
private:
    int op;
    ExprNode *expr;
public:
    enum {SUB, ADD, NOT};
    SignleExpr(SymbolEntry *se, int op, ExprNode *expr) : ExprNode(se), op(op), expr(expr){};
    void output(int level);
};

class Constant : public ExprNode
{
public:
    Constant(SymbolEntry *se) : ExprNode(se){};		//构造函数
    void output(int level);				//输出语法树信息
};

class Id : public ExprNode		//从 ExprNode 中派生出 Id
{
public:
    Id(SymbolEntry *se) : ExprNode(se){};	//构造函数
    void output(int level);
};

class ConstId : public ExprNode
{
public:
    ConstId(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
};

class FuncFParam : public ExprNode
{
public:
    FuncFParam(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
};

class ListNode : public Node
{};

class FuncRParams : public ListNode
{						//实参列表
public:
    std::vector<ExprNode*> Exprs;
    FuncRParams(std::vector<ExprNode*> Exprs) : Exprs(Exprs){};
    void output(int level);
};

class StmtNode : public Node
{};

class Empty : public StmtNode
{
public:
    void output(int level);
};

class SignleStmt : public StmtNode
{
private:
    ExprNode* expr;
public:
    SignleStmt(ExprNode* expr) : expr(expr){};
    void output(int level);
};

class CompoundStmt : public StmtNode	//复合表达式
{
private:
    StmtNode *stmt;
public:
    CompoundStmt(StmtNode *stmt) : stmt(stmt) {};
    void output(int level);
};

class SeqNode : public StmtNode
{
private:
    StmtNode *stmt1, *stmt2;
public:
    SeqNode(StmtNode *stmt1, StmtNode *stmt2) : stmt1(stmt1), stmt2(stmt2){};
    void output(int level);
};

class IfStmt : public StmtNode		//if语句
{
private:
    ExprNode *cond;			//条件
    StmtNode *thenStmt;			//then
public:
    IfStmt(ExprNode *cond, StmtNode *thenStmt) : cond(cond), thenStmt(thenStmt){};
    void output(int level);
};

class WhileStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *loop;
public:
    WhileStmt(ExprNode *cond, StmtNode *loop) : cond(cond), loop(loop) {};
    void output(int level);
};


class BreakStmt : public StmtNode
{
public:
    BreakStmt() {};
    void output(int level);
}
;

class ContinueStmt : public StmtNode
{
public:
    ContinueStmt() {};
    void output(int level);
};

class IfElseStmt : public StmtNode	//if...else...
{
private:
    ExprNode *cond;			//条件
    StmtNode *thenStmt;			//then
    StmtNode *elseStmt;			//else
public:
    IfElseStmt(ExprNode *cond, StmtNode *thenStmt, StmtNode *elseStmt) : cond(cond), thenStmt(thenStmt), elseStmt(elseStmt) {};
    void output(int level);
};

class ReturnStmt : public StmtNode	//return
{
private:
    ExprNode *retValue;			//返回值
public:
    ReturnStmt(ExprNode*retValue) : retValue(retValue) {};
    void output(int level);
};

class AssignStmt : public StmtNode	//赋值语句
{
private:
    ExprNode *lval;			//左值
    ExprNode *expr;			//表达式
public:
    AssignStmt(ExprNode *lval, ExprNode *expr) : lval(lval), expr(expr) {};
    void output(int level);
};

class IdList : public ListNode
{
public:
    std::vector<Id*> Ids;		//Id*类型的动态数组 Ids
    std::vector<AssignStmt*> Assigns;	//AssignStmt* 类型的动态数组 Assigns
    IdList(std::vector<Id*> Ids, std::vector<AssignStmt*> Assigns) : Ids(Ids), Assigns(Assigns) {};
    void output(int level);
};

class ConstIdList : public ListNode
{
public:
    std::vector<ConstId*> CIds;		//ConstId*类型的动态数组CIds
    std::vector<AssignStmt*> Assigns;	//AssignStmt*类型的动态数组Assigns
    ConstIdList(std::vector<ConstId*> CIds, std::vector<AssignStmt*> Assigns) : CIds(CIds), Assigns(Assigns) {};
    void output(int level);
};

class DeclStmt : public StmtNode	//声明语句
{
private:
    IdList *id;
public:
    DeclStmt(IdList *id) : id(id){};
    void output(int level);
};

class ConstDeclStmt : public StmtNode
{
private:
    ConstIdList *Cids;
public:
    ConstDeclStmt(ConstIdList *Cids) : Cids(Cids){};
    void output(int level);
};

class FuncFParams : public ListNode
{						//形参列表
public:
    std::vector<FuncFParam*> FPs;		//FuncFParam*类型的动态数组FPs
    std::vector<AssignStmt*> Assigns;		//AssignStmt*类型的动态数组Assigns
    FuncFParams(std::vector<FuncFParam*> FPs, std::vector<AssignStmt*> Assigns) : FPs(FPs), Assigns(Assigns) {};
    void output(int level);
};

class FunctionDef : public StmtNode	//函数定义
{
private:
    SymbolEntry *se;
    FuncFParams *FPs;
    StmtNode *stmt;
public:
    FunctionDef(SymbolEntry *se, FuncFParams *FPs, StmtNode *stmt) : se(se), FPs(FPs), stmt(stmt){};
    void output(int level);
};

class FunctionCall : public ExprNode
{
public:
    FuncRParams *RPs;
    FunctionCall(SymbolEntry*se, FuncRParams *RPs) : ExprNode(se), RPs(RPs){};
    void output(int level);
};

class Ast
{
private:
    Node* root;
public:
    Ast() {root = nullptr;}
    void setRoot(Node*n) {root = n;}	//设置语法树根节点
    void output();
};

#endif
