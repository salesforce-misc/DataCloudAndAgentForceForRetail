/**
 * Class to split strings into collections based on a specified delimiter.
 * This class provides a simple utility for handling string manipulation
 * useful in Salesforce flows.
 *
 * Author: Antoine Laviron
 * Contact: alaviron@salesforce.com
 */


public with sharing class TE_StringSplitter {

    /**
     * Invocable method to split a list of strings into collections based on a delimiter.
     * 
     * @param inputs A list of strings to be split. Each string is expected to use ',' as the delimiter.
     * @return A list of lists, where each inner list contains the split components of the corresponding input string.
     * 
     */
    @InvocableMethod(label='Split String' description='Splits a string into a collection based on a delimiter')
    public static List<List<String>> splitString(List<String> inputs) {
        List<List<String>> results = new List<List<String>>();
        for (String input : inputs) {
            if (String.isNotBlank(input)) {
                List<String> splitParts = input.split(',');
                List<String> trimmedParts = new List<String>();
                for (String part : splitParts) {
                    trimmedParts.add(part.trim());
                }
                results.add(trimmedParts);
            }
        }
        return results;
    }
}