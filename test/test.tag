test
    solid-tabs(tabs="{ opts.tabs }" callback="{ opts.callback }")
    br
    br
    br
    input(type="text" value="Open Modal" onclick="{ openModal }")
    solid-modal(name="modal1")
        solid-modal-close
        p This is a modal1
    solid-modal(name="modal2")
        solid-modal-close
        p This is a modal2
    br
    br
    br
    solid-clamp(lines="1").
        This should be clamped.
        This should be clamped.
        This should be clamped.
        This should be clamped.
        This should be clamped.
        This should be clamped.
        This should be clamped.
        This should be clamped.
        This should be clamped.
        This should be clamped.
        This should be clamped.
        This should be clamped.
        This should be clamped.
        This should be clamped.
    br
    br
    br
    solid-carousel(images="{ opts.images }" transition="{ slide }" callback="{ opts.imagesCallback }")
    br
    br
    solid-raw(content='{ opts.htmlString }')
    br
    br
    br
    div(style='position: relative; width: 100%; height: 500px;')
        solid-background-video(mp4='{ opts.backgroundVideo.mp4 }' poster='{ opts.backgroundVideo.poster }' maxwidthforplayback='{ opts.backgroundVideo.maxwidthforplayback }')
    br
    br
    br
    script.
        var self = this;
        this.openModal = openModal;

        function openModal() {
            self.tags
                    .modal1.show()
                    .then(function() {
                        return self.tags.modal2.show();
                    });
        }