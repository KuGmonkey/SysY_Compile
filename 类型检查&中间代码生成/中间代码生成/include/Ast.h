#ifndef __AST_H__
#define __AST_H__

#include <fstream>
#include<vector>
#include "Operand.h"

class SymbolEntry;
class Unit;
class Function;
class BasicBlock;
class Instruction;
class IRBuilder;

class Node
{
private:
    static int counter;	
    int seq;
protected:
    std::vector<Instruction*> true_list;
    std::vector<Instruction*> false_list;
    static IRBuilder *builder;
    void backPatch(std::vector<Instruction*> &list, BasicBlock*bb);
    void backPatchFalse(std::vector<Instruction*> &list, BasicBlock*bb);
    std::vector<Instruction*> merge(std::vector<Instruction*> &list1, std::vector<Instruction*> &list2);

public:
    Node();
    int getSeq() const {return seq;};
    static void setIRBuilder(IRBuilder*ib) {builder = ib;};
    virtual void output(int level) = 0;	
    virtual void typeCheck() = 0;
    virtual void genCode() = 0;	
    std::vector<Instruction*>& trueList() {return true_list;}
    std::vector<Instruction*>& falseList() {return false_list;}
};

class ExprNode : public Node
{
public:
    Operand *dst;
    bool isCond = false;
    SymbolEntry *symbolEntry;
    ExprNode(SymbolEntry *symbolEntry) : symbolEntry(symbolEntry){
    	dst = new Operand(symbolEntry);
    };
    Operand* getOperand() {return dst;};
    SymbolEntry* getSymPtr() {return symbolEntry;};
};

class BinaryExpr : public ExprNode
{
private:
    int op;
    ExprNode *expr1, *expr2;
public:
    enum {ADD, MUL, DIV, MOL, SUB, AND, OR, LESS, MOREEQ, LESSEQ, EQ, NOTEQ, MORE};
    BinaryExpr(SymbolEntry *se, int op, ExprNode*expr1, ExprNode*expr2) : ExprNode(se), op(op), expr1(expr1), expr2(expr2){dst = new Operand(se);};
    void output(int level);
    void typeCheck();	
    void genCode();			
};

class SignleExpr : public ExprNode 
{
private:
    int op;
    ExprNode *expr;
public:
    enum {SUB, ADD, NOT, BITAND, BITOR, BITNOT};
    SignleExpr(SymbolEntry *se, int op, ExprNode *expr) : ExprNode(se), op(op), expr(expr){};
    void output(int level);
    void typeCheck();			
    void genCode();			
};

class Constant : public ExprNode
{
public:
    Constant(SymbolEntry *se) : ExprNode(se){dst = new Operand(se);};	
    void output(int level);
    void typeCheck();
    void genCode();
};

class Id : public ExprNode
{
public:
    Id(SymbolEntry *se) : ExprNode(se){SymbolEntry *temp = new TemporarySymbolEntry(se->getType(), SymbolTable::getLabel()); dst = new Operand(temp);};
    void output(int level);
    void typeCheck();
    void genCode();
};

class ConstId : public ExprNode
{
public:
    ConstId(SymbolEntry *se) : ExprNode(se){};
    void output(int level);
    void typeCheck();
    void genCode();
};

class ListNode : public Node
{};

class FuncRParams : public ListNode
{						
public:
    std::vector<ExprNode*> Exprs;
    FuncRParams(std::vector<ExprNode*> Exprs) : Exprs(Exprs){};
    void output(int level);
    void typeCheck();
    void genCode();
};

class StmtNode : public Node
{
public:
    Type *type = nullptr;
};

class Empty : public StmtNode
{
public:
    void output(int level);
    void typeCheck();
    void genCode();
};

class SignleStmt : public StmtNode
{
private:
    ExprNode* expr;
public:
    SignleStmt(ExprNode* expr) : expr(expr){};
    void output(int level);
    void typeCheck();
    void genCode();
};

class CompoundStmt : public StmtNode		
{
private:
    StmtNode *stmt;
public:
    CompoundStmt(StmtNode *stmt) : stmt(stmt) {};
    void output(int level);
    void typeCheck();
    void genCode();
};

class SeqNode : public StmtNode			
{
private:
    StmtNode *stmt1, *stmt2;			
public:
    SeqNode(StmtNode *stmt1, StmtNode *stmt2) : stmt1(stmt1), stmt2(stmt2){};
    void output(int level);
    void typeCheck();
    void genCode();
};

