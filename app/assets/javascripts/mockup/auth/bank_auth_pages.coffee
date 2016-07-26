@AuthBankSignInPage = React.createClass
  render: ->
    manager_button_style =
      position: 'absolute'
      top: '1rem'
      left: '1rem'

    manager_sign_in_url = @props.data.manager_sign_in_url

    manager_button =
      <a className='ui basic button' style={manager_button_style} href={manager_sign_in_url}>后台登录</a>

    <div className='auth-bank-sign-in-page'>
      {manager_button}

      <div className='ui container'>
        <div className='ui grid'>
          <div className='row'>
            <div className='six wide column' />
            <div className='eight wide column product-logo'>
              <div className='logo-img' />
            </div>
          </div>

          <div className='six wide column'>
            <div className='customer-logo' />
          </div>
          <div className='eight wide column'>
            <div className='ui segment'>
              <div className='head'>
                <i className='icon sign in' />
                <span className='sign-in link'>用户登录</span>
                <a className="sign-up ui basic button" href={@props.data.sign_up_url}>
                  注册
                </a>
              </div>
              <SignInForm submit_url={@props.data.submit_url} />
            </div>
          </div>
        </div>
      </div>
    </div>


@AuthBankSignUpPage = React.createClass
  render: ->
    sign_up_form_data =
      valid_activate_code_url: @props.data.valid_activate_code_url
      get_activate_code_url:   @props.data.get_activate_code_url
      check_phone_number_url:  @props.data.check_phone_number_url
      submit_url:              @props.data.submit_url
      posts:                   @props.data.posts

    <div className='auth-bank-sign-up-page'>

      <div className='ui container'>
        <div className='ui grid'>
          <div className='row'>
            <div className='six wide column' />
            <div className='eight wide column product-logo'>
              <div className='logo-img' />
            </div>
          </div>

          <div className='six wide column'>
            <div className='customer-logo' />
          </div>
          <div className='eight wide column'>
            <div className='ui segment'>
              <div className='head'>
                <i className='icon sign up' />
                <span className='sign-up link'>用户注册</span>
                <a className="sign-in ui basic button" href={@props.data.sign_in_url}>
                  登录
                </a>
              </div>
              <AuthBankSignUpPage.SignUpForm data={sign_up_form_data} />
            </div>
          </div>
        </div>
      </div>
    </div>

  statics:
    SignUpForm: React.createClass
      getInitialState: ->
        step: 1
        phone_number: ""

      render: ->
        if @state.step == 1
          data =
            get_activate_code_url:   @props.data.get_activate_code_url
            valid_activate_code_url: @props.data.valid_activate_code_url
            check_phone_number_url:  @props.data.check_phone_number_url
            to_step_2:               @to_step_2

          <AuthBankSignUpPage.SignUpForm.Step1Form data={data} />
        else if @state.step == 2
          data =
            submit_url: @props.data.submit_url
            phone_number: @state.phone_number
            posts: @props.data.posts
          <AuthBankSignUpPage.SignUpForm.Step2Form data={data} />

      to_step_2: (phone_number)->
        @setState
          step: 2
          phone_number: phone_number

      statics:
        Step1Form: React.createClass
          getInitialState: ->
            phone_number: ""
            activate_code: ""
            activate_code_count_down: 0
            activate_code_error: false
            phone_number_is_used: false

          render: ->
            next_button_disable = if @input_is_valid() then "" else "disabled"

            <div className='sign-up-form step1 ui form' ref='form'>
              <div className='field phone'>
                <div className='ui left icon input'>
                  <i className='icon phone' />
                  <input type='text' placeholder='手机号' value={@state.phone_number} onChange={@phone_number_change()} />
                </div>
              </div>

              <div className="inline fields">
                <div className="field get-activate-code">
                {
                  if @state.activate_code_count_down == 0
                    activate_code_button_disable = if @phone_number_is_valid() then "" else "disabled"
                    <button className="ui button #{activate_code_button_disable}" disable={true} onClick={@get_activate_code}>获取短信激活码</button>
                  else
                    <button className="ui button disabled">{@state.activate_code_count_down}秒后重新获取</button>
                }
                </div>
                <div className="field input-activate-code">
                  <input type='text' placeholder='填写获取到的短信激活码' value={@state.activate_code} onChange={@on_change('activate_code')} onKeyPress={@enter_submit} />
                </div>
              </div>

              <div className="field">
                <button className="ui green button #{next_button_disable}" onClick={@do_submit}>下一步</button>
                {
                  if @state.phone_number_is_used
                    <div className="error">
                      手机号已被使用
                    </div>
                  else if @state.activate_code_error
                    <div className="error">
                      激活码错误
                    </div>
                }
              </div>

            </div>

          phone_number_is_valid: ->
            /^[0-9]{11}$/.test(@state.phone_number) && !@state.phone_number_is_used

          input_is_valid: ->
            @phone_number_is_valid() && @state.activate_code.length != 0

          get_activate_code: ->
            @activate_code_count_down_loop()
            jQuery.ajax
              url: @props.data.get_activate_code_url
              type: "POST"
              data:
                message:
                  phone_num: @state.phone_number
              dataType: "json"

          activate_code_count_down_loop: ->
            activate_code_count_down = 60
            @setState activate_code_count_down: activate_code_count_down

            loop_fun = =>
              activate_code_count_down = @state.activate_code_count_down-1
              @setState activate_code_count_down: activate_code_count_down
              if activate_code_count_down > 0
                setTimeout loop_fun, 1000

            setTimeout loop_fun, 1000

          activate_code_error: ->
            @setState
              activate_code_error: true

          phone_number_change: ()->
            (evt)=>
              phone_number = evt.target.value
              @setState phone_number: phone_number
              if /^[0-9]{11}$/.test phone_number
                jQuery.ajax
                  url: @props.data.check_phone_number_url
                  type: "GET"
                  data:
                    phone_number: phone_number
                  dataType: "json"
                  statusCode:
                    422: (res)=>
                      @setState
                        phone_number_is_used: true
                  success: (res)=>
                      @setState
                        phone_number_is_used: false

          on_change: (input_name)->
            (evt)=>
              @setState "#{input_name}": evt.target.value

          enter_submit: (evt)->
            if evt.which is 13
              @do_submit()

          do_submit: ->
            jQuery.ajax
              url: @props.data.valid_activate_code_url
              type: "POST"
              data:
                phone_num: @state.phone_number
                valid_code: @state.activate_code
              dataType: "json"
              success: (res)=>
                if res.validation_result == "correct"
                  @props.data.to_step_2(@state.phone_number)
                else
                  @activate_code_error()

        Step2Form: React.createClass
          componentDidMount: ->
            $select_post = jQuery React.findDOMNode @refs.select_post
            $select_post.dropdown()
          getInitialState: ->
            email: ""
            name: ""
            password: ""
            post_id: ""
            error: ""

          render: ->
            sign_up_button_disable = if @input_is_valid() then "" else "disabled"

            <div className='sign-up-form step2 ui form' ref='form'>
              <div className="field">
                <select className="ui dropdown" name="post" ref="select_post" value={@state.post_id} onChange={@on_change('post_id')}>
                  <option value="" key="">选择岗位</option>
                  {
                    for post in @props.data.posts
                      <option value={post.id} key={post.id}>{post.name}</option>
                  }
                </select>
              </div>
              <div className='field'>
                <div className='ui left icon input'>
                  <i className='icon mail' />
                  <input type='text' placeholder='邮箱' value={@state.email} onChange={@on_change('email')} />
                </div>
              </div>
              <div className='field'>
                <div className='ui left icon input'>
                  <i className='icon user' />
                  <input type='text' placeholder='姓名' value={@state.name} onChange={@on_change('name')} />
                </div>
              </div>
              <div className='field'>
                <div className='ui left icon input'>
                  <i className='icon asterisk' />
                  <input type='password' placeholder='密码' value={@state.password} onChange={@on_change('password')} />
                </div>
              </div>
              {
                if @state.error.length != 0
                  <div className="ui yellow message small">
                    <i className="icon info circle"></i>
                    {@state.error}
                  </div>
              }
              <button className="ui green button #{sign_up_button_disable}" onClick={@do_submit}>确定注册</button>
            </div>

          input_is_valid: ->
            @state.email.length != 0 &&
            @state.name.length != 0 &&
            @state.password.length != 0 &&
            @state.post_id.length != 0

          on_change: (input_name)->
            (evt)=>
              @setState "#{input_name}": evt.target.value

          do_submit: ->
            jQuery.ajax
              url: @props.data.submit_url
              type: "POST"
              data:
                user:
                  phone_number: @props.data.phone_number
                  email: @state.email
                  name: @state.name
                  password: @state.password
                  post_id: @state.post_id
              dataType: "json"
              success: (res)=>
                location.reload()
              statusCode:
                422: (res)=>
                  errors = []
                  for key, value of res.responseJSON.errors
                    for i in value
                      errors.push i
                  @setState error: errors[0]
