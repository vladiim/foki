STAT_SUMMARY      = '.stat-summary'
TIME_SELECTOR     = '.time-selecter'
DROPDOWN_SELECTOR = '#dropdown-title'
STAT_SELECTOR     = '.stat'
CHANGE_SELECTOR   = '.change'

refreshStatsListener = ->
  document.addEventListener 'refreshStats', (event) =>
    alert('worked')
    showStats()

timeSelectorListener = ->
  $(TIME_SELECTOR).on 'click', (event) =>
    $target = $(event.target)
    $(DROPDOWN_SELECTOR).text($target.text())
    showStats($target.data('days'))

sumValues = (count, item) => count + item.value

statSum = (data, start, end) ->
  data = data.slice(start, end)
  _.reduce(data, sumValues, 0)

percChange = (data, days) ->
  now    = statSum(data, 0, days)
  prev   = statSum(data, days, days * 2)
  change = (now - prev) / prev
  res    = "#{change.toFixed(2) * 100}%"
  if isNaN(prev) then 'Missing data' else res

formatDataItem = (item) ->
  item       = JSON.parse(item)
  item.date  = new Date(item.date)
  item.value = parseFloat(item.value)
  item

getData = (stat) ->
  metrics = stat.data('metrics')
  data    = _.map metrics, formatDataItem
  ordered = _.sortBy data, (d) => d.date
  ordered.reverse()
  # _.sortBy data, (d) => d.date

showStat = (article, days) ->
  $stat   = $(article).find(STAT_SELECTOR)
  $change = $(article).find(CHANGE_SELECTOR)
  data    = getData($stat)
  $stat.text(statSum(data, 0, days))
  $change.text(percChange(data, days))

@showStats = (days) ->
  days           = days || 1
  $stat_articles = $(STAT_SUMMARY)
  _.each $stat_articles, (article) => showStat(article, days)

activateMetricSummary = ->
  showStats()
  timeSelectorListener()
  refreshStatsListener()

$(document).on 'page:change', ->
  if $(STAT_SUMMARY).length > 0 then activateMetricSummary()
