define (require, exports, module) ->
  $ = require('jquery')
  Util =
    appUrl: ->
      if location.href.indexOf("test.wx.tommycar.cn") < 0 && location.href.indexOf("h5.d.tommycar.cn") < 0
        #线上
        Util.URL = "http://wx.tommycar.cn/weixin-server/"
        Util.appid = "wx7d010978b072a9cc"
      else
        Util.URL = "http://test.wx.tommycar.cn/weixin-server/"
        Util.appid = "wx8e414c0c25daf02e"
    isWeixin: ->
      return (/MicroMessenger/i).test(navigator.userAgent)
    urlGet: ->
      args = {}
      query = location.search.substring(1)
      pairs = query.split("&")
      for pair, i in pairs
        pos = pairs[i].indexOf('=')
        if pos == -1 then continue
        argname = pairs[i].substring(0, pos)
        value = pairs[i].substring(pos + 1)
        value = decodeURIComponent(value)
        args[argname] = value
      return args
    changeTitle: (title) ->
      document.title = title
      $iframe = $("""<iframe style="display:none;" src="/favicon.ico"></iframe>""")
        .on("load", ->
          setTimeout(
            ->
              $iframe.off('load').remove()
            ,0
          ).appendTo($('body'))
        )
    setLocal: (key, value) ->
      if window.sessionStorage
        sessionStorage[key] = value
      else
         return null
    getLocal: (key) ->
      if window.sessionStorage
        return sessionStorage[key]
      else
        return null
    request: (model) ->
      $.ajax
        url: """#{Util.URL}#{model.method}"""
        type: model.type || "get"
        data: model.params
        crossDomain: true
        beforeSend: model.beforeSend || $.noop
        dataType: model.dataType || "json"
        timeout: model.timeout || 5000
        error: (x, h, r) ->
        success: model.success || (res) ->
    tip: (text, fn, top) ->
      if $(".ui-dialog").length then $(".ui-dialog").remove()
      html = """<div class="ui-dialog">#{text}</div>"""
      $(html).appendTo('body').css("top", top)
      setTimeout(
        ->
          $(".ui-dialog").remove();
          if typeof fn is 'function' then fn()
        ,1800
      )
    getOpenId: (callback) ->
      urlSearch = Util.urlGet()  #地址栏参数
      baseUrl = """https://open.weixin.qq.com/connect/oauth2/authorize?appid=#{Util.appid}&redirect_uri=#{encodeURIComponent("""http://#{location.hostname}#{location.pathname}""")}&response_type=code&scope=snsapi_base&state=null#wechat_redirect"""
      if !urlSearch.code
        location.href = baseUrl
        return false
      Util.request
        method: "tmap/getOpenId.htm"
        params:{"code": urlSearch.code}
      .done((json) ->
        if json.code is 1
          Util.setLocal("openId", json.data.openId) #缓存openId
          callback(json.data.openId)
        else
          Util.tip(json.msg)
      )
    ###请求等待回调###
    beforeSend : ->
      loading = """
        <div class="loading" id="loading">
          <div class="spinner">
            <div class="spinner-container container1">
              <div class="circle1"></div>
              <div class="circle2"></div>
              <div class="circle3"></div>
              <div class="circle4"></div>
            </div>
            <div class="spinner-container container2">
              <div class="circle1"></div>
              <div class="circle2"></div>
              <div class="circle3"></div>
              <div class="circle4"></div>
            </div>
            <div class="spinner-container container3">
              <div class="circle1"></div>
              <div class="circle2"></div>
              <div class="circle3"></div>
              <div class="circle4"></div>
            </div>
          </div>
        </div>
      """
      $('body').append(loading);
  module.exports = Util
