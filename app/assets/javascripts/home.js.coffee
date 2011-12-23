# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$ ->
	$("a[rel=popover]").popover(
		offset: 10
		html: true
		trigger: "manual"
		content: ->
			$(this).next().html()
	).live "click", ->
		$("a[rel=popover]").popover('hide')
		if $(this).data('clicked')
			$(this).popover('hide')
			$(this).data('clicked',false)
		else
			$(this).popover('show')
			$(this).data('clicked',true)

$ ->
  navigation_list = $("<ul></ul>").attr(
    class: "navigation-list"
  )
  
  $(".node-name").each (index) ->
    $(navigation_list).append "<li>"+Array($(this).data('depth')).join("&nbsp;")+"<a href=\"#"+$(this).attr('id')+"\">"+$(this).text()+"</a></li>"
    $('.tree-navigation').append(navigation_list)
  
  $(".show-navigation").click ->
    $('.tree-navigation').toggle()
        
  $(".tree-navigation a").live "click", ->
    $('.tree-navigation').fadeOut()
  
  
  $(".filter-item a").live "click", ->
	# Меняем стиль параметра в фильтре
    $("a",$(this).parents('.filter-item')).removeClass('active')
    $(this).toggleClass('active')

    data_set_holder = $("#"+$(this).data('receiver_id'))
    filter          = $(this).data('filter')
    arg             = $(this).data('arg')

    $('.voting-table',data_set_holder).each (voting_table) ->
      if $(this).data(filter) > arg
        $(this).fadeOut()
      else
        $(this).fadeIn()
