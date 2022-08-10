public class Sim2_XOR {

    public void execute(){
        //(A+B) * (-A+-B)
        or1.a.set(a.get());
        or1.b.set(b.get());;
        or1.execute();  //or1.out is (A+B)

        not1.in.set(a.get());;
        not1.execute();  //not1.out is (-A)

        not2.in.set(b.get());
        not2.execute();  //not1.out is (-B)

        or2.a.set(not1.out.get());  
        or2.b.set(not2.out.get());
        or2.execute();  //or2.out is (-A+-B)

        and.a.set(or1.out.get());
        and.b.set(or2.out.get());
        and.execute();  //and is (A+B) * (-A+-B)
        
        out.set(and.out.get());
    }

    // inputs
	public RussWire a,b;
	// outputs
	public RussWire out;

    // internal components
	public AND and;
	public NOT not1, not2;
    public OR or1, or2;


    public Sim2_XOR(){
	    a   = new RussWire();
		b   = new RussWire();
		out = new RussWire();

        and = new AND();
        not1 = new NOT();
        not2 = new NOT();
        or1 = new OR();
        or2 = new OR();
    }
   
}