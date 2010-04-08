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
            if message != ""
              the_close = content_tag(:div, "<a href='javascript:;' onClick='hideFlashes();'> </a>", :class => 'postErrClo')
              the_content = content_tag(:div, message, :class => 'postErrNote')
              html << content_tag(:div, the_content + the_close, :id => "flash_#{css_class}")
              html << content_tag(:script, "setTimeout(hideFlashes, 25000);", :type => 'text/javascript')
              flash.delete(css_class)
            end
          end
        end
      end
    end
  end
end