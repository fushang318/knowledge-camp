@ManagerEditSimpleDocumentWarePage = React.createClass
  render: ->
    <div className="manager-edit-simple-document-ware-page">
      <ManagerEditSimpleDocumentWarePage.Form data={@props.data} />
    </div>

  statics:
    Form: React.createClass
      getInitialState: ->
        errors: {}

      render: ->
        {
          TextInputField
          TextAreaField
          Submit
        } = DataForm

        layout =
          label_width: '100px'
          wrapper_width: '50%'

        <div className='ui segment'>
          <SimpleDataForm
            data={@props.data.simple_document_ware}
            model='simple_document_wares'
            put={@props.data.update_base_info_url}
            done={@done}
          >
            <TextInputField {...layout} label='课件名：' name='name' required />
            <TextAreaField {...layout} label='课件简介：' name='desc' rows={10} />
            <Submit {...layout} text='确定保存' />
          </SimpleDataForm>
        </div>

      done: (res)->
        location.href = res.jump_url
