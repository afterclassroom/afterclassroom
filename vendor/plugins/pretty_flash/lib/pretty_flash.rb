module RPH
  module PrettyFlash
    module ControllerMethods
      TYPES = [:notice, :warning, :error]
      
      TYPES.each do |type|
        define_method(type) { |msg| flash[type] = raw(msg) }
        
        define_method("#{type}_now") { |msg| flash.now[type] = raw(msg) }
      end
    end
  
    module Display
      def display_flash_messages
        returning html = String.new do
          flash.each do |css_class, message|
            if message != ""
              the_close = content_tag(:div, raw("<a href='javascript:;' onClick='hideFlashes();'> </a>"), :class => 'postErrClo')
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