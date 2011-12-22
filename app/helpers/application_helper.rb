module ApplicationHelper
  def suckerfish(node)
    fuc = lambda do |nodes|
      return "" if nodes.empty?
      return "<ul>" +
        nodes.inject("") do |string, (node, children)|
          string + "<li rel='#{node.id}'>" +
          node.name+
          fuc.call(children) +
          "</li>"
        end +
        "</ul>"
    end
    fuc.call(node.descendants.arrange)
  end
end
