define(function(require,exports,module){var $,Util;$=require("jquery");Util={appUrl:function(){if(location.href.indexOf("test.wx.tommycar.cn")<0&&location.href.indexOf("h5.d.tommycar.cn")<0){Util.URL="http://wx.tommycar.cn/weixin-server/";return Util.appid="wx7d010978b072a9cc"}else{Util.URL="http://test.wx.tommycar.cn/weixin-server/";return Util.appid="wx8e414c0c25daf02e"}},isWeixin:function(){return/MicroMessenger/i.test(navigator.userAgent)},urlGet:function(){var argname,args,i,j,len,pair,pairs,pos,query,value;args={};query=location.search.substring(1);pairs=query.split("&");for(i=j=0,len=pairs.length;j<len;i=++j){pair=pairs[i];pos=pairs[i].indexOf("=");if(pos===-1){continue}argname=pairs[i].substring(0,pos);value=pairs[i].substring(pos+1);value=decodeURIComponent(value);args[argname]=value}return args},changeTitle:function(title){var $iframe;document.title=title;return $iframe=$('<iframe style="display:none;" src="/favicon.ico"></iframe>').on("load",function(){return setTimeout(function(){return $iframe.off("load").remove()},0).appendTo($("body"))})},setLocal:function(key,value){if(window.sessionStorage){return sessionStorage[key]=value}else{return null}},getLocal:function(key){if(window.sessionStorage){return sessionStorage[key]}else{return null}},request:function(model){return $.ajax({url:""+Util.URL+model.method,type:model.type||"get",data:model.params,crossDomain:true,beforeSend:model.beforeSend||$.noop,dataType:model.dataType||"json",timeout:model.timeout||5e3,error:function(x,h,r){},success:model.success||function(res){}})},tip:function(text,fn,top){var html;if($(".ui-dialog").length){$(".ui-dialog").remove()}html='<div class="ui-dialog">'+text+"</div>";$(html).appendTo("body").css("top",top);return setTimeout(function(){$(".ui-dialog").remove();if(typeof fn==="function"){return fn()}},1800)},getOpenId:function(callback){var baseUrl,urlSearch;urlSearch=Util.urlGet();baseUrl="https://open.weixin.qq.com/connect/oauth2/authorize?appid="+Util.appid+"&redirect_uri="+encodeURIComponent("http://"+location.hostname+location.pathname)+"&response_type=code&scope=snsapi_base&state=null#wechat_redirect";if(!urlSearch.code){location.href=baseUrl;return false}return Util.request({method:"tmap/getOpenId.htm",params:{code:urlSearch.code}}).done(function(json){if(json.code===1){Util.setLocal("openId",json.data.openId);return callback(json.data.openId)}else{return Util.tip(json.msg)}})},beforeSend:function(){var loading;loading='<div class="loading" id="loading">\n  <div class="spinner">\n    <div class="spinner-container container1">\n      <div class="circle1"></div>\n      <div class="circle2"></div>\n      <div class="circle3"></div>\n      <div class="circle4"></div>\n    </div>\n    <div class="spinner-container container2">\n      <div class="circle1"></div>\n      <div class="circle2"></div>\n      <div class="circle3"></div>\n      <div class="circle4"></div>\n    </div>\n    <div class="spinner-container container3">\n      <div class="circle1"></div>\n      <div class="circle2"></div>\n      <div class="circle3"></div>\n      <div class="circle4"></div>\n    </div>\n  </div>\n</div>';return $("body").append(loading)}};return module.exports=Util});