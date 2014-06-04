module RedmineAllDiff
	module RepositoriesControllerPatch
		def self.included(base)
			base.send(:include, InstanceMethods)

			base.class_eval do
				unloadable

				before_filter :add_diff_info, :only => :revision
			end
		end

		module InstanceMethods
			def add_diff_info
				@diff_type = params[:type] || User.current.pref[:diff_type] || 'inline'

		    @cache_key = "repositories/diff/#{@repository.id}/" +
		                      Digest::MD5.hexdigest("#{@path}-#{@rev}-#{@rev_to}-#{@diff_type}-#{current_language}")
		    unless read_fragment(@cache_key)
		      @diff = @repository.diff(@path, @rev, @rev_to)
		      show_error_not_found unless @diff
		    end
			end
		end
	end
end
