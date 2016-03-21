'use strict';

var riot = require('riot'),
    testView = require('./test.tag');

require('../solid-carousel.tag');
require('../solid-clamp.tag');
require('../solid-tabs.tag');
require('../solid-raw.tag');

riot.mount(testView, {
    tabs : [
        { hash : 'home', label : 'Home'},
        { hash : 'about', label : 'About' },
        { hash : 'products', label : 'Products' }
    ],
    callback : function(index) {
        console.log('new tabs index', index);
    },
    images : [
        {
            title : 'Header',
            url : 'img/header.png'
        },
        {
            title : 'Message',
            url : 'img/message.png'
        }
    ]
    htmlString : '<p>Lorem ipsum dolor sit amet, <strong>consectetur</strong> adipisicing elit, sed do <strong>eiusmod</strong> tempor incididunt ut labore et dolore magna aliqua.</p>'
});
