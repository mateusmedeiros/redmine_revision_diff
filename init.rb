require 'all_diff/repositories_controller_patch'

ActionDispatch::Callbacks.to_prepare do
	require_dependency 'repositories_controller'
  unless RepositoriesController.included_modules.include? RedmineAllDiff::RepositoriesControllerPatch
    RepositoriesController.send(:include, RedmineAllDiff::RepositoriesControllerPatch)
  end
end

Redmine::Plugin.register :redmine_revision_diff do
  name 'Diff on Revision'
  author 'Mateus "Doodad" Medeiros'
  description 'Shows the entire diff of a commit directly in the revision view (the one that shows a list of modified files)'
  version '0.1.0'
  url 'https://github.com/mateusmedeiros/redmine_revision_diff'
  author_url 'https://github.com/mateusmedeiros'
end
