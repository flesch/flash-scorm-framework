!function(){function d(c,e){try{if(!a){var f=c||window;if(!f.API){if(f!==f.top)return d(f.top,e);if(f.opener!==null&&typeof f.opener!="undefined"&&!f.opener.closed)return d(f.opener,e)}a=f.API,b=f}return e?b:a}catch(g){}return null}function e(){try{var a=d();if(a&&a.LMSInitialize("")==="true"&&/0|101/.test(a.LMSGetLastError())){c=Number(new Date),/(pass|complet)ed?/.test(h("cmi.core.lesson_status"))||i("cmi.core.lesson_status","incomplete");var b=d(window,!0);b&&b.parent.frames.SCODataFrame&&b.mode==="test"&&(b.parent.frames.SCODataFrame.displaySuccess=function(){});var e=window.setInterval(function(){i("cmi.core.lesson_location",h("cmi.core.lesson_location")),f()||(window.clearInterval(e),window.onLMSConnectionError&&window.onLMSConnectionError())},3e5);return!0}}catch(g){}return!1}function f(){try{var a=d();if(a&&a&&a.LMSCommit("")==="true"&&Number(a.LMSGetLastError())===0)return!0}catch(b){}return!1}function g(){try{var a=d();if(a&&i("cmi.core.session_time",m(Number(new Date)-c))&&f()&&a.LMSFinish("")==="true"){var b=d(window,!0);return b&&b.parent.frames.SCODataFrame&&(b.mode==="test"&&b.alert("The Lesson was tested successfully."),b.parent.frames.SCODataFrame.cleanup=function(){},b.location.href=b.location.href),!0}}catch(e){alert(e.description)}return!1}function h(a){try{var b=d();if(b){var c=b.LMSGetValue(a);if(c&&Number(b.LMSGetLastError())===0)return c}return null}catch(e){return!1}}function i(a,b){try{var c=d();if(c&&c.LMSSetValue(a,String(b))&&Number(c.LMSGetLastError())===0)if(/cmi.core.session_time/.test(a)||h(a)===b&&Number(c.LMSGetLastError())===0)return b;return null}catch(e){return!1}}function j(){try{var a=d();return Number(a.LMSGetLastError())||null}catch(b){return!1}}function k(a){try{var b=d();return b.LMSGetErrorString(String(a))||null}catch(c){return!1}}function l(a){try{var b=d();return b.LMSGetDiagnostic(String(a))||null}catch(c){return!1}}function m(a){var b,c,d,e;return b=/[0-9]{4}$/.exec("000"+Math.floor(a/36e5)),e=a%36e5,c=/[0-9]{2}$/.exec("0"+Math.floor(e/6e4)),e=e%6e4,d=/[0-9]{2}$/.exec("0"+Math.floor(e/1e3)),e=e%1e3,[b>9999?9999:b,c,d].join(":")+".00"}var a,b,c;window.getAPI=d,window.LMSInitialize=e,window.LMSCommit=f,window.LMSFinish=g,window.LMSGetValue=h,window.LMSSetValue=i,window.LMSGetLastError=j,window.LMSGetErrorString=k,window.LMSGetDiagnostic=l}.call(this)