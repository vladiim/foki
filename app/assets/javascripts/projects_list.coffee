PROJECTS_SELECTOR = '#projects'
CHANGE_VIEW       = '.change-projects-view'
FOCUS_SELECTOR    = '.projects-focus'
OFF               = 'off'

changeViewListener = ->
  $(document.body).on 'click', CHANGE_VIEW, (event) =>
    $(FOCUS_SELECTOR).toggleClass(OFF)

activateProjectsList = ->
  changeViewListener()

$(document).on 'page:change', ->
  if $(PROJECTS_SELECTOR).length > 0 then activateProjectsList()
