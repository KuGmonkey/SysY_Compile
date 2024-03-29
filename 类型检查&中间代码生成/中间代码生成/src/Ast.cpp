#include "Ast.h"
#include "SymbolTable.h"
#include "Unit.h"
#include "Instruction.h"
#include "IRBuilder.h"
#include <string>
#include "Type.h"

extern FILE *yyout;
int Node::counter = 0;			
IRBuilder* Node::builder = nullptr;	

Node::Node()			
{
    seq = counter++;
}

void Node::backPatch(std::vector<Instruction*> &list, BasicBlock*bb)		
{
    for(auto &inst:list)
    {
        if(inst->isCond())		
        {
            bb->addPred(dynamic_cast<CondBrInstruction*>(inst)->getParent());		
            dynamic_cast<CondBrInstruction*>(inst)->getParent()->addSucc(bb);		
            dynamic_cast<CondBrInstruction*>(inst)->setTrueBranch(bb);			
        }
        else if(inst->isUncond())	
        {
            bb->addPred(dynamic_cast<CondBrInstruction*>(inst)->getParent());		
            dynamic_cast<CondBrInstruction*>(inst)->getParent()->addSucc(bb);		
            dynamic_cast<UncondBrInstruction*>(inst)->setBranch(bb);			
        }
    }
}

void Node::backPatchFalse(std::vector<Instruction*> &list, BasicBlock*bb)
{
    for(auto &inst:list)
    {
        if(inst->isCond())		
        {
            bb->addPred(dynamic_cast<CondBrInstruction*>(inst)->getParent());		
            dynamic_cast<CondBrInstruction*>(inst)->getParent()->addSucc(bb);		
            dynamic_cast<CondBrInstruction*>(inst)->setFalseBranch(bb);			
        }
        else if(inst->isUncond())	
        {
            bb->addPred(dynamic_cast<CondBrInstruction*>(inst)->getParent());		
            dynamic_cast<CondBrInstruction*>(inst)->getParent()->addSucc(bb);		
            dynamic_cast<UncondBrInstruction*>(inst)->setBranch(bb);			
        }
    }
}

std::vector<Instruction*> Node::merge(std::vector<Instruction*> &list1, std::vector<Instruction*> &list2)	
{
    std::vector<Instruction*> res(list1);
    res.insert(res.end(), list2.begin(), list2.end());
    return res;
}

void Ast::genCode(Unit *unit)		
{
    IRBuilder *builder = new IRBuilder(unit);	
    Node::setIRBuilder(builder);
    fprintf(yyout, "declare i32 @getint()\ndeclare void @putint(i32)\ndeclare i32 @getch()\ndeclare void @putch(i32)\n");
    root->genCode();			
}

void FunctionDef::genCode()
{
    Unit *unit = builder->getUnit();		

    Function *func = new Function(unit, se);	
    BasicBlock *entry = func->getEntry();	
    
    // set the insert point to the entry basicblock of this function.
    builder->setInsertBB(entry);
    
    if(FPs)					
        FPs->genCode();
    
    stmt->genCode();	

    /**
     * Construct control flow graph. You need do set successors and predecessors for each basic block.	
     * TODO
    */
    /*
    for (auto &bb:func->getBlockList())				
    {
        Instruction *inst = bb->rbegin();			
        if(inst->isCond())					
        {
            CondBrInstruction *br;
            BasicBlock *succ1, *succ2;
            br = dynamic_cast<CondBrInstruction*>(inst);	
            succ1 = br->getTrueBranch();			
            succ2 = br->getFalseBranch();			
            bb->addSucc(succ1);				
            bb->addSucc(succ2);
            succ1->addPred(bb);					
            succ2->addPred(bb);
        }
        else if(inst->isUncond())			
        {
            UncondBrInstruction *br;
            BasicBlock *succ;
            br = dynamic_cast<UncondBrInstruction*>(inst);	
            succ = br->getBranch();				

            bb->addSucc(succ);					
            succ->addPred(bb);					
        }
    }
   */
}

