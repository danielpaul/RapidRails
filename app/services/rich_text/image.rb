class RichText::Image < RichTextRenderer::BaseNodeRenderer
  def render(node)
    entry = node['data']['target']

    "<div class='text-center'><img src='#{entry.url}' alt='#{entry.title}' class='w-full object-cover rounded-2xl mb-4 mt-3' /></div>"
  end
end