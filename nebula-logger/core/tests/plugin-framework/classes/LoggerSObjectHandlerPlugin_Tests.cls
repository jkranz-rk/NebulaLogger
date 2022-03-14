//------------------------------------------------------------------------------------------------//
// This file is part of the Nebula Logger project, released under the MIT License.                //
// See LICENSE file or go to https://github.com/jongpie/NebulaLogger for full license details.    //
//------------------------------------------------------------------------------------------------//

@SuppressWarnings('PMD.ApexDoc, PMD.CyclomaticComplexity, PMD.ExcessiveParameterList, PMD.MethodNamingConventions, PMD.NcssMethodCount')
@IsTest
private class LoggerSObjectHandlerPlugin_Tests {
    private static final String PLUGIN_LOG_STATUS = 'On Hold';

    public class ExamplePlugin extends LoggerSObjectHandlerPlugin {
        public override void execute(LoggerPlugin__mdt configuration, LoggerSObjectHandler.SObjectHandlerInput input) {
            switch on input.triggerOperationType {
                when BEFORE_INSERT {
                    for (Log__c log : (List<Log__c>) input.triggerNew) {
                        log.Status__c = PLUGIN_LOG_STATUS;
                    }
                }
            }
        }
    }

    @IsTest
    static void it_should_execute_plugin_logic() {
        Log__c log = new Log__c(TransactionId__c = '1234');
        System.assertEquals(null, log.Status__c);
        LoggerSObjectHandler.SObjectHandlerInput input = new LoggerSObjectHandler.SObjectHandlerInput();
        input.triggerOperationType = TriggerOperation.BEFORE_INSERT;
        input.triggerNew = new List<Log__c>{ log };

        ExamplePlugin plugin = new ExamplePlugin();
        plugin.execute(new LoggerPlugin__mdt(), input);

        System.assertEquals(PLUGIN_LOG_STATUS, log.Status__c);
    }
}