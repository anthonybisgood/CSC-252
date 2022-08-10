public class Test_03_checkAdd {
    
    public static void main(String[] args) {
        int size = 10;   // can hold up to 2^9 - 1
        for (int a = 0; a < 256; ++a) {
            for (int b = 0; b < 256; ++b) {
                runAdd(size, a, b);
            }
        }
    }
    
    private static void runAdd(int size, int a, int b) {
        Sim3_ALU alu = new Sim3_ALU(size);
        alu.bNegate.set(false);
        TestHelper.storeBits(2, alu.aluOp);     // ADD operation
        TestHelper.storeBits(a, alu.a);
        TestHelper.storeBits(b, alu.b);
        
        alu.execute();
        TestHelper.printBits(alu.result);
    }
    
}
