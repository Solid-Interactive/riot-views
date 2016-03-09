sc-clamp
    <yield/>
    script.
        'use strict';
        var clamp = require('clamp-js');

        this.on('mount', function () {
            clamp(this.root, {clamp: this.opts.lines });
        });
