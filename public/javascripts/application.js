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

function update_form(type_select, id){
    $.ajax({
        url: '/users_select_school/update_form',
        type: 'GET',
        cache: false,
        dataType: 'html',
        data: ({
            type : type_select,
            id : id
        }),
        success: function(data){
            $('#select_school').html(data);
            load_menus();
        }
    });
}
function select_country(){
    update_form("country", $('#country').val());
}

function select_state(){
    update_form("state", $('#state').val());
}

function select_city(){
    update_form("city", $('#city').val());
}

function select_school(){
    var school_id = $('#school').val();
    if (school_id != ""){
        document.location.href = "/session/change_school?school_id=" + school_id;
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
        select: select_country
    });
    $("#state").mcDropdown("#state_menu", {
        width: 170,
        valueAttr: "rel_state",
        select: select_state
    });
    $("#city").mcDropdown("#city_menu", {
        width: 170,
        valueAttr: "rel_city",
        select: select_city
    });
    $("#school").mcDropdown("#school_menu", {
        valueAttr: "rel_school",
        width: 170
    });
}

function load_options (){
    $("#department").mcDropdown("#department_menu", {
        width: 170,
        valueAttr: "rel_department",
        select: option_submit
    });
    $("#year").mcDropdown("#year_menu", {
        width: 75,
        valueAttr: "rel_year",
        select: option_submit
    });
    $("#over").mcDropdown("#over_menu", {
        width: 80,
        valueAttr: "rel_over",
        select: option_submit
    });
}

function option_submit(){
    $("#action_option").submit();
}