void BinaryExpr::genCode()				
{
    BasicBlock *bb = builder->getInsertBB();		
    Function *func = bb->getParent();			
    if (op == AND)	
    {
        BasicBlock *trueBB = new BasicBlock(func);  // if the result of lhs is true, jump to the trueBB.
        trueBB->addPred(bb);				
        bb->addSucc(trueBB);				
        //!
        
        expr1->genCode();				
        backPatch(expr1->trueList(), trueBB);		
        builder->setInsertBB(trueBB);               	// set the insert point to the trueBB so that intructions generated by expr2 will be inserted into it.
        						
        expr2->genCode();				
        true_list = expr2->trueList();			
        false_list = merge(expr1->falseList(), expr2->falseList());	
        dst -> getType() -> kind = 7;			
    }
    else if(op == OR)		
    {
        // TODO
        BasicBlock *falseBB = new BasicBlock(func);  // if the result of lhs is true, jump to the trueBB.
        						
        expr1->genCode();				
        backPatchFalse(expr1->falseList(), falseBB);
        builder->setInsertBB(falseBB);               // set the insert point to the trueBB so that intructions generated by expr2 will be inserted into it.
        						
        expr2->genCode();				
        false_list = expr2->falseList();			
        true_list = merge(expr1->trueList(), expr2->trueList());	
        dst -> getType() -> kind = 7;			
    }
    else if(op >= LESS && op <= MORE)	
    {
        // TODO
        expr1->genCode();
        expr2->genCode();
        Operand *src1 = expr1->getOperand();	
        Operand *src2 = expr2->getOperand();	
        int opcode;
        switch (op)
        {
        case LESS:
            opcode = CmpInstruction::LESS;
            break;
        case MORE:
            opcode = CmpInstruction::MORE;
            break;
        case LESSEQ:
            opcode = CmpInstruction::LESSEQ;
            break;
        case MOREEQ:
            opcode = CmpInstruction::MOREEQ;
            break;
        case NOTEQ:
            opcode = CmpInstruction::NOTEQ;
            break;
        case EQ:
            opcode = CmpInstruction::EQ;
            break;
        default:
            break;
        }
        new CmpInstruction(opcode, dst, src1, src2, bb);	
        
        
        true_list = merge(expr1->trueList(), expr2->trueList());		
        false_list = merge(expr1->falseList(), expr2->falseList());		
        Instruction* temp = new CondBrInstruction(nullptr,nullptr,dst,bb);	
        this->trueList().push_back(temp);					
        this->falseList().push_back(temp);					
        dst -> getType() -> kind = 7;						
    }
    else if(op >= ADD && op <= SUB)		
    {
        expr1->genCode();			
        expr2->genCode();			
        Operand *src1 = expr1->getOperand();	
        Operand *src2 = expr2->getOperand();	
        int opcode;
        switch (op)
        {
        case ADD:
            opcode = BinaryInstruction::ADD;
            break;
        case SUB:
            opcode = BinaryInstruction::SUB;
            break;
        case MUL:
            opcode = BinaryInstruction::MUL;
            break;
        case DIV:
            opcode = BinaryInstruction::DIV;
            break;
        case MOL:
            opcode = BinaryInstruction::MOL;
            break;
        }
        new BinaryInstruction(opcode, dst, src1, src2, bb);	
    }
}

void Constant::genCode()
{
    // we don't need to generate code.
}

void Id::genCode()
{
    BasicBlock *bb = builder->getInsertBB();		
    Operand *addr = dynamic_cast<IdentifierSymbolEntry*>(symbolEntry)->getAddr();	
    new LoadInstruction(dst, addr, bb);			
}

