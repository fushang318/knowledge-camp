@SimpleDocumentWareShowPage = React.createClass
  render: ->
    <div className='simple-document-ware-show-page'>
      <SimpleDocumentWareShowPage.Shower data={@props.data} />
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

      componentDidMount: ->
        jQuery(@refs.div_ware.getDOMNode()).css "height", jQuery(window).height()

      render: ->
        @percent = 0
        @ware = @props.data.ware

        <div className="simple-document-ware-show" ref="div_ware">
          {
            @props.data.ware.document_urls.map (url, index)->
              <img src={url} key={index} className="ui image" />
          }
        </div>
