
public class Test_04_checkLess {
    
    public static void main(String[] args) {
        int size = 8;
        int a = 0,  b = 0;  runLess(size, true, a, b);  // false
            a = 19; b = 19; runLess(size, true, a, b);  // false
            a = 0;  b = 50; runLess(size, true, a, b);  // true
            a = 10; b = 0;  runLess(size, true, a, b);  // false
            a = 10; b = 1;  runLess(size, true, a, b);  // false
            a = 11; b = 30; runLess(size, true, a, b);  // true
            a = 80; b = 16; runLess(size, true, a, b);  // false
            a = 80; b = 96; runLess(size, true, a, b);  // true
    }
    
    private static void runLess(int size, boolean bNegate,
            int a, int b) {
        Sim3_ALU alu = new Sim3_ALU(size);
        alu.bNegate.set(bNegate);
        TestHelper.storeBits(3, alu.aluOp);     // LESS operation
        TestHelper.storeBits(a, alu.a);
        TestHelper.storeBits(b, alu.b);
        
        alu.execute();
        TestHelper.printBits(alu.result);
    }
    
}
