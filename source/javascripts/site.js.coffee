#= require 'vendor/jquery'
#= require 'vendor/jquery-ui-1.8.20.custom.js'
#= require 'vendor/jquery.vegas'
#= require 'vendor/jquery-mousewheel'
#= require 'vendor/antiscroll'
#= require 'vendor/bootstrap'

$ ->

  $('.scrollable').each (i, el) ->
    $(el).addClass('antiscroll-wrap')
      .wrapInner('<div class="box-inner" />')
      .wrapInner('<div class="antiscroll-inner" />')
      .wrapInner('<div class="box" />')

    $(el).find('.box, .antiscroll-inner').css 'width', $(el).attr('data-width') || ($('.container[role="main"]').width() - 60)
    $(el).find('.box, .antiscroll-inner').css 'height', $(el).attr('data-height') || ($(window).height() / 2)
    # $(el).find('.box-inner').css 'padding-right', 20

    $(el).antiscroll()

  $(window).resize ->
    c = $('.container[role="main"]')
    $('.slideshow.previous, .slideshow.next').css('top', ($(window).height() / 2))

  $(window).resize()

  window.setup_slideshow = (container_selector) ->
    $.ajax(url: '/images.html').done (res) ->
      backgrounds = []
      $(res).filter(container_selector).find('img').each ->
        backgrounds.push { src: $(this).attr('src'), fade: 700 }

      $(backgrounds).each (i, el) ->
        $('.slideshow-controls nav').append("<a class='icon' data-rel='#{i}'>#</a>")

      $('.slideshow-controls nav .icon:first-child').addClass('active');
      $('.slideshow-controls nav .icon').click ->
        $(this).addClass('active').siblings().removeClass('active')
        $.vegas 'jump', $(this).attr('data-rel')

      $('.slideshow-controls .play').click ->
        if $.vegas 'get', 'paused'
          $.vegas 'slideshow'
          $(this).html "&#x0028;"
        else
          $.vegas 'pause'
          $(this).html "&#x0027;"

      $.vegas 'slideshow', backgrounds: backgrounds, delay: 4000

      $('body').bind 'vegaswalk', (e, bg, step)  ->
        $(".icon[data-rel='#{step}']").addClass('active').siblings().removeClass('active')

      $('.next').click -> $.vegas 'next'
      $('.previous').click -> $.vegas 'previous'

  window.load_photogallery = ->
    $.ajax(url: '/images.html').done (res) ->
      backgrounds = []
      thumbs = []

      $('body').append $('.gallery')

      # $(res).find('img').each ->
      $(res).filter('#photogallery').find('img').each ->
        backgrounds.push { src: $(this).attr('src'), fade: 700 }
        thumb_src = $(this).attr('data-thumb') || "/images/slides/photogallery/thumbs/" + $(this).attr('src').match(/([0-9]+\.jpg)/)[0]
        thumbs.push { src: thumb_src, caption: $(this).attr('data-caption') }

      $('.gallery .toggle').click ->
        panel = $('.gallery')
        icon  = $(this).find('.icon')

        if panel.attr('data-status') == 'open'
          panel.attr('data-status', 'closed').animate 'bottom': -panel.height(), 'normal'
          icon.html '&#x0026;'
          $(this).animate 'top': -40, 'normal', 'easeOutBack'
        else
          panel.attr('data-status', 'open').animate 'bottom': 0, 'normal'
          icon.html '&#x0025;'
          $(this).animate 'top': 15, 'normal', 'easeOutBack'

      $(thumbs).each (i, el) ->
        $('.gallery .thumbs').append "<span><img src='#{el.src}' data-rel='#{i}' data-caption='#{el.caption}' /></span>"

      $('.gallery .thumbs img').click ->
        $.vegas 'jump', $(this).attr('data-rel')

      $('.gallery .controls .total').text thumbs.length

      $('.gallery .right').click ->
        ww = $(window).width()
        ol = $('.gallery .thumbs span:last-child').offset().left

        if ol > ww / 2
          $('.gallery .thumbs').animate left: "-=#{ww/2}px"

      $('.gallery .left').click ->
        ww   = $(window).width()
        left = parseInt $('.gallery .thumbs').css('left')

        if left < 0
          $('.gallery .thumbs').animate { left: "+=#{ww/2}px" }, step: (now, fx) ->
            if now > 0
              $(this).stop().animate left: 0

      $('.gallery .controls .play').click ->
        if $.vegas 'get', 'paused'
          $.vegas 'slideshow'
          $(this).html "&#x0028;"
        else
          $.vegas 'pause'
          $(this).html "&#x0027;"

      $.vegas 'slideshow', backgrounds: backgrounds

      $('body').bind 'vegaswalk', (e, bg, step)  ->
        $(".gallery img[data-rel='#{step}']").parent().addClass('active').siblings().removeClass('active')
        $('.gallery .caption').css('opacity', 0).text($(".gallery img[data-rel='#{step}']").attr('data-caption')).animate opacity: 1, 'slow'
        $('.gallery .controls .current').text(step + 1)

      $('.next').click -> $.vegas 'next'
      $('.previous').click -> $.vegas 'previous'

  # Pannello laterale
  $('.toggle-panel').click ->
    panel = $('[data-status="open"], [data-status="closed"]')
    icon  = $(this).find('.icon')

    if panel.attr('data-status') == 'open'
      icon.html '&#x003e;'
      panel.attr('data-status', 'closed').animate left: -panel.width(), 'easeOutBack'
      $(this).animate left: 20, 'normal', 'easeOutBack'
      $('.slideshow.previous').animate left: 20
    else
      icon.html '&#x0024;'
      panel.attr('data-status', 'open').animate left: 0, 'easeOutBack'
      $(this).animate 'left': 260, 'easeOutBack'
      $('.slideshow.previous').animate left: 300, 'easeOutBack'

  # Supporto cross-browser per attributo placeholder
  $('[placeholder]').focus(->
    input = $(this)
    if input.val() == input.attr 'placeholder'
      input.val('')
      input.removeClass 'placeholder'
  ).blur(->
    input = $(this)
    if input.val() == '' || input.val() == input.attr 'placeholder'
      input.addClass 'placeholder'
      input.val input.attr('placeholder')
  ).blur().parents('form').submit ->
    $(this).find('[placeholder]').each ->
      input = $(this)
      if input.val() == input.attr 'placeholder'
        input.val ''

  $('#bookings form').submit (e) ->
    e.preventDefault()
    $.post 'form.php', $(this).serialize(), (res) ->
      $('#bookings .feedback').html(res)
