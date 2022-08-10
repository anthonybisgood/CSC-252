public class Sim2_FullAdder {

    public void execute() {
        // sets a and b
        halfAdder1.a.set(a.get());
        halfAdder1.b.set(b.get());;
        halfAdder1.execute();
        
        or.a = halfAdder1.carry;

        // sum from first halfadder is input into second
        halfAdder2.a.set(carryIn.get());
        halfAdder2.b.set(halfAdder1.sum.get());
        halfAdder2.execute();
        sum.set(halfAdder2.sum.get());

        or.b.set(halfAdder2.carry.get());

        or.execute();
        carryOut.set(or.out.get());
    }

     // inputs
	public RussWire a,b, carryIn;
	// outputs
	public RussWire out, sum, carryOut;
    // internal components
    public Sim2_HalfAdder halfAdder1, halfAdder2;
    public OR or;

    public Sim2_FullAdder(){
        a = new RussWire();
        b = new RussWire();
        carryIn = new RussWire();

        out = new RussWire();
        sum = new RussWire();
        carryOut = new RussWire();

        halfAdder1 = new Sim2_HalfAdder();
        halfAdder2 = new Sim2_HalfAdder();
        or = new OR();
    }
}
