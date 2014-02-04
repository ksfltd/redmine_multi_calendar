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
      opt = options_for_select(op.sort, selected_type)
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
    #one_calendar = "false" if !one_calendar
    options_for_select(calendars, one_calendar.to_s)
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


  def vacations_for_page_issues_calendar(vacations, project)
    if project
       calendars = []
        project.users.each do |user|
          calendars << user.assign_calendar.calendar.id if user.assign_calendar
        end
        vacations = vacations.find_all{ |elem| calendars.include?(elem.calendar_id) }
    end
   
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

  def my_page_vacations(day, vacations)
    e = ""
   vacations_day = vacations.find_all{ |elem| User.current.assign_calendar && elem.date_holiday == day && elem.calendar_id == User.current.assign_calendar.calendar_id }
   vacations_day_f = vacations.find_all{ |elem| User.current.assign_calendar && elem.calendar_id == User.current.assign_calendar.calendar_id && elem.fixed_date == 1 && elem.date_holiday.year < day.year && Date.new(day.year, elem.date_holiday.month, elem.date_holiday.day ) == day }

     vacations_day = vacations_day + vacations_day_f
     if vacations_day
       vacations_day.each do |v|
         e << "<div class='vacations tooltip' style='background: #{v.pattern_weekly.color};'>"
         duration = v.pattern_weekly.duration > 0 ? "(#{v.pattern_weekly.duration}hrs)" : ""
           e << "<p>#{v.pattern_weekly.name} #{duration}</p><p class='m_label'>#{v.holiday}</p>"
           e << "<span class='tip'>"
           e << "<p class='m_label'>#{l(:mc_calendar)}: #{v.calendar.name}</p>"
           e << "</span>"
           e << "</div>"
       end
     end
     return  e
  end


  def vacations_events_on(day, vacations, project)
    return my_page_vacations(day, vacations) if !project
   e = ""
   vacations_day = vacations.find_all{ |elem| elem.date_holiday == day } 
   vacations_day_f = vacations.find_all{ |elem| elem.fixed_date == 1 && elem.date_holiday.year < day.year && Date.new(day.year, elem.date_holiday.month, elem.date_holiday.day ) == day }

     vacations_day = vacations_day + vacations_day_f
     calendars = []
    project.users.each do |user|
      calendars << user.assign_calendar.calendar.id if user.assign_calendar
    end
    vacations_day = vacations_day.find_all{ |elem| calendars.include?(elem.calendar_id) }
     if vacations_day
       vacations_day.each do |v|
           e << "<div class='vacations tooltip' style='background: #{v.pattern_weekly.color};'>"
           duration = v.pattern_weekly.duration > 0 ? "(#{v.pattern_weekly.duration}hrs)" : ""
           e << "<p>#{v.pattern_weekly.name} #{duration}</p><p class='m_label'>#{v.holiday}</p>"
           e << "<span class='tip'>"
           e << "<p class='m_label'>#{l(:mc_calendar)}: #{v.calendar.name}</p>"
           e << "<div style='width:100%; clear:both;'>"
           t = true
           v.calendar.assign_calendars.each do |a|
             if (!project.blank? && project.users.include?(a.user))
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

=begin
  def find_color_w_d(calendar)
    e = {}
    if calendar
      wd = WeekDay.find_all_by_calendar_id(calendar)
      wd.each do |event|
        e[event.dayname] = event.pattern_weekly if event.pattern_weekly && event.pattern_weekly.id == 4
      end
    end
   return  e
  end
=end

 def find_color_w_d(calendar, project)
   pattern_weekly_name = "weekend"
    e = {}
    if calendar.to_s != "false"
      
      wd = WeekDay.find_all_by_calendar_id(calendar)
      wd.each do |event|
        e[event.dayname] = event.pattern_weekly.color if event.pattern_weekly && event.pattern_weekly.name.strip.downcase == pattern_weekly_name && event.pattern_weekly.deft
      end
    else
      
      if User.current && User.current.assign_calendar && User.current.assign_calendar.calendar_id
        wd = WeekDay.find_all_by_calendar_id(User.current.assign_calendar.calendar_id)
        wd.each do |event|
          e[event.dayname] = event.pattern_weekly.color if event.pattern_weekly && event.pattern_weekly.name.strip.downcase == pattern_weekly_name && event.pattern_weekly.deft
        end

        project.users.each do |user|
          wd = WeekDay.find_all_by_calendar_id(user.assign_calendar.calendar.id) if user.assign_calendar && User.current.id != user.id
          wd.each do |event|
           # e[event.dayname] = event.pattern_weekly.color if event.pattern_weekly && event.pattern_weekly.id == 4 && !e.include?(event.dayname)  && event.pattern_weekly.deft
          #  e[event.dayname] = "#FFE4E1" if event.pattern_weekly && event.pattern_weekly.id == 4 && !e.include?(event.dayname)  && event.pattern_weekly.deft
            e[event.dayname] = "#FFE4E1" if event.pattern_weekly && event.pattern_weekly.name.strip.downcase == pattern_weekly_name && !e.include?(event.dayname)  && event.pattern_weekly.deft
          end
        end
      end
    end
   return  e
  end

end

