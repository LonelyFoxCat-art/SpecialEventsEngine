function Storage() {
	globalvar StorageData;
	var StorageStruct = {
		type: "Storage",
		data: {},
		
		Register: function(Name, Init = undefined) {
			if (Exists(Name)) return false;
		
	        self.data[$ Name] = Init() ?? {};
			var data = self.data[$ Name];
			if (struct_exists(data, "Custom")) data.Custom();

	        return StorageData;
		},
		Invoke: function(Name) {
	        if (Exists(Name)) return self.data[$ Name];
	        return undefined;
	    },
		Exists: function(Name) {
			return struct_exists(self.data, Name);
		},
		Renewal: function(Name) {
			var FnName = "Update" + Name;
	        var key = struct_get_names(self.data);
	        for(var i = 0; i < array_length(key); i ++) {
				var data = self.data[$ key[i]];
	            if (struct_exists(data, FnName) && !is_undefined(data[$ FnName])) data[$ FnName](data);
	        }
	    },
		Destroy: function() {
	        var key = struct_get_names(self.data);
	        for(var i = 0; i < array_length(key); i ++) {
				var data = self.data[$ key[i]];
	            if (struct_exists(data, "Destroy")) data.Destroy();
	        }
	    }
	};
	
	StorageData = StorageStruct;
	return StorageStruct;
}