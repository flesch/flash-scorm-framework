!(function () {

  var api, container, session, models, cache = [];

  // Let's list out the data models we care about. We could populate this array with `cmi.core._children`,
  // but it includes more keys than we'll ever want to use (and we'd have to pull out the read-only ones).
  models = ["cmi.core.student_id", "cmi.core.student_name", "cmi.core.lesson_location", "cmi.core.lesson_status", "cmi.core.score.raw", "cmi.suspend_data"];

  // Capture the LMS API. We only need to search for it once, so we can cache it in a variable and re-use it.
  // Some SCORM API Wrappers will search for the API with every SCORM command. Is it really going to move?
  api = (function (search) {
    // We've made the `container` variable accessible outside of this function, as we'll
    // want to interact with the DOMWindow that holds the API.
    var self = arguments.callee;
    container = search || window;
    // If the API isn't in the current window, look backwards for it.
    if (!container.API) {
      // First, we'll try any parent frames.
      if (container !== container.parent) {
        return self.call(this, container.parent);
      }
      // Then, any `opener` windows.
      if (container.opener !== null && (typeof container.opener !== "undefined") && !container.opener.closed) {
        return self.call(this, container.opener);
      }
    }
    // Return the API Object.
    return container.API;
  }).call(this);

  // https://github.com/documentcloud/underscore/blob/master/underscore.js#L75
  function each(obj, iterator, context) {
    if (obj === null) { return; }
    if (Array.prototype.forEach && obj.forEach === Array.prototype.forEach) {
      obj.forEach(iterator, context);
    } else if (obj.length === +obj.length) {
      for (var i = 0, l = obj.length; i < l; i++) {
        if (i in obj && iterator.call(context, obj[i], i, obj) === {}) {
          return;
        }
      }
    } else {
      for (var key in obj) {
        if (obj.hasOwnProperty(key)) {
          if (iterator.call(context, obj[key], key, obj) === {}) {
            return;
          }
        }
      }
    }
  }

  function format_duration(start, end) {
    var duration = end - start, h, m, s;
    h = /[0-9]{4}$/.exec("000" + Math.floor(duration / 3600000));
    m = Math.floor((duration % 3600000) / 60000);
    s = Math.floor(((duration % 3600000) % 60000) / 1000);
    return [h, (m < 10 ? "0" + m : m), (s < 10 ? "0" + s : s)].join(":");
  }

  function LMSGetValue(model) {
    if (api) {
      var value;
      if (!(model in cache) || !cache[model]) {
        if (value = api.LMSGetValue(model) && +api.LMSGetLastError() === 0) {
          cache[model] = value;
        }
      }
      return cache[model];
    }
    return null;
  }

  function LMSSetValue(model, value, persist) {
    if (api) {
      value = (typeof value !== "string") ? JSON.stringify(value) : value;
      if (persist && (api.LMSSetValue(model, value) !== "true" || +api.LMSGetLastError() !== 0)) {
        return false;
      }
      cache[model] = value;
      return cache[model];
    }
    return false;
  }


  function LMSGetLastError() {
    return Number(api.LMSGetLastError()) || null;
  }

  function LMSGetErrorString(errorCode) {
    return api.LMSGetErrorString(String(errorCode)) || null;
  }

  function LMSGetDiagnostic(errorCode) {
    return api.LMSGetDiagnostic(String(errorCode)) || null;
  }

  function LMSCommit() {
    if (api && api.LMSCommit("") === "true" && +api.LMSGetLastError() === 0) {
      return true;
    }
    return false;
  }

  function LMSInitialize() {
    if (api && api.LMSInitialize("") === "true" && /0|101/.test(+api.LMSGetLastError())) {
      
      // Let's cache the data we care about from the LMS.
      each(models, function(model, index, list){
        var value;
        if (value = api.LMSGetValue(model) && +api.LMSGetLastError() === 0) {
          cache[model] = value;
        }
      });

      // Capture when we've started communication. We'll use this timestamp to determine
      // how long a learner has been in the course.
      session = +new Date;

      // As a convenience to the developer, we'll mark the learner incomplete when the first session starts.
      if (!/(pass|complet)ed?/.test(LMSGetValue("cmi.core.lesson_status"))) {
        LMSSetValue("cmi.core.lesson_status", "incomplete");
      }

      // In PeopleSoft ELM, `LMSCommit` triggers an alert, which can be pretty annoying.
      // This will remove that (and we'll fake it in LMSFinish).
      if (container.parent.frames.SCODataFrame && container.mode === "test") {
        container.parent.frames.SCODataFrame._displaySuccess = container.parent.frames.SCODataFrame.displaySuccess;
        container.parent.frames.SCODataFrame.displaySuccess = function () {};
      }

      var check = window.setInterval(function () {
        try {
          api.LMSSetValue("cmi.core.lesson_location", api.LMSGetValue("cmi.core.lesson_location"));
        } catch (e) {}
        if (!LMSCommit()) {
          window.clearInterval(check);
          if (window.onLMSConnectionError) {
            window.onLMSConnectionError();
          }
        }
      }, 300000);

      return true;
    }
    return false;
  }

  function LMSFinish() {  
    if (api) {
      // Let's track how long the user's session was.
      models["cmi.core.session_time"] = format_duration(session, +new Date);
  
      // When we exit, let's dump all our cached data into the LMS.
      each(models, function(value, index, list){
        if (cache[value] && !/cmi\.core\.student_(id|name)/.test(value)) {
          LMSSetValue(value, cache[value], true);
        }
      });
  
      if (LMSCommit() && (api.LMSFinish("") === "true")) {
        if (container.parent.frames.SCODataFrame) {
          if (container.mode === "test" && "_displaySuccess" in container.parent.frames.SCODataFrame) {
            container.parent.frames.SCODataFrame._displaySuccess.call(container);
          }
          // This throws an error once in a while. Let's hide it.
          container.parent.frames.SCODataFrame.cleanup = function () {};
          // Everybody goes crazy for this... This just refreshes the page, so that it
          // appears as if the status is updated in realtime.
          container.location.href = container.location.href;
        }
        return true;
      }
    }
    return false;
  }

  //
  window.getAPI = function () { return api; };
  window.LMSInitialize = LMSInitialize;
  window.LMSCommit = LMSCommit;
  window.LMSFinish = LMSFinish;
  window.LMSGetValue = LMSGetValue;
  window.LMSSetValue = LMSSetValue;
  window.LMSGetLastError = LMSGetLastError;
  window.LMSGetErrorString = LMSGetErrorString;
  window.LMSGetDiagnostic = LMSGetDiagnostic;

}).call(this);