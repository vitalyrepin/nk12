module ProtocolsHelper
  def f_int(attrib,name)
    haml_tag :div, :class => "clearfix" do
      haml_tag :label, :for => "for"
      haml_tag :div, :class => "input" do
        haml_tag :input, :type => "input"
      end
    end
  end
end
