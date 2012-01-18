/*
 *  SliderNav - A Simple Content Slider with a Navigation Bar
 *  Copyright 2010 Monjurul Dolon, http://mdolon.com/
 *  Released under the MIT, BSD, and GPL Licenses.
 *  More information: http://devgrow.com/slidernav
 */
$.fn.sliderNav = function(options) {
	var defaults = { items: ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"], debug: false, height: null, arrows: true};
	var opts = $.extend(defaults, options); var o = $.meta ? $.extend({}, opts, $$.data()) : opts; var slider = $(this); $(slider).addClass('slider');
	$('.slider-content li:first', slider).addClass('selected');
	$(slider).append('<div class="slider-nav"><ul></ul></div>');
	for(var i in o.items) $('.slider-nav ul', slider).append("<li><a alt='#"+o.items[i]+"'>"+o.items[i]+"</a></li>");
	var height = $('.slider-nav', slider).height();
	if(o.height) height = o.height;
	$('.slider-content, .slider-nav', slider).css('height',height);
	if(o.debug) $(slider).append('<div id="debug">Scroll Offset: <span>0</span></div>');
	$('.slider-nav a', slider).mouseover(function(event){
		var target = $(this).attr('alt');
		var cOffset = $('.slider-content', slider).offset().top;
		var tOffset = $('.slider-content '+target, slider).offset().top;
		var height = $('.slider-nav', slider).height(); if(o.height) height = o.height;
		var pScroll = (tOffset - cOffset) - height/8;
		$('.slider-content li', slider).removeClass('selected');
		$(target).addClass('selected');
		$('.slider-content', slider).stop().animate({scrollTop: '+=' + pScroll + 'px'});
		if(o.debug) $('#debug span', slider).html(tOffset);
	});
	if(o.arrows){
		$('.slider-nav',slider).css('top','20px');
		$(slider).prepend('<div class="slide-up end"><span class="arrow up"></span></div>');
		$(slider).append('<div class="slide-down"><span class="arrow down"></span></div>');
		$('.slide-down',slider).click(function(){
			$('.slider-content',slider).animate({scrollTop : "+="+height+"px"}, 500);
		});
		$('.slide-up',slider).click(function(){
			$('.slider-content',slider).animate({scrollTop : "-="+height+"px"}, 500);
		});
	}
};

$.fn.sliderNav_option = function(options) {
	var defaults = { items: ["a","b","c","d","e","f","g","h","i","j","k","l","m","n","o","p","q","r","s","t","u","v","w","x","y","z"], debug: false, height: null, arrows: true};
	var opts = $.extend(defaults, options); var o = $.meta ? $.extend({}, opts, $$.data()) : opts; var slider_option = $(this); $(slider_option).addClass('slider_option');
	$('.slider-content li:first', slider_option).addClass('selected');
	$(slider_option).append('<div class="slider-nav"><ul></ul></div>');
	for(var i in o.items) $('.slider-nav ul', slider_option).append("<li><a alt='#"+o.items[i]+"'>"+o.items[i]+"</a></li>");
	var height = $('.slider-nav', slider_option).height();
	if(o.height) height = o.height;
	$('.slider-content, .slider-nav', slider_option).css('height',height);
	if(o.debug) $(slider_option).append('<div id="debug">Scroll Offset: <span>0</span></div>');
	$('.slider-nav a', slider_option).mouseover(function(event){
		var target = $(this).attr('alt');
		var cOffset = $('.slider-content', slider_option).offset().top;
		var tOffset = $('.slider-content '+target, slider_option).offset().top;
		var height = $('.slider-nav', slider_option).height(); if(o.height) height = o.height;
		var pScroll = (tOffset - cOffset) - height/8;
		$('.slider-content li', slider_option).removeClass('selected');
		$(target).addClass('selected');
		$('.slider-content', slider_option).stop().animate({scrollTop: '+=' + pScroll + 'px'});
		if(o.debug) $('#debug span', slider_option).html(tOffset);
	});
	if(o.arrows){
		$('.slider-nav',slider_option).css('top','20px');
		$(slider_option).prepend('<div class="slide-up end"><span class="arrow up"></span></div>');
		$(slider_option).append('<div class="slide-down"><span class="arrow down"></span></div>');
		$('.slide-down',slider_option).click(function(){
			$('.slider-content',slider_option).animate({scrollTop : "+="+height+"px"}, 500);
		});
		$('.slide-up',slider_option).click(function(){
			$('.slider-content',slider_option).animate({scrollTop : "-="+height+"px"}, 500);
		});
	}
};