CHART_SELECTOR = '#traction-graph'
DATA_SELECTOR  = 'focus-data';
Y_AXIS         = 'change';
X_AXIS         = 'date';
DIM            = 'metric';

getData = ->
  chart = $(CHART_SELECTOR)
  parseData(chart.data(DATA_SELECTOR))

parseData = (data) ->
  _.map data, (d) -> JSON.parse d

createChart = (data) ->
  width = parseInt($(CHART_SELECTOR).css('width'), 10)
  svg   = dimple.newSvg(CHART_SELECTOR, width, 400)
  chart = new (dimple.chart)(svg, data)
  chart.setBounds 60, 30, width - 100, 330
  chart

addXAxis = (chart) ->
  x = chart.addTimeAxis('x', X_AXIS, '%Y-%m-%d', '%d %b \'%y')
  x.addGroupOrderRule X_AXIS
  x.title = ''
  x.addOrderRule X_AXIS
  x

rotateXAxis = (x) ->
  x.shapes.selectAll('text').attr 'transform', 'translate(-80, 50) rotate(-45)'

addYAxis = (chart) ->
  y            = chart.addMeasureAxis('y', Y_AXIS)
  y.tickFormat = '%'
  y.title      = 'Percent change'
  y

addSeries = (chart) ->
  series         = chart.addSeries(DIM, dimple.plot.line)
  series.barGap  = 0.05
  series2        = chart.addSeries(DIM, dimple.plot.bubble)
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

# makeGraph = (error, data) ->
makeGraph = ->
  data   = getData()
  chart  = createChart(data)
  x      = addXAxis(chart)
  y      = addYAxis(chart)
  series = addSeries(chart)
  legend = addLegend(chart)
  chart.draw()
  addInteractiveLegends()
  rotateXAxis(x)

$(document).ready ->
  if $(CHART_SELECTOR).length > 0 then makeGraph()
    # queue()
    #   .defer(d3.json, '/data.json')
    #   .await(makeGraph)
