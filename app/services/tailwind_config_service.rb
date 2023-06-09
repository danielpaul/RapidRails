class TailwindConfigService
  require "execjs"
  require "json"

  def get_config
    javascript_code = File.read("config/tailwind.config.js")

    context = ExecJS.compile(javascript_code)
    module_exports_value = context.eval("module.exports")

    # Parse the JavaScript object syntax into a Ruby hash
    ruby_hash = JSON.parse(module_exports_value.to_json) if module_exports_value

    # Access the values in the Ruby hash
    if ruby_hash
      puts ruby_hash["content"]
      puts ruby_hash["theme"]["extend"]["fontFamily"]["sans"]
    # Access other values as needed
    else
      puts "No module.exports hash found or it couldn't be parsed."
    end
    puts "hi"
  end
end
