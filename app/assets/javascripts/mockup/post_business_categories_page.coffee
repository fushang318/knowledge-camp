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
                    </a>
                  else
                    <a href="/business_categories/my?pid=#{bc.id}">
                      <span>{bc.name}</span>
                    </a>
                }
              </div>
          }
          </div>
        </div>
      </div>
    </div>

@FrontBusinessCategoryShowPage = React.createClass
  render: ->
    <div className='front-business-category-show-page'>
      <div className='ui container'>
        <div className='ui segment'>
          {
            for parent in @props.data.parents_data
              <span key={parent.id}>
                <a href="/business_categories?pid=#{parent.id}">{parent.name}</a>
                <span> > </span>
              </span>
          }
          <span>{@props.data.category.name}({@props.data.category.number})</span>

          <div style={marginTop: '3rem'}>
            <h4>视频演示</h4>
            {
              for video in @props.data.videos
                <div key={video.id}>
                  <a href={video.url} target='_blank'><i className='icon video' /> {video.original}</a>
                </div>
            }
          </div>

          <div style={marginTop: '3rem'}>
            <h4>课件演示</h4>
            <div className='wares ui cards'>
            {
              for ware in @props.data.teller_wares
                <FinanceTellerWareCard key={ware.id} data={ware} />
            }
            </div>
          </div>
        </div>
      </div>
    </div>
