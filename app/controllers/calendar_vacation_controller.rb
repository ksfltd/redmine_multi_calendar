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

class CalendarVacationController < ApplicationController
  unloadable

  before_filter :check_user
  before_filter :find_calendar, :only => [:list_holidays, :show, :create, :update]

  def show
   @holidays = []    
    if params[:date]
      @year = params[:date][:year].to_i
    else
      @year = Date.today.year
      @year = params[:date_year_for_list_holidays].to_i if params[:date_year_for_list_holidays]
    end

    if @calendar
      @holidays = CalendarVacation.events_for_dates(@calendar.id, Date.new(@year, 1, 1), Date.new(@year, 12, 31))
      holidays_fixed = CalendarVacation.event_fixed_date_for_year(@calendar.id, @year-1)
      @holidays = @holidays + holidays_fixed
    end
    @copy_to_year = @year

    respond_to do |format|
      format.html { redirect_to :controller => "calendar", :action => "settings", :id => @calendar.id, :tab => 'calendar_view' }     
       format.js { render(:update) {|page| page.replace_html "tab-content-calendar_view", :partial => 'calendar_vacation/show'} }
    end


  end

  def list_holidays
    @holidays = []
    if params[:date]
      @year = params[:date][:year].to_i
    else
      @year = Date.today.year
    end
    @copy_to_year = (params[:copy_to_year] ? params[:copy_to_year].to_i : @year)

    if @calendar
      @holidays = CalendarVacation.events_for_dates(@calendar.id, Date.new(@year, 1, 1), Date.new(@year, 12, 31))
      holidays_fixed = CalendarVacation.event_fixed_date_for_year(@calendar.id, @year-1)     
      @holidays = @holidays + holidays_fixed    
    end

  end


  def create
    if @calendar
     add_event_calendar_vacation(params, @calendar)
    end
    redirect_to :controller => "calendar", :action => 'settings', :id => @calendar.id, :tab => 'calendar_view', :year => params[:year]
    
  end


 def update  
    if @calendar
     add_event_calendar_vacation(params, @calendar)
    end
     redirect_to :action => 'list_holidays', :id => params[:id]
  end


  def destroy

  end


  def duplicate
    year = params[:year].to_i
    copy_to_year = params[:date][:year].to_i
    if year != copy_to_year       
    calendar = Calendar.find(params[:id])
    if calendar
      calendar_vacations = CalendarVacation.events_for_free_dates(calendar.id, Date.new(year, 1, 1), Date.new(year, 12, 31))
      if calendar_vacations
        calendar_vacations.each do |calendar_vacation|
          update_calendar_vacation = CalendarVacation.find_by_calendar_id_and_date_holiday(params[:id], Date.new(copy_to_year, calendar_vacation.date_holiday.month, calendar_vacation.date_holiday.day))
          if !update_calendar_vacation
            new_calendar_vacation = CalendarVacation.new(calendar_vacation.attributes)
            new_calendar_vacation.date_holiday = Date.new(copy_to_year, new_calendar_vacation.date_holiday.month, new_calendar_vacation.date_holiday.day)
            new_calendar_vacation.save if !CalendarVacation.fixed_date_for?(calendar.id, new_calendar_vacation.date_holiday)
          end
        end
      end
    else
      render_404
    end
  end
    redirect_to :controller => "calendar", :action => 'settings', :id => params[:id], :tab => 'calendar_view', :year => copy_to_year
    
  end

private

  def add_event_calendar_vacation(attributes, calendar)

    for i in 1..attributes["i_holiday"].to_i
        if attributes["calendar_v#{i}"]
          
          calendar_vacation = CalendarVacation.event_for_date(calendar.id, attributes["calendar_v_#{i}"])
          calendar_v = CalendarVacation.event_for_date(calendar.id, attributes["calendar_v#{i}"][:date_holiday])
          begin

          if calendar_vacation.first 
            calendar_vacation.first.update_attributes(:holiday => attributes["calendar_v#{i}"][:holiday],
                :fixed_date => attributes["calendar_v#{i}"][:fixed_date],
                :pattern_weekly_id => attributes["calendar_v#{i}"][:brief_days],
                :date_holiday => Date.parse(attributes["calendar_v#{i}"][:date_holiday]))if calendar_v.first && calendar_v.first.id == calendar_vacation.first.id
                
            calendar_v.first.update_attributes(:holiday => attributes["calendar_v#{i}"][:holiday],
                :fixed_date => attributes["calendar_v#{i}"][:fixed_date],
                :pattern_weekly_id => attributes["calendar_v#{i}"][:brief_days],
                :date_holiday => Date.parse(attributes["calendar_v#{i}"][:date_holiday]))if calendar_v.first && calendar_v.first.id != calendar_vacation.first.id

            calendar_vacation.first.update_attributes(:holiday => attributes["calendar_v#{i}"][:holiday],
                :fixed_date => attributes["calendar_v#{i}"][:fixed_date],
                :pattern_weekly_id => attributes["calendar_v#{i}"][:brief_days],
                :date_holiday => Date.parse(attributes["calendar_v#{i}"][:date_holiday]))if !calendar_v.first
                        
          else             
            if !calendar_v.first
            calendar_vacation = CalendarVacation.new({:calendar_id => calendar.id, :holiday => attributes["calendar_v#{i}"][:holiday], :date_holiday => Date.parse(attributes["calendar_v#{i}"][:date_holiday]), :fixed_date => attributes["calendar_v#{i}"][:fixed_date], :pattern_weekly_id => attributes["calendar_v#{i}"][:brief_days]})
            calendar_vacation.save if !calendar_v.first             
            end
            calendar_v.first.update_attributes(:holiday => attributes["calendar_v#{i}"][:holiday],
                :fixed_date => attributes["calendar_v#{i}"][:fixed_date],
                :pattern_weekly_id => attributes["calendar_v#{i}"][:brief_days],
                :date_holiday => Date.parse(attributes["calendar_v#{i}"][:date_holiday]))if calendar_v.first
              
          end         
          rescue => err
              puts err
          end
        end

        if attributes["del_calendar_v_#{i}"]          
          calendar_vacation = CalendarVacation.find_by_calendar_id_and_date_holiday( calendar.id, Date.parse(attributes["del_calendar_v_#{i}"]) )
          calendar_vacation.destroy if calendar_vacation
        end
      end

      destroy_repetitive_date(calendar.id)

  end

  def destroy_repetitive_date(calendar_id)
    fixed_dates = CalendarVacation.find_all_by_calendar_id_and_fixed_date(calendar_id, 1)
    all_dates = CalendarVacation.find_all_by_calendar_id(calendar_id)
    fixed_dates.each do |fixed_event|
     fixed_day, fixed_year = fixed_event.get_date
      all_dates.delete_if do |event|
        day, year = event.get_date
        if fixed_day == day && fixed_year < year
            event.destroy
        end
        fixed_day == day && fixed_year < year
      end
    end

  end


private

  def find_calendar
    @calendar = Calendar.find_by_id(params[:id])
    render_404 if !@calendar
  end

  def check_user
    if !User.current.admin
      redirect_to home_path
      return
    end
  end

end

