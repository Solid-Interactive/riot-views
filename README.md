# Riot Views

This is a collection of reusable riot views. They can be used as components to build up functionality.

Each view is prefixed with `solid-` (Solid Compnonent).

## Example

http://solid-interactive.github.io/riot-views/

## These docs in alternative format

http://documentup.com/solid-interactive/riot-views

## Guide

### `solid-clamp`

```javascript
require('riot-views/solid-clamp.tag')
```

Dependencies : `clamp-js`

A Clamp can be used to limit the number of lines displayed and ellipsize the last line i fthere is overflow. Internally
it uses a `<yield />`.

Attributes:
* lines: number of lines to clamp to - default: 1

Content:
* Text you want clamped.

```html
<solid-clamp lines="2">
    The following text will be clamped to
    two lines even if the text is longer
    than two lines.
</solid-clamp>
```

### Modals

#### `solid-modal`

```javascript
require('riot-views/solid-modal.tag')
```

Dependencies : `bluebird`

This modal can be openend using `tag.show()`. This will return a promise that is resolved if the modal is closed, or
 rejected if the modal is canceled.

```html
<my-view>
    <p onclick="{ openModal }">Open modal</p>
    <solid-modal name="modal">
        <p>
            This is a modal.
        </p>
    </solid-modal>
    <script>
        this.openModal = function openModal() {
            this.tags.modal.show().then(...).catch(...);
        }
    </script>
</my-view>
```



#### `solid-modal-close`

```javascript
require('riot-views/solid-modal-close.tag')
```

Dependencies : none

Clicking on this view will trigger close on the parent view.

```html
<solid-modal>
    <solid-modal-close> </solid-modal-close>
    <p>
        This is a modal.
    </p>
</solid-modal>
```

### `solid-raw`

```javascript
require('riot-views/solid-raw.tag')
```

Dependencies : none

Will output html string. Riot by default will not template html. Use this tag when you want to template html.

Attributes:
* content: an html string.

```javascript
riot.mount(rawView, {
    htmlString : '<p>Lorem ipsum dolor sit amet, <strong>consectetur</strong> adipisicing elit, sed do <strong>eiusmod</strong> tempor incididunt ut labore et dolore magna aliqua.</p>'
});
```

```html
<solid-raw content="{ opts.htmlString }"> </solid-raw>
```

### `solid-tabs`

```javascript
require('riot-views/solid-tabs.tag')
```

Dependencies : `velocity`

Tabs with an animated underline.

Attributes:
* tabs: an array of tabs. Each tab item should have a `hash` and a `label` property.
* callback: an optional function that gets called with the active index on each user click.

```javascript
riot.mount(tabsView, {
    tabs : [
        { hash : 'home',        label : 'Home'},
        { hash : 'about',       label : 'About' },
        { hash : 'products',    label : 'Products' }
    ],
    callback : function(index) {
        console.log('new tabs index', index);
    }
});
```

```html
<solid-tabs tabs="{ opts.tabs }" callback="{ opts.callback }"> </solid-tabs>
```

### `solid-background-video`

```javascript
require('riot-views/solid-background-video.tag');
```

Dependencies : [`listen-once`](https://github.com/Duder-onomy/listen-once), [`lodash.throttle`](https://www.npmjs.com/package/lodash.throttle)

Big background video, will autoplay and loop. Will resize with browser and maintain aspect ratio while covering parent tag.

Attributes:
* `mp4` : REQUIRED. A path to a mp4 file.
* `webm` : RECOMMENDED. A path to a webm file.
* `poster` : REQUIRED. A poster image to show when the browser does not support, OR, when when on mobile.
* `maxwidthforplayback` : REQUIRED. A pixel size that will be the max width the video will play. If below this value, show the poster (mobile).
* `playonmobile` : RECOMMENDED. If you want to cancel playback on any mobile devices (not just by the width displayed above.)

```javascript
riot.mount(backgroundVideoView, {
    mp4 : 'https://media.w3.org/2010/05/sintel/trailer.mp4',
    webm : 'https://media.w3.org/2010/05/sintel/trailer.webm',
    poster : 'http://placehold.it/800x500',
    maxwidthforplayback : 480,
    playonmobile : true
});
```

```html
<div style='position: relative; width: 100%; height: 500px;'>
    <solid-background-video mp4='{ opts.backgroundVideo.mp4 }' poster='{ opts.backgroundVideo.poster }' maxwidthforplayback='{ opts.backgroundVideo.maxwidthforplayback }'/>
</div>
```

#### Important
When using this tag, it must be wrapped in a relatively positioned parent, with a height and a width set.
