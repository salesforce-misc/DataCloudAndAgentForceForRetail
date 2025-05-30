/**
 * Class to a semantic model payload based on a provided template definition.
 *
 * Author: Antoine Laviron
 * Contact: alaviron@salesforce.com
 */
public class TE_SemanticModelPayloadGenerator {

    /**
     * Generates a semantic model payload based on a provided template definition.
     * This method parses the template, processes its sections, and builds a new payload
     * with cleaned dimensions, measurements, relationships, data objects, and other metadata.
     *
     * @param newModelName The name of the new semantic model to be created.
     * @param templateDefinitionJson The JSON string representing the template definition.
     * @return A JSON string representing the generated payload for the semantic model.
     */
    public static String generatePayload(String newModelName, String templateDefinitionJson) {
        // Parse the template model definition JSON
        Map<String, Object> templateDefinition = (Map<String, Object>) JSON.deserializeUntyped(templateDefinitionJson);

        // Create a new map for the payload
        Map<String, Object> newPayload = new Map<String, Object>();

        // Construct the payload
        // Parameters (not processed at creation)
        if (templateDefinition.containsKey('semanticParameters')) {
            newPayload.put('semanticParameters', templateDefinition.get('semanticParameters'));
        }

        // Semantic groupings (not processed at creation)
        if (templateDefinition.containsKey('semanticGroupings')) {
            newPayload.put('semanticGroupings', templateDefinition.get('semanticGroupings'));
        }

        // Metrics (not processed at creation)
        if (templateDefinition.containsKey('semanticMetrics')) {
            newPayload.put('semanticMetrics', templateDefinition.get('semanticMetrics'));
        }

        // Semantic Logical views (not processed at creation)
        if (templateDefinition.containsKey('semanticLogicalViews')) {
            newPayload.put('semanticLogicalViews', templateDefinition.get('semanticLogicalViews'));
        }

        // Calculated dimensions
        newPayload.put('semanticCalculatedDimensions', cleanCalculatedDimensions(templateDefinition));

        // Calculated measurements
        newPayload.put('semanticCalculatedMeasurements',  cleanCalculatedMeasurements(templateDefinition));

        // Relationships
        newPayload.put('semanticRelationships', cleanSemanticRelationships(templateDefinition));

        // Semantic data objects
        newPayload.put('semanticDataObjects', cleanSemanticDataObjects(templateDefinition));

        newPayload.put('dataspace', (String) templateDefinition.get('dataspace'));
        newPayload.put('queryUnrelatedDataObjects', templateDefinition.get('queryUnrelatedDataObjects')); 
        newPayload.put('categories', templateDefinition.get('categories'));
        newPayload.put('app',  '');
        newPayload.put('label', newModelName.replace('_', ' '));
        
        // Base models
        newPayload.put('baseModels', cleanBaseModels(templateDefinition));

        newPayload.put('apiName', newModelName);

        // Serialize the new payload to JSON
        return JSON.serialize(newPayload);
    }

    /**
     * Cleans a string by replacing special characters (e.g., '&quot;') with readable characters.
     *
     * @param value The string to be cleaned.
     * @return The cleaned string.
     */
    private static String cleanString(String value) {
        if (value == null) {
            return '';
        }
        return value.replace('&quot;', '\'')
                    .replace('&#39;', '\'')
                    .replace('\n', ' ')
                    .replace('&lt;','<')
                    .replace('&gt;', '>');
    }

    /**
     * Cleans and processes the calculated dimensions section from the template definition.
     *
     * @param templateDefinition The parsed template definition map.
     * @return A list of cleaned dimensions.
     */
    private static List<Map<String, Object>> cleanCalculatedDimensions(Map<String, Object> templateDefinition) {
        if (!templateDefinition.containsKey('semanticCalculatedDimensions')) {
            return new List<Map<String, Object>>();
        }

        List<Object> dimensions = (List<Object>) templateDefinition.get('semanticCalculatedDimensions');
        List<Map<String, Object>> cleanedDimensions = new List<Map<String, Object>>();

        for (Object dimensionObj : dimensions) {
            if (dimensionObj instanceof Map<String, Object>) {
                Map<String, Object> dimension = (Map<String, Object>) dimensionObj;
                Map<String, Object> cleanedDimension = new Map<String, Object>();

                cleanedDimension.put('filters', dimension.get('filters'));
                cleanedDimension.put('expression', cleanString((String) dimension.get('expression')));
                cleanedDimension.put('semanticDataType', dimension.get('semanticDataType'));
                cleanedDimension.put('dataType', dimension.get('dataType'));
                cleanedDimension.put('isVisible', dimension.get('isVisible'));
                cleanedDimension.put('displayCategory', dimension.get('displayCategory'));
                cleanedDimension.put('sortOrder', dimension.get('sortOrder'));
                cleanedDimension.put('description', cleanString((String) dimension.get('description')));
                cleanedDimension.put('label', dimension.get('label'));
                cleanedDimension.put('apiName', dimension.get('apiName'));

                cleanedDimensions.add(cleanedDimension);
            }
        }

        return cleanedDimensions;
    }

