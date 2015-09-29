FOCUS_METRIC_SELECTOR  = '.focus-metric'
METRIC_CHOICE_SELECTOR = '.metric-selector'
METRIC_TEXT_SELECTOR   = '.dropdown.metric a'

changeMetric = ($target) ->
  metric_id  = $target.data('metricId')
  program_id = $target.data('programId')
  # $.ajax type: 'PUT', url: "/programs/#{program_id}", data
  $.ajax
    type: 'PUT'
    dataType: 'json'
    url: "/programs/#{program_id}"
    contentType: 'application/json'
    data: {metric_id: metric_id}
    success: (msg)->
      alert 'Data Saved: ' + msg

changeText = ($target) ->
  text = $target.text()
  $(METRIC_TEXT_SELECTOR).text(text)

changeMetricListener = ->
  $(METRIC_CHOICE_SELECTOR).on 'click', (event) =>
    $target = $(event.target)
    changeText($target)
    changeMetric($target)

activateCurrentMetric = -> changeMetricListener()

$(document).ready ->
  if $(FOCUS_METRIC_SELECTOR).length > 0 then activateCurrentMetric()
