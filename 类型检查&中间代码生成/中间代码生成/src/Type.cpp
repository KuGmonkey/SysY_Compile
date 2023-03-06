#include "Type.h"
#include <sstream>


IntType TypeSystem::commonInt = IntType(32);
IntType TypeSystem::commonBool = IntType(1);
VoidType TypeSystem::commonVoid = VoidType();
CharType TypeSystem::commonChar = CharType(1);
FloatType TypeSystem::commonFloat = FloatType(32); 

Type* TypeSystem::intType = &commonInt;
Type* TypeSystem::voidType = &commonVoid;
Type* TypeSystem::boolType = &commonBool;
Type* TypeSystem::charType = &commonChar;
Type* TypeSystem::floatType = &commonFloat;




std::string IntType::toStr()
{
    std::ostringstream buffer;
    buffer << "i" << size;
    return buffer.str();
}

std::string VoidType::toStr()
{
    return "void";
}

std::string CharType::toStr()
{
    return "char";
}

std::string FloatType::toStr()
{
    return "float";
}

std::string FunctionType::toStr()
{
    std::ostringstream buffer;
    buffer << returnType->toStr() << "()";
    return buffer.str();
}

std::string PointerType::toStr()
{
    std::ostringstream buffer;
    buffer << valueType->toStr() << "*";
    return buffer.str();
}

std::string ArrayType::toStr()
{
    std::ostringstream buffer;
    int len = getLength();
    buffer << valType->toStr() << "["<<len<<"]";	
    return buffer.str();
}
