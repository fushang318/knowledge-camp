@ManagerSupervisorsPage = React.createClass
  render: ->
    <div className="manager-supervisors-page">
    {
      if @props.data.users.length is 0
        data =
          header: '督导员管理'
          desc: '还没有创建任何督导员'
          init_action: <ManagerSupervisorsPage.CreateBtn data={@props.data} />
        <ManagerFuncNotReady data={data} />

      else
        <div>
          <ManagerSupervisorsPage.CreateBtn data={@props.data} />
          <ManagerSupervisorsPage.Table data={@props.data} />
        </div>
    }
    </div>

  statics:
    CreateBtn: React.createClass
      render: ->
        <a className='ui button green mini' href={@props.data.new_supervisor_url}>
          <i className='icon plus' />
          创建督导员
        </a>

    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '姓名'
            email: '邮箱'
            actions: '操作'
          data_set: @props.data.users.map (x)->
            {
              id: x.id
              name: x.name
              email: x.email
              actions:
                <a className='ui button mini blue basic' href={x.manager_supervisors_edit_url}>
                  <i className='icon pencil' />
                  编辑
                </a>
            }

          th_classes: {}
          td_classes: {
            actions: 'collapsing'
          }

          paginate: @props.data.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='督导员管理' />
        </div>
