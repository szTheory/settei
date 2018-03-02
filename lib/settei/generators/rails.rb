module Settei
  module Generators
    class Rails
      def initialize(app_path:)
        @app_path = app_path

        spec = Gem::Specification.find_by_name("settei")
        @gem_path = spec.gem_dir
      end

      def run
        create_setting_rb
        create_ymls
        update_gitignore
      end

      private

      def create_setting_rb
        file_name = 'config/setting.rb'.freeze

        create_if_absent(file_name) do |file_name|
          FileUtils.cp(
            File.join(@gem_path, 'templates/setting.rb'),
            File.join(@app_path, file_name)
          )
        end
      end

      def create_ymls
        [:development, :test, :production].each do |env|
          file_name = "config/environments/#{env}.yml"

          create_if_absent(file_name) do |file_name|
            FileUtils.cp(
              File.join(@gem_path, 'templates/setting.yml'),
              File.join(@app_path, file_name)
            )
          end
        end
      end

      def update_gitignore
        file_name = '.gitignore'
        file_path = File.join(@app_path, file_name)
        text = "\n/config/environments/*.yml"

        file_content = File.read(file_path)
        if !file_content.include?(text)
          File.open(file_path, 'a+') { |file| file.write(text) }
          puts "Appended rule to #{file_name}."
        end
      end

      def create_if_absent(file_name)
        if File.exist?(file_name)
          puts "Already exists: #{file_name}, skipped"
        else
          yield file_name
          puts "Created: #{file_name}"
        end
      end
    end
  end
end