/**
 * Class to process the results of semantic queries for LLM prompts.
 * It analyzes query results, applies formatting rules, and optionally generates bar charts
 * or markdown tables for data visualization.
 *
 * Author: Kunal Tomar
 * Contact: kunal.tomar@salesforce.com
 */
public class TE_ProcessSemanticQueryResult {
    
    /**
     * Wrapper class for input parameters to the semantic query processing method.
     */
    public class InputParameters {
        @InvocableVariable(required=true)
        public String userQuery;
        @InvocableVariable(required=true)
        public String queryResult; 
        @InvocableVariable(required=false)
        public String sdmMetadata;
    }

    /**
     * Wrapper class for output parameters from the semantic query processing method.
     */
    public class OutputParameters {
        @InvocableVariable
        public String processeResult; 
    }

    /**
     * Invocable method to process semantic query results for LLM prompt preparation.
     * Parses and analyzes the query result, determines appropriate formatting,
     * and optionally generates bar charts or markdown tables.
     *
     * @param inputs A list of InputParameters containing user queries and query results.
     * @return A list of OutputParameters with processed results.
     */
    @InvocableMethod(label='Process Query Result for Prompt' description='Pre-process the query result for the LLM.')
    public static List<OutputParameters> processSemanticQueryResult(List<InputParameters> inputs) {
        List<OutputParameters> results = new List<OutputParameters>();

        for (InputParameters input : inputs) {
            OutputParameters output = new OutputParameters();
            try {
                // Step 1: Parse query result
                Map<String, Object> parsedQuery = parseQueryResult(input.queryResult);
                List<String> orderedFieldNames = getOrderedFieldNames(parsedQuery);
                List<Map<String, Object>> rowValuesList = parseRowValues(parsedQuery, orderedFieldNames);

                // Step 2: Determine formatting and visualization options
                FormattingOptions formattingOptions = analyzeQuery(input, parsedQuery, orderedFieldNames, rowValuesList);

                // Step 3: Generate output data
                String result = generateOutputData(formattingOptions, orderedFieldNames, rowValuesList);

                output.processeResult = result;
            } catch (Exception e) {
                output.processeResult = 'Error: ' + e.getMessage();
            }
            results.add(output);
        }

        return results;
    }

    /**
     * Parses the query result JSON string into a structured Map.
     * 
     * @param queryResult JSON string representing the query result.
     * @return A parsed Map of the query result.
     */
    private static Map<String, Object> parseQueryResult(String queryResult) {
        return (Map<String, Object>) JSON.deserializeUntyped(queryResult);
    }

    /**
     * Extracts ordered field names from the query metadata.
     * 
     * @param parsedQuery A structured Map of the parsed query result.
     * @return A list of ordered field names.
     */
    private static List<String> getOrderedFieldNames(Map<String, Object> parsedQuery) {
        Map<String, Object> queryMetadata = (Map<String, Object>) parsedQuery.get('queryMetadata');
        Map<String, Object> fieldsMap = (Map<String, Object>) queryMetadata.get('fields');
        List<String> orderedFieldNames = new List<String>();
        Map<Integer, String> orderToField = new Map<Integer, String>();

        for (String fieldName : fieldsMap.keySet()) {
            Map<String, Object> fieldInfo = (Map<String, Object>) fieldsMap.get(fieldName);
            Integer place = (Integer) fieldInfo.get('placeInOrder');
            orderToField.put(place, fieldName);
        }

        List<Integer> orderedPlaces = new List<Integer>(orderToField.keySet());
        orderedPlaces.sort();
        for (Integer place : orderedPlaces) {
            orderedFieldNames.add(orderToField.get(place));
        }

        return orderedFieldNames;
    }

    /**
     * Parses row values into a list of maps for further processing.
     * 
     * @param parsedQuery A structured Map of the parsed query result.
     * @param orderedFieldNames A list of ordered field names.
     * @return A list of maps representing row values.
     */
    private static List<Map<String, Object>> parseRowValues(Map<String, Object> parsedQuery, List<String> orderedFieldNames) {
        List<Object> rows = (List<Object>) ((Map<String, Object>) parsedQuery.get('queryData')).get('rows');
        List<Map<String, Object>> rowValuesList = new List<Map<String, Object>>();

        for (Object rowObj : rows) {
            Map<String, Object> rowMap = (Map<String, Object>) rowObj;
            List<Object> values = (List<Object>) rowMap.get('values');
            Map<String, Object> rowValues = new Map<String, Object>();

            for (Integer i = 0; i < values.size() && i < orderedFieldNames.size(); i++) {
                rowValues.put(orderedFieldNames[i], values[i]);
            }
            rowValuesList.add(rowValues);
        }

        return rowValuesList;
    }

