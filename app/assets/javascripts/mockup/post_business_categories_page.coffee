@PostBusinessCategoriesPage = React.createClass
  render: ->
    <div className='post-business-categories-page'>
      <div className='ui container'>
        <div className='ui segment'>
          {
            for item, idx in @props.data.parents_data
              <div key={idx} className='categories'>
              {
                for bc in item.siblings
                  klass = new ClassName
                    'category': true
                    'active': item.category.id == bc.id

                  <div key={bc.id} className={klass}>
                    <a href="/business_categories/my?pid=#{bc.id}">{bc.name}</a>
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
                    <a href="/business_categories/my?pid=#{bc.id}">
                      <span><i className='icon circle' /> {bc.name}({bc.number})</span>
                      <ProgressBar percent={bc.read_percent_of_user} />
                    </a>
                  else
                    <a href="/business_categories/my?pid=#{bc.id}">
                      <span>{bc.name}</span>
                      <ProgressBar percent={bc.read_percent_of_user} />
                    </a>
                }
              </div>
          }
          </div>

          <div className='wares'>
            {
              for ware in @props.data.wares
                <WareCard data={ware} />
            }
          </div>
        </div>
      </div>
    </div>



WareCard = React.createClass
  render: ->
    ware = @props.data
    kind = switch ware.kind
      when "video" then "video"
      when "document" then "file"
      when "teller" then "rmb"

    <div className='ware'>
      <div className='content'>
        <div className='right floated mini ui image'>
          <div className='ic'>
            <i className="icon #{kind}" />
          </div>
        </div>
        <div className='meta name'>
          {ware.name}
        </div>
      </div>
      <div className="read-percent">
        <ProgressBar percent={ware.read_percent_of_user} />
      </div>
      <div className='extra content'>
        <a className='ui basic button fluid pill' href={ware.show_url} target='_blank'>
          学　习
        </a>
      </div>
    </div>
