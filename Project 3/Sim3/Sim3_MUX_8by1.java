public class Sim3_MUX_8by1 {
    
    public void execute(){
        //000
        ands[0].set(in[0].get() && !control[0].get() && !control[1].get() && !control[2].get());
        //001
        ands[1].set(in[1].get() && control[0].get() && !control[1].get() && !control[2].get());
        //010
        ands[2].set(in[2].get() && !control[0].get() && control[1].get() && !control[2].get());
        //011
        ands[3].set(in[3].get() && control[0].get() && control[1].get() && !control[2].get());
        //100
        ands[4].set(in[4].get() && !control[0].get() && !control[1].get() && control[2].get());
        //101
        ands[5].set(in[5].get() && control[0].get() && !control[1].get() && control[2].get());
        //110
        ands[6].set(in[6].get() && !control[0].get() && control[1].get() && control[2].get());
        //111
        ands[7].set(in[7].get() && control[0].get() && control[1].get() && control[2].get());
        // or and gates
        out.set(
            ands[0].get() ||
            ands[1].get() ||
            ands[2].get() ||
            ands[3].get() ||
            ands[4].get() ||
            ands[5].get() ||
            ands[6].get() ||
            ands[7].get());
    }

    //inputs
    public RussWire[] control;
    public RussWire[] in;
    //internal compoments
    private RussWire[] ands;
    //output
    public RussWire out;

    public Sim3_MUX_8by1(){
        control = new RussWire[3];
        in = new RussWire[8];
        ands = new RussWire[8];
        control[0] = new RussWire();
        control[1] = new RussWire();
        control[2] = new RussWire();
        for (int i = 0; i < 8; i++){
            in[i] = new RussWire();
            ands[i] = new RussWire();
        }
        out = new RussWire();
	}
}