void IfStmt::genCode()
{
    Function *func;
    BasicBlock *then_bb, *end_bb;		

    func = builder->getInsertBB()->getParent();	
    then_bb = new BasicBlock(func);		
    end_bb = new BasicBlock(func);
    
    then_bb -> addPred(builder->getInsertBB());		
    builder -> getInsertBB() -> addSucc(then_bb);	
    end_bb -> addPred(then_bb);
    then_bb -> addSucc(end_bb);
    end_bb -> addPred(builder -> getInsertBB());	
    builder -> getInsertBB() -> addSucc(end_bb);
    
    if(cond != nullptr)
    	cond->genCode();
    if(!cond -> getOperand() -> getType() -> isBool())	
    {
        BasicBlock* bb=cond->builder->getInsertBB();	
        Operand *src = cond->getOperand();		
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, 0);	
        Constant* digit = new Constant(se);					
        Operand* t = new Operand(new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel()));
        CmpInstruction* temp = new CmpInstruction(CmpInstruction::NOT, t, src, digit->getOperand(), bb);	
        src=t;
        cond->trueList().push_back(temp);	
        cond->falseList().push_back(temp);	
        Instruction* m = new CondBrInstruction(nullptr,nullptr,t,bb);	
        cond->trueList().push_back(m);		
        cond->falseList().push_back(m);		
    }
    
    backPatch(cond->trueList(), then_bb);	
    backPatchFalse(cond->falseList(), end_bb);	

    builder->setInsertBB(then_bb);		
    thenStmt->genCode();
    then_bb = builder->getInsertBB();		
    new UncondBrInstruction(end_bb, then_bb);	
    						
    builder->setInsertBB(end_bb);		
    
}

void IfElseStmt::genCode()
{
    // TODO
    Function *func;
    BasicBlock *then_bb,*else_bb,*end_bb;	
    
    func = builder->getInsertBB()->getParent();	
    then_bb = new BasicBlock(func);		
    else_bb = new BasicBlock(func);
    end_bb = new BasicBlock(func);
    
    then_bb -> addPred(builder -> getInsertBB());	
    builder -> getInsertBB() -> addSucc(then_bb);

    else_bb -> addPred(builder -> getInsertBB());	
    builder -> getInsertBB() -> addSucc(else_bb);

    end_bb -> addPred(then_bb);		
    then_bb -> addSucc(end_bb);
    end_bb -> addPred(else_bb);		
    else_bb -> addSucc(end_bb);

    cond -> genCode();
    if(!cond -> getOperand() -> getType() -> isBool())	
    {
        BasicBlock* bb=cond->builder->getInsertBB();	
        Operand *src = cond->getOperand();		
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, 0);	
        Constant* digit = new Constant(se);					
        Operand* t = new Operand(new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel()));	
        CmpInstruction* temp = new CmpInstruction(CmpInstruction::NOT, t, src, digit->getOperand(), bb);	
        src=t;
        cond->trueList().push_back(temp);	
        cond->falseList().push_back(temp);	
        Instruction* m = new CondBrInstruction(nullptr,nullptr,t,bb);	
        cond->trueList().push_back(m);		
        cond->falseList().push_back(m);		
    }
    
    backPatch(cond -> trueList(), then_bb);		
    backPatchFalse(cond -> falseList(), else_bb);	

    builder -> setInsertBB(then_bb);			
    thenStmt -> genCode();
    then_bb = builder -> getInsertBB();			
    new UncondBrInstruction(end_bb, then_bb);		

    builder -> setInsertBB(else_bb);			
    elseStmt->genCode();
    else_bb = builder->getInsertBB();			
    new UncondBrInstruction(end_bb, else_bb);		

    builder->setInsertBB(end_bb);			
    
}

void CompoundStmt::genCode()
{
    // TODO
    stmt->genCode();
}

void SeqNode::genCode()
{
    // TODO
    stmt1->genCode();
    stmt2->genCode();
}

