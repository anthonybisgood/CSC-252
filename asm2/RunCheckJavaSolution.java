class Solution {

    public String Solution1(int[] args, int len){
        int signal = 0;
        if (len <= 1){
            return("BOTH");
        }
        if (args[0] <= args[1]){  //descending
            signal = 1;
        } else{  //ascending
            signal = 0;
        }
        //IF SIGNAL CHANGES THEN RETURN NIETHER
        int sig2 = signal;
        for (int i = 0; i < len; i++){
            if (args[i] <= args[i+1]){
                sig2 = 1;
            } else {
                sig2 = 0;
            }
            if (signal != sig2){
                return("NEITHER");
            }
        }
        if (signal == 0){
            return("ASCENDING");
        }
        if (signal == 1){
            return("DESCENDING");
        }
        return null;
    }   
    
}
