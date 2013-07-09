require "rake"
require "rake/clean"
require "rake/tasklib"

class MG < Rake::TaskLib
  attr_accessor :gemspec

  def initialize(gemspec)
    @gemspec = gemspec

    define_tasks
  end

  def name
    spec.name
  end

  def spec
    @spec ||= begin
      require "rubygems/specification"
      Gem::Specification.load(gemspec)
    end
  end

  private
    def package(ext="")
      "dist/#{spec.name}-#{spec.version}" + ext
    end

    def define_tasks
      directory "dist/"
      CLOBBER.include("dist")

      desc "Build and install as local gem"
      task "gem:install" => package(".gem") do
        sh "gem install #{package(".gem")}"
      end

      desc "Build gem into dist/"
      task :gem => package('.gem')

      desc "Build gem and tarball into dist/"
      task :package => %w(.gem .tar.gz).map { |ext| package(ext) }

      desc "Build the tarball in dist/"
      file package(".tar.gz") => "dist/" do |f|
        sh <<-SH
          git archive \
            --prefix=#{name}-#{spec.version}/ \
            --format=tar \
            HEAD | gzip > #{f.name}
          SH
      end

      desc "Build the gem in dist/"
      file package(".gem") => "dist/" do |f|
        sh "gem build #{name}.gemspec"
        mv File.basename(f.name), f.name
      end

      desc "Push the gem to RubyGems.org"
      task "gem:publish" => package(".gem") do
        Rake::Task[:test].invoke if Rake::Task.task_defined?(:test)
        Rake::Task[:spec].invoke if Rake::Task.task_defined?(:spec)

        sh "gem push #{package(".gem")}"
      end

      # Legacy
      task :gemcutter => :publish
    end
end
