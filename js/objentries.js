if (!Object.entries) {
    Object.entries = function ObjEntries(obj) {
      return Object.keys(obj).map(key => [key, obj[key]]);
    };
  }