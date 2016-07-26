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
                'leaf': bc.is_leaf

              <div key={bc.id} className='category'>
                {
                  if bc.is_leaf
                    <a href="/business_categories/#{bc.id}">
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
        </div>
      </div>
    </div>
