$(function() {
                /* tells us if we dragged the box */
                var dragged = false;

                /* timeout for moving the mox when scrolling the window */
                var moveBoxTimeout;

                /* make the actionsBox draggable */
                $('#actionsBox').draggable({
                    start: function(event, ui) {
                        dragged = true;
                    },
                    stop: function(event, ui) {
                        var $actionsBox = $('#actionsBox');
                        /*
                        calculate the current distance from the window's top until the element
                        this value is going to be used further, to move the box after we scroll
                         */
                        $actionsBox.data('distanceTop',parseFloat($actionsBox.css('top'),10) - $(document).scrollTop());
                    }
                });

                /*
                when clicking on an input (checkbox),
                change the class of the table row,
                and show the actions box (if any checked)
                 */
                $('#mytable input[type="checkbox"]').bind('click',function(e) {
                    var $this = $(this);
                    if($this.is(':checked'))
                        $this.parents('tr:first').addClass('selected');
                    else
                        $this.parents('tr:first').removeClass('selected');
                    showActionsBox();
                });

                function showActionsBox(){
                    /* number of checked inputs */
                    var BoxesChecked = $('#mytable input:checked').length;
                    /* update the number of checked inputs */
                    $('#cntBoxMenu').html(BoxesChecked);

                    var $acBox = $('#acBox');
                    if(BoxesChecked > 1){
                        document.getElementById("acBox").style.visibility="hidden";
                    }
                    else
                    {
                        document.getElementById("acBox").style.visibility="visible";
                    }
                    /*
                    if there is at least one selected, show the BoxActions Menu
                    otherwise hide it
                     */
                    var $actionsBox = $('#actionsBox');
                    if(BoxesChecked > 0){
                        /*
                        if we didn't drag, then the box stays where it is
                        we know that that position is the document current top
                        plus the previous distance that the box had relative to the window top (distanceTop)
                         */
                        if(!dragged)
                            $actionsBox.stop(true).animate({'top': parseInt(15 + $(document).scrollTop()) + 'px','opacity':'1'},500);
                        else
                            $actionsBox.stop(true).animate({'top': parseInt($(document).scrollTop() + $actionsBox.data('distanceTop')) + 'px','opacity':'1'},500);
                    }
                    else{
                        $actionsBox.stop(true).animate({'top': parseInt($(document).scrollTop() - 50) + 'px','opacity':'0'},500,function(){
                            $(this).css('left','50%');
                            dragged = false;
                            /* if the submenu was open we hide it again */
                            var $toggleBoxMenu = $('#toggleBoxMenu');
                            if($toggleBoxMenu.hasClass('closed')){
                                $toggleBoxMenu.click();
                            }
                        });
                    }
                }

                /*
                when scrolling, move the box to the right place
                 */
                $(window).scroll(function(){
                    clearTimeout(moveBoxTimeout);
                    moveBoxTimeout = setTimeout(showActionsBox,500);
                });

                /* open sub box menu for other actions */
                $('#toggleBoxMenu').toggle(
                function(e){
                    $(this).addClass('closed').removeClass('open');
                    $('#actionsBox .submenu').stop(true,true).slideDown();
                },
                function(e){
                    $(this).addClass('open').removeClass('closed');
                    $('#actionsBox .submenu').stop(true,true).slideUp();
                }
            );

                /*
                close the actions box menu:
                hides it, and then removes the element from the DOM,
                meaning that it will no longer appear
                 */
                $('#closeBoxMenu').bind('click',function(e){
                    $('#actionsBox').animate({'top':'-50px','opacity':'0'},1000,function(){
                        if(BoxesChecked > 0);
                    });
                });

                /*
                as an example, for all the actions (className:box_action)
                alert the values of the checked inputs
                 */
                $('#actionsBox .box_action').bind('click',function(e){
                    var ids = '';
                    $('#mytable input:checked').each(function(e,i){
                        var $this = $(this);
                        ids += 'id : ' + $this.attr('id') + ' , value : ' + $this.val() + '\n';
                    });
                    alert('checked inputs:\n'+ids);
                });
            });