    /**
     * Analyzes the query result and determines formatting options.
     * 
     * @param input InputParameters containing user queries and metadata.
     * @param parsedQuery A structured Map of the parsed query result.
     * @param orderedFieldNames A list of ordered field names.
     * @param rowValuesList A list of parsed row values.
     * @return FormattingOptions object containing analysis results.
     */
    private static FormattingOptions analyzeQuery(InputParameters input, Map<String, Object> parsedQuery,
                                                  List<String> orderedFieldNames, List<Map<String, Object>> rowValuesList) {
        Boolean isTopQuery = input.userQuery.toLowerCase().contains('top');
        Boolean isBottomQuery = input.userQuery.toLowerCase().contains('bottom');

        Integer dimensionCount = 0;
        Integer measureCount = 0;
        String dimensionFieldName = null;
        String measureFieldName = null;
        Map<String, Object> fieldsMap = (Map<String, Object>) ((Map<String, Object>) parsedQuery.get('queryMetadata')).get('fields');

        for (String fieldName : fieldsMap.keySet()) {
            Map<String, Object> fieldInfo = (Map<String, Object>) fieldsMap.get(fieldName);
            Map<String, Object> semanticType = (Map<String, Object>) fieldInfo.get('semanticType');

            Boolean isDimension = semanticType != null && semanticType.containsKey('semanticDimensionType');
            Boolean isMeasure = semanticType != null && semanticType.containsKey('semanticMeasurementType');

            if (isDimension) {
                dimensionCount++;
                if (dimensionCount == 1) dimensionFieldName = fieldName;
            } else if (isMeasure) {
                measureCount++;
                if (measureCount == 1) measureFieldName = fieldName;
            }
        }

        Boolean canBarChart = (isTopQuery || isBottomQuery) &&
                              rowValuesList.size() < 10 &&
                              dimensionCount == 1 &&
                              measureCount == 1;

        return new FormattingOptions(isTopQuery, isBottomQuery, canBarChart, dimensionFieldName, measureFieldName);
    }

    /**
     * Generates output data based on formatting options and parsed values.
     * 
     * @param formattingOptions Formatting options determined by analysis.
     * @param orderedFieldNames A list of ordered field names.
     * @param rowValuesList A list of parsed row values.
     * @return A JSON string representing the output data.
     */
    private static String generateOutputData(FormattingOptions formattingOptions, List<String> orderedFieldNames,
                                             List<Map<String, Object>> rowValuesList) {
        String format = 'markdown_table';
        String chartSvg = null;
        String markdown = null;

        if (formattingOptions.canBarChart) {
            List<DataPoint> dataPoints = createDataPoints(rowValuesList, formattingOptions.dimensionFieldName,
                                                          formattingOptions.measureFieldName);

            if (formattingOptions.isTopQuery || formattingOptions.isBottomQuery) {
                sortDataPoints(dataPoints, formattingOptions.isTopQuery);
            }

            if (!dataPoints.isEmpty()) {
                format = 'bar_chart';
                chartSvg = generateBarChartSVG(dataPoints, formattingOptions.isTopQuery, formattingOptions.isBottomQuery);
            }
        } else {
            markdown = generateMarkdownTable(orderedFieldNames, rowValuesList);
        }

        Map<String, Object> keyPoints = generateKeyPoints(formattingOptions, rowValuesList);

        Map<String, Object> allDataMap = new Map<String, Object>();
        allDataMap.put('format', format);
        if (format == 'bar_chart') {
            allDataMap.put('chartSvg', chartSvg);
        } else {
            allDataMap.put('markdownTable', markdown);
        }
        allDataMap.put('keyPointsJson', JSON.serialize(keyPoints));

        return JSON.serialize(allDataMap);
    }

    /**
     * Represents formatting options for the query result.
     */
    public class FormattingOptions {
        public Boolean isTopQuery;
        public Boolean isBottomQuery;
        public Boolean canBarChart;
        public String dimensionFieldName;
        public String measureFieldName;

        public FormattingOptions(Boolean isTop, Boolean isBottom, Boolean canChart,
                                 String dimField, String measField) {
            this.isTopQuery = isTop;
            this.isBottomQuery = isBottom;
            this.canBarChart = canChart;
            this.dimensionFieldName = dimField;
            this.measureFieldName = measField;
        }
    }
    
