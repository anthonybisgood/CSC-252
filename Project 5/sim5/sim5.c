#include "sim5.h"
/**
 * Anthony Bisgood
 * CSC 252
 * Sim5 
 * 
 * Mimics the actions of a CPU and handles forwarding and stalling. 
 * 
 */

/**
 * @brief get all the instruction fields from 32 bit instruction
 * 
 * @param instruction 
 * @param fieldsOut 
 */
void extract_instructionFields(WORD instruction, InstructionFields *fieldsOut){
	fieldsOut->opcode = (instruction >> 26) & 0x3f;
	fieldsOut->rs = (instruction >> 21) & 0x1f;
	fieldsOut->rt = (instruction >> 16) & 0x1f;
	fieldsOut->rd = (instruction >> 11) & 0x1f;
	fieldsOut->shamt = (instruction >> 6) & 0x1f;
	fieldsOut->funct = instruction & 0x3f;
	fieldsOut->imm16 = instruction & 0xffff;
	fieldsOut->imm32 = signExtend16to32(fieldsOut->imm16);
	fieldsOut->address = instruction & 0x3ffffff;
}

/**
 * @brief returns 1 if there needs to be a stall, 0 otherwise. Checks to see if theres a sw, 
 * if there are any hazards then return 1. If not sw, checks r and i format instructions to see if 
 * there are any hazards from lw.
 * 
 * @param fields
 * @param old_idex 
 * @param old_exmem 
 * @return int 
 */
int IDtoIF_get_stall(InstructionFields *fields,ID_EX  *old_idex, EX_MEM *old_exmem){
    // check sw first
    if (fields -> opcode == 43){
        //if exmem pipeline is writing to the same register rt in fields
        if (old_exmem -> regWrite && 
            old_idex -> regWrite && 
            fields -> rt == old_exmem -> writeReg){
            if (old_exmem -> writeReg != old_idex -> rd && old_idex -> regDst){
                return 1;  
            } else if (old_exmem -> writeReg != old_idex -> rt && !old_idex -> regDst){
                return 1; 
            }
        // if old ex/mem wrote to the rt field and rt and rd fields in id/ex pipeline
        // dont equal the ex/mem write register
        } else if (old_exmem -> writeReg == fields -> rt && old_exmem -> regWrite){
            if (old_idex -> rd != old_exmem -> writeReg &&
             old_idex -> rt != old_exmem -> writeReg){
                return 1;
            }
        }
    }
    // r format instructions
    if (fields->opcode == 0){
        if (old_idex -> memRead && (fields -> rs == old_idex -> rt || 
        fields -> rt == old_idex -> rt)){
            return 1;
        }
    // i format
    } else if (fields->opcode != 0){
        if (old_idex -> memRead && (fields -> rs == old_idex -> rt)){
            return 1;
        }
    }
    return 0;
}
/**
 * @brief This asks the ID phase if the current instruction (in ID) needs to a
 * perform a branch/jump. 0 means normal advance, 1 is relative branch, 2 is absolute jump
 * 
 * @param fields 
 * @param rsVal 
 * @param rtVal 
 * @return int 
 */
int IDtoIF_get_branchControl(InstructionFields *fields, WORD rsVal, WORD rtVal){
    if (fields -> opcode == 2 || fields-> opcode == 3){
        return 2;
    } else if (fields -> opcode == 4 && rsVal == rtVal){
        return 1;
    } if (fields -> opcode == 5 && rsVal != rtVal){
        return 1;
    }
    return 0;
}

/**
 * @brief returns pcPlus4 plus the imm32 << 2
 * 
 * @param pcPlus4 
 * @param fields 
 * @return WORD 
 */
WORD calc_branchAddr(WORD pcPlus4, InstructionFields *fields){
    return (pcPlus4 + (fields -> imm32 << 2));
}

/**
 * @brief  to calculate the address that you would jump
 *  to if you perform an unconditional branch
 * 
 * @param pcPlus4 
 * @param fields 
 * @return WORD 
 */
WORD calc_jumpAddr  (WORD pcPlus4, InstructionFields *fields){
    return (fields -> address << 2) | (pcPlus4 & 0xf0000000);
}

/**
 * @brief This function implements the core of the ID phase. Its first parameter is
    the stall setting (exactly what you returned from IDtoIF get stall()).
    The next is the Fields for this instruction, followed by the rsVal and rtVal;
    last is a pointer to the (new) ID/EX pipeline register
 * 
 * @param IDstall 
 * @param fieldsIn 
 * @param pcPlus4 
 * @param rsVal 
 * @param rtVal 
 * @param new_idex 
 * @return int 
 */
