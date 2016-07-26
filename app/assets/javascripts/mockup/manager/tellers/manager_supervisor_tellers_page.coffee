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
          data_set: @props.data.users.map (x)->
            {
              id: x.id
              name: x.name
              email: x.email
              phone_number: x.phone_number
              read_percent: "待填充"
            }

          th_classes: {}
          td_classes: {
            actions: 'collapsing'
          }

          paginate: @props.data.paginate
        }

        <div className='ui segment'>
          <ManagerTable data={table_data} title='柜员管理' />
        </div>

