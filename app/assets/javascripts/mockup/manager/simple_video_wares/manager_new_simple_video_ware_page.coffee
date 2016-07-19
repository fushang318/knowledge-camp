@ManagerNewSimpleVideoWarePage = React.createClass
  render: ->
    <div className="manager-new-simple-video-ware-page">
      <ManagerNewSimpleVideoWarePage.Form data={@props.data} />
    </div>

  statics:
    Form: React.createClass
      getInitialState: ->
        errors: {}

      render: ->
        {
          TextInputField
          TextAreaField
          OneFileUploadField
          Submit
        } = DataForm

        layout =
          label_width: '100px'
          wrapper_width: '50%'

        file_upload_field_data =
          title: "上传视频"
          desc:
            <div>
              支持 MP4 格式
            </div>
          mime_types: [{title: 'MP4 files',    extensions: 'MP4' }]
          max_file_size: "1GB"

        <div className='ui segment'>
          <SimpleDataForm
            model='simple_video_wares'
            post={@props.data.create_simple_video_ware_url}
            done={@done}
          >
            <TextInputField {...layout} label='课件名：' name='name' required />
            <TextAreaField {...layout} label='课件简介：' name='desc' rows={10} />
            <OneFileUploadField {...layout}  label='视频：' name='file_entity_id' {...file_upload_field_data} />
            <Submit {...layout} text='确定保存' />
          </SimpleDataForm>
        </div>
      done: (res)->
        location.href = res.jump_url
