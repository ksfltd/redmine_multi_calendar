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

require_dependency 'calendars_controller'
module CalendarsControllerPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      alias_method_chain :show, :m_calendar_show
    end

  end

  module ClassMethods

  end

  module InstanceMethods
    def show_with_m_calendar_show
     # show_without_m_calendar_show
      
           begin        
           @one_calendar = false           
           @one_calendar = User.current.assign_calendar.calendar_id  if params[:m_calendar] == nil && User.current.assign_calendar && User.current.assign_calendar.one_calendar
           @one_calendar = params[:m_calendar] if params[:m_calendar] != nil && params[:m_calendar] != false           
           rescue => err
             puts err
             
           end
           
    show_without_m_calendar_show
    end
  end
end