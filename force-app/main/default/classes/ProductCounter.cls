public class ProductCounter {
    public class ProductCountWrapper {
        @InvocableVariable
        public Integer totalProductCount;
        
        public ProductCountWrapper(Integer count) {
            this.totalProductCount = count;
        }
    }

    @InvocableMethod(label='Get Total Product Count' description='Returns the total count of Product2 records')
    public static List<ProductCountWrapper> getTotalProductCount(List<String> request) {
        Integer count = [SELECT COUNT() FROM Product2];
        return new List<ProductCountWrapper>{ new ProductCountWrapper(count) };
    }
}