void DeclStmt::genCode()
{
    for(auto iter = ids->Ids.rbegin(); iter != ids->Ids.rend(); iter++)		
    {
        IdentifierSymbolEntry *se = dynamic_cast<IdentifierSymbolEntry *>((*iter)-> getSymPtr());	
        if(se->isGlobal())		
        {
            Operand *addr;
            SymbolEntry *addr_se;
            addr_se = new IdentifierSymbolEntry(*se);		
            addr_se->setType(new PointerType(se->getType()));	
            addr = new Operand(addr_se);
            se->setAddr(addr);
            bool temp = false;
            Operand *src;
            
            for(long unsigned int i = 0; i < ids -> Assigns.size(); i++)	
            {
                if(ids -> Assigns[i] -> lval -> symbolEntry == se)		
                {
                    ids -> Assigns[i] -> genCode();
                    src = ids -> Assigns[i] -> expr -> getOperand();		
                    temp = true;
                    break; 
                }              
            }
            if(temp == false)							
            {
                SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, 0);	
                Constant* digit = new Constant(se);
                src = digit -> getOperand();						
            }
            Instruction *alloca = new AllocaInstruction2(src, addr, se);		
            alloca -> output();
        }
        else if(se->isLocal())				
        {
            Function *func = builder->getInsertBB()->getParent();		
            BasicBlock *entry = func->getEntry();				
            Instruction *alloca;
            Operand *addr;
            SymbolEntry *addr_se;
            Type *type;
            type = new PointerType(se->getType());				
            addr_se = new TemporarySymbolEntry(type, SymbolTable::getLabel());
            addr = new Operand(addr_se);
            alloca = new AllocaInstruction(addr, se);                  
            entry->insertFront(alloca);                               
            								
            se->setAddr(addr);                                         
            								
        }
    }
    for(long unsigned int i = 0; i < ids -> Assigns.size(); i++)	
    {
        IdentifierSymbolEntry *se = dynamic_cast<IdentifierSymbolEntry *>(ids -> Assigns[i] -> lval -> getSymPtr());	
        if(se -> isGlobal())		
        { 
            continue;                   
        }
        else if(se -> isLocal())	
        {
            Operand *addr = dynamic_cast<IdentifierSymbolEntry*>(ids -> Assigns[i] -> lval ->getSymPtr())->getAddr();	
            se->setAddr(addr); 				
            ids -> Assigns[i] -> genCode();
        }
    }
}

void ReturnStmt::genCode()
{
    // TODO
    BasicBlock* bb = builder->getInsertBB();		

    retValue -> genCode();
    Operand* src = retValue -> getOperand();

    new RetInstruction(src, bb);			
    
}

void AssignStmt::genCode()
{
    BasicBlock *bb = builder->getInsertBB();		
    expr->genCode();
    Operand *addr = dynamic_cast<IdentifierSymbolEntry*>(lval->getSymPtr())->getAddr();		
    Operand *src = expr->getOperand();			
    /***
     * We haven't implemented array yet, the lval can only be ID. So we just store the result of the `expr` to the addr of the id.   
     * If you want to implement array, you have to caculate the address first and then store the result into it.		   
     */
    new StoreInstruction(addr, src, bb);		
}

void SignleStmt::genCode()
{
    expr -> genCode();
}

void Empty::genCode()
{
    //do nothing
}


void FuncRParams::genCode()
{
    //do nothing
}

void FuncFParam::genCode()
{
    //do nothing
    BasicBlock *bb = builder->getInsertBB();			
    Operand *addr = dynamic_cast<IdentifierSymbolEntry*>(symbolEntry)->getAddr();	
    new LoadInstruction(dst, addr, bb);				
}

void FuncFParams::genCode()
{
    Function *func = builder -> getInsertBB() -> getParent();	
    for(long unsigned int i = 0; i < FPs.size(); i++)		
    {
        IdentifierSymbolEntry *se = dynamic_cast<IdentifierSymbolEntry *>(FPs[i]->getSymPtr());	
        Type *type1 = new PointerType(se->getType());			
        Type *type2 = new IntType(32);					
        SymbolEntry *addr_se = new TemporarySymbolEntry(type2, SymbolTable::getLabel());	
        Operand *addr = new Operand(addr_se);

        SymbolTable :: counter++; 
        SymbolEntry *addr_se2 = new TemporarySymbolEntry(type1, SymbolTable::getLabel());	
        Operand *addr2 = new Operand(addr_se2);

        BasicBlock *entry = func->getEntry();			
        Instruction *alloca;
        alloca = new AllocaInstruction(addr2, se);          	
        entry->insertBack(alloca);                             
        							
        StoreInstruction *store = new StoreInstruction(addr2, addr);	
        entry -> insertBack(store);				


        se->setAddr(addr2);   			
        func->params.push_back(addr);		
    }
}

