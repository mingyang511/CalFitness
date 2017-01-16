Parse.Cloud.beforeSave(Parse.User, function(request, response) {
  Parse.Cloud.useMasterKey();

  if (!request.object.get("group")) {
    request.object["group"] = Math.floor(Math.random() * (5 - 1)) + 1;
  }
  response.success();
});

Parse.Cloud.beforeSave("Record", function(request, response) {
  Parse.Cloud.useMasterKey();
  
  var newRecord = request.object;
  var goal = newRecord.get("goal");
  var date = newRecord.get("date");
  
  if (typeof goal != 'number') {
    response.error("Invalid goal");
  }
  
  if (!date || typeof date != 'string') {
    response.error("Invalid date");
  }
  
  var Record = Parse.Object.extend("Record");
  var query = new Parse.Query(Record);
  query.equalTo("user", newRecord.get("user"));
  query.equalTo("date", newRecord.get("date"));
  query.first({
    success: function(oldRecord) {
      if (oldRecord) {        
        request.object.set("goal", oldRecord.get("goal"));
        if (newRecord.id != oldRecord.id) {
          oldRecord.destroy();
        }
      }
      response.success();
    },
    error: function(error) {
      response.error(error.message);
    },
    useMasterKey: true
  });
});

Parse.Cloud.define("collectRecord", function(request, response) {
  Parse.Cloud.useMasterKey();
  
  // Query for all users
  var query = new Parse.Query(Parse.Installation);
  Parse.Push.send({
    where: query,
    data: {
      "aps" : {
        "content-available" : 1,
        "sound" : "",
        "type":"collect",
      }
    }
  },{
    success: function() {
      response.success();
    },
    error: function(error) {
      response.error(error.message);
    },
    useMasterKey: true
  });
});

