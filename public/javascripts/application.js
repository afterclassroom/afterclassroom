// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
/**
   * Returns the value of the selected radio button in the radio group, null if
   * none are selected, and false if the button group doesn't exist
   *
   * @param {radio Object} or {radio id} el
   * OR
   * @param {form Object} or {form id} el
   * @param {radio group name} radioGroup
   */
function $RF(el, radioGroup) {
    if($(el).type && $(el).type.toLowerCase() == 'radio') {
        var radioGroup = $(el).name;
        var el = $(el).form;
    } else if ($(el).tagName.toLowerCase() != 'form') {
        return false;
    }

    var checked = $(el).getInputs('radio', radioGroup).find(
        function(re) {
            return re.checked;
        }
        );
    return (checked) ? $F(checked) : null;
}