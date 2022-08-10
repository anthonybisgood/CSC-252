/* Implementation of a 32-bit adder in C.
 *
 * Author: Anthony Bisgood
 */


#include "sim1.h"


//obj is what to access
void execute_add(Sim1Data *obj)
{
	int a = obj->a;
	int b = obj->b;
	int carryIn = 0;
	if (obj->isSubtraction){
		carryIn = 1;
	}
	for (int i = 0; i <32; i++){
		//goes from LSB to MSB bit by bit
		int currA = (a>>i) & 0x1;
		int currB = (b>>i) & 0x1;
		if (obj->isSubtraction){
			if (currB == 1){
				currB = 0;
			} else {
				currB = 1;
			}
		}
		if (carryIn){
			if (currA & currB){
				obj->sum |= (0x1<<i);
			} else if (currA == 0 & currB == 0){
				obj->sum |= (0x1<<i);
			}
		} else {
			if (currA ^ currB){
				obj->sum |= (0x1<<i);
			}
		}
		//determins carryout
		carryIn = (currA & currB) | (currA & carryIn) | (currB & carryIn);
	}
	obj ->carryOut = carryIn;
	//MSB XOR 1, if MSB is 1 then aNonNeg = 0
	obj ->aNonNeg = (a>>31 & 0x1) ^ 1;
	obj ->bNonNeg = (b>>31 & 0x1) ^ 1;
	obj ->sumNonNeg = carryIn;
	if (obj->isSubtraction){
		//if a is pos and b is neg sum must be pos
		if (obj ->aNonNeg & ~obj -> bNonNeg & ~obj ->sumNonNeg){
			obj->overflow = 1;
		//if a is neg and b is pos sum must be neg
		} else if (~obj ->aNonNeg & obj -> bNonNeg & obj ->sumNonNeg) {
			obj->overflow = 1;
		}
	//addition
	} else {
		//if a and b are pos sum must be pos 
		if (!obj ->aNonNeg & ~obj -> bNonNeg & obj ->sumNonNeg){
			obj->overflow = 1;
		//if a and b are neg sum must be neg
		} else if (obj ->aNonNeg & obj -> bNonNeg & ~obj ->sumNonNeg){
			obj->overflow = 1;
		}
	}
}



