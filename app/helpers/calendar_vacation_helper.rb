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
module CalendarVacationHelper


  def calendar(options = {}, &block)
    raise(ArgumentError, "No year given")  unless options.has_key?(:year)
    raise(ArgumentError, "No month given") unless options.has_key?(:month)

    block                        ||= Proc.new {|d| nil}

    defaults = {
      :table_class => 'calendar',
      :month_name_class => 'monthName',
      :other_month_class => 'otherMonth',
      :day_name_class => 'dayName',
      :day_class => 'day',
      :abbrev => (0..2),
      :first_day_of_week => 0,
      :accessible => false,
      :show_today => true,
      :previous_month_text => nil,
      :next_month_text => nil
    }

    options = defaults.merge options

    first = Date.civil(options[:year], options[:month], 1)
    last = Date.civil(options[:year], options[:month], -1)

    first_weekday = first_day_of_week(options[:first_day_of_week])
    last_weekday = last_day_of_week(options[:first_day_of_week])

    day_names = Date::DAYNAMES.dup
    first_weekday.times do
      day_names.push(day_names.shift)
    end

    cal = attach_jquery

    cal << %(<table class="#{options[:table_class]}" border="0" cellspacing="0" cellpadding="0">)
    cal << %(<thead><tr>)
    if options[:previous_month_text] or options[:next_month_text]
      cal << %(<th colspan="2">#{options[:previous_month_text]}</th>)
      colspan=3
    else
      colspan=7
    end
    cal << %(<th colspan="#{colspan}" class="#{options[:month_name_class]}">#{Date::MONTHNAMES[options[:month]]}</th>)
    cal << %(<th colspan="2">#{options[:next_month_text]}</th>) if options[:next_month_text]
    cal << %(</tr><tr class="#{options[:day_name_class]}">)
    day_names.each do |d|
      unless d[options[:abbrev]].eql? d
        cal << "<th scope='col'><abbr title='#{d}'>#{d[options[:abbrev]]}</abbr></th>"
      else
        cal << "<th scope='col'>#{d[options[:abbrev]]}</th>"
      end
    end
    cal << "</tr></thead><tbody><tr>"
    fixed_date, events_fixed_date = find_fixed_date(options[:calendar], options[:year])
    beginning_of_week(first, first_weekday).upto(first - 1) do |d|
      cal << %(<td class="#{options[:other_month_class]})
   
      if options[:accessible]
        cal << %(">#{d.day}<span class="hidden"> #{Date::MONTHNAMES[d.month]}</span></td>)
      else
        cal << %(">#{d.day}</td>)
      end
    end unless first.wday == first_weekday
    
    date_e, events = find_events(options[:calendar], first, last)
    wd = find_color_week_days(options[:calendar])

    first.upto(last) do |cur|

      if date_e.include?(cur)
       
        if options[:calendar]
          calendar_id = options[:calendar].id
          event = events.event_for_date(calendar_id, cur)
          
          select_day_types = event.first.pattern_weekly_id
          cell_text = "<a href='#' onclick='return e_edit(\"#{event.first.holiday}\",\"#{cur}\",\"#{event.first.fixed_date}\",\"#{select_day_types}\");'> #{cur.mday}</a>"
        end


        cell_attrs = { :class => 'specialDay', :style => "background-color: #{event.first.pattern_weekly.color};"} if event.first.pattern_weekly

      end
      if fixed_date.include?(cur.to_formatted_s(:short))
        if options[:calendar]
          calendar_id = options[:calendar].id
          event = events_fixed_date.find_all{ |elem| elem.date_holiday.to_formatted_s(:short)==cur.to_formatted_s(:short) } #event_for_date(calendar_id, cur)
          
          select_day_types = event.first.pattern_weekly_id
          cell_text = "<a href='#' onclick='return e_edit(\"#{event.first.holiday}\",\"#{event.first.date_holiday}\",\"#{event.first.fixed_date}\",\"#{select_day_types}\");'> #{cur.mday}</a>"
        end

        cell_attrs = { :class => 'specialDay', :style => "background-color: #{event.first.pattern_weekly.color};"} if event.first.pattern_weekly
      end


    

    id_holiday = PatternWeekly.type(options[:calendar],"Holiday").first
    id_holiday = id_holiday.id if id_holiday
      
      select_day_types = id_holiday
      cell_text  ||= "<a href='#' onclick='return e_add(\"#{cur}\", \"#{select_day_types}\");'> #{cur.mday}</a>" # cur.mday "<a href='#' onclick='return click_me();'>" + cur.mday.to_s + "</a>"
      cell_attrs ||= {:class => options[:day_class], :style => "background-color: #{wd[cur.wday].color};"}

      cell_attrs[:class] += " weekendDay" if [0, 6].include?(cur.wday) && !cell_attrs[:class].index("specialDay")
      cell_attrs[:class] += " today" if (cur == Date.today) and options[:show_today]
     
      cell_attrs = cell_attrs.map {|k, v| %(#{k}="#{v}") }.join(" ")

      cal << "<td #{cell_attrs}>#{cell_text}</td>"
      cal << "</tr><tr>" if cur.wday == last_weekday
    end
    (last + 1).upto(beginning_of_week(last + 7, first_weekday) - 1)  do |d|
      cal << %(<td class="#{options[:other_month_class]})
    
      if options[:accessible]
        cal << %(">#{d.day}<span class='hidden'> #{Date::MONTHNAMES[d.mon]}</span></td>)
      else
        cal << %(">#{d.day}</td>)
      end
    end unless last.wday == last_weekday
    cal << "</tr></tbody></table>"
  end

  private

  def first_day_of_week(day)
    day
  end

  def last_day_of_week(day)
    if day > 0
      day - 1
    else
      6
    end
  end

  def days_between(first, second)
    if first > second
      second + (7 - first)
    else
      second - first
    end
  end

  def beginning_of_week(date, start = 1)
    days_to_beg = days_between(start, date.wday)
    date - days_to_beg
  end

  def weekend?(date)
    [0, 6].include?(date.wday)
  end

  def _event_path(event)
    "/events/#{event.id}"
  end

  def attach_jquery
    "<script type='text/javascript'>jQuery(document).ready(function($){$('a[rel*=facebox]').facebox()})</script>"
  end

  
  def find_events(calendar, first, last)
    e = []
    if calendar
      events = CalendarVacation.events_for_dates(calendar.id, first, last)
      events.each do |event|
        e << event.date_holiday
      end
    end

   return  e, events
  end

  def find_fixed_date(calendar, year)
    e = []
    if calendar
      events = CalendarVacation.event_fixed_date_for_year(calendar.id, year)
      events.each do |event|
        e << event.date_holiday.to_formatted_s(:short)
      end
    end
   return  e, events
  end

  def find_color_week_days(calendar)
    e = {}
    if calendar
      wd = WeekDay.find_all_by_calendar_id(calendar.id)
      wd.each do |event|
        e[event.dayname] = event.pattern_weekly
      end
    end
   return  e
  end

end
