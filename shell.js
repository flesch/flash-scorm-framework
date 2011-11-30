window.onbeforeunload = function(){
    if (!/passed|completed/.test(LMSGetValue('cmi.core.lesson_status')) && LMSCommit()) {
        return 'You have not yet completed the course!\nClick CANCEL to remain here and finish\nthe course or OK to exit and return to VZLearn.';
    }
    return;
};
window.onunload = LMSFinish;

function mail(address) {
    var iframe = document.createElement('iframe');
    iframe.setAttribute('src', 'mailto:'+address);
    document.getElementsByTagName('head')[0].appendChild(iframe).parentNode.removeChild(iframe);
}

function getQueryValue(p) {
    var qs = window.location.search, s = qs.indexOf(p+'=')+1;
    return s ? unescape(qs.substring(s+p.length, (qs.indexOf('&', s)+1 || qs.length+1)-1)) : null;
}

function launchExternalWindow(href, width, height, scrollbars, resizable) {
    try {
        var externalWindow = window.open(href, 'xExternalWindow'+(+new Date), 'width='+width+',height='+height+',left='+Math.round((screen.availWidth/2)-(width/2))+',top='+Math.round((screen.availHeight/2)-(height/2))+',scrollbars='+Number(!!scrollbars||screen.availWidth<=width)+',resizable='+Number(!!resizable||screen.availWidth<=width)+',menubar=0,toolbar=0,personalbar=0,location=0,directories=0,status=0,dependent=0');
        return (typeof externalWindow !== 'undefined' && !!externalWindow);
    } catch(e) {
        return false;
    }
}

function quit() {
    if (window.top.open('','_self') && (window.top.opener = window)) {
        window.top.close();
    }
}

function unlock() {
    var application = document.getElementById('application');
    if (application && 'unlock' in application) {
        application.unlock();
    }
}

function onLMSConnectionError() {
    var application = document.getElementById('application');
    if (application && 'onLMSConnectionError' in application) {
        application.onLMSConnectionError();
    }    
}

function lofi() {
    return /5.2/.test((/Windows NT 5.[0-9];/.exec(window.navigator.userAgent)||[]).pop());
}

(function(){
    if ('CanvasRenderingContext2D' in window) {
        var s = document.createElement('script'); s.src = 'assets/js/echelon-min.js';
        s.onload = s.onreadystatechange = function(){
            document.getElementsByTagName('html')[0].className = 'echelon';
        };
        document.getElementsByTagName('body')[0].appendChild(s); 
    }
})();