void FunctionCall::genCode()
{
    std::vector<Operand*> params;
    if(RPs != nullptr)
        for(unsigned i = 0; i < RPs -> Exprs.size(); i++)	
        {
            if(RPs -> Exprs[i] != nullptr)				
        	    RPs -> Exprs[i] -> genCode();
            params.push_back(RPs -> Exprs[i] -> getOperand());	
        }
    BasicBlock *entry = builder -> getInsertBB();		

    Type *type2 = new IntType(32);			
    SymbolTable :: counter++; 				
    SymbolEntry *addr_se2 = new TemporarySymbolEntry(type2, SymbolTable::getLabel());
    dst = new Operand(addr_se2);			
    FunctioncallInstruction *temp = new FunctioncallInstruction(dst ,symbolEntry, params);	
    entry -> insertBack(temp);				
}

void ConstIdList::genCode()
{
    //do nothing
}

void IdList::genCode()
{
    //do nothing
}

void WhileStmt::genCode()
{
    Function *func;
    BasicBlock *loop_bb, *end_bb , *cond_bb;


    func = builder -> getInsertBB() -> getParent();	
    loop_bb = new BasicBlock(func);
    end_bb = new BasicBlock(func);
    cond_bb = new BasicBlock(func);

    UncondBrInstruction *temp = new UncondBrInstruction(cond_bb, builder -> getInsertBB());	
    temp -> output();

    cond_bb -> addPred(builder -> getInsertBB());	
    builder -> getInsertBB() -> addSucc(cond_bb);
    loop_bb -> addPred(cond_bb);			
    cond_bb -> addSucc(loop_bb);

    end_bb -> addPred(loop_bb);				
    loop_bb -> addSucc(end_bb);

    end_bb -> addPred(cond_bb);				
    cond_bb -> addSucc(end_bb);

    builder->setInsertBB(cond_bb);			

    cond -> genCode();
    if(!cond -> getOperand() -> getType() -> isBool())
    {
        BasicBlock* bb=cond->builder->getInsertBB();	
        Operand *src = cond->getOperand();		
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, 0);	
        Constant* digit = new Constant(se);
        Operand* t = new Operand(new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel()));
        CmpInstruction* temp = new CmpInstruction(CmpInstruction::NOT, t, src, digit->getOperand(), bb);	
        src=t;					
        cond->trueList().push_back(temp);
        cond->falseList().push_back(temp);	
        Instruction* m = new CondBrInstruction(nullptr,nullptr,t,bb);
        cond->trueList().push_back(m);		
        cond->falseList().push_back(m);		
    }
    backPatch(cond -> trueList(), loop_bb);		
    backPatchFalse(cond -> falseList(), end_bb);	
    
    builder -> setInsertBB(loop_bb);			
    loop -> genCode();
    loop_bb = builder -> getInsertBB();			
    new CondBrInstruction(cond_bb, end_bb, cond->getOperand(), loop_bb);	

    builder->setInsertBB(end_bb);	
}

void ConstDeclStmt::genCode()
{
    for(long unsigned int i = 0; i < Cids -> CIds.size(); i++)		
    {
        IdentifierSymbolEntry *se = dynamic_cast<IdentifierSymbolEntry *>(Cids -> CIds[i] -> getSymPtr());	
        if(se->isGlobal())		
        {
            Operand *addr;
            SymbolEntry *addr_se;
            addr_se = new IdentifierSymbolEntry(*se);		
            addr_se->setType(new PointerType(se->getType()));	
            addr = new Operand(addr_se);
            se->setAddr(addr);					
            Cids -> Assigns[i] -> genCode();			
            Operand *src = Cids -> Assigns[i] -> expr -> getOperand();		
            Instruction *alloca = new AllocaInstruction2(src ,addr, se);	
            alloca -> output();
        }
        else if(se->isLocal())		
        {
            Function *func = builder->getInsertBB()->getParent();		
            BasicBlock *entry = func->getEntry();				
            Instruction *alloca;
            Operand *addr;
            SymbolEntry *addr_se;
            Type *type;
            type = new PointerType(se->getType());				
            addr_se = new TemporarySymbolEntry(type, SymbolTable::getLabel());	
            addr = new Operand(addr_se);
            alloca = new AllocaInstruction(addr, se);                
            entry->insertFront(alloca);                               
            se->setAddr(addr);						

            Cids -> Assigns[i] -> expr -> genCode();			
            Operand *addr1 = dynamic_cast<IdentifierSymbolEntry*>(Cids -> Assigns[i] -> lval ->getSymPtr())->getAddr();	
            se->setAddr(addr1); 					
            Operand *src = Cids -> Assigns[i] -> expr -> getOperand();	
            BasicBlock *ttt = builder -> getInsertBB();			
            new StoreInstruction(addr1, src, ttt);                      
        }
    }
}

