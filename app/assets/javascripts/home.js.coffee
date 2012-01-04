# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ ->

  loader = (obj,flag=false) ->    
    $(".loading",obj).show()
    $(obj).load $(obj).data("url"), ->

      $(this).data('loaded') == true      
      $(this).addClass('loaded')
      $('.loading',this).hide()

      if flag is true        
        $('.votings').appear ->
          loader $(this)  
  
  loader $('.votings:first'),true

  

#загружаем уики, если есть анкор в ссылкы  
  if window.location.hash    
    loader $('.tree-node-holder'+window.location.hash+' .votings')

# навигация 
  navigation_list = $("<ul></ul>").attr(
    class: "navigation-list"
  )
  
  $(".node-name").each (index) ->
    $(navigation_list).append "<li>"+Array($(this).data('depth')).join("&nbsp;")+"<a href=\"#"+$('h3',$(this)).attr('id')+"\" data-id=\""+$('h3',$(this)).attr('id')+"\">"+$('h3',$(this)).text()+"</a></li>"
    $('.tree-navigation').append(navigation_list)
  
  $(".show-navigation").click ->
    $('.tree-navigation').toggle()
  
  # переход по анкору      
  $(".tree-navigation a").live "click", ->
    $('.tree-navigation').fadeOut()
    loader $('.tree-node-holder#'+$(this).data('id')+' .votings')
  
  
  
