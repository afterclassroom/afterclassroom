/** 
 * Copyright (c) 2010 Sylvain Gougouzian (sylvain@gougouzian.fr)
 * MIT (http://www.opensource.org/licenses/mit-license.php) licensed.
 * GNU GPL (http://www.gnu.org/licenses/gpl.html) licensed.
 *
 * jQuery carrousel version: 1.2
 *
 * Requires: jQuery 1.3.2+ 	// http://www.jquery.com
 * Compatible : Internet Explorer 6+, Firefox 1.5+, Safari 3+, Opera 9+, Chrome 0.9+
 */
jQuery(function($){
    var C = "carrousel";
    $.fn.carrousel = function(options){
        var el = this.eq(0).data(C);
        var opts = $.extend({}, $.fn.carrousel.defaults, options);
        var ctrls = $.extend({}, $.fn.carrousel.controls);
        var effects = $.extend({}, $.fn.carrousel.effects);
        this.each(function(){
            el = new $carrousel(this, opts, ctrls, effects);
        });
        return opts.api ? el : null;
    };
    $.carrousel = function(e, opts, ctrls, effects){
        this.e = $(e);
        $(e).css('position', 'relative').wrap('<div><div></div></div>');
        if (opts.continuous)
            $(e).html($(e).html() + $(e).html());
        var self = this;
        var tA = new Date();
        this.id = (this.e.attr('id') == "" ? C + '_' + tA.getTime() : this.e.attr('id'));
        this.container = $(e).parent();
        this.container.parent().css('overflow', 'hidden');
        this.aItems = null;
        this.nbItems = 0;
        this.current = 0;
        this.locked = false;
        this.dep = 0;
        this.timerMoving = null;
        this.opts = opts;
        this.controls = ctrls;
        this.effects = effects;
        this.direction = ((opts.direction == 'left') || (opts.direction == 'top') ? 'next' : 'prev');
        this.pos = ((opts.direction == 'left') || (opts.direction == 'right') ? 'left' : 'top');
        this.dir = ((opts.direction == 'right') || (opts.direction == 'bottom') ? -1 : 1);
        this.vertical = (this.pos == 'left' ? false : true);
        this._init();
    };
    var $carrousel = $.carrousel;
    $carrousel.fn = $carrousel.prototype = {
        carrousel: '1.2.1'
    };
    $carrousel.fn.extend = $carrousel.extend = $.extend;
    $carrousel.fn.extend({
        _init: function(){
            var self = this;
            this.aItems = $('> li', this.e);
            this.nbItems = this.aItems.length;
            if (!this.opts.continuous) this.nbItems = this.nbItems * 2;
            this.container.parent().addClass(C).attr('id', this.id + '_div');
            this.container.addClass(C + '_' + C).attr('id', this.id + '_carrousel').css({
                'overflow': 'hidden',
                'position': 'relative'
            });
            $('ul > li ', this.container).each(function(i){
                $(this).children().wrap('<div class="' + C + '_item" rel="' + i + '"></div>');
            });
            this.e.css(this.pos, 0);
            var control = this.opts.controls.split(' ');
            for (var i = 0; i < control.length; i++) {
                if ($.isFunction(this.controls[control[i]])) 
                    this.controls[control[i]](this);
            }
            var effect = this.opts.effects.split(' ');
            for (var i = 0; i < effect.length; i++) {
                if ($.isFunction(this.effects.init[effect[i]])) 
                    this.effects.init[effect[i]](this);
            }
            if (self.opts.auto) {
                setTimeout(function(){
                    self._animate('next');
                }, self.opts.dispTimeout);
            }
        },
        _animate: function(dir){
            dir = (dir == undefined ? this.direction : dir);
            if (!this.locked) {
                clearTimeout(this.timerMoving);
                this.locked = true;
                this.dep = this.dep == 0 ? this.opts.scroll : this.dep;
                if (this.dir == -1) {
                    if (dir == "next") {
                        dir = "prev";
                    }
                    else if (dir == "prev") {
                        dir = "next";
                    }
                }
                if (dir != 'next') {
                    this.dep *= -1;
                }
                var cont = true;
                if (!this.opts.continuous) {
                    if (dir == 'next') {
                        if (this.current == ((this.nbItems / 2) - this.opts.dispNumber)) {
                            cont = false;
                            this.locked = false;
                        }
                    }
                    else {
                        if (this.current == 0) {
                            cont = false;
                            this.locked = false;
                        }
                    }
                }
                if (cont)
                    this._beforeMoving();
            }
        },
        _beforeMoving: function(){
            var effect = this.opts.effects.split(' ');
            for (var i = 0; i < effect.length; i++) {
                if ($.isFunction(this.effects.before[effect[i]])) 
                    this.effects.before[effect[i]](this, (this.dep < 0 ? -1 : 1));
            }
            if (this.dep < 0) {
                var size = 0;
                for (var i = 0; i < Math.abs(this.dep); i++) {
                    var item = $('> li:last', this.e);
                    size += parseInt(item.css(this.vertical ? 'height' : 'width'));
                    $('> li:last', this.e).remove();
                    this.e.prepend(item);
                }
                this.e.css(this.pos, -size);
            }
            this._move();
        },
        _move: function(){
            var self = this;
            if ($.isFunction(this.opts.move)) {
                this.opts.move(this, function(){
                    self._afterMoving();
                });
            }
            else {
                var self = this;
                var size = 0;
                if (this.dep > 0) {
                    for (var i = 0; i < this.dep; i++) {
                        size += parseInt(this.aItems.eq(this._realpos(this.current) + i).css(this.vertical ? 'height' : 'width'));
                    }
                }
                else {
                    for (var i = 0; i < Math.abs(this.dep); i++) {
                        size += parseInt(this.aItems.eq(this._realpos(this.current) - i).css(this.vertical ? 'height' : 'width'));
                    }
                }
                if (this.vertical) {
                    this.e.stop(true, true).animate({
                        top: (this.dep > 0 ? "-=" : "+=") + size + 'px'
                    }, this.opts.speed, this.opts.easing, function(){
                        self._afterMoving();
                    });
                }
                else {
                    this.e.stop(true, true).animate({
                        left: (this.dep > 0 ? "-=" : "+=") + size + 'px'
                    }, this.opts.speed, this.opts.easing, function(){
                        self._afterMoving();
                    });
                }
            }
        },
        _afterMoving: function(){
            if (this.dep > 0) {
                for (var i = 0; i < this.dep; i++) {
                    var item = $('> li:first', this.e);
                    $('> li:first', this.e).remove();
                    this.e.append(item);
                }
                this.e.css(this.pos, 0);
            }
            var self = this;
            this.current = this.current + this.dep;
            if (this.current == -1) {
                this.current = this.nbItems - 1;
            }
            else {
                if (this.current == this.nbItems) {
                    this.current = 0;
                }
                else {
                    this.current = this._realpos(this.current);
                }
            }
            this.dep = 0;
            this.locked = false;
            var effect = this.opts.effects.split(' ');
            for (var i = 0; i < effect.length; i++) {
                if ($.isFunction(this.effects.after[effect[i]])) 
                    this.effects.after[effect[i]](this);
            }
            for (var i = 0; i < this.opts.callbacks.length; i++) {
                this.opts.callbacks[i](this);
            }
            var control = this.opts.controls.split(' ');
            for (var i = 0; i < control.length; i++) {
                if ($.isFunction(this.controls.callback[control[i]])) 
                    this.controls.callback[control[i]](this);
            }
            if (this.opts.auto) {
                this.timerMoving = setTimeout(function(){
                    self._animate('next');
                }, this.opts.dispTimeout);
            }
        },
        _realpos: function(i){
            if (i < 0) i = (this.nbItems / 2) - i;
            return (i < (this.nbItems / 2) ? i : (i - (this.nbItems / 2)));
        },
        start: function(){
            if (!this.opts.auto) {
                this.locked = false;
                this.opts.auto = true;
                this._animate('next');
            }
            return false;
        },
        stop: function(){
            clearTimeout(this.timerMoving);
            this.opts.auto = false;
            return false;
        },
        next: function(){
            this._animate('next');
            return false;
        },
        prev: function(){
            this._animate('prev');
            return false;
        },
        getCurrent: function(){
            return this._realpos(this.current);
        },
        moveTo: function(i){
            if (i > (this.nbItems / 2)) {
                i = (this.nbItems / 2) - 1;
            }
            this.dep = parseInt(i) - parseInt(this.current);
            if (this.dep != 0) {
                this._animate('next');
            }
            return false;
        }
    });
    $.fn.carrousel.defaults = {
        controls: '',
        effects: '',
        easing: '',
        auto: true,
        continuous: true,
        speed: 2000,
        direction: 'left',
        scroll: 1,
        dispTimeout: 1000,
        dispNumber: 3,
        callbacks: [],
        api: false
    };
    $.fn.carrousel.controls = {
        callback: {}
    };
    $.fn.carrousel.effects = {
        init: {},
        before: {},
        after: {}
    };
});
