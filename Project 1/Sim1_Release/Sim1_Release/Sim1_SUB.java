/* Simulates a physical device that performs (signed) subtraction on
 * a 32-bit input.
 *
 * Author: Anthony Bisgood
 */

public class Sim1_SUB
{
	public void execute()
	{
		complement.in = b;
		complement.execute();
		bComplement = complement.out;

		add.a = a;
		add.b = bComplement;
		add.execute();
		sum = add.sum;
	}



	// --------------------
	// Don't change the following standard variables...
	// --------------------

	// inputs
	public RussWire[] a,b;

	// output
	public RussWire[] sum;

	private Sim1_ADD add;
	private RussWire[] bComplement;
	private Sim1_2sComplement complement;

	public Sim1_SUB()
	{
		a = new RussWire[32];
		b = new RussWire[32];
		sum = new RussWire[32];

		bComplement = new RussWire[32];
		add = new Sim1_ADD();
		complement = new  Sim1_2sComplement();
	}
}