int execute_ID(int IDstall, InstructionFields *fieldsIn, WORD pcPlus4, WORD rsVal, WORD rtVal, ID_EX *new_idex){
    //sets all the fields in new_idex 
    new_idex -> rs = fieldsIn -> rs;
    new_idex -> rt = fieldsIn -> rt;
    new_idex -> rd = fieldsIn -> rd;
    new_idex -> rsVal = rsVal;
    new_idex -> rtVal = rtVal;
    new_idex -> imm16 = fieldsIn -> imm16;
    new_idex -> imm32 = fieldsIn -> imm32;
    new_idex -> ALUsrc = 0;
    new_idex -> ALU.bNegate = 0;
    new_idex -> ALU.op = 0;
    new_idex -> memRead = 0;
    new_idex -> memWrite = 0;
    new_idex -> memToReg = 0;
    new_idex -> regDst = 0;
    new_idex -> regWrite = 0;
    new_idex -> extra1 = 0;
    new_idex -> extra2 = 0;
    new_idex -> extra3 = 0;
    if (IDstall){
        new_idex -> rs = 0;
        new_idex -> rt = 0;
        new_idex -> rd = 0;
        new_idex -> rsVal = 0;
        new_idex -> rtVal = 0;
        new_idex -> imm32 = 0;
        new_idex -> imm16 = 0;
        return 1;
    }
    if (fieldsIn -> opcode == 0){
        new_idex -> regDst = 1;
        new_idex -> regWrite = 1;
        //add, addu
        if (fieldsIn -> funct == 32 || fieldsIn -> funct == 33){
            new_idex -> ALU.op = 2;
            return 1;
        //sub, subbu
        } else if (fieldsIn -> funct == 34 || fieldsIn -> funct == 35) {
            new_idex -> ALU.op = 2; 
            new_idex -> ALU.bNegate = 1;    
            return 1;
        //and    
        } else if (fieldsIn -> funct == 36){
            //already set regDst and regWrite
            return 1;
        //or
        } else if (fieldsIn -> funct == 37){
            new_idex -> ALU.op = 1;
            return 1;
        //xor
        } else if (fieldsIn -> funct == 38){
            new_idex -> ALU.op = 4;
            return 1;
        //nor
        } else if (fieldsIn -> funct == 39){
            new_idex -> extra1 = 1;
            new_idex -> ALU.op = 1;
            new_idex -> ALU.bNegate = 1;
            return 1;
        //slt
        } else if (fieldsIn -> funct == 42){
            new_idex -> ALU.op = 3;
            new_idex -> ALU.bNegate = 1;
            return 1;
        //nop
        } else if (fieldsIn -> funct == 0) {
            //reset controls
            new_idex -> ALU.op = 5;
            return 1;
        } else{
            new_idex -> regDst = 0;
            new_idex -> regWrite = 0;
            return 0;
        }
    //jump format
    } else if (fieldsIn -> opcode == 2){
        new_idex -> rs = 0;
        new_idex -> rt = 0;
        new_idex -> rd = 0;
        new_idex -> rsVal = 0;
        new_idex -> rtVal = 0;
        return 1;
    //I format
    } else {
        //slti
        if (fieldsIn -> opcode == 10){
            new_idex -> ALU.op = 3;
            new_idex -> ALU.bNegate = 1;
            new_idex -> ALUsrc = 1;
            new_idex -> regWrite = 1; 
            return 1;
        }
        //addi, addiu
        if (fieldsIn -> opcode == 8 || fieldsIn -> opcode == 9){
            new_idex -> ALU.op = 2; 
            new_idex -> ALUsrc = 1;
            new_idex -> regWrite = 1;
            return 1;
        }
        //lw
        if (fieldsIn -> opcode == 35){
            new_idex -> ALU.op = 2;
            new_idex -> ALUsrc = 1;
            new_idex -> memRead = 1;
            new_idex -> regWrite = 1;
            new_idex -> memToReg = 1;
            return 1;
        }
        //sw
        if (fieldsIn -> opcode == 43){
            new_idex -> ALU.op = 2;
            new_idex -> ALUsrc = 1;
            new_idex -> memWrite = 1;
            return 1;
        }
        //beq, bne
        if (fieldsIn -> opcode == 4 || fieldsIn -> opcode == 5){
            new_idex -> rs = 0;
            new_idex -> rt = 0;
            new_idex -> rd = 0;
            new_idex -> rsVal = 0;
            new_idex -> rtVal = 0;
            return 1;
        }
        //andi
        if (fieldsIn -> opcode == 12){
            new_idex -> ALUsrc = 2;
            new_idex -> regWrite = 1;
            return 1;
        }
        //ori
        if (fieldsIn -> opcode == 13){
            new_idex -> ALUsrc = 2;
            new_idex -> regWrite = 1;
            new_idex -> ALU.op = 1;
            return 1;
        }
        //lui
        if (fieldsIn -> opcode == 15){
            new_idex -> extra3 = 1;
            new_idex -> ALU.op = 5;
            new_idex -> regWrite = 1;
            new_idex -> ALUsrc = 1;
            return 1;
        }
    }
    return 0;
}

/**
 * @brief This function must return the value which should be delivered to input 1
 * of the ALU. The first parameter is the current ID/EX register; it also has
 * pointers to the current EX/MEM and MEM/WB registers
 * 
 * @param in 
 * @param old_exMem 
 * @param old_memWb 
 * @return WORD 
 */
