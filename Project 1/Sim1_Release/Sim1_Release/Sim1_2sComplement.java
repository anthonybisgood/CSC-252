/* Simulates a physical device that performs 2's complement on a 32-bit input.
 *
 * Author: Anthony Bisgood
 */

public class Sim1_2sComplement
{
	public void execute()
	{
		//switches all the values in the bit array
		for (int i = 0; i < 32; i++){
			not[i].in = in[i];
			not[i].execute();
			outMinusOne[i].set(not[i].out.get());
		}
		addIn.a = outMinusOne;
		addIn.b = one;
		addIn.execute();
		out = addIn.sum;
	}



	// you shouldn't change these standard variables...
	public RussWire[] in;
	public RussWire[] out;

	private RussWire[] outMinusOne;
	private Sim1_NOT not[];
	private Sim1_ADD addIn;
	private RussWire[] one;

	public Sim1_2sComplement()
	{
		in = new RussWire[32];
		out = new RussWire[32];
		outMinusOne = new RussWire[32];
		addIn = new Sim1_ADD();
		one = new RussWire[32];
		for (int i = 1; i < 32; i++){
			not[i] = new Sim1_NOT();
			one[i].set(false);
		}
		not[0] = new Sim1_NOT();
		one[0].set(true);
	}
}

