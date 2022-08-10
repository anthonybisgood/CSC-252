
public class Test_01_checkAnd {
    
    public static void main(String[] args) {
        runAnd(4, false, "1100", "1001");
        runAnd(8, false, "11111111", "11111111");
        runAnd(6, false, "000000", "000000");
    }
    
    private static void runAnd(int size, boolean bNegate,
            String aBits, String bBits) {
        Sim3_ALU alu = new Sim3_ALU(size);
        alu.bNegate.set(bNegate);
        TestHelper.storeBits(0, alu.aluOp);     // AND operation
        TestHelper.storeBits(aBits, alu.a);
        TestHelper.storeBits(bBits, alu.b);
        
        alu.execute();
        TestHelper.printBits(alu.result);
    }
    
}
