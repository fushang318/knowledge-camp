@ManagerSupervisorTellersPage = React.createClass
  render: ->
    <div className="manager-tellers-page">
      <ManagerSupervisorTellersPage.Table data={@props.data} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '姓名'
            email: '邮箱'
            phone_number: '手机'
            read_percent: '学习进度'
            action: '操作'
          data_set: @props.data.users.map (x)->
            {
              id: x.id
              name: x.name
              email: x.email
              phone_number: x.phone_number
              read_percent:
                <ProgressBar percent={x.read_percent} />

              action:
                <a className='ui button mini blue basic' href={x.supervisor_teller_show_url}>
                  <i className='icon unhide' />
                  查看详情
                </a>
            }

          th_classes: {}
          td_classes: {
            actions: 'collapsing'
          }

          paginate: @props.data.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='柜员学习进度' />
        </div>
