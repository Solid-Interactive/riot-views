'use strict';

var riot = require('riot'),
    testView = require('./test.tag');

require('../solid-clamp.tag');
require('../solid-modal.tag');
require('../solid-modal-close.tag');
require('../solid-tabs.tag');
require('../solid-raw.tag');
require('../solid-background-video.tag');

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
    ],
    htmlString : '<p>Lorem ipsum dolor sit amet, <strong>consectetur</strong> adipisicing elit, sed do <strong>eiusmod</strong> tempor incididunt ut labore et dolore magna aliqua.</p>',
    backgroundVideo : {
        mp4 : 'https://media.w3.org/2010/05/sintel/trailer.mp4',
        poster : 'http://placehold.it/800x500',
        maxwidthforplayback : 480
    }
});
