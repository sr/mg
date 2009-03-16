require "rake"
require "rake/clean"
require "rake/tasklib"

class MG < Rake::TaskLib
  attr_accessor :gemspec

  def initialize(gemspec)
    @gemspec = gemspec

    define_tasks
  end

  private
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

    def name
      spec.name
    end

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

      desc "Publish the current release on Rubyforge"
      task :rubyforge => ["rubyforge:gem", "rubyforge:tarball", "rubyforge:git"]

      namespace :rubyforge do
        desc "Publish gem and tarball to rubyforge"
        task :gem => package(".gem") do
          sh "rubyforge add_release #{name} #{name} #{spec.version} #{package('.gem')}"
        end

        task :tarball => package(".tar.gz") do
          sh "rubyforge add_file #{name} #{name} #{spec.version} #{package('.tar.gz')}"
        end

        desc "Push to gitosis@rubyforge.org:#{name}.git"
        task :git do
          sh "git push gitosis@rubyforge.org:#{name}.git master"
        end
      end

      desc "Build gem tarball into dist/"
      task :package => %w(.gem .tar.gz).map { |ext| package(ext) }

      file package(".tar.gz") => "dist/" do |f|
        sh <<-SH
          git archive \
            --prefix=#{name}-#{spec.version}/ \
            --format=tar \
            HEAD | gzip > #{f.name}
          SH
      end

      file package(".gem") => "dist/" do |f|
        sh "gem build #{name}.gemspec"
        mv File.basename(f.name), f.name
      end
    end
end