    /**
     * Represents a data point for visualization.
     */
    public class DataPoint {
        public String label;
        public Decimal value;

        public DataPoint(String label, Decimal value) {
            this.label = label;
            this.value = value;
        }
    }



    /**
     * Comparator for sorting DataPoint objects in descending order based on their value.
     * Used primarily for 'top' queries to rank data points from highest to lowest.
     */
    public class DescSort implements Comparator<DataPoint> {
        public Integer compare(DataPoint a, DataPoint b) {
            if (a.value == b.value) return 0;
            return a.value > b.value ? -1 : 1; 
        }
    }

    /**
     * Comparator for sorting DataPoint objects in ascending order based on their value.
     * Used primarily for 'bottom' queries to rank data points from lowest to highest.
     */
    public class AscSort implements Comparator<DataPoint> {
        public Integer compare(DataPoint a, DataPoint b) {
            if (a.value == b.value) return 0;
            return a.value < b.value ? -1 : 1; 
        }
    }

    /**
     * Sorts data points in ascending or descending order based on query type.
     */
    private static void sortDataPoints(List<DataPoint> dataPoints, Boolean isTopQuery) {
        if (isTopQuery) {
            dataPoints.sort(new DescSort());
        } else {
            dataPoints.sort(new AscSort());
        }
    }

    /**
     * Converts a list of row maps into a list of DataPoint objects for visualization.
     * Each DataPoint represents a dimension-value pair, where the dimension serves
     * as the label and the measure serves as the value.
     *
     * @param rows A list of maps representing the rows of data.
     * @param dimensionFieldName The field name representing the dimension (e.g., category or label).
     * @param measureFieldName The field name representing the measure (e.g., numeric value).
     * @return A list of DataPoint objects derived from the provided rows.
     */
    private static List<DataPoint> createDataPoints(List<Map<String, Object>> rows, String dimensionFieldName, String measureFieldName) {
        List<DataPoint> dataPoints = new List<DataPoint>();
        for (Map<String, Object> row : rows) {
            Object dimensionValue = row.get(dimensionFieldName);
            Object measureValue = row.get(measureFieldName);
    
            if (dimensionValue != null && measureValue instanceof Decimal) {
                dataPoints.add(new DataPoint(String.valueOf(dimensionValue), (Decimal) measureValue));
            }
        }
        return dataPoints;
    }

    /**
     * Generates an SVG representation of a bar chart based on provided data points.
     * Adjusts bar heights and colors dynamically depending on the context (e.g., top or bottom query).
     *
     * @param dataPoints A list of DataPoint objects representing the chart data.
     * @param isTop A boolean indicating if the query represents a "top" query.
     * @param isBottom A boolean indicating if the query represents a "bottom" query.
     * @return A string containing the SVG markup for the bar chart.
     */
    private static String generateBarChartSVG(List<DataPoint> dataPoints, Boolean isTop, Boolean isBottom) {
        // Determine the maximum value among the data points
        Decimal maxVal = 0;
        for (DataPoint dp : dataPoints) {
            if (dp.value > maxVal) maxVal = dp.value;
        }

        // Set chart dimensions
        Integer count = dataPoints.size();
        Integer height = count * 30 + 20; // bar height
        Integer svgWidth = 300; // SVG width to fit in the chat panel
        Integer barMaxWidth = 110; // Max bar width
        String svg = '<svg width="' + svgWidth + '" height="' + height + '" xmlns="http://www.w3.org/2000/svg">';
        
        // Iterate through data points to create bars and labels
        for (Integer i = 0; i < count; i++) {
            DataPoint dp = dataPoints[i];
            Decimal ratio = dp.value.divide(maxVal, 5, RoundingMode.HALF_UP);
            Decimal barWidth = ratio * barMaxWidth;
            Integer barIntWidth = barWidth.setScale(0, RoundingMode.HALF_UP).intValue();
            Integer yPosition = (i * 30) + 10;

            // Determine the color for the bar
            String color = getColorForBar(i, count, isTop, isBottom);
            
            svg += '\n  <text x="10" y="' + (yPosition + 15) + '" font-size="12" fill="#333">' + dp.label + '</text>';
            svg += '\n  <rect x="120" y="' + yPosition + '" width="' + barIntWidth + '" height="20" fill="' + color + '"/>';
            svg += '\n  <text x="' + (barIntWidth + 130) + '" y="' + (yPosition + 15) + '" font-size="12" fill="#333">' + formatValue(dp.value) + '</text>';
        }

        svg += '\n</svg>';
        return svg;
    }