void ContinueStmt::genCode()
{
    //do nothing
}

void BreakStmt::genCode()
{
    //do nothing
}

void ConstId::genCode()
{
    //do nothing!
}

void SignleExpr::genCode()
{
    BasicBlock *bb = builder->getInsertBB();		
    if(op == NOT)					
    {
        Operand *src = expr->getOperand(); 		
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, 0);	
        Constant* digit = new Constant(se);
        expr->genCode();
        if(!expr -> getOperand() -> getType() -> isBool()){		
            Operand* t=new Operand(new TemporarySymbolEntry(TypeSystem::boolType, SymbolTable::getLabel()));
            new CmpInstruction(CmpInstruction::NOT, t, src, digit->getOperand(), bb);	
            src=t;			
        }
        new XorInstruction(dst,src,bb);		
        dst -> getType() -> kind = 7;		
        isCond = true;
    }
    if(op >= SUB && op <= ADD)			
    {
        expr->genCode();
        Operand *src = expr->getOperand();	
        if(src -> getType() -> isBool())	
        {
            Operand* t =new Operand(new TemporarySymbolEntry(TypeSystem::intType,SymbolTable::getLabel()));
            new ZextInstruction(t,expr -> dst,bb); 	
            expr -> dst = t;
            src = t; 
        }
        int opcode;
        switch (op)
        {
        case ADD:
            opcode = BinaryInstruction::ADD;
            break;
        case SUB:
            opcode = BinaryInstruction::SUB;
            break;
        default:
            break;
        }
        SymbolEntry *se = new ConstantSymbolEntry(TypeSystem::intType, 0);	
        Constant* digit = new Constant(se);
        new BinaryInstruction(opcode, dst, digit -> getOperand(), src, bb);	
        isCond = expr -> isCond;
    }
}


void Ast::typeCheck()	
{
    if(root != nullptr)
        root->typeCheck();
}

void FunctionDef::typeCheck()
{
    // TODO  
    if(FPs)			
        FPs->typeCheck();
    stmt->typeCheck();
    
}

void BinaryExpr::typeCheck()
{
    // TODO
    expr1->typeCheck();
    expr2->typeCheck();
    Type *type1 = expr1->getSymPtr()->getType();	
    Type *type2 = expr2->getSymPtr()->getType();	
    
    if(type1 != type2)				
    {
    	fprintf(stderr, "type %s and %s mismatch in line xx",type1->toStr().c_str(), type2->toStr().c_str());
    	exit(EXIT_FAILURE);
    }    
    symbolEntry->setType(type1);	
}

void Constant::typeCheck()
{
    // Todo
}

void Id::typeCheck()
{
    // Todo
}

void IfStmt::typeCheck()
{
    // TODO

}

void IfElseStmt::typeCheck()
{
    // TODO

}

void WhileStmt::typeCheck() 
{
}

void CompoundStmt::typeCheck()
{
    // TODO
}

void SeqNode::typeCheck()
{
    // TODO
}

void DeclStmt::typeCheck()
{
    // TODO

}

void ReturnStmt::typeCheck()
{
    // TODO
    if(retValue != nullptr)
        retValue->typeCheck();
}

void AssignStmt::typeCheck()
{
    // TODO

}

