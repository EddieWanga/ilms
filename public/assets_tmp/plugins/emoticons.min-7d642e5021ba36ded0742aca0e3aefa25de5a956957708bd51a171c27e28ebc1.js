/*!
 * froala_editor v2.1.0 (https://www.froala.com/wysiwyg-editor)
 * License https://froala.com/wysiwyg-editor/terms
 * Copyright 2014-2016 Froala Labs
 */
!function(e){"function"==typeof define&&define.amd?define(["jquery"],e):"object"==typeof module&&module.exports?module.exports=function(o,t){return void 0===t&&(t="undefined"!=typeof window?require("jquery"):require("jquery")(o)),e(t),t}:e(jQuery)}(function(e){"use strict";e.extend(e.FroalaEditor.POPUP_TEMPLATES,{emoticons:"[_BUTTONS_][_EMOTICONS_]"}),e.extend(e.FroalaEditor.DEFAULTS,{emoticonsStep:8,emoticonsSet:[{code:"1f600",desc:"Grinning face"},{code:"1f601",desc:"Grinning face with smiling eyes"},{code:"1f602",desc:"Face with tears of joy"},{code:"1f603",desc:"Smiling face with open mouth"},{code:"1f604",desc:"Smiling face with open mouth and smiling eyes"},{code:"1f605",desc:"Smiling face with open mouth and cold sweat"},{code:"1f606",desc:"Smiling face with open mouth and tightly-closed eyes"},{code:"1f607",desc:"Smiling face with halo"},{code:"1f608",desc:"Smiling face with horns"},{code:"1f609",desc:"Winking face"},{code:"1f60a",desc:"Smiling face with smiling eyes"},{code:"1f60b",desc:"Face savoring delicious food"},{code:"1f60c",desc:"Relieved face"},{code:"1f60d",desc:"Smiling face with heart-shaped eyes"},{code:"1f60e",desc:"Smiling face with sunglasses"},{code:"1f60f",desc:"Smirking face"},{code:"1f610",desc:"Neutral face"},{code:"1f611",desc:"Expressionless face"},{code:"1f612",desc:"Unamused face"},{code:"1f613",desc:"Face with cold sweat"},{code:"1f614",desc:"Pensive face"},{code:"1f615",desc:"Confused face"},{code:"1f616",desc:"Confounded face"},{code:"1f617",desc:"Kissing face"},{code:"1f618",desc:"Face throwing a kiss"},{code:"1f619",desc:"Kissing face with smiling eyes"},{code:"1f61a",desc:"Kissing face with closed eyes"},{code:"1f61b",desc:"Face with stuck out tongue"},{code:"1f61c",desc:"Face with stuck out tongue and winking eye"},{code:"1f61d",desc:"Face with stuck out tongue and tightly-closed eyes"},{code:"1f61e",desc:"Disappointed face"},{code:"1f61f",desc:"Worried face"},{code:"1f620",desc:"Angry face"},{code:"1f621",desc:"Pouting face"},{code:"1f622",desc:"Crying face"},{code:"1f623",desc:"Persevering face"},{code:"1f624",desc:"Face with look of triumph"},{code:"1f625",desc:"Disappointed but relieved face"},{code:"1f626",desc:"Frowning face with open mouth"},{code:"1f627",desc:"Anguished face"},{code:"1f628",desc:"Fearful face"},{code:"1f629",desc:"Weary face"},{code:"1f62a",desc:"Sleepy face"},{code:"1f62b",desc:"Tired face"},{code:"1f62c",desc:"Grimacing face"},{code:"1f62d",desc:"Loudly crying face"},{code:"1f62e",desc:"Face with open mouth"},{code:"1f62f",desc:"Hushed face"},{code:"1f630",desc:"Face with open mouth and cold sweat"},{code:"1f631",desc:"Face screaming in fear"},{code:"1f632",desc:"Astonished face"},{code:"1f633",desc:"Flushed face"},{code:"1f634",desc:"Sleeping face"},{code:"1f635",desc:"Dizzy face"},{code:"1f636",desc:"Face without mouth"},{code:"1f637",desc:"Face with medical mask"}],emoticonsButtons:["emoticonsBack","|"],emoticonsUseImage:!0}),e.FroalaEditor.PLUGINS.emoticons=function(o){function t(){var e=o.$tb.find('.fr-command[data-cmd="emoticons"]'),t=o.popups.get("emoticons");if(t||(t=s()),!t.hasClass("fr-active")){o.popups.refresh("emoticons"),o.popups.setContainer("emoticons",o.$tb);var c=e.offset().left+e.outerWidth()/2,i=e.offset().top+(o.opts.toolbarBottom?10:e.outerHeight()-10);o.popups.show("emoticons",c,i,e.outerHeight())}}function c(){o.popups.hide("emoticons")}function s(){var e="";o.opts.toolbarInline&&o.opts.emoticonsButtons.length>0&&(e='<div class="fr-buttons fr-emoticons-buttons">'+o.button.buildList(o.opts.emoticonsButtons)+"</div>");var t={buttons:e,emoticons:i()},c=o.popups.create("emoticons",t);return o.tooltip.bind(c,".fr-emoticon"),c}function i(){for(var e='<div style="text-align: center">',t=0;t<o.opts.emoticonsSet.length;t++)0!==t&&t%o.opts.emoticonsStep===0&&(e+="<br>"),e+='<span class="fr-command fr-emoticon" data-cmd="insertEmoticon" title="'+o.language.translate(o.opts.emoticonsSet[t].desc)+'" data-param1="'+o.opts.emoticonsSet[t].code+'">'+(o.opts.emoticonsUseImage?'<img src="https://cdnjs.cloudflare.com/ajax/libs/emojione/2.0.1/assets/svg/'+o.opts.emoticonsSet[t].code+'.svg"/>':"&#x"+o.opts.emoticonsSet[t].code+";")+"</span>";return o.opts.emoticonsUseImage&&(e+='<p style="font-size: 12px; text-align: center; padding: 0 5px;">Emoji free by <a href="http://emojione.com/" target="_blank" rel="nofollow">Emoji One</a></p>'),e+="</div>"}function n(t,c){o.html.insert('<span class="fr-emoticon'+(c?" fr-emoticon-img":"")+'"'+(c?' style="background: url('+c+')"':"")+">"+(c?" ":t)+"</span>"+e.FroalaEditor.MARKERS,!0)}function d(){o.popups.hide("emoticons"),o.toolbar.showInline()}function a(){o.events.on("html.get",function(t){for(var c=0;c<o.opts.emoticonsSet.length;c++){var s=o.opts.emoticonsSet[c],i=e("<div>").html(s.code).text();t=t.split(i).join(s.code)}return t});var t=function(){if(!o.selection.isCollapsed())return!1;var t=o.selection.element(),c=o.selection.endElement();if(e(t).hasClass("fr-emoticon"))return t;if(e(c).hasClass("fr-emoticon"))return c;var s=o.selection.ranges(0),i=s.startContainer;if(i.nodeType==Node.ELEMENT_NODE&&i.childNodes.length>0&&s.startOffset>0){var n=i.childNodes[s.startOffset-1];if(e(n).hasClass("fr-emoticon"))return n}return!1};o.events.on("keydown",function(c){if(o.keys.isCharacter(c.which)&&o.selection.inEditor()){var s=o.selection.ranges(0),i=t();i&&(0===s.startOffset?e(i).before(e.FroalaEditor.MARKERS+e.FroalaEditor.INVISIBLE_SPACE):e(i).after(e.FroalaEditor.INVISIBLE_SPACE+e.FroalaEditor.MARKERS),o.selection.restore())}}),o.events.on("keyup",function(){for(var t=o.$el.get(0).querySelectorAll(".fr-emoticon"),c=0;c<t.length;c++)"undefined"!=typeof t[c].textContent&&0===t[c].textContent.replace(/\u200B/gi,"").length&&e(t[c]).remove()})}return{_init:a,insert:n,showEmoticonsPopup:t,hideEmoticonsPopup:c,back:d}},e.FroalaEditor.DefineIcon("emoticons",{NAME:"smile-o"}),e.FroalaEditor.RegisterCommand("emoticons",{title:"Emoticons",undo:!1,focus:!0,refreshOnCallback:!1,popup:!0,callback:function(){this.popups.isVisible("emoticons")?(this.$el.find(".fr-marker")&&(this.events.disableBlur(),this.selection.restore()),this.popups.hide("emoticons")):this.emoticons.showEmoticonsPopup()},plugin:"emoticons"}),e.FroalaEditor.RegisterCommand("insertEmoticon",{callback:function(e,o){this.emoticons.insert("&#x"+o+";",this.opts.emoticonsUseImage?"https://cdnjs.cloudflare.com/ajax/libs/emojione/2.0.1/assets/svg/"+o+".svg":null),this.emoticons.hideEmoticonsPopup()}}),e.FroalaEditor.DefineIcon("emoticonsBack",{NAME:"arrow-left"}),e.FroalaEditor.RegisterCommand("emoticonsBack",{title:"Back",undo:!1,focus:!1,back:!0,refreshAfterCallback:!1,callback:function(){this.emoticons.back()}})});