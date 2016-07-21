@SimpleVideoWareShowPage = React.createClass
  render: ->
    <div className='simple-video-ware-show-page'>
      <SimpleVideoWareShowPage.Shower data={@props.data} />
    </div>

  statics:
    Shower: React.createClass
      render: ->
        ware = @props.data.ware
        klass = new ClassName
          'ware-show-shower': true
          'contents-close': @props.contents_close
          #'comments-close': @props.comments_close

        <div className={klass}>
          <div className='shower-head'></div>
          <div className='shower-main'>
          {
            switch ware.kind
              when 'video'
                <div className='video-box'>
                  <Ware.Video data={ware} />
                </div>
          }
          </div>
          <div className='shower-foot'></div>
        </div>