    /**
     * Cleans and processes the calculated measurements section from the template definition.
     *
     * @param templateDefinition The parsed template definition map.
     * @return A list of cleaned measurements.
     */
    private static List<Map<String, Object>> cleanCalculatedMeasurements(Map<String, Object> templateDefinition) {
        if (!templateDefinition.containsKey('semanticCalculatedMeasurements')) {
            return new List<Map<String, Object>>();
        }

        List<Object> measurements = (List<Object>) templateDefinition.get('semanticCalculatedMeasurements');
        List<Map<String, Object>> cleanedMeasurements = new List<Map<String, Object>>();

        for (Object measurementObj : measurements) {
            if (measurementObj instanceof Map<String, Object>) {
                Map<String, Object> measurement = (Map<String, Object>) measurementObj;
                Map<String, Object> cleanedMeasurement = new Map<String, Object>();

                cleanedMeasurement.put('filters', measurement.get('filters'));
                cleanedMeasurement.put('expression', cleanString((String) measurement.get('expression')));
                cleanedMeasurement.put('shouldTreatNullsAsZeros', measurement.get('shouldTreatNullsAsZeros'));
                cleanedMeasurement.put('sentiment', measurement.get('sentiment'));
                cleanedMeasurement.put('aggregationType', measurement.get('aggregationType'));
                cleanedMeasurement.put('decimalPlace', measurement.get('decimalPlace'));
                cleanedMeasurement.put('semanticDataType', measurement.get('semanticDataType'));
                cleanedMeasurement.put('dataType', measurement.get('dataType'));
                cleanedMeasurement.put('isVisible', measurement.get('isVisible'));
                cleanedMeasurement.put('displayCategory', measurement.get('displayCategory'));
                cleanedMeasurement.put('sortOrder', measurement.get('sortOrder'));
                cleanedMeasurement.put('description', cleanString((String) measurement.get('description')));
                cleanedMeasurement.put('label', measurement.get('label'));
                cleanedMeasurement.put('apiName', measurement.get('apiName'));

                cleanedMeasurements.add(cleanedMeasurement);
            }
        }

        return cleanedMeasurements;
    }

    /**
     * Cleans and processes the semantic relationships section from the template definition.
     *
     * @param templateDefinition The parsed template definition map.
     * @return A list of cleaned semantic relationships.
     */
    private static List<Map<String, Object>> cleanSemanticRelationships(Map<String, Object> templateDefinition) {
        if (!templateDefinition.containsKey('semanticRelationships')) {
            return new List<Map<String, Object>>();
        }

        List<Object> relationships = (List<Object>) templateDefinition.get('semanticRelationships');
        List<Map<String, Object>> cleanedRelationships = new List<Map<String, Object>>();

        for (Object relationshipObj : relationships) {
            if (relationshipObj instanceof Map<String, Object>) {
                Map<String, Object> relationship = (Map<String, Object>) relationshipObj;
                Map<String, Object> cleanedRelationship = new Map<String, Object>();

                cleanedRelationship.put('rightSemanticDefinitionApiName', relationship.get('rightSemanticDefinitionApiName'));
                cleanedRelationship.put('logicalViewId', relationship.get('logicalViewId'));
                cleanedRelationship.put('leftSemanticDefinitionApiName', relationship.get('leftSemanticDefinitionApiName'));
                cleanedRelationship.put('joinType', relationship.get('joinType'));
                cleanedRelationship.put('isEnabled', relationship.get('isEnabled'));
                cleanedRelationship.put('criteria', relationship.get('criteria'));
                cleanedRelationship.put('cardinality', relationship.get('cardinality'));
                cleanedRelationship.put('label', relationship.get('label'));
                cleanedRelationship.put('description', cleanString((String) relationship.get('description')));
                cleanedRelationship.put('apiName', relationship.get('apiName'));

                cleanedRelationships.add(cleanedRelationship);
            }
        }

        return cleanedRelationships;
    }

    /**
     * Cleans and processes the semantic data objects section from the template definition.
     *
     * @param templateDefinition The parsed template definition map.
     * @return A list of cleaned semantic data objects.
     */
    private static List<Map<String, Object>> cleanSemanticDataObjects(Map<String, Object> templateDefinition) {
        if (!templateDefinition.containsKey('semanticDataObjects')) {
            return new List<Map<String, Object>>();
        }

        List<Object> dataObjects = (List<Object>) templateDefinition.get('semanticDataObjects');
        List<Map<String, Object>> cleanedDataObjects = new List<Map<String, Object>>();

        for (Object dataObjectObj : dataObjects) {
            if (dataObjectObj instanceof Map<String, Object>) {
                Map<String, Object> dataObject = (Map<String, Object>) dataObjectObj;
                Map<String, Object> cleanedDataObject = new Map<String, Object>();

                // Process semantic measurements
                if (dataObject.containsKey('semanticMeasurements')) {
                    cleanedDataObject.put('semanticMeasurements', cleanMeasurements((List<Object>) dataObject.get('semanticMeasurements')));
                }

                // Process semantic dimensions
                if (dataObject.containsKey('semanticDimensions')) {
                    cleanedDataObject.put('semanticDimensions', cleanDimensions((List<Object>) dataObject.get('semanticDimensions')));
                }

                // Add other properties
                cleanedDataObject.put('shouldIncludeAllFields', dataObject.get('shouldIncludeAllFields'));
                cleanedDataObject.put('dataObjectType', dataObject.get('dataObjectType'));
                cleanedDataObject.put('dataObjectName', dataObject.get('dataObjectName'));
                cleanedDataObject.put('description', cleanString((String) dataObject.get('description')));
                cleanedDataObject.put('label', dataObject.get('label'));
                cleanedDataObject.put('apiName', dataObject.get('apiName'));

                cleanedDataObjects.add(cleanedDataObject);
            }
        }

        return cleanedDataObjects;
    }

