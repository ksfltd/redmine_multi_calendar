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

class CalendarController < ApplicationController
  unloadable

  menu_item :settings, :only => :settings

  before_filter :check_user
  before_filter :find_calendar, :only => [:edit, :show, :settings]

  def index
   @calendars = Calendar.all
  end

  def show
    @list_holidays = {}
    @users_assign_calendar = []
    if @calendar
      year_now = DateTime.now.year
      for year in year_now..year_now+1
        holidays = []
        holidays = CalendarVacation.events_for_dates(@calendar.id, Date.new(year, 1, 1), Date.new(year, 12, 31))
        holidays_fixed = CalendarVacation.event_fixed_date_for_year(@calendar.id, year-1)
        holidays = holidays + holidays_fixed.map do|d|
          d.date_holiday = Date.new(year, d.date_holiday.month, d.date_holiday.day )
          d
        end
        if !holidays.empty?
            @list_holidays[year] = holidays #.map{|d|d}
        end
      end
    
    @users_assign_calendar = AssignCalendar.all_users_for_calendar(@calendar.id)
    end
  end


  def settings
    @holidays = []
    
    if params[:year]
      @year = params[:year].to_i
    else
      @year = Date.today.year
      @year = params[:date_year_for_list_holidays].to_i if params[:date_year_for_list_holidays]
    end
    if @calendar
      @holidays = CalendarVacation.events_for_dates(@calendar.id, Date.new(@year, 1, 1), Date.new(@year, 12, 31))
      holidays_fixed = CalendarVacation.event_fixed_date_for_year(@calendar.id, @year-1)

      @holidays = @holidays + holidays_fixed

    end
    @copy_to_year = (params[:copy_to_year] ? params[:copy_to_year].to_i : @year)

    @a_calendar = AssignCalendar.new(:calendar_id =>  @calendar.id)
    @day_type = PatternWeekly.new(:calendar_id =>  @calendar.id, :color => "#fbaf5a")



  end


  def new
    @calendar = Calendar.new
    if params[:id_copy_calendar]
      @copy_calendar = Calendar.find_by_id(params[:id_copy_calendar])
      @calendar.name = "#{l(:mc_copy_of)} " + @copy_calendar.name
      @ac = "duplicate"
    else
      @ac = "create"
    end
    
  end

  def create
    @calendar = Calendar.new( params[:calendar])
    if @calendar.save    
      flash[:notice] = "#{l(:mc_successful_creation)} "
      redirect_to :action => 'show', :id => @calendar.id
    else
      render "new"
    end
  end


  def edit
    
  end

  def update
    @calendar = Calendar.find_by_id(params[:id])
    if @calendar.update_attributes( params[:calendar])
      @calendar.week_days.each do |day|
        day.update_attributes(:pattern_weekly_id => params["day_type#{day.id}"])
      end   
    else
      session[:error_multi_calendar] = @calendar.errors.full_messages
    end
    redirect_to :action => 'settings', :id => @calendar.id
  end

  def destroy
    calendar = Calendar.find_by_id(params[:id])
    if calendar
      calendar.destroy
    end
    redirect_to :action => 'index'
  end

  def duplicate
    copy_from_item = Calendar.find(params[:id_copy_calendar]) 
    new_calendar = Calendar.new(copy_from_item.attributes)
    new_calendar.name = params[:calendar][:name] 
    new_calendar.duplicate = true
    if new_calendar.save
      new_calendar.copy_from(copy_from_item)
      redirect_to :controller => 'calendar', :action => "show", :id => new_calendar.id      
    else
      redirect_to :action => 'new' 
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

