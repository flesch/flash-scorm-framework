!(function(){

    var _apiReference, _apiContainer, _sessionStartTime;

    function getAPI(searchWindow, bReturnWindow) {
        try {
            if (!_apiReference) {
                var apiContainer = searchWindow || window;
                if (!apiContainer.API) {
                    if (apiContainer !== apiContainer.top) {
                        return getAPI(apiContainer.top, bReturnWindow);
                    } else {
                        if (apiContainer.opener !== null && (typeof apiContainer.opener !== "undefined") && !apiContainer.opener.closed) {
                            return getAPI(apiContainer.opener, bReturnWindow);
                        }
                    }        
                }
                _apiReference = apiContainer.API;
                _apiContainer = apiContainer;
            }
            return bReturnWindow ? _apiContainer : _apiReference;
        } catch (e) {}
        return null;
    }

    function LMSInitialize() {
        try {
            var apiReference = getAPI();
            if (apiReference && (apiReference.LMSInitialize("") === "true") && /0|101/.test(apiReference.LMSGetLastError())) {
                _sessionStartTime = Number(new Date());
                if (!/(pass|complet)ed?/.test(LMSGetValue("cmi.core.lesson_status"))) {
                    LMSSetValue("cmi.core.lesson_status", "incomplete");
                }
                var apiContainerWindow = getAPI(window, true);
                if (apiContainerWindow && apiContainerWindow.parent.frames["SCODataFrame"] && apiContainerWindow.mode === "test") {
                    apiContainerWindow.parent.frames["SCODataFrame"].displaySuccess = function(){};
                }
                var checkLMSConnection = window.setInterval(function(){
                    LMSSetValue("cmi.core.lesson_location", LMSGetValue("cmi.core.lesson_location"));
                    if (!LMSCommit()) {
                        window.clearInterval(checkLMSConnection);
                        if (window.onLMSConnectionError) {
                            window.onLMSConnectionError();
                        }
                    }
                }, 300000);
                return true;
            }
        } catch(e) {}
        return false;
    }

    function LMSCommit() {
        try {
            var apiReference = getAPI();
            if (apiReference) {
                if (apiReference && apiReference.LMSCommit("") === "true" && Number(apiReference.LMSGetLastError()) === 0) {
                    return true;
                }
            }
        } catch(e) {}
        return false;
    }

    function LMSFinish() {
        try {
            var apiReference = getAPI();
            if (apiReference && LMSSetValue("cmi.core.session_time", toCMIDurationString(Number(new Date())-_sessionStartTime)) && LMSCommit() && (apiReference.LMSFinish("") === "true")) {
                var apiContainerWindow = getAPI(window, true);
                if (apiContainerWindow && apiContainerWindow.parent.frames["SCODataFrame"]) {        
                    if (apiContainerWindow.mode === "test") {
                        apiContainerWindow.alert("The Lesson was tested successfully.");
                    }
                    apiContainerWindow.parent.frames["SCODataFrame"].cleanup = function(){};
                    apiContainerWindow.location.href = apiContainerWindow.location.href;
                }
                return true;
            }
        } catch(e) {
            alert(e.description);
        }
        return false;
    }

    function LMSGetValue(dataModel) {
        try {
            var apiReference = getAPI();
            if (apiReference) {
                var dataValue = apiReference.LMSGetValue(dataModel);
                if (dataValue && Number(apiReference.LMSGetLastError()) === 0) {
                    return dataValue;
                }
            }
            return null;
        } catch(e) {
            return false;
        }
    }

    function LMSSetValue(dataModel, dataValue) {
        try {
            var apiReference = getAPI();
            if (apiReference && apiReference.LMSSetValue(dataModel, String(dataValue)) && (Number(apiReference.LMSGetLastError()) === 0)) {
                if (/cmi.core.session_time/.test(dataModel) || LMSGetValue(dataModel) === dataValue && (Number(apiReference.LMSGetLastError()) === 0)) {
                    return dataValue;    
                }
            }
            return null;
        } catch(e) {
            return false;
        }
    }

    function LMSGetLastError() {
        try {    
            var apiReference = getAPI();
            return Number(apiReference.LMSGetLastError()) || null;
        } catch(e) {
            return false;
        }    
    }

    function LMSGetErrorString(errorCode) {
        try {
            var apiReference = getAPI();
            return apiReference.LMSGetErrorString(String(errorCode)) || null;
        } catch(e) {
            return false;
        }    
    }

    function LMSGetDiagnostic(errorCode) {
        try {
            var apiReference = getAPI();
            return apiReference.LMSGetDiagnostic(String(errorCode)) || null;
        } catch(e) {
            return false;
        }
    }

    function toCMIDurationString(duration) {
        var h, m, s;
        h = /[0-9]{4}$/.exec("000" + Math.floor(duration / 3600000));
        m = Math.floor((duration % 3600000) / 60000);
        s = Math.floor(((duration % 3600000) % 60000) / 1000);
        return [h, (m < 10 ? "0" + m : m), (s < 10 ? "0" + s : s)].join(":");
    }
    
    window.getAPI = getAPI;
    window.LMSInitialize = LMSInitialize;
    window.LMSCommit = LMSCommit;   
    window.LMSFinish = LMSFinish;   
    window.LMSGetValue = LMSGetValue;   
    window.LMSSetValue = LMSSetValue;
    window.LMSGetLastError = LMSGetLastError;
    window.LMSGetErrorString = LMSGetErrorString;
    window.LMSGetDiagnostic = LMSGetDiagnostic;

}).call(this);
