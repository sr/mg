require "test/unit"
require File.dirname(__FILE__) + "/../lib/mg"

class MGTest < Test::Unit::TestCase
  def setup
    MG.new(File.dirname(__FILE__) + "/../mg.gemspec")
  end

  def test_tasks
    assert_task_defined :install
    assert_task_defined :rubyforge
    assert_task_defined :package
    assert_task_defined "dist/mg-0.0.1.gem"
    assert_task_defined "dist/mg-0.0.1.tar.gz"

    assert_equal ["rubyforge:gem", "rubyforge:tarball", "rubyforge:git"],
      Rake::Task["rubyforge"].prerequisites
  end

  private
    def assert_task_defined(task_name)
      assert Rake::Task.task_defined?(task_name)
    end
end
