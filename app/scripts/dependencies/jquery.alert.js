/*
 * Jquery Message
 * 
 * normal use
 * $.alert("Content",{
 *      title : "Title",
 *      position : ['left', [-0.1,0]]
 * })
 * 
 * shortcut use
 * $.alert("content","title");
 * 
 * position types
 * top-left,top-right,bottom-left,bottom-right,center 大小写都可以哦
 */

(function ($) {
    $.alert_ext = {
        // default params
        defaults: {
            autoClose: true,  // TRUE, if u want it to be closed automatically
            closeTime: 5000,   // Duration for which the alert will be displayed before the automatic close
            withTime: false, // 
            type: 'danger',  // type of alert
            position: ['center', [-0.42, 0]], 
            title: false, // title of alert
            close: '',   // label of Close Button
            speed: 'normal',   //
            isOnly: true, //only one alert at one time?
            minTop: 10, //
            onShow: function () {
            },  // callback function
            onClose: function () {
            }  // callback function
        },

        // template of the alert box
        tmpl: '<div class="alert alert-dismissable ${State}"><button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button><h4>${Title}</h4><p>${Content}</p></div>',

        // 
        init: function (msg, options) {
            this.options = $.extend({}, this.defaults, options);

            this.create(msg);
            this.set_css();

            this.bind_event();

            return this.alertDiv;
        },

        template: function (tmpl, data) {
            $.each(data, function (k, v) {
                tmpl = tmpl.replace('${' + k + '}', v);
            });
            return $(tmpl);
        },

        // 
        create: function (msg) {
            this.alertDiv = this.template(this.tmpl, {
                State: 'alert-' + this.options.type,
                Title: this.options.title,
                Content: msg
            }).hide();
            if (!this.options.title) {
                $('h4', this.alertDiv).remove();
                $('p', this.alertDiv).css('margin-right', '15px');
            }
            if (this.options.isOnly) {
                $('body > .alert').remove();
            }
            this.alertDiv.appendTo($('body'));
        },

        // 
        set_css: function () {
            var alertDiv = this.alertDiv;

            // 
            alertDiv.css({
                'position': 'absolute',
                'z-index': 10001 + $(".alert").length
            });

            // 
            var ie6 = 0;
            if ($.browser && $.browser.msie && $.browser.version == '6.0') {
                alertDiv.css('position', 'absolute');
                ie6 = $(window).scrollTop();
            }
            
            // 
            var position = this.options.position,
                pos_str = position[0].split('-'),
                pos = [0, 0];
            if (position.length > 1) {
                pos = position[1];
            }
            
            alertDiv.css('width', "400");
            alertDiv.css('top', pos[0] - 30);
            alertDiv.css('left', pos[1] - 450);
            
            var scrollTop = $(window).scrollTop();
            var clientHeight = $(window).height();
            if (pos[0] > scrollTop + clientHeight - 200){
            	$(window).scrollTop(scrollTop + 200);
            }
        },

        bind_event: function () {
            this.bind_show();
            this.bind_close();

            if ($.browser && $.browser.msie && $.browser.version == '6.0') {
                this.bind_scroll();
            }
        },

        bind_show: function () {
            var ops = this.options;
            this.alertDiv.fadeIn(ops.speed, function () {
                ops.onShow($(this));
            });
        },

        bind_close: function () {
            var alertDiv = this.alertDiv,
                ops = this.options,
                closeBtn = $('.close', alertDiv).add($(this.options.close, alertDiv));

            closeBtn.bind('click', function (e) {
                alertDiv.fadeOut(ops.speed, function () {
                    $(this).remove();
                    ops.onClose($(this));
                });
                e.stopPropagation();
            });

            if (this.options.autoClose) {
                var time = parseInt(this.options.closeTime / 1000);
                if (this.options.withTime) {
                    $('p', alertDiv).append('<span>...<em>' + time + '</em></span>');
                }
                var timer = setInterval(function () {
                    $('em', alertDiv).text(--time);
                    if (!time) {
                        clearInterval(timer);
                        closeBtn.trigger('click');
                    }
                }, 1000);
            }
        },

        bind_scroll: function () {
            var alertDiv = this.alertDiv,
                top = alertDiv.offset().top - $(window).scrollTop();
            $(window).scroll(function () {
                alertDiv.css("top", top + $(window).scrollTop());
            })
        },

        check_mobile: function () {
            var userAgent = navigator.userAgent;
            var keywords = ['Android', 'iPhone', 'iPod', 'iPad', 'Windows Phone', 'MQQBrowser'];
            for (var i in keywords) {
                if (userAgent.indexOf(keywords[i]) > -1) {
                    return keywords[i];
                }
            }
            return false;
        }
    };

    $.alert = function (msg, arg) {
        if ($.alert_ext.check_mobile()) {
            alert(msg);
            return;
        }
        if (!$.trim(msg).length) {
            return false;
        }
        if ($.type(arg) === "string") {
            arg = {
                title: arg
            }
        }
        if (arg && arg.type == 'error') {
            arg.type = 'danger';
        }
        return $.alert_ext.init(msg, arg);
    }
})(jQuery);