void SignleStmt::typeCheck()
{

}

void FuncRParams::typeCheck()
{
    
}

void Empty::typeCheck()
{
    
}

void FuncFParam::typeCheck()
{
    
}

void FuncFParams::typeCheck()
{
    
}

void ConstIdList::typeCheck()
{
    
}

void IdList::typeCheck()
{
    
}

void FunctionCall::typeCheck()
{
    
}

void ConstDeclStmt::typeCheck()
{
    
}

void ContinueStmt::typeCheck()
{
    
}

void BreakStmt::typeCheck()
{
    
}

void ConstId::typeCheck()
{
    
}

void SignleExpr::typeCheck()
{
    Type *type = expr -> getSymPtr() -> getType();	
    if(type -> isVoid()){				
        fprintf(stderr, "type can't be void");
        exit(EXIT_FAILURE);
    }
    symbolEntry -> setType(type);
    expr -> typeCheck();
}

void BinaryExpr::output(int level)	
{
    std::string op_str;
    switch(op)				
    {
        case ADD:
            op_str = "add";
            break;
        case SUB:
            op_str = "sub";
            break;
        case AND:
            op_str = "and";
            break;
        case OR:
            op_str = "or";
            break;
        case LESS:
            op_str = "less";
            break;
        case MORE:
            op_str = "more";
            break;
        case MOREEQ:
            op_str = "moreeq";
            break;
        case LESSEQ:
            op_str = "lesseq";
            break;
        case EQ:
            op_str = "eq";
            break;
        case DIV:
            op_str = "div";
            break;
        case MUL:
            op_str = "mul";
            break;
        case MOL:
            op_str = "mol";
            break;
    }
    fprintf(yyout, "%*cBinaryExpr\top: %s\n", level, ' ', op_str.c_str());	
    expr1->output(level + 4);			
    expr2->output(level + 4);
}

void Ast::output()
{
    fprintf(yyout, "program\n");
    if(root != nullptr)
        root->output(4);
}

void SignleExpr::output(int level)
{
    std::string op_str;
    switch(op)
    {
        case SUB:
            op_str = "negative";		
            break;
        case ADD:
            op_str = "positive";		
            break;
        case NOT:				
            op_str = "anti";
            break;
        case BITAND:				
            op_str = "bitand";
            break;
        case BITOR:				
            op_str = "bitor";
            break;
        case BITNOT:				
            op_str = "bitnot";
            break;

    }
    fprintf(yyout, "%*cSignleExpr\top: %s\n", level, ' ', op_str.c_str());
    expr->output(level + 4);
}

void Constant::output(int level)
{
    std::string type, value;
    type = symbolEntry->getType()->toStr();
    value = symbolEntry->toStr();
    fprintf(yyout, "%*cIntegerLiteral\tvalue: %s\ttype: %s\n", level, ' ',
            value.c_str(), type.c_str());
}

void ConstId::output(int level)
{
    std::string name, type;
    int scope;					
    name = symbolEntry->toStr();
    type = symbolEntry->getType()->toStr();
    scope = dynamic_cast<IdentifierSymbolEntry*>(symbolEntry)->getScope();	
    fprintf(yyout, "%*cConstId\tname: %s\tscope: %d\ttype: %s\n", level, ' ',
            name.c_str(), scope, type.c_str());
}

void Id::output(int level)
{
    std::string name, type;
    int scope;
    name = symbolEntry->toStr();
    type = symbolEntry->getType()->toStr();
    scope = dynamic_cast<IdentifierSymbolEntry*>(symbolEntry)->getScope();
    fprintf(yyout, "%*cId\tname: %s\tscope: %d\ttype: %s\n", level, ' ',
            name.c_str(), scope, type.c_str());
}

void FuncFParam::output(int level)
{
    std::string name, type;
    int scope;
    name = symbolEntry -> toStr();
    type = symbolEntry -> getType() -> toStr();
    scope = dynamic_cast<IdentifierSymbolEntry*>(symbolEntry) -> getScope();
    fprintf(yyout, "%*cFuncFParam\tname:%s\tscope:%d\ttype:%s\n", level, ' ',
            name.c_str(), scope, type.c_str());
}

