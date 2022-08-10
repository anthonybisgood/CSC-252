public class Sim2_HalfAdder {
    public void execute(){
        // carry = AB
        and.a.set(a.get());
        and.b.set(b.get());
        and.execute();

        carry.set(and.out.get());
        // sum = a XOR b 
        xor.a.set(a.get());
        xor.b.set(b.get());
        xor.execute();

        sum.set(xor.out.get());

    }

     // inputs
	public RussWire a,b;
	// outputs
	public RussWire sum;
    public RussWire carry;
    // internal components
    public AND and;
    public Sim2_XOR xor;

    public Sim2_HalfAdder(){
        a = new RussWire();
        b = new RussWire();

        sum = new RussWire();
        carry = new RussWire();
        
        and = new AND();
        xor = new Sim2_XOR();
    }
}
