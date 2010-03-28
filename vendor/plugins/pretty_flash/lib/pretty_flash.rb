module RPH
  module PrettyFlash
    module ControllerMethods
      TYPES = [:notice, :warning, :error]
      
      TYPES.each do |type|
        define_method(type) do |msg|
          flash[type] = msg
        end
        
        define_method("#{type}_now") do |msg|
          flash.now[type] = msg
        end
      end
    end
  
    module Display
      def display_flash_messages
        returning html = String.new do
          flash.each do |css_class, message|
            the_close = content_tag(:div, "<a href='javascript:;' onClick='hideFlashes();'> </a>", :class => 'postErrClo')
            the_content = content_tag(:div, message, :class => 'postErrNote')
            the_script = %Q"
            $(document).ready(function() {
              setTimeout(hideFlashes, 25000);
            });

            var hideFlashes = function() {
              $('div#notice, div#warning, div#error').fadeOut(1500);
            }
            "
            html << content_tag(:div, the_content + the_close, :id => "flash_#{css_class}")
            html << content_tag(:script, the_script, :type => 'text/javascript')
          end
        end
      end
    end
  end
end