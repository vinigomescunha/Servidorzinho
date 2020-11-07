var showModalHelp = document.querySelector('.showModalHelp');
var showModalHelpButton = document.querySelector('.show-modal-help');
if (!showModalHelp.showModal) {
  dialogPolyfill.registerDialog(showModalHelp);
}
showModalHelpButton.addEventListener('click', function () {
  showModalHelp.showModal();
});
showModalHelp.querySelector('.close').addEventListener('click', function () {
  showModalHelp.close();
});