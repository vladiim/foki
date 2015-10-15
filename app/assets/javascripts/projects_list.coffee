PROJECTS_SELECTOR = '#projects'
CHANGE_VIEW       = '.change-projects-view'
FOCUS_SELECTOR    = '.projects-focus'
OFF               = 'off'

changeViewListener = ->
  # $(CHANGE_VIEW).on 'click', (event) =>
  $(document.body).on 'click', CHANGE_VIEW, (event) =>
    $(FOCUS_SELECTOR).toggleClass(OFF)

activateProjectsList = ->
  changeViewListener()

$(document).ready ->
  if $(PROJECTS_SELECTOR).length > 0 then activateProjectsList()
