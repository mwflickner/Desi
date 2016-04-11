Parse.Cloud.define('hello', function(req, res) {
  res.success('Hi');
});

Parse.Cloud.afterDelete(Parse.DesiGroup, function(request) {
  userGroupQuery = new Parse.Query("DesiUserGroup");
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

  userGroupTaskQuery = new Parse.Query("DesiUserGroupTask");
  userGroupTaskQuery.matchesQuery("userGroup", userGroupQuery);

  userGroupTaskLogQuery = new Parse.Query("DesiUserGroupTaskLog");
  userGroupTaskLogQuery.matchesQuery("userGroupTask", userGroupTaskQuery);

});
