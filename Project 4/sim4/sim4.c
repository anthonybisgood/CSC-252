#include "sim4.h"

WORD getInstruction(WORD curPC, WORD *instructionMemory) {
    return instructionMemory[curPC/4];
}

void extract_instructionFields(WORD instruction, InstructionFields *fieldsOut){
    fieldsOut -> opcode = instruction >> 26 & 0x3F; //0011 1111
    fieldsOut -> rs     = instruction >> 21 & 0x1F; //0001 1111
    fieldsOut -> rt     = instruction >> 16 & 0x1F;
    fieldsOut -> rd     = instruction >> 11 & 0x1F;
    fieldsOut -> shamt  = instruction >> 6 & 0x1F;
    fieldsOut -> funct  = instruction & 0x3F;
    fieldsOut -> imm16  = instruction & 0xFFFF;
    fieldsOut -> imm32  = signExtend16to32(fieldsOut -> imm16);
    fieldsOut -> address= instruction & 0x3FFFFFF;
}

int  fill_CPUControl(InstructionFields *fields, CPUControl *controlOut){
    //just set everything to 0 at beginning, less writing
    controlOut -> ALUsrc = 0;
    controlOut -> ALU.op = 0;
    controlOut -> ALU.bNegate = 0;
    controlOut -> memRead = 0;
    controlOut -> memWrite = 0;
    controlOut -> memToReg = 0;
    controlOut -> regDst = 0;
    controlOut -> regWrite = 0;
    controlOut -> branch = 0;
    controlOut -> jump = 0;
    controlOut -> extra1 = 0;
    controlOut -> extra2 = 0;
    controlOut -> extra3 = 0;
    //r format instructions
    if (fields -> opcode == 0) {
        //if opcode is 0, always going to be writing to registers
        controlOut -> regDst = 1;
        controlOut -> regWrite = 1;
        //add, addu
        if (fields -> funct == 32 || fields -> funct == 33){
            controlOut -> ALU.op = 2;
            return 1;
        //sub, subbu
        } else if (fields -> funct == 34 || fields -> funct == 35) {
            controlOut -> ALU.op = 2; 
            controlOut -> ALU.bNegate = 1;    
            return 1;
        //and    
        } else if (fields -> funct == 36){
            //already set regDst and regWrite
            return 1;
        //or
        } else if (fields -> funct == 37){
            controlOut -> ALU.op = 1;
            return 1;
        //xor
        } else if (fields -> funct == 38){
            controlOut -> ALU.op = 4;
            return 1;
        //slt
        } else if (fields -> funct == 42){
            controlOut -> ALU.op = 3;
            controlOut -> ALU.bNegate = 1;
            return 1;
        //sll
        } else if (fields -> funct == 0){
            controlOut -> extra1 = 1;
            return 1;
        }
        //invalid, return 0
        else {
            //reset controls
            controlOut -> regDst = 0;
            controlOut -> regWrite = 0;
            return 0;
        }
    //jump format
    } else if (fields -> opcode == 2){
        controlOut -> jump = 1;
        return 1;
    //i format instructions
    } else { 
        //slti
        if (fields -> opcode == 10){
            controlOut -> ALU.op = 3;
            controlOut -> ALU.bNegate = 1;
            controlOut -> ALUsrc = 1;
            controlOut -> regWrite = 1; 
            return 1;
        }
        //addi, addiu
        if (fields -> opcode == 8 || fields -> opcode == 9){
            controlOut -> ALU.op = 2; 
            controlOut -> ALUsrc = 1;
            controlOut -> regWrite = 1;
            return 1;
        }
        //lw
        if (fields -> opcode == 35){
            controlOut -> ALU.op = 2;
            controlOut -> ALUsrc = 1;
            controlOut -> memRead = 1;
            controlOut -> regWrite = 1;
            controlOut -> memToReg = 1;
            return 1;
        }
        //sw
        if (fields -> opcode == 43){
            controlOut -> ALU.op = 2;
            controlOut -> ALUsrc = 1;
            controlOut -> memWrite = 1;
            return 1;
        }
        //beq, bne
        if (fields -> opcode == 4 || fields -> opcode == 5){
            controlOut -> ALU.op = 2;
            controlOut -> ALU.bNegate = 1;
            controlOut -> branch = 1;
            //bne extra1 = 1
            if (fields -> opcode == 5){
                controlOut -> extra2 = 1;
            }
            return 1;
        }
        //andi
        if (fields -> opcode == 12){
            controlOut -> ALUsrc = 1;
            controlOut -> regWrite = 1;
            controlOut -> extra3 = 1;
            return 1;
        }
    } 
    //if not any of those, invalid input
    return 0;
}

