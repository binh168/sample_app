import I18n from 'i18n-js/index.js.erb'
$('#micropost_picture').on('change', function() {
  var size_in_megabytes = this.files[0].size/I18n.t('gb')/I18n.t('gb');
  if (size_in_megabytes > I18n.t('picture_size')) {
    alert(I18n.t('alert'));
  }
});
