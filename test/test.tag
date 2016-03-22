test
    solid-tabs(tabs="{ opts.tabs }" callback="{ opts.callback }")
    br
    br
    br
    input(type="text" value="Open Modal" onclick="{ openModal }")
    solid-modal(name="modal1")
        solid-modal-close
        p This is a modal
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
    script.
        this.openModal = openModal;

        function openModal() {
            this.tags.modal1.show();
        }