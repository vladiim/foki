STAT_SUMMARY      = '.stat-summary'
DROPDOWN_SELECTOR = '#dropdown-title'
STAT_SELECTOR     = '.stat'
CHANGE_SELECTOR   = '.change'

refreshStatsListener = ->
  document.addEventListener 'refreshStats', (event) => showStats()

sumValues = (count, item) => count + item.value

statSum = (data) -> parseInt(_.reduce(data, sumValues, 0)).toLocaleString()

percChange = (data) ->
  if data.length is 0 then return 'Missing data'
  now    = data[0].value
  prev   = data[data.length - 1].value
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
  _.filter(ordered.reverse(), @filterData)

showStat = (article) ->
  $stat   = $(article).find(STAT_SELECTOR)
  $change = $(article).find(CHANGE_SELECTOR)
  data    = getData($stat)
  $stat.text(statSum(data))
  $change.text(percChange(data))

@showStats = ->
  $stat_articles = $(STAT_SUMMARY)
  _.each $stat_articles, (article) => showStat(article)

activateMetricSummary = ->
  showStats()
  refreshStatsListener()

$(document).on 'page:change', ->
  if $(STAT_SUMMARY).length > 0 then activateMetricSummary()
