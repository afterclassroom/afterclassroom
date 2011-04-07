// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function submit(){
    var result = $("#form_post").validate();
    if (result) {
        $("#form_post").submit();
    }
}

function downloadFile(path){
    document.location.href = path;
}

function getPostSearchType(post_type){
    action = "";
    switch (post_type) {
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
        case "Food":
            action = "/post_foods";
            break;
        case "Schedules":
            action = "/post_exam_schedules";
            break;
    }
    $('#action_post_search').attr("action", action);
}

function load_options(){
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

function send_comment(id, type){
    comment = $('#comment').val();
    if (comment != "") {
        $.ajax({
            url: '/posts/create_comment',
            type: 'GET',
            cache: false,
            dataType: 'html',
            data: ({
                commentable_id: id,
                commentable_type: type,
                comment: comment
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
    if (comment != "") {
        $.ajax({
            url: '/post_qas/create_comment',
            type: 'GET',
            cache: false,
            dataType: 'html',
            data: ({
                post_id: post_id,
                comment: comment,
                show: $('#show').val()
            }),
            success: function(data){
                $('#list_comments').html(data);
                $('#comment').val('');
                $('#form_comment').toggle('slow');
            }
        });
    }
}

function sendEmail(current_user_id, user_id){
    subject = $('#message_subject').val();
    body = $('#message_body').val();
    $.ajax({
        url: '/users/' + current_user_id + '/messages/send_message',
        type: 'GET',
        cache: false,
        dataType: 'html',
        data: ({
            recipient_id: user_id,
            subject: subject,
            body: body
        }),
        success: function(data){
            $('#div_send_message').html(data);
        }
    });
}


function sendReportAbuse(){
    reported_id = $('#reported_id').val();
    reported_type = $('#reported_type').val();
    abuse_type_id = $('#abuse_type_id').val();
    abuse_content = $('#abuse_content').val();
    
    if (reported_id != "" && reported_type != "" && content != "") {
        $.ajax({
            url: '/posts/create_report_abuse',
            type: 'GET',
            cache: false,
            dataType: 'html',
            data: ({
                reported_id: reported_id,
                reported_type: reported_type,
                abuse_type_id: abuse_type_id,
                abuse_content: abuse_content
            }),
            success: function(data){
                $('#div_send_report').html(data);
            }
        });
    }
}

function requireRating(post_id, path){
    rating = $('input[name=rating]:checked').val();
    
    if (rating != "") {
        $.ajax({
            url: path,
            type: 'GET',
            cache: false,
            dataType: 'script',
            data: ({
                rating: rating,
                post_id: post_id
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

function showCommentForm(wall_id){
    $('#wall_comment_form_' + wall_id).show();
    $('#wall_comment_' + wall_id).hide();
    $('#comment_' + wall_id).focus();
}

function hideCommentForm(wall_id){
    if ($('#comment_' + wall_id).val() == "") {
        $('#wall_comment_' + wall_id).show();
        $('#wall_comment_form_' + wall_id).hide();
    }
}

function goToByScroll(id){
    $('html,body').animate({
        scrollTop: $("#" + id).offset().top
    }, 'slow');
}

function resetForm(id){
    $('#' + id).each(function(){
        this.reset();
    });
}

// Pretty flash
function hideFlashes(){
    $('#flash_notice, #flash_warning, #flash_error').fadeOut(1500);
}

// Become a fan
function become_a_fan(path){
    $.ajax({
        url: path,
        type: "GET",
        dataType: "html",
        failure: function(msg){
            alert('ajax fail:' + msg);
        },
        success: function(msg){
            $('.AsDContR .fan').html(msg);
        }
    });
}

//Chat

function invite_chat(id){
    $.ajax({
        url: '/student_lounges/invite_chat',
        type: 'GET',
        cache: false,
        dataType: 'html',
        data: ({
            user_id: id
        }),
        success: function(data){
            $('.AsDContR .chat').text('Chatting...');
        },
        error: function(data){
            alert('Error connecting to server');
        }
        
    });
}

function add_users_to_chat(chanel_name){
    obj_form = document.forms['form_' + chanel_name];
    len = obj_form.elements.length;
    val = "";
    var i = 0;
    for (i = 0; i < len; i++) {
        if (obj_form.elements[i].type == "checkbox" && obj_form.elements[i].checked) {
            val += obj_form.elements[i].value + ";";
        }
    }
    
    $.ajax({
        url: '/student_lounges/add_users_to_chat',
        type: 'GET',
        cache: false,
        dataType: 'html',
        data: ({
            user_id: val,
            chanel_name: chanel_name
        })
    });
}

function stop_chat(chanel_name){
    $.ajax({
        url: '/student_lounges/stop_chat',
        type: 'GET',
        cache: false,
        dataType: 'html',
        data: ({
            chanel_name: chanel_name
        }),
        success: function(data){
            //Close window chat
        }
    });
}

function friends_changed_message(){
    $.ajax({
        url: '/student_lounges/friends_changed_message',
        type: 'GET',
        cache: false,
        dataType: 'html',
        success: function(data){
            $('#div_friends_changed_their_message').html(data);
        }
    });
}

function friends_you_invited_chat(){
    $.ajax({
        url: '/student_lounges/friends_you_invited_chat',
        type: 'GET',
        cache: false,
        dataType: 'html',
        success: function(data){
            $("#div_friends_you_invited_to_chat").html(data);
        }
    });
}

function friends_want_you_chat(){
    $.ajax({
        url: '/student_lounges/friends_want_you_chat',
        type: 'GET',
        cache: false,
        dataType: 'html',
        success: function(data){
            $("#div_friends_want_you_chat").html(data);
        }
    });
}

function friends_online(){
    $.ajax({
        url: '/student_lounges/friends_online',
        type: 'GET',
        cache: false,
        dataType: 'html',
        success: function(data){
            $("#div_friends_online").html(data);
        }
    });
}

function insert_text_to_chatcontent(chanel_name, text_chat){
    if ($('#' + chanel_name)) {
        $('#' + chanel_name).before(text_chat);
        scroll_div('#chat_content_' + chanel_name);
    }
}

function openChat(title, chanel_name){
    if ($('#' + chanel_name).length == 0) {
        var win = $.customWindow({
			winId: chanel_name,
            title: title,
            onopen: function(cont, obj){
                $.ajax({
                    url: '/student_lounges/chanel_chat_content',
                    type: 'GET',
                    cache: false,
                    dataType: 'html',
                    data: ({
                        chanel_name: chanel_name
                    }),
                    success: function(data){
                        cont.html(data);
                    }
                });
            },
            onclose: function(){
                //
            },
            onresize: function(obj){
                //Nothing
            }
        });
    }
}

function scroll_div(id){
    $(id).animate({
        scrollTop: $(id).attr("scrollHeight")
    }, 3000);
}

//Chat

//My Stories
function searchFriendStories(){
    var form = $("#friend_stories_search");
    var url = form.attr("action");
    var formData = form.serialize();
    $.get(url, formData, function(html){
        $("#friend_stories_list").html(html);
    });
}

function searchMyStories(){
    var form = $("#my_stories_search");
    var url = form.attr("action");
    var formData = form.serialize();
    $.get(url, formData, function(html){
        $("#my_stories_list").html(html);
    });
}

function formatLinkForPaginationURLFriend(){
    var form = $("#friend_stories_search");
    var url = form.attr("action");
    $("div.friend_stories").find("a").each(function(){
        var linkElement = $(this);
        var page = linkElement.html();
        linkElement.attr({
            "page": page,
            "href": "javascript:;"
        });
        
        linkElement.click(function(){
            form.attr("action", url + "?page=" + $(this).attr('page'));
            searchFriendStories();
        });
    });
}

function formatLinkForPaginationURLMy(){
    var form = $("#my_stories_search");
    var url = form.attr("action");
    $("div.my_stories").find("a").each(function(){
        var linkElement = $(this);
        var page = linkElement.html();
        linkElement.attr({
            "page": page,
            "href": "javascript:;"
        });
        
        linkElement.click(function(){
            form.attr("action", url + "?page=" + $(this).attr('page'));
            searchMyStories();
        });
    });
}

//My Stories

//My Photos
function searchFriendPhotos(){
    var form = $("#friend_photos_search");
    var url = form.attr("action");
    var formData = form.serialize();
    $.get(url, formData, function(html){
        $("#friend_photos_list").html(html);
    });
}

function searchMyPhotos(){
    var form = $("#my_photos_search");
    var url = form.attr("action");
    var formData = form.serialize();
    $.get(url, formData, function(html){
        $("#my_photos_list").html(html);
    });
}

function formatLinkForPaginationURLFriendPhoto(){
    var form = $("#friend_photos_search");
    var url = form.attr("action");
    $("div.friend_photos").find("a").each(function(){
        var linkElement = $(this);
        var page = linkElement.html();
        linkElement.attr({
            "page": page,
            "href": "javascript:;"
        });
        
        linkElement.click(function(){
            form.attr("action", url + "?page=" + $(this).attr('page'));
            searchFriendStories();
        });
    });
}

function formatLinkForPaginationURLMyPhoto(){
    var form = $("#my_photos_search");
    var url = form.attr("action");
    $("div.my_photos").find("a").each(function(){
        var linkElement = $(this);
        var page = linkElement.html();
        linkElement.attr({
            "page": page,
            "href": "javascript:;"
        });
        
        linkElement.click(function(){
            form.attr("action", url + "?page=" + $(this).attr('page'));
            searchMyStories();
        });
    });
}

//My Photos

//My Musics
function searchFriendMusics(){
    var form = $("#friend_musics_search");
    var url = form.attr("action");
    var formData = form.serialize();
    $.get(url, formData, function(html){
        $("#friend_musics_list").html(html);
    });
}

function searchMyMusics(){
    var form = $("#my_musics_search");
    var url = form.attr("action");
    var formData = form.serialize();
    $.get(url, formData, function(html){
        $("#my_musics_list").html(html);
    });
}

function formatLinkForPaginationURLFriendMusic(){
    var form = $("#friend_musics_search");
    var url = form.attr("action");
    $("div.friend_musics").find("a").each(function(){
        var linkElement = $(this);
        var page = linkElement.html();
        linkElement.attr({
            "page": page,
            "href": "javascript:;"
        });
        
        linkElement.click(function(){
            form.attr("action", url + "?page=" + $(this).attr('page'));
            searchFriendStories();
        });
    });
}

function formatLinkForPaginationURLMyMusic(){
    var form = $("#my_musics_search");
    var url = form.attr("action");
    $("div.my_musics").find("a").each(function(){
        var linkElement = $(this);
        var page = linkElement.html();
        linkElement.attr({
            "page": page,
            "href": "javascript:;"
        });
        
        linkElement.click(function(){
            form.attr("action", url + "?page=" + $(this).attr('page'));
            searchMyStories();
        });
    });
}

//My Musics