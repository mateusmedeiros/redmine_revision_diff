#!/usr/bin/env ruby
# encoding: UTF-8

require File.expand_path('../../test_helper', __FILE__)

class RepositoriesRevisionDiffTest < ActionController::TestCase
  tests RepositoriesController

  fixtures :projects, :repositories, :users

  REPOSITORY_PATH = Rails.root.join('tmp/test/git_repository').to_s
  REPOSITORY_PATH.gsub!(/\//, "\\") if Redmine::Platform.mswin?

  CHAR_1_HEX = "\xc3\x9c"
  FELIX_HEX  = "Felix Sch\xC3\xA4fer"

  def setup
    @ruby19_non_utf8_pass = (RUBY_VERSION >= '1.9' && Encoding.default_external.to_s != 'UTF-8')

    User.current = nil
    @project = Project.find(3)
    @repository = Repository::Git.create(
      :project => @project,
      :url => REPOSITORY_PATH,
      :path_encoding => 'ISO-8859-1'
    )
    assert @repository
    @char_1 = CHAR_1_HEX.dup
    @felix_utf8 = FELIX_HEX.dup
    if @char_1.respond_to?(:force_encoding)
      @char_1.force_encoding('UTF-8')
      @felix_utf8.force_encoding('UTF-8')
    end
  end

  def test_diff_on_revision
    assert_equal 0, @repository.changesets.count
    @repository.fetch_changesets
    @project.reload
    assert_equal 28, @repository.changesets.count
    get :revision, :id => 3, :rev => '61b685fbe55ab05b5ac68402d5720c1a6ac973d1'
    assert_response :success
    assert_template 'revision'
    assert_select 'div>table.filecontent'
  end
end
