#include "sim4.h"

WORD getInstruction(WORD curPC, WORD *instructionMemory) {
	return instructionMemory[curPC >> 2];
}

void extract_instructionFields(WORD instruction, InstructionFields *fieldsOut) {
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

void add(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0;
	controlOut->ALU.op = 0x2;
	controlOut->ALU.bNegate = 0;
	controlOut->memRead = 0;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0;
	controlOut->regDst = 0x1;
	controlOut->regWrite = 0x1;
	controlOut->branch = 0;
	controlOut->jump = 0;
}
void addu(InstructionFields *fields, CPUControl *controlOut) {
	add(fields, controlOut);
}
void sub(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0;
	controlOut->ALU.op = 0x2;
	controlOut->ALU.bNegate = 0x1;
	controlOut->memRead = 0;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0;
	controlOut->regDst = 0x1;
	controlOut->regWrite = 0x1;
	controlOut->branch = 0;
	controlOut->jump = 0;
}
void subu(InstructionFields *fields, CPUControl *controlOut) {
	sub(fields, controlOut);
}
void addi(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0x1;
	controlOut->ALU.op = 0x2;
	controlOut->ALU.bNegate = 0;
	controlOut->memRead = 0;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0;
	controlOut->regDst = 0;
	controlOut->regWrite = 0x1;
	controlOut->branch = 0;
	controlOut->jump = 0;
}
void addiu(InstructionFields *fields, CPUControl *controlOut) {
	addi(fields, controlOut);
}

void and(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0;
	controlOut->ALU.op = 0;
	controlOut->ALU.bNegate = 0;
	controlOut->memRead = 0;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0;
	controlOut->regDst = 0x1;
	controlOut->regWrite = 0x1;
	controlOut->branch = 0;
	controlOut->jump = 0;
}
void or(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0;
	controlOut->ALU.op = 0x1;
	controlOut->ALU.bNegate = 0;
	controlOut->memRead = 0;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0;
	controlOut->regDst = 0x1;
	controlOut->regWrite = 0x1;
	controlOut->branch = 0;
	controlOut->jump = 0;
}
void xor(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0;
	controlOut->ALU.op = 0x4;
	controlOut->ALU.bNegate = 0;
	controlOut->memRead = 0;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0;
	controlOut->regDst = 0x1;
	controlOut->regWrite = 0x1;
	controlOut->branch = 0;
	controlOut->jump = 0;
}

void slt(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0;
	controlOut->ALU.op = 0x3;
	controlOut->ALU.bNegate = 1;
	controlOut->memRead = 0;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0;
	controlOut->regDst = 0x1;
	controlOut->regWrite = 0x1;
	controlOut->branch = 0;
	controlOut->jump = 0;
}
void slti(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0x1;
	controlOut->ALU.op = 0x3;
	controlOut->ALU.bNegate = 1;
	controlOut->memRead = 0;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0;
	controlOut->regDst = 0;
	controlOut->regWrite = 0x1;
	controlOut->branch = 0;
	controlOut->jump = 0;
}
void andi(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0x1;
	controlOut->ALU.op = 0x0;
	controlOut->ALU.bNegate = 0;
	controlOut->memRead = 0;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0;
	controlOut->regDst = 0;
	controlOut->regWrite = 0x1;
	controlOut->branch = 0;
	controlOut->jump = 0;
}
void ori(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0x1;
	controlOut->ALU.op = 0x1;
	controlOut->ALU.bNegate = 0;
	controlOut->memRead = 0;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0;
	controlOut->regDst = 0;
	controlOut->regWrite = 0x1;
	controlOut->branch = 0;
	controlOut->jump = 0;
}


void lw(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0x1;
	controlOut->ALU.op = 0x2;
	controlOut->ALU.bNegate = 0;
	controlOut->memRead = 0x1;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0x1;
	controlOut->regDst = 0;
	controlOut->regWrite = 0x1;
	controlOut->branch = 0;
	controlOut->jump = 0;
}
void sw(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0x1;
	controlOut->ALU.op = 0x2;
	controlOut->ALU.bNegate = 0;
	controlOut->memRead = 0;
	controlOut->memWrite = 1;
	controlOut->memToReg = 0;
	controlOut->regDst = 0;
	controlOut->regWrite = 0;
	controlOut->branch = 0;
	controlOut->jump = 0;
}

void beq(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0;
	controlOut->ALU.op = 0x2;
	controlOut->ALU.bNegate = 0x1;
	controlOut->memRead = 0;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0;
	controlOut->regDst = 0;
	controlOut->regWrite = 0;
	controlOut->branch = 1;
	controlOut->jump = 0;
}
void j(InstructionFields *fields, CPUControl *controlOut) {
	controlOut->ALUsrc = 0;
	controlOut->ALU.op = 0;
	controlOut->ALU.bNegate = 0;
	controlOut->memRead = 0;
	controlOut->memWrite = 0;
	controlOut->memToReg = 0;
	controlOut->regDst = 0;
	controlOut->regWrite = 0;
	controlOut->branch = 0;
	controlOut->jump = 1;
}

int rFormat(InstructionFields *fields, CPUControl *controlOut) {
	switch(fields->funct) {
		//add
		case 0x20:
			add(fields, controlOut);
			break;
		//addu
		case 0x21:
			addu(fields, controlOut);
			break;
		//sub
		case 0x22:
			sub(fields, controlOut);
			break;
		//subu
		case 0x23:
			subu(fields, controlOut);
			break;
		//and
		case 0x24:
			and(fields, controlOut);
			break;
		//or
		case 0x25:
			or(fields, controlOut);
			break;
		//xor
		case 0x26:
			xor(fields, controlOut);
			break;
		//slt
		case 0x2a:
			slt(fields, controlOut);
			break;
		default:
			//Unrecognized Instruction
			return 0;
	}
	return 1;
}

int fill_CPUControl(InstructionFields *fields, CPUControl *controlOut) {
	switch(fields->opcode) {
		//add, addu, sub, subu | and, or, xor | slt
		case 0x0:
			return rFormat(fields, controlOut);
		//j
		case 0x2:
			j(fields, controlOut);
			break;
		//beq
		case 0x4:
			beq(fields, controlOut);
			break;
		//addi
		case 0x8:
			addi(fields, controlOut);
			break;
		//addiu
		case 0x9:
			addiu(fields, controlOut);
			break;
		//slti
		case 0xa:
			slti(fields, controlOut);
			break;
		//andi
		case 0xc:
			andi(fields, controlOut);
			break;
		//ori
		case 0xd:
			ori(fields, controlOut);
			break;
		//lw
		case 0x23:
			lw(fields, controlOut);
			break;
		//sw
		case 0x2b:
			sw(fields, controlOut);
			break;
		default:
			//Unrecognized Instruction
			return 0;
		}
	return 1;
}

WORD getALUinput1(CPUControl *controlIn,
                  InstructionFields *fieldsIn,
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
                  WORD oldPC) {
	return rsVal;
}

WORD getALUinput2(CPUControl *controlIn,
                  InstructionFields *fieldsIn,
                  WORD rsVal, WORD rtVal, WORD reg32, WORD reg33,
                  WORD oldPC) {
	if (controlIn->ALUsrc == 0) {
		return rtVal;
	}
	return fieldsIn->imm32;
}

/* Always set the zero field no matter what.*/
void execute_ALU(CPUControl *controlIn,
                 WORD input1, WORD input2,
                 ALUResult  *aluResultOut) {
	WORD result = 0;
	switch (controlIn->ALU.op) {
		//and
		case 0x0:
			result = input1 & input2;
			break;
		//or
		case 0x1:
			result = input1 | input2;
			break;
		//add/subtract
		case 0x2:
			result = controlIn->ALU.bNegate ? input1 - input2 : input1 + input2;
			break;
		//slt
		case 0x3:
			result = (input1 < input2);
			break;
		//xor
		case 0x4:
			result = input1 ^ input2;
			break;
		default:
			return;
	}
	aluResultOut->result = result;
	aluResultOut->zero = result == 0;
}

void execute_MEM(CPUControl *controlIn,
                 ALUResult  *aluResultIn,
                 WORD        rsVal, WORD rtVal,
                 WORD       *memory,
                 MemResult  *resultOut) {
	WORD address = aluResultIn->result >> 2;
	if (controlIn->memRead) {
		resultOut->readVal = memory[address];
	} else if (controlIn->memWrite) {
		memory[address] = rtVal;
		resultOut->readVal = 0;
	} else {
		resultOut->readVal = 0;
	}
}

WORD getNextPC(InstructionFields *fields, CPUControl *controlIn, int aluZero,
               WORD rsVal, WORD rtVal,
               WORD oldPC) {
	WORD newPC = oldPC + 4;
	if (controlIn->branch && aluZero) {
		newPC = newPC + (fields->imm32 << 2);
	} else if (controlIn->jump) {
		newPC = newPC & 0xf0000000;
		newPC = newPC | (fields->address << 2);
	}
	return newPC;
}

void execute_updateRegs(InstructionFields *fields, CPUControl *controlIn,
                        ALUResult  *aluResultIn, MemResult *memResultIn,
                        WORD       *regs) {
	WORD data = 0;
	WORD dest = 0;
	if (controlIn->regWrite) {
		if (controlIn->memToReg) {
			data = memResultIn->readVal;	
		} else {
			data = aluResultIn->result;
		}
		if (controlIn->regDst) {
			//R format
			//reg in [15-11]
			dest = fields->rd;
		} else {
			//I format
			//reg in [20-16]	
			dest = fields->rt;
		}
		regs[dest] = data;
	}
}


