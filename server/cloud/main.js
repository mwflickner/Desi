Parse.Cloud.define('hello', function(req, res) {
  res.success('Hi');
});

// Parse.Cloud.beforeSave("DesiUserGroup", function(request, response){
//   console.log("ug beforeSave");
//   console.log(request.object);
// });

// Parse.Cloud.afterSave("DesiUserGroup", function(request){
//   console.log(request.object.get("updateCounter"));
//   request.object.decrement("updateCounter");
//   console.log(request.object.get("updateCounter"));
// });

// Parse.Cloud.beforeSave("DesiUserGroupTask", function(request, response){
  
// });

// Parse.Cloud.afterSave("DesiUserGroupTask", function(request){
  
// });


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
  userGroupTaskQuery.include("task");
  userGroupTaskQuery.matchesQuery("userGroup", userGroupQuery);
  userGroupTaskQuery.find({
    success: function(userGroupTasks) {
      var tasks = new Set();
      for(var i = 0; i < userGroupTasks.length; i++){
        var task = userGroupTasks[i].get("task");
        tasks.add(task);
      }
      var taskArray = Array.from(tasks);

      Parse.Object.destroyAll(userGroupTasks, {
        success: function() {
            console.log("Succesfully removed related userGroupsTasks");
        },
        error: function(error) {
          console.error("Error deleting related userGroupTasks " + error.code + ": " + error.message);
        }
      });

      Parse.Object.destroyAll(taskArray, {
        success: function() {
            console.log("Succesfully removed related tasks");
        },
        error: function(error) {
          console.error("Error deleting related tasks " + error.code + ": " + error.message);
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
});

// Parse.Cloud.afterDelete("DesiUserGroup", function(request){
//   console.log("userGroup afterDelete");
//   var userGroupTaskQuery = new Parse.Query("DesiUserGroupTask");
//   userGroupTaskQuery.include("userGroup");
//   userGroupTaskQuery.equalTo("userGroup", request.object);
//   userGroupTaskQuery.find({
//     success: function(userGroupTasks) {
//       console.log("swagggg");
//       console.log(userGroupTasks);
//       console.log(userGroupTasks.length);
//       for(var i = 0; i < userGroupTasks.length; i++){
//         var isDesi = userGroupTasks[i].get("isDesi");
//         if (isDesi){
//           var otherUgtQuery = new Parse.Query("DesiUserGroupTask");
//           otherUgtQuery.include("task");
//           otherUgtQuery.include("userGroup");
//           otherUgtQuery.notEqualTo("userGroup", request.object);
//           console.log(userGroupTasks[i].get("task"));
//           otherUgtQuery.matchesQuery("task", userGroupsTasks[i].get("task"));
//           console.log("about to search");
//           otherUgtQuery.find({
//             success: function(otherUgts){
//               console.log("here");
//               if (otherUgts.length > 0){
//                 otherUgts[0].set("isDesi", true);
//                 otherUgts[0].save();
//               }
//             },
//             error: function(error){
//               console.error("Error finding other ugts " + error.code + ": " + error.message);
//             }
//           });
//         }
//         console.log(isDesi);
//       }

//       Parse.Object.destroyAll(userGroupTasks, {
//         success: function() {
//             console.log("Succesfully removed related userGroupsTasks");
//         },
//         error: function(error) {
//           console.error("Error deleting related userGroupTasks " + error.code + ": " + error.message);
//         }
//       });
//     },
//     error: function(error) {
//       console.error("Error finding related userGroupsTasks " + error.code + ": " + error.message);
//     }
//   });
// });

Parse.Cloud.afterDelete("DesiTask", function(request){
  console.log("task afterDelete");
  var userGroupTaskQuery = new Parse.Query("DesiUserGroupTask");
  userGroupTaskQuery.include("task");
  userGroupTaskQuery.equalTo("task", request.object);
  userGroupTaskQuery.find({
    success: function(userGroupTasks){
      Parse.Object.destroyAll(userGroupTasks, {
        success: function(){
          console.log("Succesfully removed related UGTs");
        },
        error: function(error){
          console.error("Error deleting related UGTS" + error.code + ": " + error.message);
        }
      });
    },
    error: function(error){
      console.error("Error finding related UGTs " + error.code + ": " + error.message);
    }
  });
});
