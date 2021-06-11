---
layout: default
---

## LoggerSObjectHandlerPlugin interface

Interface used to define custom logic to run when DML statements occur on `Log__c` or `LogEntry__c`

---

### Methods

#### `execute(TriggerOperation triggerOperationType,List<SObject> triggerNew,Map<Id, SObject> triggerNewMap,List<SObject> triggerOld,Map<Id, SObject> triggerOldMap)` → `void`

---