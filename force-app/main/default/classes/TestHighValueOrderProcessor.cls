@isTest
public with sharing class TestHighValueOrderProcessor {

    // Test setup method to create both high-value and low-value orders
    @testSetup
    static void setup() {
        List<Order__c> orders = new List<Order__c>();
        // Create high-value orders
        for (Integer i = 0; i < 3; i++) {
            orders.add(new Order__c(Amount__c = 600000, Status__c = 'Pending'));
        }
        // Create low-value orders
        for (Integer i = 0; i < 2; i++) {
            orders.add(new Order__c(Amount__c = 400000, Status__c = 'Pending'));
        }
        insert orders;
    }

    // Test single record that meets the criteria
    @isTest
    static void testPositiveSingleOrder() {
        Order__c order = [SELECT Id, Status__c FROM Order__c WHERE Amount__c = 600000 LIMIT 1];
        Test.startTest();
        update order;  // This should trigger the Flow
        Test.stopTest();

        Order__c updatedOrder = [SELECT Status__c FROM Order__c WHERE Id = :order.Id];
        Assert.areEqual('Processed', updatedOrder.Status__c, 'The order status should be updated to Processed.');
    }

    // Test single record that does not meet the criteria
    @isTest
    static void testNegativeSingleOrder() {
        Order__c order = [SELECT Id, Status__c FROM Order__c WHERE Amount__c = 400000 LIMIT 1];
        Test.startTest();
        update order;  // This should not trigger the Flow to update status
        Test.stopTest();

        Order__c updatedOrder = [SELECT Status__c FROM Order__c WHERE Id = :order.Id];
        Assert.areNotEqual('Processed', updatedOrder.Status__c, 'The order status should not be updated.');
    }

    // Test bulk records to ensure bulk processing works as expected
    @isTest
    static void testPositiveBulkOrders() {
        List<Order__c> orders = [SELECT Id, Status__c FROM Order__c WHERE Amount__c = 600000];
        Test.startTest();
        update orders;  // This should trigger the Flow for each order
        Test.stopTest();

        List<Order__c> updatedOrders = [SELECT Status__c FROM Order__c WHERE Id IN :orders];
        for (Order__c order : updatedOrders) {
            Assert.areEqual('Processed', order.Status__c, 'Each order status should be updated to Processed.');
        }
    }

    // Test mixed condition bulk orders to ensure each is processed correctly
    @isTest
    static void testMixedBulkOrders() {
        List<Order__c> orders = [SELECT Id, Status__c, Amount__c FROM Order__c ORDER BY Amount__c DESC];
        Test.startTest();
        update orders;
        Test.stopTest();

        for (Order__c order : orders) {
            if (order.Amount__c >= 500000) {
                Assert.areEqual('Processed', order.Status__c, 'High value orders should be processed.');
            } else {
                Assert.areNotEqual('Processed', order.Status__c, 'Lower value orders should not be processed.');
            }
        }
    }
}
