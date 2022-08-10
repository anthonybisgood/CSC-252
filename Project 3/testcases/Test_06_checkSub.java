public class Test_06_checkSub {
    
    public static void main(String[] args) {
        int size = 6;   // can hold up to 2^5 - 1
        int a = 0,  b = 0;  runSub(size, a, b);   // 0
            a = 8;  b = 4;  runSub(size, a, b);   // 4
            a = 7;  b = 13; runSub(size, a, b);   // -6
            a = 20; b = 13; runSub(size, a, b);   // 7
            a = 15; b = 16; runSub(size, a, b);   // -1
            a = 30; b = 30; runSub(size, a, b);   // 0
            a = 30; b = 20; runSub(size, a, b);   // 10
            a = 30; b = 0;  runSub(size, a, b);   // 30
            a = 0;  b = 30; runSub(size, a, b);   // -30
    }
    
    private static void runSub(int size, int a, int b) {
        Sim3_ALU alu = new Sim3_ALU(size);
        alu.bNegate.set(true);
        TestHelper.storeBits(2, alu.aluOp);     // ADD operation
        TestHelper.storeBits(a, alu.a);
        TestHelper.storeBits(b, alu.b);
        
        alu.execute();
        TestHelper.printBits(alu.result);
    }
    
}
