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

class WeekDay < ActiveRecord::Base
  unloadable

  belongs_to :calendar
  belongs_to :pattern_weekly

  named_scope :w_day, lambda { |d, calendar| { :conditions => { :dayname => d.wday, :calendar_id => calendar.id} } }

   def self.type_day_for(d, calendar)
     begin
        res = self.w_day(d, calendar)
        res = res.first.pattern_weekly if res.first
        res
     rescue => err
       puts err
     end

   end

   def self.all_week_days_for_empty_duration(calendar=nil)
    w_days = []
       if calendar
         week_days = WeekDay.find_all_by_calendar_id(calendar.id)
         week_days.each do |wd|
              w_days << wd.dayname if wd.pattern_weekly.duration == 0
          end
       else
         w_days = [0, 6]
       end
       w_days
   end

end
