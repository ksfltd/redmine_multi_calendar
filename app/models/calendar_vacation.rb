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

class CalendarVacation < ActiveRecord::Base
  unloadable

  belongs_to :calendar
  belongs_to :pattern_weekly

named_scope :events_for_dates, lambda { |calendar, b_date, e_date| {:conditions => ["calendar_id = ? AND date_holiday >= ? AND date_holiday <= ?", calendar, b_date, e_date]} }
named_scope :events_for_free_dates, lambda { |calendar, b_date, e_date| {:conditions => ["calendar_id = ? AND date_holiday >= ? AND date_holiday <= ? AND fixed_date = 0", calendar, b_date, e_date]} }
named_scope :event_for_date, lambda { |calendar, date| {:conditions => ["calendar_id = ? AND date_holiday = ? ", calendar, date]} }
named_scope :event_fixed_date_for_year, lambda { |calendar, year| {:conditions => ["calendar_id = ? AND date_holiday <= ?  AND fixed_date = ?", calendar, Date.new(year, 12, 31), 1]} }



  
def get_date
    return self.date_holiday.to_formatted_s(:short), self.date_holiday.year()
end

def self.fixed_date_for?(calendar, date)
    fixed_date = CalendarVacation.event_fixed_date_for_year(calendar, date.year)
    fixed_date.each do |event|
      return true if event.date_holiday.to_formatted_s(:short) == date.to_formatted_s(:short)
    end
    return false
end

def self.fixed_date_for(calendar, bdate, fdate)
 
    f_dateh = {}
    year = bdate.year
    while year < (fdate.year + 1.year)      
      bf_date = CalendarVacation.event_fixed_date_for_year(calendar, year)      
      bf_date.each do |event|
        date = bdate.to_date
        while date < fdate.to_date + 1.day
          if event.date_holiday.to_formatted_s(:short) == date.to_formatted_s(:short) && date.year == year
            event.date_holiday = date           
            f_dateh[date] = event
            date = fdate
          end
          date = date + 1.day
        end
      end
      year = year + 1.year
    end    
    return f_dateh
end




end
