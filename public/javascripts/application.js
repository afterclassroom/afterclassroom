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
    $('#action_post_search').attr("action", action);
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

function select_alphabet(alphabet){
    city_id = $('#city').val();
    $.ajax({
        url: '/users_select_school/list_school',
        type: 'GET',
        cache: false,
        dataType: 'html',
        data: ({
            city_id : city_id,
            alphabet : alphabet
        }),
        success: function(data){
            $('#select_school').html(data);
            load_menus();
        }
    });
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
        width: 170,
        valueAttr: "rel_school"   
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

function send_comment(post_id){
    comment = $('#comment').val();
    if (comment != ""){
        $.ajax({
            url: '/posts/create_comment',
            type: 'GET',
            cache: false,
            dataType: 'html',
            data: ({
                post_id : post_id,
                comment : comment
            }),
            success: function(data){
                $('#list_comments').append(data);
                $('#comment').val('');
                $('#form_comment').toggle('slow');
            }
        });
    }
}

function send_answer(post_id){
    comment = $('#comment').val();
    if (comment != ""){
        $.ajax({
            url: '/post_qas/create_comment',
            type: 'GET',
            cache: false,
            dataType: 'html',
            data: ({
                post_id : post_id,
                comment : comment,
                show : $('#show').val()
            }),
            success: function(data){
                $('#list_comments').html(data);
                $('#comment').val('');
                $('#form_comment').toggle('slow');
            }
        });
    }
}

function sendEmail(user_id){
    subject = $('#message_subject').val();
    body = $('#message_body').val();

    if (subject != "" && body != ""){
        $.ajax({
            url: '/users/' + user_id + '/messages/send_message',
            type: 'GET',
            cache: false,
            dataType: 'html',
            data: ({
                recipient_id : user_id,
                subject : subject,
                body : body
            }),
            success: function(data){
                $('#div_send_message').html(data);
            }
        });
    }
}

function sendReportAbuse(){
    reported_id = $('#reported_id').val();
    reported_type = $('#reported_type').val();
    abuse_type_id = $('#abuse_type_id').val();
    abuse_content = $('#abuse_content').val();

    if (reported_id != "" && reported_type != "" && content != ""){
        $.ajax({
            url: '/posts/create_report_abuse',
            type: 'GET',
            cache: false,
            dataType: 'html',
            data: ({
                reported_id : reported_id,
                reported_type : reported_type,
                abuse_type_id : abuse_type_id,
                abuse_content : abuse_content
            }),
            success: function(data){
                $('#div_send_report').html(data);
            }
        });
    }
}

function requireRating(post_id, path){
    rating = $('input[name=rating]:checked').val();

    if (rating != ""){
        $.ajax({
            url: path,
            type: 'GET',
            cache: false,
            dataType: 'html',
            data: ({
                rating : rating,
                post_id : post_id
            }),
            success: function(data){
                $('#require_rating_action').html(data);
            }
        });
    }
}

function showResult(){
    $('[rel=rate]').each(function(index){
        $(this).show();
    });
    
    $('#view_results').hide();
}

function goToByScroll(id){
    $('html,body').animate({
        scrollTop: $("#"+id).offset().top
    },'slow');
}

// Pretty flash
function hideFlashes() {
    $('#flash_notice, #flash_warning, #flash_error').fadeOut(1500);
}