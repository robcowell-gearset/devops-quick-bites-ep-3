@isTest
public with sharing class OrderProcessorTest {

    // Setup method to create test data
    @testSetup
    static void setupTestData() {
        List<Order__c> orders = new List<Order__c>();
        // Creating orders that meet the criteria
        orders.add(new Order__c(
            Amount__c = 200000,
            Item_Count__c = 5,
            Status__c = 'Pending'
        ));
        // Creating orders that do not meet the criteria
        orders.add(new Order__c(
            Amount__c = 50000,
            Item_Count__c = 0,
            Status__c = 'Pending'
        ));
        insert orders;
    }

    // Test method for positive single order processing
    @isTest
    static void testPositiveSingleOrderProcessing() {
        List<Order__c> orders = [SELECT Id, Amount__c, Item_Count__c, Status__c FROM Order__c WHERE Amount__c = 200000 LIMIT 1];
        Test.startTest();
        OrderProcessor.processOrders(orders);
        Test.stopTest();

        // Assert that the order was processed
        Assert.areEqual('Processed', orders[0].Status__c, 'The order should be processed.');
    }

    // Test method for negative single order processing
    @isTest
    static void testNegativeSingleOrderProcessing() {
        List<Order__c> orders = [SELECT Id, Amount__c, Item_Count__c, Status__c FROM Order__c WHERE Amount__c = 50000 LIMIT 1];
        Test.startTest();
        OrderProcessor.processOrders(orders);
        Test.stopTest();

        // Assert that the order was not processed
        Assert.areNotEqual('Processed', orders[0].Status__c, 'The order should not be processed.');
    }

    // Test method for positive bulk order processing
    @isTest
    static void testPositiveBulkOrderProcessing() {
        List<Order__c> orders = [SELECT Id, Amount__c, Item_Count__c, Status__c FROM Order__c WHERE Amount__c = 200000];
        Test.startTest();
        OrderProcessor.processOrders(orders);
        Test.stopTest();

        // Assert that all orders are processed
        for (Order__c order : orders) {
            Assert.areEqual('Processed', order.Status__c, 'All orders should be processed.');
        }
    }

    // Test method for negative bulk order processing
    @isTest
    static void testNegativeBulkOrderProcessing() {
        List<Order__c> orders = [SELECT Id, Amount__c, Item_Count__c, Status__c FROM Order__c WHERE Amount__c = 50000];
        Test.startTest();
        OrderProcessor.processOrders(orders);
        Test.stopTest();

        // Assert that none of the orders are processed
        for (Order__c order : orders) {
            Assert.areNotEqual('Processed', order.Status__c, 'None of the orders should be processed.');
        }
    }
}
