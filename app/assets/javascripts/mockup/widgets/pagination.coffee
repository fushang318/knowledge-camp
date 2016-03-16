@Pagination = React.createClass
  render: ->
    total = @props.data.total_pages
    current = @props.data.current_page

    pages = [1..total]
      .map (page)->
        if page <= 2
          page
        else if page >= total - 1
          page
        else if current - 1 <= page <= current + 1
          page
        else
          'X'
      .join ' '
      .replace /(X\ )*(X)/g, '…'
      .split ' '

    first = 1
    last = total
    prev = Math.max first, current - 1
    next = Math.min last, current + 1

    first_href = URI(location.href).addSearch({page: first})
    last_href = URI(location.href).addSearch({page: last})
    prev_href = URI(location.href).addSearch({page: prev})
    next_href = URI(location.href).addSearch({page: next})

    <div className="ui pagination menu">
      <a className='item' href={first_href}><i className='icon step backward' /></a>
      <a className='item' href={prev_href}><i className='icon chevron left' /></a>

      {
        for page, idx in pages
          if page == '…'
            <a key={idx} className='item' href='javascript:;'>{page}</a>
          else
            klass = new ClassName
              'item': true
              'active': page == current + ''
            href = URI(location.href).addSearch({page: page})
            <a key={idx} className={klass} href={href}>{page}</a>
      }

      <a className='item' href={next_href}><i className='icon chevron right' /></a>
      <a className='item' href={prev_href}><i className='icon step forward' /></a>
    </div>