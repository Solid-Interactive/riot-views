solid-modal
    .container(if="{ modalOpen }")
        <yield/>
    style(scoped type="scss").
        @import "styles/solid-modal.scss";
    script.
        var BB = require('bluebird'),
            self = this;

        self.modalOpen = false;
        self.promise = null;
        self.resolve = null;
        self.reject = null;

        self.show = show;
        self.hide = hide;
        self.close = close;
        self.cancel = cancel;

        function show() {
            self.modalOpen = true;
            self.promise = new BB(function(resolve, reject) {
                self.resolve = resolve;
                self.reject = reject;
            });
            self.update();
            return self.promise;
        }

        function hide() {
            self.modalOpen = false;
            self.update();
        }

        function close() {
            self.hide();
            self.resolve();
            self.update();
        }

        function cancel() {
            self.hide();
            self.reject();
            self.update();
        }