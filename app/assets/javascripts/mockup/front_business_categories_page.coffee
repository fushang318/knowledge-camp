@FrontBusinessCategoriesPage = React.createClass
  render: ->
    <div className='front-business-categories-page'>
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
                    <a href="/business_categories?pid=#{bc.id}">{bc.name}</a>
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
                    <a href="/business_categories?pid=#{bc.id}">
                      <span><i className='icon circle' /> {bc.name}({bc.number})</span>
                    </a>
                  else
                    <a href="/business_categories?pid=#{bc.id}">
                      <span>{bc.name}</span>
                    </a>
                }
              </div>
          }
          </div>

          {
            if @props.data.current_category
              <div className='wares'>
                {
                  if @props.data.wares.length > 0
                    for ware in @props.data.wares
                      <WareCard data={ware} />
                  else
                    <div className="no-ware">
                      该业务下没有课件
                    </div>
                }
              </div>
          }

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
      <div className='extra content'>
        <a className='ui basic button fluid pill' href={ware.show_url} target='_blank'>
          学　习
        </a>
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
