public with sharing class OrderProcessor {

    // Method to process multiple orders
    public static void processOrders(List<Order__c> orders) {
        List<Order__c> ordersToUpdate = new List<Order__c>();

        for (Order__c order : orders) {
            // Validate order before processing
            if (validateOrder(order)) {
                order.Status__c = 'Processed';
                ordersToUpdate.add(order);
            }
        }

        // Update orders if they are valid and marked as processed
        if (!ordersToUpdate.isEmpty()) {
            if (Schema.sObjectType.Order__c.isUpdateable()) {
                update ordersToUpdate;
            }
        }
    }

    // Helper method to validate individual orders
    private static Boolean validateOrder(Order__c order) {
        // Check for minimum order amount and valid item count
        return (order.Amount__c >= 100 && order.Item_Count__c > 0);
    }
}
