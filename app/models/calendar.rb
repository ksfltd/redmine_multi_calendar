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

class Calendar < ActiveRecord::Base
  unloadable

  has_many :calendar_vacations, :dependent => :destroy
  has_many :assign_calendars, :dependent => :destroy
  has_many :pattern_weeklies, :dependent => :destroy
  has_many :week_days, :dependent => :destroy

  validates_presence_of :name, :message => l(:mc_field_is_required) #" field is required"

  attr_accessor :duplicate
  after_create :default_pattern_weekly


  def copy_from(calendar)
    copy_week_days = calendar.week_days
    copy_calendar_vacations = calendar.calendar_vacations
    copy_pattern_weeklies = calendar.pattern_weeklies
      copy_pattern_weeklies.each do |pattern_weekly|
        new_pattern_weekly = PatternWeekly.new(pattern_weekly.attributes)
        new_pattern_weekly.calendar_id = id

        if new_pattern_weekly.save
          copy_week_days.each do |wd|
            if wd.pattern_weekly_id == pattern_weekly.id
              wd.pattern_weekly_id = new_pattern_weekly.id
              new_week_day = WeekDay.new(wd.attributes)
              new_week_day.calendar_id = id
              new_week_day.save
            end
          end

          copy_calendar_vacations.each do |calendar_vacation|
            if calendar_vacation.pattern_weekly_id == pattern_weekly.id
              calendar_vacation.pattern_weekly_id = new_pattern_weekly.id
              new_calendar_vacation = CalendarVacation.new(calendar_vacation.attributes)
              new_calendar_vacation.calendar_id = id
              new_calendar_vacation.save
            end
          end
        end
      end

  end



  def self.all_vacation_days(user, start, finish)
     holidays = {}     
    if user.assign_calendar
      calendar = user.assign_calendar.calendar    
      CalendarVacation.events_for_free_dates(calendar.id, start, finish).each do |event|
          holidays[event.date_holiday] = event        
      end      
      holidays.merge!(CalendarVacation.fixed_date_for(calendar, start, finish))
      w_days = WeekDay.all_week_days_for_empty_duration(calendar)
    else
      w_days = WeekDay.all_week_days_for_empty_duration()
    end
    date = start.to_date
    days = holidays.size
    days_v = 0  
    while date < finish.to_date + 1.day
        days = days + 1 if !holidays[date] && w_days.include?(date.wday)     
        date = date + 1.day
        days_v = days_v + 1     
     end     
     days_v = days_v - days
     days_v
  end


  private

  def default_pattern_weekly
    if !duplicate
    working_day = PatternWeekly.create(:name => "Working day",
                         :color => "#BBCCFF",
                         :calendar_id => id,
                         :duration => 8,
                         :deft => true)
    short_day = PatternWeekly.create(:name => "Short day",
                         :color => "#dcbccf",
                         :calendar_id => id,
                         :duration => 7,
                         :deft => true)
    PatternWeekly.create(:name => "Holiday",
                         :color => "#fdc68c",
                         :calendar_id => id,
                         :duration => 0,
                         :deft => true)
    weekend = PatternWeekly.create(:name => "Weekend",
                         :color => "#FFFFDD",
                         :calendar_id => id,
                         :duration => 0,
                         :deft => true)

    for i in 1..5
      WeekDay.create(:dayname => i, :calendar_id => id, :pattern_weekly_id => working_day.id)
    end
    WeekDay.create(:dayname => 0, :calendar_id => id, :pattern_weekly_id => weekend.id)
    WeekDay.create(:dayname => 6, :calendar_id => id, :pattern_weekly_id => weekend.id)
    end

  end

end
