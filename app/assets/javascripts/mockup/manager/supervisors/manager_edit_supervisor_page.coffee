@ManagerEditSupervisorPage = React.createClass
  render: ->
    <div className="manager-edit-supervisor-page">
      <ManagerEditSupervisorPage.Form data={@props.data} />
    </div>

  statics:
    Form: React.createClass
      getInitialState: ->
        errors: {}

      render: ->
        {
          TextInputField
          PasswordInputField
          Submit
        } = DataForm

        layout =
          label_width: '100px'
          wrapper_width: '50%'

        <div className='ui segment'>
          <SimpleDataForm
            model='users'
            data={@props.data.user}
            put={@props.data.update_url}
            done={@done}
          >
            <TextInputField {...layout} label='姓名：' name='name' required />
            <TextInputField {...layout} label='邮箱：' name='email' required />
            <PasswordInputField {...layout} label='密码：' name='password' />
            <Submit {...layout} text='确定保存' />
          </SimpleDataForm>
        </div>
      done: (res)->
        location.href = res.jump_url
