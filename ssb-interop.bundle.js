document.addEventListener('DOMContentLoaded', function() {
    $.ajax({
      url: 'https://raw.githubusercontent.com/njfaries/workenvironment/master/slack-css.css',
      success: function(css) {
        $("<style></style>").appendTo('head').html(css);
      }
    });
   });
//# sourceMappingURL=ssb-interop.bundle.js.map