
public class Test_05_checkXor {
    
    public static void main(String[] args) {
        int size = 4;
        Sim3_ALU alu = new Sim3_ALU(size);
        alu.bNegate.set(false);
        TestHelper.storeBits(4, alu.aluOp);     // XOR operation
        
        String aBits = "1100";
        String bBits = "1001";
        TestHelper.storeBits(aBits, alu.a);
        TestHelper.storeBits(bBits, alu.b);
        
        alu.execute();
        TestHelper.printBits(alu.result);
    }
}
