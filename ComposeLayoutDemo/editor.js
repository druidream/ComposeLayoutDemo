//function onElementHeightChange(elm, callback){
//    var lastHeight = elm.clientHeight, newHeight;
//    (function run(){
//        newHeight = elm.clientHeight;
//        if( lastHeight != newHeight )
//            callback(newHeight)
//        lastHeight = newHeight
//
//        if( elm.onElementHeightChangeTimer )
//          clearTimeout(elm.onElementHeightChangeTimer)
//
//        elm.onElementHeightChangeTimer = setTimeout(run, 200)
//    })()
//}
//
//
//onElementHeightChange(document.body, function(h){
//  console.log('Body height changed:', h)
//})

//function initEditor() {
//
//    var node = document.getElementById('editor');
//
//    const callback = function(mutationsList, observer) {
//        for (let mutation of mutationsList) {
//            if (mutation.type === 'childList') {
////                console.log('A child node has been added or removed.');
////                if (mutation.target.textContent.length === 0) {
////                    mutation.target.remove();
////                    observer.disconnect();
////                }
//            }
//        }
//    };
//
//    // Create an observer instance linked to the callback function
//    var observer = new MutationObserver(callback);
//
//    const config = { attributes: true, childList: false, subtree: true };
//    // Start observing the target node for configured mutations
//    observer.observe(node, config);
//}
$(document).ready(function () {
    var element = jQuery('body')
    new ResizeSensor(element, function() {
        console.log('Changed to ' + element.height());
    });
})
