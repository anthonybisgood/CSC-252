
public class TestHelper {
    
    /**
     * Stores the bits into the destination RussWires
     * @param bits is the String of bits, LSB first character
     * @param destination is the array of RussWires
     */
    public static void storeBits(String bits, RussWire[] destination) {
        for (int i = 0, n = bits.length(); i < n; ++i) {
            if (bits.charAt(i) == '1') {
                destination[i].set(true);
            } else {
                destination[i].set(false);
            }
        }
    }
    
    /**
     * Stores the bits of the number into the destination RussWires
     * @param val is the integer to save bitwise into the RussWires
     * @param destination is the array of RussWires
     */
    public static void storeBits(int val, RussWire[] destination) {
        for (int i = 0; i < destination.length; ++i) {
            int bit = (val >> i) & 0x1;
            destination[i].set(bit == 1);
        }
    }
    
    /**
     * Prints the result of the given ALU
     * @param alu
     */
    public static void printBits(RussWire ...vals) {
        for (RussWire rw : vals) {
            if (rw.get()) {
                System.out.print("1");
            } else {
                System.out.print("0");
            }
        }
        System.out.println();
    }
    
    /**
     * Utility method for converting a positive int to bits
     * @param val is the positive integer
     * @param numBits is the number of bits to use
     * @return string representing the integer as 0/1 bits
     */
    public static String intToBits(int val, int numBits) {
        String result = "";
        for (int i = 0; i < numBits; ++i) {
            int bit = (val >> i) & 0x1;
            result += (bit == 1) ? "1" : "0";
        }
        return result;
    }
    
}
