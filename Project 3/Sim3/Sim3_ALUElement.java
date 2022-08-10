public class Sim3_ALUElement {

    public void execute_pass1() {
        bInverterMux.control[0].set(bInvert.get());
        bInverterMux.control[1].set(false);
        bInverterMux.control[2].set(false);
        bInverterMux.in[0].set(b.get());
        bInverterMux.in[1].set(!b.get());
        bInverterMux.in[2].set(false);
        bInverterMux.in[3].set(false);
        bInverterMux.in[4].set(false);
        bInverterMux.in[5].set(false);
        bInverterMux.in[6].set(false);
        bInverterMux.in[7].set(false);
        bInverterMux.execute();
        //AND
        and.a.set(a.get());
        and.b.set(bInverterMux.out.get());
        and.execute();
        //OR
        or.a.set(a.get());
        or.b.set(bInverterMux.out.get());
        or.execute();
        //FullAdder
        adder.a.set(a.get());
        adder.b.set(bInverterMux.out.get());
        adder.carryIn.set(carryIn.get());
        adder.execute();
        carryOut.set(adder.carryOut.get());
        addResult.set(adder.sum.get());
        //XOR
        xor.a.set(a.get());
        xor.b.set(bInverterMux.out.get());
        xor.execute();
    }
    
    public void execute_pass2() {
        //sets in
        mux.in[0].set(and.out.get());
        mux.in[1].set(or.out.get());
        mux.in[2].set(adder.sum.get());
        mux.in[3].set(less.get());
        mux.in[4].set(xor.out.get());
        mux.in[5].set(false);
        mux.in[6].set(false);
        mux.in[7].set(false);
        //sets controls
        mux.control[0].set(aluOp[0].get());
        mux.control[1].set(aluOp[1].get());
        mux.control[2].set(aluOp[2].get());
        mux.execute();
        result.set(mux.out.get());
    }

    //inputs
    public RussWire[] aluOp;
    public RussWire bInvert;
    public RussWire carryIn;
    public RussWire less; 
    public RussWire a, b; 
    //components
    public Sim3_MUX_8by1 bInverterMux;
    public Sim3_MUX_8by1 mux;
    public AND and;
    public OR or;
    public FullAdder adder;
    public XOR xor;
    //outputs
    public RussWire result;
    public RussWire addResult;
    public RussWire carryOut;

    public Sim3_ALUElement(){
        //inputs
        bInvert = new RussWire();
        carryIn = new RussWire();
        less = new RussWire();
        a = new RussWire();
        b = new RussWire();
        aluOp = new RussWire[3];
        for (int i = 0; i < 3; i++){
            aluOp[i] = new RussWire();
        }
        //components
        bInverterMux = new Sim3_MUX_8by1();
        mux = new Sim3_MUX_8by1();
        and = new AND();
        or = new OR();
        adder = new FullAdder();
        xor = new XOR();
        //outputs
        result = new RussWire();
        addResult = new RussWire();
        carryOut = new RussWire();
    }
}
