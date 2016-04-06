Parse.Cloud.define('hello', function(req, res) {
  res.success('Hi');
});

Parse.Cloud.afterDelete(Parse.DesiGroup, function(request) {
  query = new Parse.Query("DesiUserGroup");
  query.equalTo("group", request.object);
  query.find({
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
});
