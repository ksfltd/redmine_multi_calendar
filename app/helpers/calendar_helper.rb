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

module CalendarHelper
  include CalendarVacationHelper 
  include AssignCalendarHelper 

  def menu_selected(menu, selected) 
    if menu == selected
      return "selected"
    else
      return ""
    end

  end

  def calendart_settings_tabs
    tabs = [{:name => 'edit_calendar',:controller => 'calendar', :action => "edit", :partial => 'edit', :label => :edit_calendar},
            {:name => 'calendar_view', :controller => 'calendar_vacation', :action => "show", :partial => 'calendar_vacation/show', :label => :calendar_view},
            {:name => 'members', :controller => 'assign_calendar', :action => "new", :partial => 'assign_calendar/new', :label => :members},
            {:name => 'day_type', :controller => 'pattern_weeklies', :action => "index", :partial => 'pattern_weeklies/index', :label => :day_type}
            ]
    tabs 
  end

  def select_day_types_tag(calendar, day)
      op =  {}
      calendar.pattern_weeklies.each do |i|
        op[i.name] = i.id
      end
      opt = options_for_select(op, day.pattern_weekly_id)
      tag = select_tag "day_type#{day.id}", opt
      tag
  end


end