// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

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
    $('#action_post_search').action = action;
}

function update_form(){
    $.ajax({
        url: '/users_select_school/update_form',
        type: 'GET',
        dataType: 'html',
        data: ({
            country : $('#country').val(),
            state : $('#state').val(),
            city : $('#city').val()
            }),
        success: function(html){
            $('#select_school').replaceWith(html);
            load_menus();
        }
    });
}

function select_school(){
    var school_id = $('#school').val();
    if (school_id != ""){
        document.location.href = "/session/change_school?school_id=" + school_id;
        Dialogs.close();
    }
}

function select_alphabet(id){
    $('a.selected').removeClass('selected');
    $(id).addClass('selected');
}

function load_menus (){
    $("#country").mcDropdown("#country_menu", {
        width: 170,
        valueAttr: "rel_country",
        select: update_form
    });
    $("#state").mcDropdown("#state_menu", {
        width: 170,
        valueAttr: "rel_state",
        select: update_form
    });
    $("#city").mcDropdown("#city_menu", {
        width: 170,
        valueAttr: "rel_city",
        select: update_form
    });
    $("#school").mcDropdown("#school_menu", {
        valueAttr: "rel_school",
        width: 170
    });
}