WORD getALUinput1(CPUControl *controlIn, InstructionFields *fieldsIn, 
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33, WORD oldPC){
    if (controlIn -> extra1 == 1){
        return rtVal;
    }
    return rsVal;
}

WORD getALUinput2(CPUControl *controlIn, InstructionFields *fieldsIn,
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33, WORD oldPC){
    //for sll
    if (controlIn -> extra1 == 1){
        return fieldsIn -> shamt;
    }
    //for andi
    if (controlIn -> ALUsrc == 1 && controlIn -> extra3 == 1){
        return fieldsIn -> imm16;
    //for immediate
    } else if (controlIn -> ALUsrc == 1){
        return fieldsIn -> imm32;
    //everything else
    } else {
        return rtVal;
    }
}

void execute_ALU(CPUControl *controlIn, WORD input1, WORD input2, 
                 ALUResult  *aluResultOut){
    aluResultOut -> result = 0;
    aluResultOut -> zero = 0;
    aluResultOut -> extra = 0;
    //and
    if (controlIn -> ALU.op == 0){
        aluResultOut -> result = input1 & input2;
    //or
    } else if (controlIn -> ALU.op == 1){
        aluResultOut -> result = input1 | input2;
    //add
    } else if (controlIn -> ALU.op == 2){
        //sub
        if (controlIn -> ALU.bNegate == 1){
            input2 = -input2;
        }
        aluResultOut -> result = input1 + input2;
    //less
    } else if (controlIn -> ALU.op == 3){
        if (input1 < input2){
            aluResultOut -> result = 1;
        } 
    //xor
    } else if (controlIn -> ALU.op == 4){
        aluResultOut -> result = input1 ^ input2;
    } 
    if (aluResultOut -> result == 0){
        aluResultOut -> zero = 1;
    } else{
        aluResultOut -> zero = 0;
    }
    //sll
    if (controlIn -> extra1 == 1){
        aluResultOut -> result = input1<<input2;
    }
    //bne 
    if (controlIn -> extra2 == 1){
        //swap zeros if bne
        aluResultOut -> zero = !aluResultOut -> zero;
    }

}

void execute_MEM(CPUControl *controlIn, ALUResult  *aluResultIn,
                 WORD        rsVal, WORD rtVal,
                 WORD       *memory,
                 MemResult  *resultOut){
    resultOut -> readVal = 0;
    //lw  
    if (controlIn -> memRead == 1){
        resultOut -> readVal = memory[aluResultIn -> result / 4];
    //sw
    } else if (controlIn -> memWrite == 1){
        memory[aluResultIn -> result / 4] = rtVal;
    }
}

WORD getNextPC(InstructionFields *fields, CPUControl *controlIn, int aluZero,
               WORD rsVal, WORD rtVal,
               WORD oldPC){
    WORD newPc = oldPC + 4;
    //check if jump first 
    if (controlIn -> jump == 1){
        int upper4 = (oldPC >> 28) & 0xF;
        upper4 = upper4 << 28;
        return upper4 + (fields -> address << 2);
    //if branch
    } else if (controlIn -> branch == 1 && aluZero == 1){
        WORD toGo = fields -> imm32;
        toGo = toGo << 2;
        return toGo + newPc;
    }
    //regular line move
    return newPc;
}

void execute_updateRegs(InstructionFields *fields, CPUControl *controlIn,
                        ALUResult  *aluResultIn, MemResult *memResultIn,
                        WORD       *regs){
    if (controlIn -> regWrite == 1){
        //lw, readVal to register
        if (controlIn -> memToReg == 1){
            regs[fields -> rt] = memResultIn -> readVal;
        //R Format instructions, result to register
        } else if (controlIn -> regDst == 1){
            regs[fields -> rd] = aluResultIn -> result;
        } else{
            regs[fields -> rt] = aluResultIn -> result;
        }
    }
}