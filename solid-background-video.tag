solid-background-video
    .video-block(name='videoWrapper')
        video(if='{ canShowVideo }' name='backgroundVideo' muted=true autoplay=true playbackRate=1 loop=true)
            source(if='{ canShowVideo && hasMp4 }' src='{ opts.mp4 }' type='video/mp4')
            source(if='{ canShowVideo && hasWebm }' src='{ opts.webm }' type='video/webm')
    .video-poster(if='{ hasPoster }' name='videoPoster' style='background-image: { opts.poster };').showing
    style(scoped type='scss').
        @import 'node_modules/riot-views/styles/solid-background-video.scss';
    script.
        'use strict';

        var listenOnce = require('listen-once'),
            throttle = require('lodash.throttle');
            
        this.hasMp4 = false;
        this.hasWebM = false;
        this.hasPoster = false;
        this.hasMaxWidthSet = false;

        this.on('before-mount', function() {
            _ensureVideoOptions.call(this);

            this.canShowVideo = this.hasMaxWidthSet && (window.innerWidth > this.opts.maxwidthforplayback) && this.hasPoster;
        });

        this.on('mount', function() {
            listenOnce(this.backgroundVideo, 'canplaythrough', this.resizeVideo); // Resize the video, when it's loaded

            listenOnce(this.backgroundVideo, 'playing', function() { // Make it visible, when it's already playing
                this.backgroundVideo.classList.add('loaded');
                this.videoPoster.classList.remove('showing');
            }.bind(this));

            window.addEventListener('resize', this.resizeVideo, false);
        });

        this.on('unmount', function() {
            window.removeEventListener('resize', this.resizeVideo, false);
        });

        this.resizeVideo = throttle(function() {
                // Get a native video size
            var videoHeight = this.backgroundVideo.videoHeight,
                videoWidth = this.backgroundVideo.videoWidth,

                // Get a wrapper size
                wrapperHeight = this.videoWrapper.offsetHeight,
                wrapperWidth = this.videoWrapper.offsetWidth;

            if (wrapperWidth / videoWidth > wrapperHeight / videoHeight) {
                this.backgroundVideo.style.width = wrapperWidth + 2 + 'px'; // +2 pixels to prevent an empty space after transformation
                this.backgroundVideo.style.height = 'auto';
            } else {
                this.backgroundVideo.style.width = 'auto';
                this.backgroundVideo.style.height = wrapperHeight + 2 + 'px'; // +2 pixels to prevent an empty space after transformation
            }
        }.bind(this), 200);
        
        function _ensureVideoOptions()  {
            if(!this.opts.mp4) {
                console.log('!!! THE BACKGROUND VIDEO TAG MUST HAVE A MP4 FILE PASSED IN AS `mp4`');
            } else {
                this.hasMp4 = true;
            }
            
            if(!this.opts.webm) {
                console.log('IT IS RECMOMENDED THAT YOU ALSO PASS A WEBM FILE TO THE SOLID BACKGOUND VIDEO, `webm`');
            } else {
                this.hasWebM = true
            }
            
            if(!this.opts.poster) {
                console.log('YOU MUST PASS A POSTER IMAGE TO THE SOLID BACKGROUND VIDEO TAG, `poster`');
            } else {
                this.hasPoster = true;
            }
            
            if(!this.opts.maxwidthforplayback) {
                console.log('YOU MUST PASS A MAX WIDTH FOR PLAYBACK TO THE SOLID BACKGROUND VIDEO TAG, `maxwidthforplayback`');
            } else {
                this.hasMaxWidthSet = true;
            }
        }