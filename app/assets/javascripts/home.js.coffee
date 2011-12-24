# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/


$ ->
	modal = ""
	$(".open-dialog").bind "click", ->
		modal = $("#add-comment-modal").modal('show')	
		id = $(this).data("id")
		$('form input[name="commission_id"]',modal).val(id)
	$(".add-comment").live "click", ->
		$.post $("#add-comment-form").attr("action"), $("#add-comment-form").serialize(), ((data) ->
			if data.status == "created"
				modal.modal('hide')
			end
		), "json"
$ ->
# фильтр на главной странице - по вводу имени субъекта

	$("#go-to").change ->
		typed = $(this).val()
		if typed.length > 2
		  $(".tree-root").fadeOut()
		else
		  $(".tree-root").fadeIn()
		$("h4:contains('"+typed+"')").parents('.tree-root').fadeIn();

$ ->
# сводная таблица результатов голосования
	$(".tree-node-holder").hover (->
		$(".root-voting-table",$(this)).animate
		    opacity: "1"
		  ,
		    queue: false
		    duration: 200
	), ->
	  $(".root-voting-table",$(this)).animate
		    opacity: "0"
		  ,
		    queue: false
		    duration: 200


$ ->
# навигация 
	navigation_list = $("<ul></ul>").attr(
		class: "navigation-list"
	)
  
	$(".node-name").each (index) ->
		$(navigation_list).append "<li>"+Array($(this).data('depth')).join("&nbsp;")+"<a href=\"#"+$('h3',$(this)).attr('id')+"\">"+$('h3',$(this)).text()+"</a></li>"
		$('.tree-navigation').append(navigation_list)
  
	$(".show-navigation").click ->
		$('.tree-navigation').toggle()
        
	$(".tree-navigation a").live "click", ->
		$('.tree-navigation').fadeOut()
  
# фильтр

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
