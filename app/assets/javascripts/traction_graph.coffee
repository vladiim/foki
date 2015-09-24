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
  x.shapes.selectAll('text').attr 'transform', 'translate(-80, 60) rotate(-45)'

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
  legend = chart.addLegend '0%', 10, 500, 20, 'right'
  legend

addInteractiveLegends = (legend) ->
  $('g.dimple-legend text').on 'click', (event) ->
    metric = $($(event.target)).text()
    $modal = $('#metricModal')
    $modal.modal('show');
    $modal.find('.modal-title').text("#{metric} projects")
    width = parseInt($('.modal-content').css('width'), 10)


# TODO: filter by last week, filter by month, year etc
# Latest period only
# dimple.filterData(data, "Date", "01/12/2012");

makeGraph = (error, data) ->
  data   = parseData(data)
  chart  = createChart(data)
  x      = addXAxis(chart)
  y      = addYAxis(chart)
  series = addSeries(chart)
  legend = addLegend(chart)
  chart.draw()
  addInteractiveLegends()
  rotateXAxis(x)

$(document).ready ->
  queue()
    .defer(d3.json, '/data.json')
    .await(makeGraph)
