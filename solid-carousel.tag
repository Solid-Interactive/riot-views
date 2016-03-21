solid-carousel
    div(each="{ image in model.images }")
        h3(if="{ image.title }") image.title
        img(src="{ image.url }")

    style(scoped type="scss").

    script.
        'use strict';

        this.model = {
            images : this.opts.images
        };