class IfStmt : public StmtNode			
{
private:
    ExprNode *cond;				
    StmtNode *thenStmt;				
public:
    IfStmt(ExprNode *cond, StmtNode *thenStmt) : cond(cond), thenStmt(thenStmt){};
    void output(int level);
    void typeCheck();
    void genCode();
};

class WhileStmt : public StmtNode
{
private:
    ExprNode *cond;
    StmtNode *loop;
public:
    WhileStmt(ExprNode *cond, StmtNode *loop) : cond(cond), loop(loop) {};
    void output(int level);
    void typeCheck();
    void genCode();
};

class BreakStmt : public StmtNode
{
public:
    BreakStmt() {};
    void output(int level);
    void typeCheck();
    void genCode();
};

class ContinueStmt : public StmtNode
{
public:
    ContinueStmt() {};
    void output(int level);
    void typeCheck();
    void genCode();
};

class IfElseStmt : public StmtNode		
{
private:
    ExprNode *cond;				
    StmtNode *thenStmt;				
    StmtNode *elseStmt;				
public:
    IfElseStmt(ExprNode *cond, StmtNode *thenStmt, StmtNode *elseStmt) : cond(cond), thenStmt(thenStmt), elseStmt(elseStmt) {};
    void output(int level);
    void typeCheck();
    void genCode();
};

class ReturnStmt : public StmtNode
{
private:
    ExprNode *retValue;		
public:
    ReturnStmt(ExprNode*retValue) : retValue(retValue) {};
    void output(int level);
    void typeCheck();
    void genCode();
};

class AssignStmt : public StmtNode	
{
public:
    ExprNode *lval;		
    ExprNode *expr;		
    AssignStmt(ExprNode *lval, ExprNode *expr) : lval(lval), expr(expr) {};
    void output(int level);
    void typeCheck();
    void genCode();
};

class FuncFParam : public ExprNode
{
public:
    FuncFParam(SymbolEntry *se) : ExprNode(se){SymbolEntry *temp = new TemporarySymbolEntry(se->getType(), SymbolTable::getLabel()); dst = new Operand(temp);};
    void output(int level);
    void typeCheck();
    void genCode();
};


class IdList : public ListNode
{
public:
    std::vector<Id*> Ids;		
    std::vector<AssignStmt*> Assigns;	
    IdList(std::vector<Id*> Ids, std::vector<AssignStmt*> Assigns) : Ids(Ids), Assigns(Assigns) {};
    void output(int level);
    void typeCheck();
    void genCode();
};

class ConstIdList : public ListNode
{
public:
    std::vector<ConstId*> CIds;		
    std::vector<AssignStmt*> Assigns;	
    ConstIdList(std::vector<ConstId*> CIds, std::vector<AssignStmt*> Assigns) : CIds(CIds), Assigns(Assigns) {};
    void output(int level);
    void typeCheck();
    void genCode();
};

class DeclStmt : public StmtNode		
{
private:
    IdList *ids;
public:
    DeclStmt(IdList *ids) : ids(ids){};
    void output(int level);
    void typeCheck();
    void genCode();
};

class ConstDeclStmt : public StmtNode
{
private:
    ConstIdList *Cids;
public:
    ConstDeclStmt(ConstIdList *Cids) : Cids(Cids){};
    void output(int level);
    void typeCheck();
    void genCode();
};

class FuncFParams : public ListNode
{						
public:
    std::vector<FuncFParam*> FPs;		
    std::vector<AssignStmt*> Assigns;		
    FuncFParams(std::vector<FuncFParam*> FPs, std::vector<AssignStmt*> Assigns) : FPs(FPs), Assigns(Assigns) {};
    void output(int level);
    void typeCheck();
    void genCode();
};

class FunctionDef : public StmtNode	
{
private:
    SymbolEntry *se;
    FuncFParams *FPs;
    StmtNode *stmt;
public:
    FunctionDef(SymbolEntry *se, FuncFParams *FPs, StmtNode *stmt) : se(se), FPs(FPs), stmt(stmt){se->setisfunc();};
    void output(int level);
    void typeCheck();
    void genCode();
};

class FunctionCall : public ExprNode
{
public:
    FuncRParams *RPs;
    FunctionCall(SymbolEntry*se, FuncRParams *RPs) : ExprNode(se), RPs(RPs){};
    void output(int level);
    void typeCheck();
    void genCode();
};

class Ast		
{
private:
    Node* root;
public:
    Ast() {root = nullptr;}
    void setRoot(Node*n) {root = n;}
    void output();
    void typeCheck();
    void genCode(Unit *unit);
};

#endif
