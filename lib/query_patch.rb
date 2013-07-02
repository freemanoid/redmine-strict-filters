module StrictFilter
  module QueryPatch
    module ClassMethods

    end

    module InstanceMethods
      def issues_with_only_created_by_self_for_manager(options={})
        issues = issues_without_only_created_by_self_for_manager(options)
        project = issues.first.try(:project)
        if Setting.plugin_strict_filter[:role_id_for_strict_filter_author] &&
           project &&
           User.current.roles_for_project(project).any? { |r| r.id == Setting.plugin_strict_filter[:role_id_for_strict_filter_author].to_i }
          issues.select! do |i|
            i.author == User.current
          end
        end
        if Setting.plugin_strict_filter[:role_id_for_strict_filter_custom_field_list] &&
           Setting.plugin_strict_filter[:custom_field_id_for_strict_filter_custom_field_list] &&
           project &&
           User.current.roles_for_project(project).any? { |r| r.id == Setting.plugin_strict_filter[:role_id_for_strict_filter_custom_field_list].to_i }
          issues.select! do |i|
            cfv = i.custom_field_values.find do |cfv|
              cfv.custom_field_id == Setting.plugin_strict_filter[:custom_field_id_for_strict_filter_custom_field_list].to_i
            end
            if cfv.value.kind_of?(Array)
              cfv.value.include?(User.current.lastname)
            else
              cfv.value == User.current.lastname
            end
          end
        end
        issues
      end

      def issue_count_with_only_created_by_self_for_manager
        res = issue_count_without_only_created_by_self_for_manager - (issues_without_only_created_by_self_for_manager.count - issues_with_only_created_by_self_for_manager.count)
        res < 0 ? 0 : res
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods

      receiver.class_eval do

        alias_method_chain :issues, :only_created_by_self_for_manager
        alias_method_chain :issue_count, :only_created_by_self_for_manager
      end
    end
  end
end
