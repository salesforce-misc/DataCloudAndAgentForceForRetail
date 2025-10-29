global class MathRandomFunction {

    @InvocableMethod(label='Return Math.random()' description='')
    global static List<RandomResult> MathRandom(List<Case> records) {
        
        //System.Debug(records.size());

        List<RandomResult> results = new List<RandomResult>();
        for (Integer i = 0; i < records.size(); i++) {
            RandomResult result = new RandomResult();
            results.add (result);
        }
        return results;
    }

    global class RandomResult {
        @InvocableVariable(label='Math.random result' required=true)
        global Double result;
        
        global RandomResult() {
            result = Math.random();
        }
        
    }

}