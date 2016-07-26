@ManagerTellersPage = React.createClass
  render: ->
    <div className="manager-tellers-page">
      <ManagerTellersPage.Table data={@props.data} />
    </div>

  statics:
    Table: React.createClass
      render: ->
        table_data = {
          fields:
            name: '姓名'
            email: '邮箱'
            phone_number: '手机'
          data_set: @props.data.users.map (x)->
            {
              id: x.id
              name: x.name
              email: x.email
              phone_number: x.phone_number
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
