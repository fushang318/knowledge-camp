@ManagerEditBusinessCategoriesEnterprisePostPage = React.createClass
  render: ->
    <div className="manager-edit-business-categories-enterprise-post-page">
      <ManagerEditBusinessCategoriesEnterprisePostPage.Form data={@props.data} />
    </div>

  statics:
    Form: React.createClass
      getInitialState: ->
        errors: {}

      render: ->
        tdp = new Array2TreeParser @props.data.business_categories
        root_business_categories = tdp.get_root_array()

        checked_ids = []
        for x in @props.data.post.business_categories
          checked_ids.push x.id

        tree_data =
          items: root_business_categories
          checked_leaf_item_ids: checked_ids

        <div className="ui segment">
          <div className="ui small form data-form">
            <label>所属业务类别：</label>
            <div className="tree">
              <BusinessCategoriesSelectTree data={tree_data} ref="tree" />
            </div>
            <div className="field">
              <a className="ui button green" href="javascript:;" onClick={@submit}>
                <i className="icon check" />
                <span>确定保存</span>
              </a>
            </div>
          </div>
        </div>

      submit: ->
        jQuery
          .ajax
            url: @props.data.update_business_categories_url
            type: 'PUT'
            data:
              post:
                business_category_ids: @refs.tree.value()
          .done (res)->
            location.href = res.jump_url
