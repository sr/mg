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

  def group
    spec.rubyforge_project
  end

  # Load the gemspec using the same limitations as github
  def spec
    @spec ||= begin
      require "rubygems/specification"
      data = File.read(gemspec)
      spec = nil
      Thread.new { spec = eval("$SAFE = 3\n#{data}") }.join
      spec
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
      task :install => package(".gem") do
        sh "gem install #{package(".gem")}"
      end

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

      if group
        desc "Publish the current version on Rubyforge"
        task :rubyforge => ["rubyforge:gem", "rubyforge:tarball", "rubyforge:git"]

        namespace :rubyforge do
          desc "Publish gem and tarball on rubyforge"
          task :gem => package(".gem") do
            sh "rubyforge add_release #{group} #{name} #{spec.version} #{package('.gem')}"
          end

          task :tarball => package(".tar.gz") do
            sh "rubyforge add_file #{group} #{name} #{spec.version} #{package('.tar.gz')}"
          end

          desc "Push to gitosis@rubyforge.org:#{name}.git"
          task :git do
            sh "git push gitosis@rubyforge.org:#{name}.git master"
          end
        end
      end
    end
end
