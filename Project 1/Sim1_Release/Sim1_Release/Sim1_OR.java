/* Simulates a physical OR gate.
 *
 * Author: Anthony Bisgood
 */

public class Sim1_OR
{
	public void execute()
	{
		out.set(a.get()||b.get());
	}



	public RussWire a,b;   // inputs
	public RussWire out;   // output

	public Sim1_OR()
	{
		a = new RussWire();
		b = new RussWire();
		out = new RussWire();
	}
}

