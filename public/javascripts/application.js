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
  
  function downloadFile(path){
    document.location.href = path;
  }
  
  function getPostSearchType(post_type){
    action = "";
    switch(post_type)
    {
      case "Assignments":
        action = "/post_assignments/search";
        break;
      case "Tests":
        action = "/post_tests/search";
        break;
      case "Projects":
        action = "/post_projects/search";
        break;
      case "Exams":
        action = "/post_exams/search";
        break;
      case "QAs":
        action = "/post_qas/search";
        break;
      case "Education":
        action = "/post_educations/search";
        break;
      case "Tutors":
        action = "/post_tutors/search";
        break;
      case "Books":
        action = "/post_books/search";
        break;
      case "Jobs":
        action = "/post_jobs/search";
        break;
      case "Party":
        action = "/post_parties/search";
        break;
      case "Student Awareness":
        action = "/post_awarenesses/search";
        break;
      case "Housing":
        action = "/post_housings/search";
        break;
      case "Team Up":
        action = "/post_teamups/search";
        break;
      case "MyX":
        action = "/post_myxes/search";
        break;
      case "Foods":
        action = "/post_foods";
        break;
    }
    $('action_post_search').action = action;
  }