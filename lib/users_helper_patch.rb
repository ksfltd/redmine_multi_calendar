# Redmine Multicalendar plugin - multiple, customizable calendars
# Copyright (C) 2011  KSF Technologies http://ksfltd.com
# Authors: Anna Yalagina, Eugene Hutorny
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; version 2
# of the License.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA

require_dependency 'users_helper'

 module UsersHelperPatch

     def self.included(base)
         base.extend(ClassMethods)
          base.send(:include, InstanceMethods)
          base.class_eval do
              unloadable
             alias_method_chain :user_settings_tabs, :plugin
         end
     end

     module ClassMethods
     end

     module InstanceMethods

        def user_settings_tabs_with_plugin
            tabs = user_settings_tabs_without_plugin
            tabs.push({ :name => 'assign_calendar',
                         :action => :new_assign_calendar,
                         :partial => 'assign_calendar/new_assign_calendar',
                         :label => :label_members_calendar })
             return tabs
         end

     end

 end