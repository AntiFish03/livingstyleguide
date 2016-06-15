Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

require "yaml"

begin
  require "compass"
rescue LoadError
end

module LivingStyleGuide
  @@default_options = {
    default_language: :example,
    title: "Living Style Guide",
    header: %Q(<h1 class="lsg--page-title">Living Style Guide</h1>),
    footer: %Q(<div class="lsg--footer"><a class="lsg--logo" href="http://livingstyleguide.org">Made with the LivingStyleGuide gem.</a></div>),
    root: "/"
  }
  class << self
    def default_options
      @@default_options
    end

    def command(*keys, &block)
      Commands.command(*keys, &block)
    end

    def parse_data(data)
      if data
        if Psych.respond_to?(:safe_load)
          Psych.safe_load(data)
        else
          Psych.load(data)
        end
      end
    end

    def template(file, scope)
      file = "#{File.dirname(__FILE__)}/livingstyleguide/templates/#{file}"
      erb = File.read(file)
      ERB.new(erb).result(scope)
    end

    def gem_path
      @gem_path ||= File.expand_path '..', File.dirname(__FILE__)
    end

    def stylesheets_path
      File.join assets_path, 'stylesheets'
    end

    def assets_path
      @assets_path ||= File.join gem_path, 'assets'
    end

    def configure_sass
      require 'sass'

      ::Sass.load_paths << stylesheets_path
    end
  end
end

require "livingstyleguide/version"
require "livingstyleguide/markdown_extensions"
require "livingstyleguide/document"
require "livingstyleguide/commands"
require "livingstyleguide/integration"

LivingStyleGuide.configure_sass
