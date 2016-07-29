@SimpleVideoWareShowPage = React.createClass
  render: ->
    <div className='simple-video-ware-show-page'>
      <SimpleVideoWareShowPage.Shower data={@props.data} />
    </div>

  statics:
    Shower: React.createClass
      read: (percent)->
        jQuery.ajax
          url: "/wares/#{@ware.id}/read"
          type: "POST"
          data:
            ware:
              percent: percent
        .done (res) =>
          console.log 'done'
          console.log res
        .fail (res) ->
          console.log res.responseJSON

      timeupdate: (mediaElement, domObject)->
        (e) =>
          # 大于前一次比值（百分比），则提交一次
          p = Math.floor(100 * mediaElement.currentTime / mediaElement.duration)
          @read(@percent = p) if p > @percent + 5

      ended: (mediaElement, domObject)->
        (e) =>
          # 结束，则设置为100%
          console.log 'ended'
          @read(100)

      render: ->
        @percent = 0
        @ware = @props.data.ware
        klass = new ClassName
          'ware-show-shower': true
          'contents-close': @props.contents_close
          #'comments-close': @props.comments_close

        <div className={klass}>
          <div className='shower-head'></div>
          <div className='shower-main'>
          {
            switch @ware.kind
              when 'video'
                <div className='video-box'>
                  {
                    if @props.data.in_business_categories
                      <Ware.Video data={@ware} timeupdate={@timeupdate} ended={@ended} />
                    else
                      <Ware.Video data={@ware} />
                  }
                </div>
          }
          </div>
          <div className='shower-foot'></div>
        </div>

