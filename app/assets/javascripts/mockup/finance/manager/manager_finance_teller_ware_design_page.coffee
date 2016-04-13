@ManagerFinanceTellerWareDesignPage = React.createClass
  getInitialState: ->
    actions: @props.data.ware.actions || {}

  render: ->
    {
      Sidebar, Previewer
    } = ManagerFinanceTellerWareDesignPage

    <div className='manager-finance-teller-ware-designer-page'>
      <Sidebar actions={@state.actions} ware={@props.data.ware} />
      <Previewer actions={@state.actions} />
    </div>

  componentDidMount: ->
    Actions.set_store new DataStore @

  statics:
    Sidebar: React.createClass
      render: ->
        actions_array = (action for id, action of @props.actions)

        table_data = {
          fields:
            name_label: '名称'
            ops: '操作'

          data_set: actions_array.map (x)=>
            jQuery.extend {
              name_label:
                <div>
                  {x.role}: {x.name}
                </div>
              ops:
                <div className='ops'>
                  <a href='javascript:;' className='ui button basic mini blue' onClick={@edit(x)}>
                    <i className='icon pencil' />
                  </a>
                  <a href='javascript:;' className='ui button basic mini blue'>
                    <i className='icon desktop' />
                  </a>
                  <a href='javascript:;' className='ui button basic mini red' onClick={@remove(x)}>
                    <i className='icon delete' />
                  </a>
                </div>
            }, x

          th_classes:
            {}
          td_classes:
            ops: 'collapsing'
        }

        <div className='sidebar'>
          <div className='bar-header'>
            <a href='javascript:;' className='ui button mini green' onClick={@show_add_modal}>
              <i className='icon plus' />
            </a>
            <div className='name'>{@props.ware.name}</div>
            <div className='number'>{@props.ware.number}</div>
          </div>
          <div className='table-scroller'>
            {
              if actions_array.length > 0
                <ManagerTable data={table_data} title='流程节点' />
              else
                <div style={padding: '0.5rem'}>没有数据</div>
            }

          </div>
        </div>

      edit: (x)->
        =>
          jQuery.open_modal(
            <ManagerFinanceTellerWareDesignPage.UpdateModal action={x} actions={@props.actions}/>
          )

      remove: (x)->
        ->
          jQuery.modal_confirm
            text: '确定要删除吗？<br/>关联关系将被自动解除。'
            yes: ->
              Actions.remove(x)

      show_add_modal: ->
        jQuery.open_modal(
          <ManagerFinanceTellerWareDesignPage.AddModal />
        )


    Previewer: React.createClass
      render: ->
        actioninfo =
          actions: @props.actions
          action_desc: []
          screens: []
          screens_desc: []

        <div className='previewer'>
          <TellerCourseWare.Panel data={actioninfo} />
        </div>


    AddModal: React.createClass
      render: ->
        {
          TextInputField
          SelectField
          Submit
        } = DataForm

        layout =
          label_width: '100px'

        roles = 
          '柜员': '柜员'
          '客户': '客户'

        <div>
          <h3 className='ui header'>新增操作节点</h3>
          <DataForm.Form onSubmit={@submit} ref='form'>
            <TextInputField {...layout} label='操作名称：' name='name' required />
            <SelectField {...layout} label='操作角色：' name='role' values={roles}/>
            <Submit {...layout} text='确定保存' />
          </DataForm.Form>
        </div>

      submit: (data)->
        @refs.form.set_submiting true
        Actions.add data, =>
          @state.close()

    UpdateModal: React.createClass
      render: ->
        {
          TextInputField
          SelectField
          MultipleSelectField
          Submit
        } = DataForm

        layout =
          label_width: '100px'

        roles = 
          '柜员': '柜员'
          '客户': '客户'

        all_pres_action_ids = Object.keys @get_all_pres_actions @props.action
        optional_actions = Immutable.fromJS []
        for a_id, _action of @props.actions
          if all_pres_action_ids.indexOf(_action.id) < 0
            optional_actions = optional_actions.push Immutable.fromJS(_action)

        grid_values = {}
        for x in optional_actions.toJS()
          grid_values[x.id] = x.name

        <div>
          <h3 className='ui header'>修改操作节点</h3>
          <DataForm.Form onSubmit={@submit} ref='form' data={@props.action}>
            <TextInputField {...layout} label='操作名称：' name='name' required />
            <SelectField {...layout} label='操作角色：' name='role' values={roles} />
            <MultipleSelectField {...layout} label='后续操作' name='post_action_ids' values={grid_values} />
            <Submit {...layout} text='确定保存' />
          </DataForm.Form>
        </div>

      submit: (data)->
        @refs.form.set_submiting true
        Actions.update data, =>
          @state.close()

      # 获取所有直接前置节点
      get_pre_actions: (action)->
        pre_actions = {}
        for _id, _action of @props.actions
          if (_action.post_action_ids || []).indexOf(action.id) > -1
            pre_actions[_action.id] = _action
        pre_actions 

      get_all_pres_actions: (action)->
        all_pres_actions = {}
        @_r_ga action, all_pres_actions
        all_pres_actions

      _r_ga: (action, all_pres_actions)->
        all_pres_actions[action.id] = action
        for _id, _action of @get_pre_actions(action)
          @_r_ga _action, all_pres_actions


class DataStore
  constructor: (@page)->
    @actions = Immutable.fromJS(@page.state.actions || {})
    @update_url = @page.props.data.ware?.design_update_url

  remove_action: (action)->
    actions = @actions.filter (x)->
      x.get('id') != action.id

    actions = actions.map (x)->
      x = x.update 'post_action_ids', (ids)->
        ids = if ids?
          ids.filter (pid)->
            pid != action.id
        else
          Immutable.fromJS []
      x

    @ajax_update actions

  add_action: (action, callback)->
    actions = @actions.set action.id, Immutable.fromJS(action)
    @ajax_update actions, callback

  update_action: (action, callback)->
    actions = @actions.set action.id, Immutable.fromJS(action)
    @ajax_update actions, callback

  ajax_update: (actions, callback)->
    jQuery.ajax
      type: 'PUT'
      url: @update_url
      data:
        actions: actions.toJS()
    .done (res)=>
      @reload_page actions
      callback?()


  reload_page: (actions)->
    @actions = actions
    @page.setState
      actions: actions.toJS()


Actions = class
  @set_store: (store)->
    @store = store

  @remove: (action)->
    @store.remove_action action

  @add: (data, callback)->
    action = jQuery.extend {
      id: "id#{new Date().getTime()}"
      post_action_ids: []
    }, data

    @store.add_action action, callback

  @update: (data, callback)->
    action = data
    @store.update_action action, callback