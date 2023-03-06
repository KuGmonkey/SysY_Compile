#ifndef __TYPE_H__
#define __TYPE_H__
#include <vector>
#include <string>

class Type
{
protected:
    enum {INT, VOID, FUNC, PTR, CHAR, FLOAT, ARRAY, BOOL};
public:
    int kind;	
    Type(int kind) : kind(kind) {};	
    virtual ~Type() {};
    virtual std::string toStr() = 0;
    bool isInt() const {return kind == INT;};
    bool isVoid() const {return kind == VOID;};
    bool isFunc() const {return kind == FUNC;};
    bool isChar() const {return kind == CHAR;};
    bool isFloat() const {return kind == FLOAT;};
    bool isArray() const {return kind == ARRAY;};
    bool isBool() const {return kind == BOOL;};

};

class BoolType : public Type
{
public:
    BoolType() : Type(Type::BOOL){};
    std::string toStr();
    Type* getrettype(){return NULL;}
};

class IntType : public Type
{
private:
    int size;
public:
    IntType(int size) : Type(Type::INT), size(size){};	
    int getBits() const {return size;};
    static IntType* get(int size);
    std::string toStr();
};

class VoidType : public Type
{
public:
    VoidType() : Type(Type::VOID){};
    std::string toStr();
};

class FunctionType : public Type
{
private:
    Type *returnType;	
    std::vector<Type*> paramsType;	
public:
    FunctionType(Type* returnType, std::vector<Type*> paramsType) : 
    Type(Type::FUNC), returnType(returnType), paramsType(paramsType){};		
    Type* getRetType() {return returnType;};	
    std::string toStr();		
};

class PointerType : public Type
{
private:
    Type *valueType;	
public:
    PointerType(Type* valueType) : Type(Type::PTR) {this->valueType = valueType;};
    std::string toStr();
};

class CharType : public Type
{
private:
    int size;		
public:
    CharType(int size) : Type(Type::CHAR), size(size){};
    int getBits() const {return size;};
    static CharType* get(int size);
    std::string toStr();
};


class FloatType : public Type
{
private:
    int size;		
public:
    FloatType(int size) : Type(Type::FLOAT), size(size){};
    int getBits() const {return size;};
    static FloatType* get(int size);
    std::string toStr();
};

class ArrayType : public Type
{
private:
    Type *valType;
    int length;
public:
    ArrayType(Type* valType,int length) : 
    Type(Type::ARRAY), valType(valType),length(length){};
    std::string toStr();
    int getLength() const { return length; };
};

//类型系统
class TypeSystem
{
private:
    static IntType commonInt;
    static IntType commonBool;
    static VoidType commonVoid;
    static CharType commonChar;
    static FloatType commonFloat;
    
public:
    static Type *intType;
    static Type *voidType;
    static Type *boolType;
    static Type *charType;
    static Type *floatType;
};

#endif