WORD EX_getALUinput1(ID_EX *in, EX_MEM *old_exMem, MEM_WB *old_memWb){
    if (old_exMem -> regWrite && (old_exMem -> writeReg == in -> rs)){
        return old_exMem -> aluResult;
    } else if (old_memWb -> regWrite && old_memWb -> memToReg && (old_memWb -> writeReg == in -> rs)){
        return old_memWb -> memResult;
    } else if (old_memWb -> regWrite && (old_memWb -> writeReg == in -> rs)){
        return old_memWb -> aluResult;
    } else{
        return in -> rsVal;
    }
}
    
/**
 * @brief Same as EX_getALUinput1 but can handle immidiate values.
 * 
 * @param in 
 * @param old_exMem 
 * @param old_memWb 
 * @return WORD 
 */
WORD EX_getALUinput2(ID_EX *in, EX_MEM *old_exMem, MEM_WB *old_memWb){
    //i format
    if (in -> ALUsrc == 1){
        return in -> imm32;
    } else if (in -> ALUsrc == 2){
        return in -> imm16;
    } else if (old_exMem -> regWrite && (in -> rt == old_exMem -> writeReg)){
        return old_exMem -> aluResult;
    } else if (old_memWb -> regWrite && (in -> rt == old_memWb -> writeReg)){
        return old_memWb -> aluResult;
    } else{
        return in -> rtVal;
    }
}

/**
 * @brief Does EX calculations including nor and lui, handles nop
 * 
 * @param in 
 * @param input1 
 * @param input2 
 * @param new_exMem 
 */
void execute_EX(ID_EX *in, WORD input1, WORD input2, EX_MEM *new_exMem){
    new_exMem -> rt = in -> rt;
    new_exMem -> rtVal = in -> rtVal;
    new_exMem -> memRead = in -> memRead;
    new_exMem -> memWrite = in -> memWrite;
    new_exMem -> memToReg = in -> memToReg;
    new_exMem -> regWrite = in -> regWrite;
    if (in -> regDst){
        new_exMem -> writeReg = in -> rd;
    } else {
        new_exMem -> writeReg = in -> rt;
    }
    //and
    if (in -> ALU.op == 0){
        new_exMem -> aluResult = (input1 & input2);
    //or
    } else if (in -> ALU.op == 1){
        if (in -> ALU.bNegate == 0){
            new_exMem -> aluResult = (input1 | input2);
        } else{
            new_exMem -> aluResult = ~(input1 | input2);
        }
    //xor
    } else if (in -> ALU.op == 4){
        new_exMem -> aluResult = (input1 ^ input2);
    //add/subtract
    } else if (in -> ALU.op == 2){
        //sub
        if (in -> ALU.bNegate == 1){
            new_exMem -> aluResult = input1 - input2; 
        //add
        } else {
            new_exMem -> aluResult = input1 + input2; 
        }
    //less
    } else if (in -> ALU.op == 3){
        new_exMem -> aluResult = input1 < input2; 
    //lui
    } else if (in -> extra3){
        new_exMem -> aluResult = input2 << 16;
    // nothing happens
    } else{
        new_exMem -> aluResult = 0;
    } 
}

/**
 * @brief it may read or write memory. Handles SW data forwarding so
 * the value that you write to memory might come from the MEM/WB register ahead.
 * 
 * @param in 
 * @param old_memWb 
 * @param mem 
 * @param new_memwb 
 */
void execute_MEM(EX_MEM *in, MEM_WB *old_memWb,WORD *mem, MEM_WB *new_memwb){
    new_memwb -> memToReg = in -> memToReg;
    new_memwb -> writeReg = in -> writeReg;
    new_memwb -> regWrite = in -> regWrite;
    new_memwb -> aluResult = in -> aluResult;
    //lw
    if (in -> memRead){
        new_memwb -> memResult = mem[in->aluResult / 4];
    //sw
    } else if (in -> memWrite) {
        if (old_memWb -> regWrite && old_memWb -> writeReg == in -> rt){
            //if memWb was stored in a register get it from there
            if (old_memWb -> memToReg){
                mem[in->aluResult / 4] = old_memWb -> memResult;
            //forward from alu if mem/wb register is same as in.rt reg
            } else {
                mem[in->aluResult / 4] = old_memWb -> aluResult;
            }
        //from current instruction
        } else{
            mem[in->aluResult / 4] = in -> rtVal;
        }
    } 
    //if were not lw then set memResult to 0
    if (!in->memRead){
        new_memwb -> memResult = 0;
    }
}

/**
 * @brief executes wb to registers
 * 
 * @param in 
 * @param regs 
 */
void execute_WB (MEM_WB *in, WORD *regs){
    //if we write to register
    if (in -> regWrite){
        //lw
        if (in -> memToReg){
            regs[in -> writeReg] = in -> memResult;
        //other
        } else{
            regs[in-> writeReg] = in -> aluResult;
        }
    }
}