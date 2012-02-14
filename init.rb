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

require 'redmine'

require 'dispatcher'
require_dependency 'multi_calendar_hooks'

Dispatcher.to_prepare :redmine_multi_calendar do
  require_dependency 'principal'
  
  require_dependency 'calendars_controller'
  require_dependency 'my_controller'
  require_dependency 'users_helper'
  require_dependency 'application_helper'

  require_dependency 'multi_calendar_application_helper'
  
  User.class_eval do
    has_one :assign_calendar,  :dependent => :destroy
  end




  unless CalendarsController.included_modules.include? CalendarsControllerPatch
    CalendarsController.send(:include, CalendarsControllerPatch)
  end

  unless ApplicationHelper.included_modules.include? MultiCalendarApplicationHelper
     ApplicationHelper.send(:include, MultiCalendarApplicationHelper)
  end

  unless MyController.included_modules.include? MyControllerPatch
    MyController.send(:include, MyControllerPatch)
  end




end


Redmine::Plugin.register :redmine_multi_calendar do
  name 'Redmine Multi Calendar plugin'
  author 'Yalagina Anna'
  description 'This is a plugin for Redmine'
  version '0.0.1'

     menu :top_menu, 'calendar', { :controller => 'calendar', :action => 'index' },
        {
            :caption => 'Calendars',
            :if => Proc.new { User.current.admin }
        }

end
