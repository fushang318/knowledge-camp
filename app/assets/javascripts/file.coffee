# 一开始用的是 Resumeable.js
# 然后改成了 Flow.js
# 话说这两个库的关系很纠结。
# 具体见 https://github.com/flowjs/flow.js/issues/1

class MindpinFlowUploader
  constructor: (config)->
    @target         = config['target']
    @csrf_token     = config['csrf_token']
    @$browse_button = config['browse']
    @$drop          = config['drop']
    @$uploader      = config['uploader']
    
    @file_added_func = config['file_added_func']
    @complete_func   = config['complete_func']


    @$item = @$uploader.find('.progress-item')
    @$list = @$uploader.find('.upload-list')

    @init()
    @events()

    @data = {}

  init: ->
    @r = new Flow
      target: @target
      headers:
        'X-CSRF-Token': @csrf_token
      chunkSize: 196608 # 1024 * 192 192K
      testChunks: true
      simultaneousUploads: 1 # 最多同时上传一个，保证顺序
      generateUniqueIdentifier: (file)->
        "#{file.size}|#{file.name}"

    @r.assignBrowse @$browse_button[0]
    @r.assignDrop @$drop[0]

    dc = 0
    @$drop.on 'dragenter', (evt)=>
      dc++
      @$drop.addClass 'over'

    @$drop.on 'dragleave drop', (evt)=>
      dc--
      if dc is 0
        @$drop.removeClass 'over'

  events: ->
    @r.on 'fileAdded', (file, event)=>
      @_clone_item(file)
      file.start_at = new Date().getTime()
      file.last_progress = 0

      @file_added_func()

    @r.on 'filesSubmitted', (array, event)=>
      @r.upload()

    @r.on 'fileProgress', (file)=>
      $item = file.$item

      @__set_progress(file)
      @__set_remaining_time(file)

    @r.on 'fileSuccess', (file, message)=>
      file_entity_id = JSON.parse(message)['file_entity_id']
      @data[file_entity_id] = file.name

      setTimeout ->
        file.$item.addClass('completed')
      , 300

    @r.on 'complete', (file)=>
      setTimeout =>
        @complete_func()
      , 300

  _clone_item: (file)->
    $item = @$item.clone()
    file.$item = $item

    @__set_name(file)
    @__set_progress(file)
    @__set_remaining_time(file)
    @__set_extension_klass(file)
    
    $item.show().appendTo @$list


  __set_name: (file)->
    if file.$item
      file.$item.find('.name').html file.name

  __set_progress: (file)->
    if file.$item
      percent = "#{(file.progress() * 100).toFixed()}%"
      file.$item.find('.bar').css 'width', percent
      file.$item.find('.percent').html percent

  __set_remaining_time: (file)->
    if file.$item
      remaining = file.timeRemaining()
      remaining =
        if remaining == Number.POSITIVE_INFINITY
        then '未知'
        else @__human_time(remaining)

      file.$item.find('.remaining-time').html remaining

  __human_time: (remaining)->
    remaining += 1

    hour   = Math.floor(remaining / 3600)
    minute = Math.floor(remaining % 3600 / 60)
    second = remaining % 60

    hour = if hour >= 10 then hour else "0#{hour}"
    minute = if minute >= 10 then minute else "0#{minute}"
    second = if second >= 10 then second else "0#{second}"

    "#{hour}:#{minute}:#{second}"

  __set_extension_klass: (file)->
    if file.$item
      file.$item.addClass file.getExtension()

  get_data: ->
    @data
    # [key, @data[key]] for key of @data

ready = ->
  if jQuery('.page-manage-files-new').length > 0
    uploader = _init_uploader()
    _init_submit_button(uploader)


_init_uploader = ->
  token_value = jQuery('meta[name=csrf-token]').attr('content')
  $button = jQuery('.page-manage-files-new a.select-file')
  $drop = jQuery('.page-manage-files-new .file-box')
  target = $button.data('url')
  $uploader = jQuery('.page-file-uploader')

  new MindpinFlowUploader({
    target: target
    csrf_token: token_value
    browse: $button
    drop: $drop
    uploader: $uploader
    file_added_func: ->
      jQuery('.page-manage-files-new .ops a.submit').addClass('disabled')
    complete_func: ->
      jQuery('.page-manage-files-new .ops a.submit').removeClass('disabled')
  })

_init_submit_button = (uploader)->
  jQuery(document).delegate '.page-manage-files-new .ops a.submit', 'click', (evt)->
    $button = jQuery(this)
    return if $button.hasClass('disabled')

    data = uploader.get_data()
    url = $button.data('url')

    jQuery.ajax
      url: url
      type: 'POST'
      data:
        files: data
      success: (res)->
        Turbolinks.AniToggle.visit(url, ['open', 'close'])


jQuery(document).on 'ready page:load', ready


# 排版方法
# ----------------------
class GridLayout
  constructor: (@$grid)->
    @col = @$grid.data('cols')
  
  layout: ->
    stack = []
    @$grid.find('.gcell').each (index, cell)=>
      if index % @col is 0
        @_layout_stack(stack)
        stack = []
      stack.push cell
    @_layout_stack(stack)

  _layout_stack: (stack)->
    max_height = 0
    for cell in stack
      height = jQuery(cell).height()
      max_height = height if height > max_height

    for cell in stack
      jQuery(cell).height(max_height)

jQuery(document).on 'ready page:load', ->
  if jQuery('.cell-manage-files.grid').length > 0
    new GridLayout(jQuery('.cell-manage-files.grid')).layout()