    /**
     * Cleans and processes a list of semantic measurements.
     *
     * @param measurements The list of measurements to process.
     * @return A list of cleaned semantic measurements.
     */
    private static List<Map<String, Object>> cleanMeasurements(List<Object> measurements) {
        List<Map<String, Object>> cleanedMeasurements = new List<Map<String, Object>>();
        for (Object measurementObj : measurements) {
            if (measurementObj instanceof Map<String, Object>) {
                Map<String, Object> measurement = (Map<String, Object>) measurementObj;
                Map<String, Object> cleanedMeasurement = new Map<String, Object>();

                cleanedMeasurement.put('sentiment', measurement.get('sentiment'));
                cleanedMeasurement.put('shouldTreatNullsAsZeros', measurement.get('shouldTreatNullsAsZeros'));
                cleanedMeasurement.put('isVisible', measurement.get('isVisible'));
                cleanedMeasurement.put('directionality', measurement.get('directionality'));
                cleanedMeasurement.put('displayCategory', measurement.get('displayCategory'));
                cleanedMeasurement.put('sortOrder', measurement.get('sortOrder'));
                cleanedMeasurement.put('aggregationType', measurement.get('aggregationType'));
                cleanedMeasurement.put('decimalPlace', measurement.get('decimalPlace'));
                cleanedMeasurement.put('semanticDataType', measurement.get('semanticDataType'));
                cleanedMeasurement.put('dataType', measurement.get('dataType'));
                cleanedMeasurement.put('description', cleanString((String) measurement.get('description')));
                cleanedMeasurement.put('label', measurement.get('label'));
                cleanedMeasurement.put('dataObjectFieldName', measurement.get('dataObjectFieldName'));
                cleanedMeasurement.put('apiName', measurement.get('apiName'));

                cleanedMeasurements.add(cleanedMeasurement);
            }
        }
        return cleanedMeasurements;
    }

    /**
     * Cleans and processes a list of semantic dimensions.
     *
     * @param dimensions The list of dimensions to process.
     * @return A list of cleaned semantic dimensions.
     */
    private static List<Map<String, Object>> cleanDimensions(List<Object> dimensions) {
        List<Map<String, Object>> cleanedDimensions = new List<Map<String, Object>>();
        for (Object dimensionObj : dimensions) {
            if (dimensionObj instanceof Map<String, Object>) {
                Map<String, Object> dimension = (Map<String, Object>) dimensionObj;
                Map<String, Object> cleanedDimension = new Map<String, Object>();

                cleanedDimension.put('isVisible', dimension.get('isVisible'));
                cleanedDimension.put('displayCategory', dimension.get('displayCategory'));
                cleanedDimension.put('sortOrder', dimension.get('sortOrder'));
                cleanedDimension.put('semanticDataType', dimension.get('semanticDataType'));
                cleanedDimension.put('dataType', dimension.get('dataType'));
                cleanedDimension.put('description', cleanString((String) dimension.get('description')));
                cleanedDimension.put('label', dimension.get('label'));
                cleanedDimension.put('dataObjectFieldName', dimension.get('dataObjectFieldName'));
                cleanedDimension.put('apiName', dimension.get('apiName'));

                cleanedDimensions.add(cleanedDimension);
            }
        }
        return cleanedDimensions;
    }

    /**
     * Cleans and processes the base models section from the template definition.
     *
     * @param templateDefinition The parsed template definition map.
     * @return A list of cleaned base models.
     */
    private static List<Map<String, Object>> cleanBaseModels(Map<String, Object> templateDefinition) {
        if (!templateDefinition.containsKey('baseModels') || !(templateDefinition.get('baseModels') instanceof List<Object>)) {
            return new List<Map<String, Object>>();
        }

        List<Object> baseModels = (List<Object>) templateDefinition.get('baseModels');
        List<Map<String, Object>> cleanedBaseModels = new List<Map<String, Object>>();

        for (Object baseModelObj : baseModels) {
            if (baseModelObj instanceof Map<String, Object>) {
                Map<String, Object> baseModel = (Map<String, Object>) baseModelObj;
                Map<String, Object> cleanedModel = new Map<String, Object>();
                cleanedModel.put('apiName', baseModel.get('apiName'));
                cleanedBaseModels.add(cleanedModel);
            }
        }

        return cleanedBaseModels;
    }

}