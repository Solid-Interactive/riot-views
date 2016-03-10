'use strict';

var riot = require('riot'),
    testView = require('./test.tag');

require('../sc-tabs.tag');
require('../sc-clamp.tag');

riot.mount(testView, {
    tabs : [
        { hash : 'home', label : 'Home'},
        { hash : 'about', label : 'About' },
        { hash : 'products', label : 'Products' }
    ],
    callback : function(index) {
        console.log('new tabs index', index);
    }
});
