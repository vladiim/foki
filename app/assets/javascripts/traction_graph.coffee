CHART_SELECTOR = '#traction-graph'

parseData = (data) ->
  _.map data, (d) -> JSON.parse d

createChart = (data) ->
  width = parseInt($(CHART_SELECTOR).css('width'), 10)
  svg   = dimple.newSvg(CHART_SELECTOR, width, 400)
  chart = new (dimple.chart)(svg, data)
  chart.setBounds 60, 30, width - 100, 330
  chart

addXAxis = (chart) ->
  x = chart.addTimeAxis('x', 'date', '%d/%m/%y', '%d %b \'%y')
  x.addGroupOrderRule 'date'
  x.title = ''
  x.addOrderRule 'date'
  x

rotateXAxis = (x) ->
  x.shapes.selectAll('text').attr 'transform', 'translate(-80, 55) rotate(-45)'
  return

addYAxis = (chart) ->
  y            = chart.addMeasureAxis('y', 'perc')
  y.tickFormat = '%'
  y.title      = 'Percent change'
  y

addSeries = (chart) ->
  series         = chart.addSeries('metric', dimple.plot.line)
  series.barGap  = 0.05
  series2        = chart.addSeries('metric', dimple.plot.bubble)
  series2.barGap = 0.05
  series

addLegend = (chart) ->
  chart.addLegend '0%', 10, 500, 20, 'right'
  return

makeGraph = (error, data) ->
  console.log('here')
  data   = parseData(data)
  chart  = createChart(data)
  x      = addXAxis(chart)
  y      = addYAxis(chart)
  series = addSeries(chart)
  addLegend(chart)
  chart.draw()
  rotateXAxis(x)
  return

$(document).ready ->
  queue()
    .defer(d3.json, '/data.json')
    .await(makeGraph)
