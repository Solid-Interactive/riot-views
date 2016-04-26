solid-image-spin
    .wrapper
        ol.three-sixty
            li(no-reorder each='{ ringSpinImage in model.ringSpinImages }')
                img.previous-image(src='{ ringSpinImage }' name='frames')

    script.
        'use strict';

        var mobileDetective = require('mobile-detective'),
            _ = require('lodash'),
            BB = require('bluebird');

        this.renderRAF = null; // The request animation frame reference.
        this.isStarted = false;
        this.previousFrame = 0;

        this.pointerStartPosX = 0;
        this.pointerEndPosX = 0;

        this.currentFrame = 0;
        this.endFrame = 0;
        this.dragging = false;

        this.monitorStartTime = null;
        this.monitorInt = 10;
        this.speedMultiplier = 2;

        this.on('before-mount', function() {
            if(mobileDetective.any) {
                // Only load 20 images on mobile.
                this.opts.images = this.opts.images.filter(function(item, index) {
                    return index % 9 === 0;
                });
            }
        });

        this.on('mount', function() {
            window.addEventListener('scroll', this.scrollHandler, false);

            if(!mobileDetective.any) {
                this.ringSection.addEventListener('mousedown', this.startDrag, false);
                document.body.addEventListener('mouseup', this.endDrag, false);
                document.body.addEventListener('mousemove', this.handleDrag, false); // Add to the document so the user can drag outside the image
                this.ringSection.addEventListener('touchstart', this.startDrag, false);
                this.ringSection.addEventListener('touchmove', this.handleDrag, false);
                this.ringSection.addEventListener('touchend', this.endDrag, false);
                clickAndHold.register(this.arrowBack, this.skipBackward.bind(this), 100);
                clickAndHold.register(this.arrowForward, this.skipForward.bind(this), 100);
            }

            this.loadImages(this.opts.images)
                .then(function() {
                    this.endFrame = 1;

                    this.isOnScreen() && this.start();

                    this.root.classList.add('fade-in');
                }.bind(this));
        });

        this.on('unmount', function() {
            window.removeEventListener('scroll', this.scrollHandler, false);

            if(!mobileDetective.any) {
                this.ringSection.removeEventListener('mousedown', this.startDrag, false);
                document.body.removeEventListener('mouseup', this.endDrag, false);
                document.body.removeEventListener('mousemove', this.handleDrag, false);
                this.ringSection.removeEventListener('touchstart', this.startDrag, false);
                this.ringSection.removeEventListener('touchmove', this.handleDrag, false);
                this.ringSection.removeEventListener('touchend', this.endDrag, false);
                clickAndHold.unregister(this.arrowBack);
                clickAndHold.unregister(this.arrowForward);
            }
        });

        this.scrollHandler = _.throttle(function() {
            var isOnScreen = this.isOnScreen();
            if(isOnScreen && !this.isStarted) {
                this.start();
            } else if(!isOnScreen && this.isStarted) {
                this.stop();
            }
        }.bind(this), 700);

        this.isOnScreen = function() {
            if(this.ringSection.getBoundingClientRect().bottom < 0) { // Element bottom is off the top of the screen.
                return false;
            } else if(this.ringSection.getBoundingClientRect().top > (window.scrollY + window.innerHeight)) { // Element top is off the bottom of the viewport.
                return false;
            } else {
                return true;
            }
        };

        this.start = function() {
            console.log('STARTED');
            this.renderRAF = this.getRequestAnimationFrame()(this.render);
            this.isStarted = true;
        };

        this.stop = function() {
            var cancelAnimationFrame = window.cancelAnimationFrame || window.mozCancelAnimationFrame;

            this.renderRAF = cancelAnimationFrame(this.renderRAF);
            this.isStarted = false;
        };

        this.render = function() {
            var currentFrame = this.getCurrentFrame();

            if(currentFrame !== this.previousFrame) {
                this.frames[this.previousFrame].classList.remove('current-image');
                this.frames[this.previousFrame].classList.add('previous-image');

                this.frames[currentFrame].classList.remove('previous-image');
                this.frames[currentFrame].classList.add('current-image');

                this.previousFrame = currentFrame;
            }

            this.renderRAF = this.getRequestAnimationFrame()(this.render);
        }.bind(this);

        this.getRequestAnimationFrame = function() {
            return window.requestAnimationFrame || window.mozRequestAnimationFrame || window.webkitRequestAnimationFrame || window.msRequestAnimationFrame;
        };

        this.getCurrentFrame = function() {
            var frameEasing = this.endFrame < this.currentFrame ? Math.floor((this.endFrame - this.currentFrame) * 0.1) : Math.ceil((this.endFrame - this.currentFrame) * 0.1),
                adjustedCurrentFrame = -Math.ceil((this.currentFrame += frameEasing) % this.frames.length);

            if (adjustedCurrentFrame < 0) {
                adjustedCurrentFrame += (this.frames.length - 1);
            };

            return adjustedCurrentFrame;
        };

        this.startDrag = function(event) {
            // Prevents the original event handler behaciour
            event.preventDefault();
            // Stores the pointer x position as the starting position
            this.pointerStartPosX = _getPointerEvent(event).pageX;
            // Tells the pointer tracking function that the user is actually dragging the pointer and it needs to track the pointer changes
            this.dragging = true;
        }.bind(this);

        this.endDrag = function(event) {
            // Prevents the original event handler behaciour
            event.preventDefault();
            // Tells the pointer tracking function that the user finished dragging the pointer and it doesn't need to track the pointer changes anymore
            this.dragging = false;
        }.bind(this);

        this.handleDrag = function(event) {
            // Prevents the original event handler behaciour
            event.preventDefault();
            // Starts tracking the pointer X position changes
            this.dragging && this.trackPointer(event);
        }.bind(this);

        // Tracks the pointer X position changes and calculates the "endFrame"
        this.trackPointer = function(event) {
            var pointerDistance = 0;

            // Stores the last x position of the pointer
            this.pointerEndPosX = this.dragging && _getPointerEvent(event).pageX;

            // Checks if there is enough time past between this and the last time period of tracking
            if(this.monitorStartTime < new Date().getTime() - this.monitorInt) {
                // Calculates the distance between the pointer starting and ending position during the last tracking time period
                pointerDistance = this.pointerEndPosX - this.pointerStartPosX;

                // Calculates the endFrame using the distance between the pointer X starting and ending positions and the "speedMultiplier" values
                this.endFrame = this.currentFrame + Math.ceil((this.frames.length - 1) * this.speedMultiplier * (pointerDistance / this.ringSection.clientWidth));

                // restarts counting the pointer tracking period
                this.monitorStartTime = new Date().getTime();
                // Stores the the pointer X position as the starting position (because we started a new tracking period)

                this.pointerStartPosX = this.dragging && _getPointerEvent(event).pageX;
            }
        };

        this.loadImages = function(imagesArray) {
            return BB.all(imagesArray.map(function(url) {
                return new BB(function(resolve, reject) {
                    setTimeout(function() {
                        var imageTag = new window.Image();

                        imageTag.onload = resolve;
                        imageTag.onerror = reject;

                        imageTag.src = url;
                    }, 0);
                });
            }));
        };

        this.skipBackward = function() {
            this.endFrame = this.currentFrame - 10;
        };

        this.skipForward = function() {
            this.endFrame = this.currentFrame + 10;
        };

        this.turnRingAround = function() {
            if(mobileDetective.any) {
                this.endFrame = this.currentFrame + 10;
            } else {
                this.endFrame = this.currentFrame + 90;
            }
        };

        function _getPointerEvent(event) {
            return event.targetTouches ? event.targetTouches[0] : event;
        }

