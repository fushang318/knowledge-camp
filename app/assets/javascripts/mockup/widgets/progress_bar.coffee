@ProgressBar = React.createClass
  render: ->
    percent_bar_style =
      width: "#{@props.percent}%"

    <div className="progress-bar">
      <div className="bar">
        <div className="percent-bar" style={percent_bar_style}></div>
      </div>
      <div className="text">
        {@props.percent}%
      </div>
    </div>
