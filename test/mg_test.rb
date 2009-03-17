require "test/unit"
require File.dirname(__FILE__) + "/../lib/mg"

class MGTest < Test::Unit::TestCase
  def setup
    MG.new(File.dirname(__FILE__) + "/../mg.gemspec")
  end

  def test_tasks
    assert task_defined?(:install)
    assert task_defined?(:package)
    assert task_defined?("dist/mg-0.0.1.gem")
    assert task_defined?("dist/mg-0.0.1.tar.gz")
    assert ! task_defined?(:rubyforge)
  end

  def test_with_rubyforge_project
    # TODO assert_task_defined :rubyforge
    # TODO assert_equal ["rubyforge:gem", "rubyforge:tarball", "rubyforge:git"],
    # TODO  Rake::Task["rubyforge"].prerequisites
  end

  private
    def task_defined?(task_name)
      Rake::Task.task_defined?(task_name)
    end
end
