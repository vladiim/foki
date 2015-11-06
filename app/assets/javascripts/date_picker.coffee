DATE_SELECTOR      = '#date-range'
FROM_DATE_SELECTOR = '#from-date'
TO_DATE_SELECTOR   = '#to-date'
SELECTORS          = [FROM_DATE_SELECTOR, TO_DATE_SELECTOR]

setupDatePickers = ->
  _.each(SELECTORS, showDatePicker)

showDatePicker = (selector) ->
  $(selector).datetimepicker
    locale: 'en-au'
    format: 'DD MMM YYYY'
    viewMode: 'days'

changeDateListeners = ->
  _.each(SELECTORS, changeDateListener)

changeDateListener = (selector) ->
  $(selector).on 'dp.change', (event) => changeTractionGraphChart()

changeTractionGraphChart = ->
  data = getData()
  removeTractionGraphChart()
  createTractionGraphChart(data)

getData = ->
  _.filter(tractionGraphGetData(), filterData)

filterData = (data) ->
  from_date = getDate(FROM_DATE_SELECTOR)
  to_date   = getDate(TO_DATE_SELECTOR)
  date = new Date(data.date)
  from_date <= date && to_date >= date

getDate = (selector) ->
  date = $(selector)[0].value
  new Date(date)

init = ->
  setupDatePickers()
  changeDateListeners()

$(document).on 'page:change', ->
  if $(DATE_SELECTOR).length > 0 then init()
