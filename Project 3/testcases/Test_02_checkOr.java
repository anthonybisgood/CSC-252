
public class Test_02_checkOr {
    
    public static void main(String[] args) {
        runOr(4, false, "1100", "1001");
        runOr(8, false, "11111111", "11111111");
        runOr(6, false, "000000", "000000");
        runOr(5, false, "10101", "01010");
    }
    
    private static void runOr(int size, boolean bNegate,
            String aBits, String bBits) {
        Sim3_ALU alu = new Sim3_ALU(size);
        alu.bNegate.set(bNegate);
        TestHelper.storeBits(1, alu.aluOp);     // AND operation
        TestHelper.storeBits(aBits, alu.a);
        TestHelper.storeBits(bBits, alu.b);
        
        alu.execute();
        TestHelper.printBits(alu.result);
    }
    
}
