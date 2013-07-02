require 'redmine'

Rails.configuration.to_prepare do
  require File.join(File.dirname(__FILE__), 'lib', 'query_patch')
  Query.send       :include, StrictFilter::QueryPatch
  # require 'role_patch'
  # Role.send                   :include, CustomFieldsPermissions::RolePatch
  # require 'user_patch'
  # User.send                   :include, CustomFieldsPermissions::UserPatch
  # require 'issues_helper_patch'
  # IssuesHelper.send           :include, CustomFieldsPermissions::IssuesHelperPatch
  # require File.join(File.dirname(__FILE__), 'lib', 'issue_patch')
  # Issue.send                  :include, CustomFieldsPermissions::IssuePatch
  # require 'query_patch'
  # Query.send                  :include, CustomFieldsPermissions::QueryPatch
  # require 'context_menus_controller_patch'
  # ContextMenusController.send :include, CustomFieldsPermissions::ContextMenusControllerPatch
end

class ViewsHooks < Redmine::Hook::ViewListener
  # render_on :view_custom_fields_form_issue_custom_field, :partial => "custom_fields/role_access"
end


Redmine::Plugin.register :strict_filter do
  name 'Strict Filter plugin'
  author 'Alexandr Elhovenko'
  description 'This is a plugin for Redmine'
  version '0.1.0'
  url 'http://example.com/path/to/plugin'
  author_url 'alexandr.elhovenko@gmail.com'
  settings default: {'empty' => true}, partial: 'strict_filter/settings'
end