    /**
     * Generates a markdown table based on provided field names and row values.
     *
     * @param fieldNames A list of field names to serve as column headers.
     * @param rows A list of maps representing rows of data.
     * @return A string containing the markdown table.
     */
    private static String generateMarkdownTable(List<String> fieldNames, List<Map<String, Object>> rows) {
        Integer maxRows = 10;
        List<Map<String, Object>> limitedRows = new List<Map<String, Object>>();
    
        // Copy only up to maxRows entries to limitedRows
        for (Integer i = 0; i < Math.min(rows.size(), maxRows); i++) {
            limitedRows.add(rows[i]);
        }        
        String md = '|';
        for (String f : fieldNames) {
            md += ' ' + f + ' |';
        }
        md += '\n|';
        for (String f : fieldNames) {
            md += '-------|';
        }
        md += '\n';

        for (Map<String, Object> row : limitedRows) {
            md += '|';
            for (String f : fieldNames) {
                Object val = row.get(f);
                String cellVal;
                if (val instanceof Decimal) {
                    cellVal = formatValue((Decimal)val);
                } else {
                    cellVal = String.valueOf(val);
                }
                md += ' ' + cellVal + ' |';
            }
            md += '\n';
        }

        return md;
    }
    
    /**
     * Generates key points for visualization based on query type and data.
     */
    private static Map<String, Object> generateKeyPoints(FormattingOptions options, List<Map<String, Object>> rows) {
        Map<String, Object> keyPoints = new Map<String, Object>();

        if (options.canBarChart && rows.size() > 0) {
            if (options.isTopQuery) {
                Map<String, Object> topRow = rows.get(0);
                keyPoints.put('topDimension', topRow.get(options.dimensionFieldName));
                keyPoints.put('topValue', topRow.get(options.measureFieldName));
            } else if (options.isBottomQuery) {
                Map<String, Object> bottomRow = rows.get(rows.size() - 1);
                keyPoints.put('bottomDimension', bottomRow.get(options.dimensionFieldName));
                keyPoints.put('bottomValue', bottomRow.get(options.measureFieldName));
            }
        }

        return keyPoints;
    }
    
    /**
     * Formats a decimal value into a human-readable string with appropriate units (e.g., K, M, B).
     *
     * @param val The Decimal value to be formatted.
     * @return A string representation of the formatted value.
     */
    private static String formatValue(Decimal val) {
        if (val == null) return '';
        if (val >= 1000000000) {
            Decimal billions = val.divide(1000000000, 2, RoundingMode.HALF_UP);
            return String.valueOf(billions) + 'B';
        } else if (val >= 1000000) {
            Decimal millions = val.divide(1000000, 2, RoundingMode.HALF_UP);
            return String.valueOf(millions) + 'M';
        } else if (val >= 1000) {
            Decimal thousands = val.divide(1000, 1, RoundingMode.HALF_UP);
            return String.valueOf(thousands) + 'K';
        } 

        // Default to plain numbers
        return String.valueOf(val.setScale(2, RoundingMode.HALF_UP));
    }

    /**
     * Determines the appropriate color for a bar in the bar chart based on its position.
     *
     * @param index The index of the data point in the list.
     * @param totalCount The total number of data points.
     * @param isTop A boolean indicating if the query is a "top" query.
     * @param isBottom A boolean indicating if the query is a "bottom" query.
     * @return A string representing the color code for the bar.
     */
    private static String getColorForBar(Integer index, Integer totalCount, Boolean isTop, Boolean isBottom) {
        List<String> descendingColors = new List<String>{'#5A1BA8','#7548B7','#9175C6','#B08FD5','#C7B5E3','#D7BFF3'};
        List<String> ascendingColors = new List<String>{'#D7BFF3','#C7B5E3','#B08FD5','#9175C6','#7548B7','#5A1BA8'};

        List<String> chosenPalette;
        if (isTop) {
            chosenPalette = descendingColors;
        } else if (isBottom) {
            chosenPalette = ascendingColors;
        } else {
            chosenPalette = new List<String>{'#5A1BA8'};
        }

        Integer colorIndex = Math.min(index, chosenPalette.size()-1);
        return chosenPalette[colorIndex];
    }


}