(function(data){
    
  (function(fn){ var s = arguments.callee; setTimeout((/in/.test(document.readyState) ? function(){ s(fn) } : fn), 9); })(function(){

    var canvas, context, token, size, repeat, r, i, domain, cdn, application, width, height;
        
    domain = (/[A-z]+.[A-z]{2,6}$/.exec(window.location.hostname)||['vzwcorp.com']).pop();
    cdn = +data ? (+data).toString(36) : Math.floor(Math.random()*9) + 1;
    
    application = document.getElementById('application');
    width = (+application.getAttribute('width'))+10;
    height = (+application.getAttribute('height'))+10;
    
    canvas = document.createElement('canvas');
    canvas.setAttribute('width', width);
    canvas.setAttribute('height', height);
    document.getElementsByTagName('body')[0].insertBefore(canvas, document.getElementsByTagName('body')[0].firstChild);
  
    if (canvas && 'G_vmlCanvasManager' in window) {
      canvas = G_vmlCanvasManager.initElement(canvas);
    }
    
    if (canvas && canvas.getContext) {
  
      context = canvas.getContext('2d');
      token = parseInt(data || 'null', 36).toString(2).split('');
      size = ((token.length+1)*6);
      repeat = Math.ceil(Math.max(width, height)/size);

      for (r=0; r<repeat; r++) {        
        for (i=0; i<token.length; i++) {    
          context.fillStyle = (+token[i]) ? 'rgb(55,57,58)' : 'rgb(147,153,156)';
          context.fillRect((r*size)+(i*6), 0, 4, 4);
          context.fillRect(width-4, (r*size)+6+(i*6), 4, 4);
          context.fillRect((r*size)+(i*6), height-4, 4, 4);
          context.fillRect(0, (r*size)+6+(i*6), 4, 4);
        }
        context.fillStyle = 'rgb(155,12,12)';
        context.fillRect((r*size)+(i*6), 0, 4, 4);
        context.fillRect(width-4, (r*size)+6+(i*6), 4, 4);
        context.fillRect((r*size)+(i*6), height-4, 4, 4);
        context.fillRect(0, (r*size)+6+(i*6), 4, 4);
      }
      
    }

    document.title = document.title + ' (cdn-'+cdn+'.'+domain+')';  

  });
    
})('getAPI' in window && +LMSGetValue('cmi.core.student_id'));