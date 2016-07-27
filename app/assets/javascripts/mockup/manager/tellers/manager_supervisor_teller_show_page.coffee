@ManagerSupervisorTellerShowPage = React.createClass
  render: ->
    <div className="manager-supervisor-teller-show-page">
      <div className='ui segment base'>
        <div className="info">
          <label>姓名：</label>
          <div className="value">{@props.data.user.name}</div>
        </div>
        <div className="info">
          <label>邮箱：</label>
          <div className="value">{@props.data.user.email}</div>
        </div>
        <div className="info">
          <label>手机号：</label>
          <div className="value">{@props.data.user.phone_number}</div>
        </div>
        <div className="info">
          <label>岗位：</label>
          <div className="value">{@props.data.user.post.name}</div>
        </div>
      </div>
      <div className="ui segment">
        <ManagerSupervisorTellerShowPage.TellerBusinessCategoriesReadPercent data={@props.data} />
      </div>
    </div>

  statics:
    TellerBusinessCategoriesReadPercent: React.createClass
      render: ->
        supervisor_teller_show_url = @props.data.user.supervisor_teller_show_url
        <div className='teller-business-categories-read-percent'>
          {
            if @props.data.parents_data.length > 0
              <a className="back" href={supervisor_teller_show_url}>
                <i className="angle left icon"></i>
              </a>
          }

          {
            for item, idx in @props.data.parents_data
              <div key={idx} className='categories'>
              {
                for bc in item.siblings
                  klass = new ClassName
                    'category': true
                    'active': item.category.id == bc.id

                  <div key={bc.id} className={klass}>
                    <a href="#{supervisor_teller_show_url}?pid=#{bc.id}">{bc.name}</a>
                  </div>
              }
              </div>
          }

          <div className='categories current'>
          {
            for bc in @props.data.categories
              klass = new ClassName
                'category': true
                'active': bc.current

              <div key={bc.id} className={klass}>
                {
                  if bc.is_leaf
                    <a href="#{supervisor_teller_show_url}?pid=#{bc.id}">
                      <span><i className='icon circle' /> {bc.name}({bc.number})</span>
                      <ProgressBar percent={bc.read_percent_of_user} />
                    </a>
                  else
                    <a href="#{supervisor_teller_show_url}?pid=#{bc.id}">
                      <span>{bc.name}</span>
                      <ProgressBar percent={bc.read_percent_of_user} />
                    </a>
                }
              </div>
          }
          </div>

        </div>
