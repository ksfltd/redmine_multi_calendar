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

require_dependency 'my_controller'
module MyControllerPatch
  def self.included(base) # :nodoc:
    base.extend(ClassMethods)

    base.send(:include, InstanceMethods)

    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      alias_method_chain :account, :m_calendar
    end

  end

  module ClassMethods

  end

  module InstanceMethods
    def account_with_m_calendar
      # account_without_m_calendar
       
       begin
         
           if User.current.assign_calendar && params[:m_calendar]
             User.current.assign_calendar.one_calendar = params[:m_calendar]
             
             User.current.assign_calendar.save
             
           end
        rescue => err
         puts err
         
       end
       account_without_m_calendar
    end
  end
end