void CompoundStmt::output(int level)
{
    fprintf(yyout, "%*cCompoundStmt\n", level, ' ');
    stmt->output(level + 4);
}

void SeqNode::output(int level)
{
    stmt1->output(level);
    stmt2->output(level);
}

void BreakStmt::output(int level)
{
    fprintf(yyout, "%*cBreakStmt\n", level, ' ');
}

void ContinueStmt::output(int level)
{
    fprintf(yyout, "%*cContinueStmt\n", level, ' ');
}

void DeclStmt::output(int level)
{
    fprintf(yyout, "%*cDeclStmt\n", level, ' ');
    ids->output(level + 4);
}

void IfStmt::output(int level)
{
    fprintf(yyout, "%*cIfStmt\n", level, ' ');
    cond->output(level + 4);
    thenStmt->output(level + 4);
}

void IfElseStmt::output(int level)
{
    fprintf(yyout, "%*cIfElseStmt\n", level, ' ');
    cond->output(level + 4);
    thenStmt->output(level + 4);
    elseStmt->output(level + 4);
}

void ConstDeclStmt::output(int level)
{
    fprintf(yyout, "%*cConstDeclStmt\n", level, ' ');
    Cids->output(level + 4);
}

void ReturnStmt::output(int level)
{
    fprintf(yyout, "%*cReturnStmt\n", level, ' ');
    retValue->output(level + 4);
}

void AssignStmt::output(int level)
{
    fprintf(yyout, "%*cAssignStmt\n", level, ' ');
    lval->output(level + 4);
    expr->output(level + 4);
}

void FunctionDef::output(int level)
{
    std::string name, type;
    name = se->toStr();
    type = se->getType()->toStr();
    fprintf(yyout, "%*cFunctionDefine function name: %s, type: %s\n", level, ' ', 
            name.c_str(), type.c_str());
    stmt->output(level + 4);
}

void WhileStmt::output(int level)
{
    fprintf(yyout, "%*cWhileStmt\n", level, ' ');
    cond->output(level + 4);
    loop->output(level + 4);
}

void IdList::output(int level)
{
    fprintf(yyout, "%*cIdList\n", level, ' ');
    for(long unsigned int i = 0; i < Ids.size(); i++)
    {
        Ids[i] -> output(level + 4);
    }
    for(long unsigned int i = 0; i < Assigns.size(); i++)
    {
        Assigns[i] -> output(level + 4);
    }
}
void ConstIdList::output(int level)
{
    fprintf(yyout, "%*cConstIdList\n", level, ' ');
    for(long unsigned int i = 0; i < CIds.size(); i++)
    {
        CIds[i] -> output(level + 4);
        Assigns[i] -> output(level + 4);
    }
}

void FuncFParams::output(int level)
{
    fprintf(yyout, "%*cFuncFParams\n", level, ' ');
    for(long unsigned int i = 0; i < FPs.size(); i++)
    {
        FPs[i] -> output(level + 4);
    }
    for(long unsigned int i = 0; i < Assigns.size(); i++)
    {
        Assigns[i] -> output(level + 4);
    }
}

void FuncRParams::output(int level)
{
    fprintf(yyout, "%*cFuncRParams\n", level, ' ');
    for(long unsigned int i = 0; i < Exprs.size(); i++)
    {
        Exprs[i] -> output(level + 4);
    }
}

void FunctionCall::output(int level)
{
    std::string name, type;
    name = symbolEntry->toStr();
    type = symbolEntry->getType()->toStr();
    fprintf(yyout, "%*cFuncCall\tname: %s\ttype: %s\n", level, ' ',
            name.c_str(), type.c_str());
    if(RPs != nullptr)
    {
        RPs -> output(level + 4);
    }
}

void Empty::output(int level)
{
    fprintf(yyout, "%*cEmpty Statement\n", level, ' ');
}

void SignleStmt::output(int level)
{
    fprintf(yyout, "%*cSignle Statement\n", level, ' ');
    expr -> output(level + 4);
}
