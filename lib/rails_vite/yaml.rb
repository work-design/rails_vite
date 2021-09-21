module RailsVite
  class Yaml
    attr_reader :content
    # uses config/viter_template.yml in rails_ui engine as default,
    # config/viter_template.yml in Rails project will override this.
    def initialize(template:, export:)
      template_path = (Rails.root + template).existence || Engine.root + template
      export_path = Rails.root + export

      @yaml = YAML.parse_stream File.read(template_path)
      @content = @yaml.children[0].children[0].children
      @parsed = @yaml.to_ruby[0]
      @io = File.new(export_path, 'w+')
    end

    def dump
      @yaml.yaml @io
      @io.fsync
      @io.close
    end

    def append(env = 'default', key, value)
      env_content, index = xx(env, key)
      if index
        value_content = env_content[index]
      else
        return
      end

      return if value_content.children.find { |i| i.value == value }

      if value_content.is_a?(Psych::Nodes::Sequence)
        value_content.style = 1  # block style
        value_content.children << Psych::Nodes::Scalar.new(value)
      end

      value_content
    end

    def add(env = 'default', key, value)
      env_content, index = xx(env, key)
      if index
        value_content = env_content[index]
      else
        return
      end

      if value_content.is_a?(Psych::Nodes::Sequence)  # 数组
        value_content.style = 1  # block style
        value_content.children << Psych::Nodes::Scalar.new(value)
      elsif value_content.is_a?(Psych::Nodes::Mapping) && value.is_a?(Hash)  # 有下级内容
        value.each do |item, val|
          value_content.children << Psych::Nodes::Scalar.new(item)
          value_content.children << Psych::Nodes::Scalar.new(val)
        end
      elsif value_content.is_a?(Psych::Nodes::Scalar) && value.is_a?(Hash)
        value_content.children = []
        value.each do |item, val|
          value_content.children << Psych::Nodes::Scalar.new(item)
          value_content.children << Psych::Nodes::Scalar.new(val)
        end
      end

      value_content
    end

    def set(env = 'default', key, value)
      env_content, index = xx(env, key)
      if index
        value_content = env_content[index]
        value_content.value = value
      elsif key && value
        env_content << Psych::Nodes::Scalar.new(key)
        env_content << Psych::Nodes::Scalar.new(value)
      end
    end

    def xx(env, key)
      env_index = @content.find_index { |i| i.is_a?(Psych::Nodes::Scalar) && i.value == env }
      env_content = @content[env_index + 1].children
      value_index = env_content.find_index { |i| i.is_a?(Psych::Nodes::Scalar) && i.value == key }
      if value_index
        index = value_index + 1
      else
        index = nil
      end

      [env_content, index]
    end

  end
end
