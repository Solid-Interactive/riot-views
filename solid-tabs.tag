solid-tabs
    div
        ul
            li(no-reorder each="{ item, index in model.tabs }" style="{ parent.itemWidth() }" class="{ active : active(index) }")
                a(href="{ '#' + item.hash }" onclick="{ activate }") { item.label }
        .underline(name='underline' style="{ itemWidth() }")
    style(scoped type="scss").
        @import "node_modules/riot-views/styles/solid-tabs.scss";
    script.
        var velocity = require('velocity-animate');

        this.model = {
            activeIndex : 0,
            tabs : this.opts.tabs
        }

        this.callback = this.opts.callback || function() { };

        this.itemWidth = itemWidth;
        this.activate = activate;
        this.active = active;

        function itemWidth() {
            return 'width : ' + (100 / this.opts.tabs.length) + '%;';
        }

        function activate() {
            this.model.activeIndex = this.index;

            velocity(this.underline, {
               translateX : this.model.activeIndex * this.underline.offsetWidth
            },
            "spring");

            this.callback(this.model.activeIndex);
        }

        function active(index) {
            return this.model.activeIndex === index;
        }