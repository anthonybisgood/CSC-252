/* Simulates a physical device that performs (signed) addition on
 * a 32-bit input.
 *
 * Author: Anthony Bisgood
 */

public class Sim1_ADD
{
	public void execute()
	{
		boolean carry_out = false;
		for (int i = 0; i < 32; i++){
			boolean aVal = a[i].get();
			boolean bVal = b[i].get();
			//if a[i], b[i], and carryout are all true (1,1,1) = 11
			if (aVal && bVal && carry_out){
				sum[i].set(true);
				carry_out = true;
			//if none of them are true (0,0,0) = 00
			} else if (aVal == false && bVal == false && carry_out == false){
				sum[i].set(false);
				carry_out = false;
			// if 2 of 3 are true (0,1,1) = 10
			} else if ((aVal && bVal && carry_out == false) ||
			 (aVal == false && bVal && carry_out == true) || (aVal && bVal == false && carry_out == true)){
				sum[i].set(false);
				carry_out = true;
			// if one of 3 are true (0,0,1) = 01
			} else{
				sum[i].set(true);
				carry_out = false;
			}	
		}
		carryOut.set(carry_out);
		// if a and b have the same MSB and sum has different MSB, 
		if ((a[31].get() == b[31].get()) && (sum[31].get() != a[31].get())){
			overflow.set(true);
		} else{
			overflow.set(false);
		}
	}



	// ------ 
	// It should not be necessary to change anything below this line,
	// although I'm not making a formal requirement that you cannot.
	// ------ 

	// inputs
	public RussWire[] a,b;

	// outputs
	public RussWire[] sum;
	public RussWire   carryOut, overflow;

	public Sim1_ADD()
	{
		/* Instructor's Note:
		 *
		 * In Java, to allocate an array of objects, you need two
		 * steps: you first allocate the array (which is full of null
		 * references), and then a loop which allocates a whole bunch
		 * of individual objects (one at a time), and stores those
		 * objects into the slots of the array.
		 */

		a   = new RussWire[32];
		b   = new RussWire[32];
		sum = new RussWire[32];

		for (int i=0; i<32; i++)
		{
			a  [i] = new RussWire();
			b  [i] = new RussWire();
			sum[i] = new RussWire();
		}

		carryOut = new RussWire();
		overflow = new RussWire();
	}
}

