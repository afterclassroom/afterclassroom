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
        action = "/post_assignments";
        break;
      case "Tests":
        action = "/post_tests";
        break;
      case "Projects":
        action = "/post_projects";
        break;
      case "Exams":
        action = "/post_exams";
        break;
      case "QAs":
        action = "/post_qas";
        break;
      case "Education":
        action = "/post_educations";
        break;
      case "Tutors":
        action = "/post_tutors";
        break;
      case "Books":
        action = "/post_books";
        break;
      case "Jobs":
        action = "/post_jobs";
        break;
      case "Party":
        action = "/post_parties";
        break;
      case "Student Awareness":
        action = "/post_awarenesses";
        break;
      case "Housing":
        action = "/post_housings";
        break;
      case "Team Up":
        action = "/post_teamups";
        break;
      case "MyX":
        action = "/post_myxs";
        break;
      case "Foods":
        action = "/post_foods";
        break;
    }
    $('action_post_search').action = action;
  }