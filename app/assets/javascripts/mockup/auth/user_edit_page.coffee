@UserEditPage = React.createClass
  render: ->
    <div className="user-edit-page">
      <div className="ui container">
        <UserEditPage.Form data={@props.data} />
      </div>
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
            <PasswordInputField {...layout} label='旧密码：' name='current_password' />
            <PasswordInputField {...layout} label='新密码：' name='password' />
            <Submit {...layout} text='确定保存' />
          </SimpleDataForm>
        </div>
      done: (res)->
        location.href = res.jump_url

@AdminOrSupervisorEditPage = React.createClass
  render: ->
    <div className="admin-or-supervisor-edit-page">
      <div className="ui segment">
        <AdminOrSupervisorEditPage.Form data={@props.data} />
      </div>
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

        <SimpleDataForm
          model='users'
          data={@props.data.user}
          put={@props.data.update_url}
          done={@done}
        >
          <PasswordInputField {...layout} label='旧密码：' name='current_password' required/>
          <PasswordInputField {...layout} label='新密码：' name='password' required/>
          <Submit {...layout} text='确定保存' />
        </SimpleDataForm>
      done: (res)->
        location.href = res.jump_url
