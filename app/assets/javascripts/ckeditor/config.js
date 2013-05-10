CKEDITOR.editorConfig = function( config )
{
  config.toolbar = 'MyToolbar';
  config.extraPlugins = 'markups';
  config.forcePasteAsPlainText = true;

  config.toolbar_MyToolbar =
    [
      ['Source'],
      ['Fachtermini'],
      ['Werktitel original'],
      ['Werktitel fremdspr'],
      ['Sonstiges'],
      ['Eigennamen'],
      ['fragliche Stellen'],
      ['Undo'],
      ['Redo']
    ];
};
