#ifndef __SYMBOLTABLE_H__	//if not define
#define __SYMBOLTABLE_H__

#include <assert.h>
#include <iostream>
#include <string>
#include <map>

class Type;

class SymbolEntry		//符号表节点类
{
private:
    int kind;
protected:
    enum {CONSTANT, VARIABLE, TEMPORARY};	//常数   变量   ?
    Type *type;

public:
    SymbolEntry(Type *type, int kind);		//构造函数
    virtual ~SymbolEntry() {};			//虚 析构函数
    bool isConstant() const {return kind == CONSTANT;};		//判断 CONSTANT
    bool isTemporary() const {return kind == TEMPORARY;};	//判断 TEMPORARY
    bool isVariable() const {return kind == VARIABLE;};		//判断VARIABLE
    Type* getType() {return type;};				//获取类型
    virtual std::string toStr() = 0;				//纯虚函数 toStr()
    // You can add any function you need here.
};


/*  
    Symbol entry for literal constant. Example:

    int a = 1;

    Compiler should create constant symbol entry for literal constant '1'.	编译器应为文字常量“1”创建常量符号项
*/
class ConstantSymbolEntry : public SymbolEntry		//Constant类型 符号表节点，继承符号表节点
{
private:
    int value;		//常量数值
    float fvalue;      //浮点数

public:
    ConstantSymbolEntry(Type *type, int value);		//构造函数
    ConstantSymbolEntry(Type *type, float fvalue);
    virtual ~ConstantSymbolEntry() {};			//虚 析构函数
    int getValue() const;		//获取 值value
    std::string toStr();				
    // You can add any function you need here.
};


/* 
    Symbol entry for identifier. Example:

    int a;
    int b;
    void f(int c)
    {
        int d;
        {
            int e;
        }
    }

    Compiler should create identifier symbol entries for variables a, b, c, d and e:	编译器应为变量a、b、c、d和e创建标识符符号条目：

    | variable | scope    |
    | a        | GLOBAL   |
    | b        | GLOBAL   |
    | c        | PARAM    |
    | d        | LOCAL    |
    | e        | LOCAL +1 |
*/
class IdentifierSymbolEntry : public SymbolEntry	//Variable变量类型 符号表节点
{
private:
    enum {GLOBAL, PARAM, LOCAL};			//全局   参数   局部
    std::string name;					//标识符名字
    int scope;						//作用域
    // You can add any field you need here.

public:
    IdentifierSymbolEntry(Type *type, std::string name, int scope);	//构造函数
    virtual ~IdentifierSymbolEntry() {};				//虚 析构函数
    std::string toStr();
    bool isGlobal() const { return scope == GLOBAL; };
    bool isParam() const { return scope == PARAM; };
    bool isLocal() const { return scope >= LOCAL; };
    int getScope() const {return scope;};				//获取作用域
    // You can add any function you need here.
};


/* 
    Symbol entry for temporary variable created by compiler. Example:

    int a;
    a = 1 + 2 + 3;

    The compiler would generate intermediate code like:			编译器将生成中间代码

    t1 = 1 + 2
    t2 = t1 + 3
    a = t2

    So compiler should create temporary symbol entries for t1 and t2:	所以编译器应该为t1和t2创建临时符号条目：

    | temporary variable | label |
    | t1                 | 1     |
    | t2                 | 2     |
*/
class TemporarySymbolEntry : public SymbolEntry		//Temporary类型 符号表节点
{
private:
    int label;
public:
    TemporarySymbolEntry(Type *type, int label);	//构造函数
    virtual ~TemporarySymbolEntry() {};			//析构函数
    std::string toStr();
    int getLabel() const { return label; };
    // You can add any function you need here.
};

// symbol table managing identifier symbol entries
class SymbolTable					//符号表类
{
private:
    std::map<std::string, SymbolEntry*> symbolTable;		//map 容器是一个键值对 key-value 的映射。是一棵以 key 为关键码的红黑树。
    SymbolTable *prev;						//前向指针，指向前一个符号表
    int level;							
    static int counter;
public:
    SymbolTable();						//无参构造函数
    SymbolTable(SymbolTable *prev);				//含参构造函数
    void install(std::string name, SymbolEntry* entry);		
    SymbolEntry* lookup(std::string name);
    SymbolTable* getPrev() {return prev;};
    int getLevel() {return level;};
    static int getLabel() {return counter++;};
};

extern SymbolTable *identifiers;
extern SymbolTable *globals;

#endif
