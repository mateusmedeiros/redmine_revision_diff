require 'all_diff/repositories_controller_patch'

ActionDispatch::Callbacks.to_prepare do
	require_dependency 'repositories_controller'
  unless RepositoriesController.included_modules.include? RedmineAllDiff::RepositoriesControllerPatch
    RepositoriesController.send(:include, RedmineAllDiff::RepositoriesControllerPatch)
  end
end

Redmine::Plugin.register :redmine_all_diff do
  name 'Redmine all-diff plugin'
  author 'Mateus "Doodad" Medeiros'
  description 'Shows the entire changeset of a commit in the changeset page, instead of just the links for each specific file diff'
  version '0.0.1'
  url 'https://github.com/mateusmedeiros/redmine_all_diff'
  author_url 'https://github.com/mateusmedeiros'
end
