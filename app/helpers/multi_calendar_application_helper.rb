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

require 'date'
module MultiCalendarApplicationHelper
   include IssuesCalendarHelper

    def select_day_types_tag_for_calendar_vacations(calendar, id, selected_type=nil, name=nil)
      op =  {}
      calendar.pattern_weeklies.each do |i|
        op[i.name] = i.id
      end
      opt = options_for_select(op, selected_type)
      if name
        tag = select_tag "#{id}", opt, :name => name
      else
        tag = select_tag "#{id}", opt
      end
      tag
  end


  def holiday_options_for_select(one_calendar, project)
    calendars = {}
    project.users.each do |user|
      calendars[user.assign_calendar.calendar.name] = user.assign_calendar.calendar.id.to_s if user.assign_calendar && !calendars.values.include?(user.assign_calendar.calendar.id.to_s)
    end
    calendars["All calendars"] = "false"
    one_calendar = "false" if !one_calendar   
    options_for_select(calendars, one_calendar)
  end



  def vacations_for_users(only_one_calendar)   
    vacations = []
    if only_one_calendar && only_one_calendar != "false"
      vacations = CalendarVacation.find_all_by_calendar_id(only_one_calendar)   
    else
       vacations = CalendarVacation.all
    end
   return  vacations
  end


  def vacations_for_page_issues_calendar(vacations)
   e = []
     vacations.each do |event|
        e << event.date_holiday
        if event.fixed_date == 1
          for year in event.date_holiday.year..Time.now.year+6
            e << Date.new(year, event.date_holiday.month, event.date_holiday.day )
          end
        end
      end
   return  e
  end


  def vacations_events_on(day, vacations, project)
   e = ""
   vacations_day = vacations.find_all{ |elem| elem.date_holiday == day } 
   vacations_day_f = vacations.find_all{ |elem| elem.fixed_date == 1 && elem.date_holiday.year < day.year && Date.new(day.year, elem.date_holiday.month, elem.date_holiday.day ) == day }

     vacations_day = vacations_day + vacations_day_f
     if vacations_day
       vacations_day.each do |v|
           e << "<div class='vacations tooltip'>"
           e << "<p>#{l(:mc_holiday2)}</p><p class='m_label'>#{v.holiday}</p>"
           e << "<span class='tip'>"
           e << "<p class='m_label'>#{l(:mc_calendar)}: #{v.calendar.name}</p>"
           e << "<div style='width:100%; clear:both;'>"
           t = true
           v.calendar.assign_calendars.each do |a|
             if project.users.include?(a.user)
                if t
                   e << "<div style='width:50%; float: left;'>"
                    t = false
                 else
                   e << "<div style='width:50%; float: right;'>"
                    t = true
                 end
                 e << "<p>#{link_to_user a.user}</p>"
                 e << "</div>"
             end             
           end           
           if v.calendar.assign_calendars.empty?
             e << "#{l(:mc_is_empty)}"
           end
           e << "</div>"
           e << "</span>"
           e << "</div>"
       end
     end
   return  e
  end

  def select_m_calendar(one_calendar, only_my_calendar='Only my calendar' )
   options = {only_my_calendar => true, 'All calendars' => false} # ["Allow immediate", "Allow with subtask"]
   opt = options_for_select(options, one_calendar)
  select_tag 'm_calendar', opt
  end


  
  def options_for_calendar_select(calendars)
    options = content_tag('option', "--- #{l(:actionview_instancetag_blank_option)} ---")
    calendars.each do |i|
      tag_options = {:value => i.id}
      options << content_tag('option', i.name, tag_options)
    end
    options
  end



end

