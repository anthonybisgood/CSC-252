
public class Test_07_checkMux {
    
    public static void main(String[] args) {
        
        boolean[] inputs = {true, false, true, true,
                false, true, false, false};
        
        /*
         * Order:
         * 000 - true
         * 001 - false
         * 010 - true
         * 011 - false
         * 100 - false
         * 101 - true
         * 110 - true
         * 111 - false
         */
        for (int i = 0; i < 2; ++i) {
            for (int j = 0; j < 2; ++j) {
                for (int k = 0; k < 2; ++k) {
                    // Set the MUX inputs
                    Sim3_MUX_8by1 mux = new Sim3_MUX_8by1();
                    mux.control[0].set(i == 1);
                    mux.control[1].set(j == 1);
                    mux.control[2].set(k == 1);
                    for (int q = 0; q < inputs.length; ++q) {
                        mux.in[q].set(inputs[q]);
                    }
                    
                    // Print output
                    mux.execute();
                    System.out.println(mux.out.get());
                }
            }
        }
    }
    
}
