public class Sim2_AdderX {

    public void execute(){
        halfAdder.a.set(a[0].get());
        halfAdder.b.set(b[0].get());
        halfAdder.execute();

        //sets the first fullAdders carryOut to the halfAdders carryout
        fullAdders[0].carryOut.set(halfAdder.carry.get());
        sum[0].set(halfAdder.sum.get());

        for (int i = 1; i < numOfBits; i++){
            //inputs
            fullAdders[i].a.set(a[i].get());
            fullAdders[i].b.set(b[i].get());
            fullAdders[i].carryIn.set(fullAdders[i-1].carryOut.get());
            fullAdders[i].execute();
            //outputs
            
            sum[i].set(fullAdders[i].sum.get());
        }
        carryOut.set(fullAdders[numOfBits-1].carryOut.get());
        
        xor.a.set(fullAdders[numOfBits-1].carryOut.get());
        xor.b.set(fullAdders[numOfBits-2].carryOut.get());
        xor.execute();
        overflow.set(xor.out.get());
    }

	// inputs
	public RussWire[] a,b;
    public int numOfBits;
	// outputs
	public RussWire[] sum;
	public RussWire   carryOut, overflow;
    // internal components
    public Sim2_FullAdder[] fullAdders;
    public Sim2_HalfAdder halfAdder;
    public Sim2_XOR xor;

    public Sim2_AdderX(int numOfBits){
        this.numOfBits = numOfBits;
        a   = new RussWire[numOfBits];
		b   = new RussWire[numOfBits];
		sum = new RussWire[numOfBits];
        fullAdders = new Sim2_FullAdder[numOfBits];

        for (int i=0; i<numOfBits; i++)
		{
			a  [i] = new RussWire();
			b  [i] = new RussWire();
			sum[i] = new RussWire();
            fullAdders  [i] = new Sim2_FullAdder();
		}
        carryOut = new RussWire();
        overflow = new RussWire();
        halfAdder = new Sim2_HalfAdder();
        xor = new Sim2_XOR();
    }

}
