public class Sim3_ALU {
    
    public void execute(){
        //sets the first alu so we dont set less and carryIn = bNegate
        aluElements[0].aluOp[0].set(aluOp[0].get());
        aluElements[0].aluOp[1].set(aluOp[1].get());
        aluElements[0].aluOp[2].set(aluOp[2].get());
        aluElements[0].a.set(a[0].get());
        aluElements[0].b.set(b[0].get());
        aluElements[0].bInvert.set(bNegate.get());
        aluElements[0].carryIn.set(bNegate.get());
        aluElements[0].execute_pass1();
        // Runs through all other alus, sets carryIn to last CarryOut
        for (int i = 1; i < bits; i++){
            aluElements[i].aluOp[0].set(aluOp[0].get());
            aluElements[i].aluOp[1].set(aluOp[1].get());
            aluElements[i].aluOp[2].set(aluOp[2].get());
            aluElements[i].a.set(a[i].get());
            aluElements[i].b.set(b[i].get());
            aluElements[i].bInvert.set(bNegate.get());
            aluElements[i].carryIn.set(aluElements[i-1].carryOut.get());
            aluElements[i].less.set(false);
            aluElements[i].execute_pass1();
        }
        //alu element 31 addResult goes back to first aluElement and sets Less
        aluElements[0].less.set(aluElements[bits-1].addResult.get());
        //Runs through array, executes pass2 and sets result
        for (int i = 0; i < bits; i++){
            aluElements[i].execute_pass2();
            result[i].set(aluElements[i].result.get());
        }
    }

    //inputs
    public RussWire[] aluOp;
    public RussWire bNegate;
    public RussWire[] a;
    public RussWire[] b;
    public int bits;
    //components
    public Sim3_ALUElement[] aluElements;
    //outputs
    public RussWire[] result;

    public Sim3_ALU(int bits){
        //inputs
        this.bits = bits;
        bNegate = new RussWire();
        a = new RussWire[bits];
        b = new RussWire[bits];
        result = new RussWire[bits];
        aluElements = new Sim3_ALUElement[bits];
        for (int i = 0; i < bits; i++){
            a[i] = new RussWire();
            b[i] = new RussWire();
            result[i] = new RussWire();
            aluElements[i] = new Sim3_ALUElement();
        }
        aluOp = new RussWire[3];
        for (int i = 0; i < 3; i++){
            aluOp[i] = new RussWire();
        }
    }
}
