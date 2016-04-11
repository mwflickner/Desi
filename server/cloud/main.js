Parse.Cloud.define('hello', function(req, res) {
  res.success('Hi');
});

Parse.Cloud.afterDelete("DesiGroup", function(request) {
  console.log("group afterDelete");
  var userGroupQuery = new Parse.Query("DesiUserGroup");
  userGroupQuery.equalTo("group", request.object);
  userGroupQuery.find({
    success: function(userGroups) {
      Parse.Object.destroyAll(userGroups, {
        success: function() {
            console.log("Succesfully removed related userGroups");
        },
        error: function(error) {
          console.error("Error deleting related userGroups " + error.code + ": " + error.message);
        }
      });
    },
    error: function(error) {
      console.error("Error finding related userGroups " + error.code + ": " + error.message);
    }
  });

  var userGroupTaskQuery = new Parse.Query("DesiUserGroupTask");
  userGroupTaskQuery.matchesQuery("userGroup", userGroupQuery);
  userGroupTaskQuery.find({
    success: function(userGroupTasks) {
      Parse.Object.destroyAll(userGroupTasks, {
        success: function() {
            console.log("Succesfully removed related userGroupsTasks");
        },
        error: function(error) {
          console.error("Error deleting related userGroupTasks " + error.code + ": " + error.message);
        }
      });
    },
    error: function(error) {
      console.error("Error finding related userGroupsTasks " + error.code + ": " + error.message);
    }
  });

  var userGroupTaskLogQuery = new Parse.Query("DesiUserGroupTaskLog");
  userGroupTaskLogQuery.matchesQuery("userGroupTask", userGroupTaskQuery);
  userGroupTaskLogQuery.find({
    success: function(userGroupTaskLogs) {
      Parse.Object.destroyAll(userGroupTaskLogs, {
        success: function() {
            console.log("Succesfully removed related userGroupsTaskLogs");
        },
        error: function(error) {
          console.error("Error deleting related userGroupTaskLogs " + error.code + ": " + error.message);
        }
      });
    },
    error: function(error) {
      console.error("Error finding related userGroupsTaskLogs " + error.code + ": " + error.message);
    }
  });

  var taskQuery = new Parse.Query("DesiTask");
  taskQuery.matchesKeyInQuery("objectId" ,"task", userGroupTaskQuery);
  taskQuery.find({
    success: function(tasks) {
      Parse.Object.destroyAll(tasks, {
        success: function() {
            console.log("Succesfully removed related tasks");
        },
        error: function(error) {
          console.error("Error deleting related tasks " + error.code + ": " + error.message);
        }
      });
    },
    error: function(error) {
      console.error("Error finding related tasks " + error.code + ": " + error.message);
    }
  });
});
