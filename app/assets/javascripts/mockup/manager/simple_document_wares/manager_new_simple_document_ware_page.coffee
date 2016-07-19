@ManagerNewSimpleDocumentWarePage = React.createClass
  render: ->
    <div className="manager-new-simple-document-ware-page">
      <ManagerNewSimpleDocumentWarePage.Form data={@props.data} />
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
          title: "上传文档"
          desc:
            <div>
              支持 PDF/PPT/PPTX/DOC/DOCX 格式
            </div>
          mime_types: [
            {title: 'PDF files',    extensions: 'pdf' }
            {title: 'PPT files', extensions: 'ppt,pptx' }
            {title: 'DOC files', extensions: 'doc,docx' }
          ]
          max_file_size: "50MB"

        <div className='ui segment'>
          <SimpleDataForm
            model='simple_document_wares'
            post={@props.data.create_simple_document_ware_url}
            done={@done}
          >
            <TextInputField {...layout} label='文档课件名：' name='name' required />
            <TextAreaField {...layout} label='文档课件简介：' name='desc' rows={10} />
            <OneFileUploadField {...layout}  label='文档：' name='file_entity_id' title="123" {...file_upload_field_data}/>
            <Submit {...layout} text='确定保存' />
          </SimpleDataForm>
        </div>
      done: (res)->
        location.href = res.jump_url
