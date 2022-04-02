//------------------------------------------------------------------------------------------------//
// This file is part of the Nebula Logger project, released under the MIT License.                //
// See LICENSE file or go to https://github.com/jongpie/NebulaLogger for full license details.    //
//------------------------------------------------------------------------------------------------//

/**
 * @group Test Utilities
 * @description Utility class used to help with setting up Nebula Logger's configurations within a test context.
 *              These methods are specific to metadata implemented within Nebula Logger.
 *              These methods can be used when writing Apex tests for plugins.
 * @see LoggerMockCreator
 */
@IsTest
public without sharing class LoggerTestConfigurator {
    // Lazy-load & cache permission sets & profiles
    private static final Map<String, PermissionSet> PERMISSION_SETS_BY_NAME {
        get {
            if (PERMISSION_SETS_BY_NAME == null) {
                PERMISSION_SETS_BY_NAME = queryPermissionSets();
            }
            return PERMISSION_SETS_BY_NAME;
        }
        private set;
    }

    /**
     * @description Assigns the permission set `LoggerAdmin` to the specified user ID
     * @param  userId The ID of the user that should be assigned the permission set
     */
    public static void assignAdminPermissionSet(Id userId) {
        assignPermissionSet(userId, PERMISSION_SETS_BY_NAME.get('LoggerAdmin'));
    }

    /**
     * @description Assigns the permission set `LoggerLogViewer` to the specified user ID
     * @param  userId The ID of the user that should be assigned the permission set
     */
    public static void assignLogViewerPermissionSet(Id userId) {
        assignPermissionSet(userId, PERMISSION_SETS_BY_NAME.get('LoggerLogViewer'));
    }

    /**
     * @description Assigns the permission set `LoggerEndUser` to the specified user ID
     * @param  userId The ID of the user that should be assigned the permission set
     */
    public static void assignEndUserPermissionSet(Id userId) {
        assignPermissionSet(userId, PERMISSION_SETS_BY_NAME.get('LoggerEndUser'));
    }

    /**
     * @description Assigns the permission set `LoggerLogCreator` to the specified user ID
     * @param  userId The ID of the user that should be assigned the permission set
     */
    public static void assignLogCreatorPermissionSet(Id userId) {
        assignPermissionSet(userId, PERMISSION_SETS_BY_NAME.get('LoggerLogCreator'));
    }

    public static LoggerSObjectHandler__mdt getSObjectHandlerConfiguration(Schema.SObjectType sobjectType) {
        return LoggerSObjectHandler.getHandlerConfiguration(sobjectType);
    }

    public static void initiliazeTestDefaults() {
        LoggerDataStore.setMock(LoggerMockDataStore.getEventBus());
        LoggerDataStore.setMock(LoggerMockDataStore.getDatabase());
        setupMockSObjectHandlerConfigurations();
    }

    /**
     * @description Loads the mock `LogEntryDataMaskRule__mdt` during test execution
     * @param  mock The mock instance of `LogEntryDataMaskRule__mdt` to load
     */
    public static void setMock(LogEntryDataMaskRule__mdt mock) {
        LogEntryEventBuilder.setMockDataMaskRule(mock);
    }

    /**
     * @description Loads the mock `LogEntryTagRule__mdt` during test execution
     * @param  mock The mock instance of `LogEntryTagRule__mdt` to load
     */
    public static void setMock(LogEntryTagRule__mdt mock) {
        LogEntryEventHandler.TAG_ASSIGNMENT_RULES.add(mock);
    }

    /**
     * @description Loads the mock `LoggerParameter__mdt` during test execution
     * @param  mock The mock instance of `LoggerParameter__mdt` to load
     */
    public static void setMock(LoggerParameter__mdt mock) {
        LoggerParameter.setMock(mock);
    }

    /**
     * @description Loads the mock `LoggerPlugin__mdt` during test execution
     * @param  mock The mock instance of `LoggerPlugin__mdt` to load
     */
    public static void setMock(LoggerPlugin__mdt mock) {
        LoggerPlugin.setMock(mock);
    }

    /**
     * @description Loads the mock `LoggerSObjectHandler__mdt` during test execution
     * @param  mock The mock instance of `LoggerSObjectHandler__mdt` to load
     */
    public static void setMock(LoggerSObjectHandler__mdt mock) {
        LoggerSObjectHandler.setMock(mock);
    }

    /**
     * @description Loads the mock `LogScenarioRule__mdt` during test execution
     * @param  mock The mock instance of `LogScenarioRule__mdt` to load
     */
    public static void setMock(LogScenarioRule__mdt mock) {
        Logger.setMockScenarioRule(mock);
        LogHandler.setMockScenarioRule(mock);
    }

    /**
     * @description Loads the mock `LogStatus__mdt` during test execution
     * @param  mock The mock instance of `LogStatus__mdt` to load
     */
    public static void setMock(LogStatus__mdt mock) {
        LogHandler.setMockLogStatus(mock);
    }

    public static void setupMockSObjectHandlerConfigurations() {
        setupMockSObjectHandlerConfigurations(true);
    }

    public static void setupMockSObjectHandlerConfigurations(Boolean isEnabled) {
        Map<Schema.SObjectType, System.Type> sobjectTypeToDefaultHandlerApexClass = new Map<Schema.SObjectType, System.Type>{
            Schema.Log__c.SObjectType => LogHandler.class,
            Schema.LogEntry__c.SObjectType => LogEntryHandler.class,
            Schema.LogEntryEvent__e.SObjectType => LogEntryEventHandler.class,
            Schema.LogEntryTag__c.SObjectType => LogEntryTagHandler.class,
            Schema.LoggerTag__c.SObjectType => LoggerTagHandler.class
        };
        for (Schema.SObjectType sobjectType : sobjectTypeToDefaultHandlerApexClass.keySet()) {
            setMock(
                new LoggerSObjectHandler__mdt(
                    IsEnabled__c = isEnabled,
                    SObjectHandlerApexClass__c = sobjectTypeToDefaultHandlerApexClass.get(sobjectType).getName(),
                    SObjectType__c = sobjectType.getDescribe().getName()
                )
            );
        }
    }

    // Helper methods
    private static void assignPermissionSet(Id userId, PermissionSet permissionSet) {
        PermissionSetAssignment permissionSetAssignment = new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = permissionSet.Id);
        insert permissionSetAssignment;
    }

    private static Map<String, PermissionSet> queryPermissionSets() {
        List<String> permissionSetNames = new List<String>{ 'LoggerAdmin', 'LoggerLogViewer', 'LoggerEndUser', 'LoggerLogCreator' };
        Map<String, PermissionSet> results = new Map<String, PermissionSet>();
        for (PermissionSet permissionSet : [SELECT Id, Name FROM PermissionSet WHERE Name IN :permissionSetNames]) {
            results.put(permissionSet.Name, permissionSet);
        }
        return results;
    }

    public class MockBatchablePlugin implements LoggerPlugin.Batchable {
        public void start(LoggerPlugin__mdt configuration, LoggerBatchableContext input) {
        }
        public void execute(LoggerPlugin__mdt configuration, LoggerBatchableContext input, List<SObject> scope) {
        }
        public void finish(LoggerPlugin__mdt configuration, LoggerBatchableContext input) {
        }
    }
}