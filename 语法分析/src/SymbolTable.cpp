#include "SymbolTable.h"
#include <iomanip>
#include <iostream>
#include <sstream>
#include "Type.h"

//构造函数 和 toStr()函数
SymbolEntry::SymbolEntry(Type *type, int kind) 
{
    this->type = type;
    this->kind = kind;
}

ConstantSymbolEntry::ConstantSymbolEntry(Type *type, int value) : SymbolEntry(type, SymbolEntry::CONSTANT)
{
    this->value = value;
}

ConstantSymbolEntry::ConstantSymbolEntry(Type *type, float fvalue) : SymbolEntry(type, SymbolEntry::CONSTANT)
{
    this->fvalue = fvalue;
}

int ConstantSymbolEntry::getValue() const {
    if(type->isInt())
        return value;
    else
        return fvalue;
}

// 这里需要判断一下再输出
std::string ConstantSymbolEntry::toStr(){
    if(type->isInt())
    {
        std::ostringstream buffer;
        buffer << value;
        return buffer.str();
    }
    else
    {
        std::ostringstream buffer;
        buffer << fvalue;
        return buffer.str();
    }
}

IdentifierSymbolEntry::IdentifierSymbolEntry(Type *type, std::string name, int scope) : SymbolEntry(type, SymbolEntry::VARIABLE), name(name)
{
    this->scope = scope;
}

std::string IdentifierSymbolEntry::toStr()
{
    return name;
}

TemporarySymbolEntry::TemporarySymbolEntry(Type *type, int label) : SymbolEntry(type, SymbolEntry::TEMPORARY)
{
    this->label = label;
}

std::string TemporarySymbolEntry::toStr()	//将 label 转换为字符串类型
{
    std::ostringstream buffer;
    buffer << "t" << label;
    return buffer.str();
}

SymbolTable::SymbolTable()			//构造函数
{
    prev = nullptr;
    level = 0;
}

SymbolTable::SymbolTable(SymbolTable *prev)
{
    this->prev = prev;
    this->level = prev->level + 1;	
}

/*
    Description: lookup the symbol entry of an identifier in the symbol table				描述：在符号表中查找标识符的符号条目
    Parameters: 											参数：
        name: identifier name										name: 标识符的名字
    Return: pointer to the symbol entry of the identifier						Return：指向标识符符号项的指针

    hint:												提示：														
    1. The symbol table is a stack. The top of the stack contains symbol entries in the current scope.	1.符号表是一个堆栈。堆栈顶部包含当前作用域中的符号项
    2. Search the entry in the current symbol table at first.						2.首先搜索当前符号表中的条目。
    3. If it's not in the current table, search it in previous ones(along the 'prev' link).		3.如果它不在当前表中，请在以前的表中搜索（沿着“prev” link）
    4. If you find the entry, return it.								4.如果找到了节点，返回
    5. If you can't find it in all symbol tables, return nullptr.					5.如果在所有符号表中都找不到，返回nullptr.
*/
SymbolEntry* SymbolTable::lookup(std::string name)
{
    //TODO:实现符号表的查找函数
    SymbolTable *t = this;
    while(t != nullptr)
    {
        if(t -> symbolTable[name] != 0)
        {
            return t -> symbolTable[name];
        }
        t = t -> prev;		//跳出该作用域
    }
    return nullptr;   
}

// install the entry into current symbol table.				插入
void SymbolTable::install(std::string name, SymbolEntry* entry)
{
    symbolTable[name] = entry;
}

int SymbolTable::counter = 0;				//当前符号表中的标识符数量
static SymbolTable t;					//符号表 t
SymbolTable *identifiers = &t;				
SymbolTable *globals = &t;
