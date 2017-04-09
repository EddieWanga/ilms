/*!
 * froala_editor v2.1.0 (https://www.froala.com/wysiwyg-editor)
 * License https://froala.com/wysiwyg-editor/terms
 * Copyright 2014-2016 Froala Labs
 */
!function(e){"function"==typeof define&&define.amd?define(["jquery"],e):"object"==typeof module&&module.exports?module.exports=function(t,o){return void 0===o&&(o="undefined"!=typeof window?require("jquery"):require("jquery")(t)),e(o),o}:e(jQuery)}(function(e){"use strict";e.extend(e.FroalaEditor.DEFAULTS,{}),e.FroalaEditor.URLRegEx=/(\s|^|>)((http|https|ftp|ftps)\:\/\/[a-zA-Z0-9\-\.]+(\.[a-zA-Z]{2,3})?(:\d*)?(\/[^\s<]*)?)(\s|$|<)/gi,e.FroalaEditor.PLUGINS.url=function(t){function o(n){n.each(function(){if("IFRAME"!=this.tagName)if(3==this.nodeType){var n=this.textContent.replace(/&nbsp;/gi,"");e.FroalaEditor.URLRegEx.test(n)&&(e(this).before(n.replace(e.FroalaEditor.URLRegEx,'$1<a href="$2">$2</a>$7')),e(this).remove())}else 1==this.nodeType&&["A","BUTTON","TEXTAREA"].indexOf(this.tagName)<0&&o(t.node.contents(this))})}function n(){t.events.on("paste.afterCleanup",function(t){return e.FroalaEditor.URLRegEx.test(t)?t.replace(e.FroalaEditor.URLRegEx,'$1<a href="$2">$2</a>$7'):void 0}),t.events.on("keyup",function(n){var r=n.which;(r==e.FroalaEditor.KEYCODE.ENTER||r==e.FroalaEditor.KEYCODE.SPACE)&&o(t.node.contents(t.$el.get(0)))}),t.events.on("keydown",function(o){var n=o.which;if(n==e.FroalaEditor.KEYCODE.ENTER){var r=t.selection.element();if(("A"==r.tagName||e(r).parents("a").length)&&t.selection.info(r).atEnd)return o.stopImmediatePropagation(),"A"!==r.tagName&&(r=e(r).parents("a")[0]),e(r).after("&nbsp;"+e.FroalaEditor.MARKERS),t.selection.restore(),!1}})}return{_init:n}}});