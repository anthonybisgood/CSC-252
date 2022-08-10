
public class Test_08_checkALUElement {
    
    public static void main(String[] args) {
        testALUElement(false, false);
        testALUElement(true, false);
        testALUElement(true, true);
    }
    
    private static void testALUElement(boolean a, boolean b) {
        Sim3_ALUElement aluElement = new Sim3_ALUElement();
        TestHelper.storeBits(2, aluElement.aluOp);
        aluElement.bInvert.set(false);
        aluElement.a.set(a);
        aluElement.b.set(b);
        aluElement.carryIn.set(false);
        
        // Pass 1
        aluElement.execute_pass1();
        System.out.println(aluElement.addResult.get());
        System.out.println(aluElement.carryOut.get());
        
        // Pass 2
        aluElement.less.set(false);
        aluElement.execute_pass2();
        System.out.println(aluElement.result.get());
        System.out.println();
    }
    
}
