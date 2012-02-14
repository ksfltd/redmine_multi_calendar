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
module IssuesCalendarHelper
  
  def vacations_for_users(only_one_calendar)
    vacations = []
    if only_one_calendar
      if User.current && User.current.assign_calendar && User.current.assign_calendar.calendar && User.current.assign_calendar.calendar.calendar_vacations
        vacations = User.current.assign_calendar.calendar.calendar_vacations
      end
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

   vacations_day = vacations.find_all{ |elem| elem.date_holiday == day } #.find_all_by_date_holiday(day)
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

  def m_calendar_link_to_previous_month1(year, month, m_calendar,  options={})
    target_year, target_month = if month == 1
                                  [year - 1, 12]
                                else
                                  [year, month - 1]
                                end

    name = if target_month == 12
             "#{month_name(target_month)} #{target_year}"
           else
             "#{month_name(target_month)}"
           end

    m_calendar_link_to_month(('&#171; ' + name), target_year, target_month, m_calendar,  options)
  end

  def m_calendar_link_to_next_month1(year, month, m_calendar, options={})
    target_year, target_month = if month == 12
                                  [year + 1, 1]
                                else
                                  [year, month + 1]
                                end

    name = if target_month == 1
             "#{month_name(target_month)} #{target_year}"
           else
             "#{month_name(target_month)}"
           end

    m_calendar_link_to_month((name + ' &#187;'), target_year, target_month, m_calendar,  options)
  end

  def m_calendar_link_to_month(link_name, year, month, m_calendar,  options={})
    link_to_content_update(link_name, params.merge(:year => year, :month => month, :m_calendar => m_calendar.to_s))
  end
  

end
