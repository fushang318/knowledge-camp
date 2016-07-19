@DataForm.OneFileUploadField = React.createClass
  render: ->
    file_upload_data =
      title: @props.title
      desc:  @props.desc
      mime_types: @props.mime_types
      max_file_size: @props.max_file_size

    <DataForm.Form.Field {...@props}>
      <OneFileUpload done={@props._set_value} file_entity_id={@props._value} {...file_upload_data}/>
    </DataForm.Form.Field>

# 用法：
# <OneFileUpload done={callback} value={value} />
# callback 回调方法，会被传入 file_entity.id
# value 预设值，用于“编辑修改”场景

OneFileUpload = React.createClass
  getInitialState: ->
    status: UploadStatus.READY
    percent: 0
    file_entity_id: @props.file_entity_id

  render: ->
    width = 640
    height = 360

    h = 180
    w = width * h / height

    browse_style =
      width: "#{w}px"
      height: "#{h}px"

    <div className='file-upload'>
      <div className='browse' style={browse_style}>
        <OneFileUpload.Progress {...@state} />
        {
          title = @props.title || '上传文件'
          desc = @props.desc || ""

          <UploadWidget.BrowseButton ref='browse_btn' status={@state.status}>
            <div className='btn-text'>
              <div className='header'>＋ {title}</div>
              <div className='desc'>{desc}</div>
            </div>
          </UploadWidget.BrowseButton>
        }
      </div>
      <input type='hidden' value={@state.file_entity_id} readOnly />
    </div>

  statics:
    Progress: React.createClass
      render: ->
        if @props.status != UploadStatus.READY
          bar_style =
            width: "#{100 - @props.percent}%"

          <div className='percent'>
            {
              if @props.status is UploadStatus.UPLOADING
                <div className='bar' style={bar_style} />
            }
            {
              switch @props.status
                when UploadStatus.UPLOADING
                  <div className='p'>{@props.percent}%</div>
                when UploadStatus.REMOTE_DONE
                  <div className='p'>
                    <div className='ui active inverted loader' />
                  </div>
                when UploadStatus.LOCAL_DONE
                  <div className='p'><i className='icon check circle' /></div>
            }
          </div>
        else
          <div />

  componentDidMount: ->
    $browse_button = jQuery React.findDOMNode @refs.browse_btn
    new QiniuFilePartUploader
      debug:                true
      browse_button:        $browse_button
      dragdrop_area:        null
      file_progress_class:  UploadUtils.GenerateOneFileUploadProgress(@)
      max_file_size:        @props.max_file_size || '5MB'
      mime_types :          @props.mime_types || undefined

  on_upload_event: (evt, params...)->
    switch evt
      when 'start'
        qiniu_file = params[0]
        @set_preview_data_url qiniu_file

      when 'remote_done'
        qiniu_response_info = params[0]
        @set_preview_true_url qiniu_response_info

      when 'local_done'
        response_info = params[0]
        file_entity_id = response_info.file_entity_id
        @props.done? file_entity_id


  set_preview_data_url: (qiniu_file)->
    UploadUtils.load_image_data_url(
      qiniu_file.getNative(),
      (data_url)=>
        @setState preview_url: data_url
    )

  set_preview_true_url: (qiniu_response_info)->
    UploadUtils.load_qiniu_image_url(
      qiniu_response_info,
      (loaded_url)=>
        @setState preview_url: loaded_url
    )
