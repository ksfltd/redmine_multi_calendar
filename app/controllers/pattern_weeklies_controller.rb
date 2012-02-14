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

class PatternWeekliesController < ApplicationController
  unloadable

  before_filter :check_user
 

  def index
  end

  def create
    day_type = PatternWeekly.new( params[:day_type])
    day_type.save
    redirect_to :controller => "calendar", :action => "settings", :id => params[:day_type][:calendar_id], :tab => 'day_type'
  end

  def edit
    day_type = PatternWeekly.find(params[:id])
    day_type.update_attributes(params[:day_type])
    redirect_to :controller => "calendar", :action => "settings", :id => params[:day_type][:calendar_id], :tab => 'day_type'
  end



  def destroy
    day_type = PatternWeekly.find_by_id(params[:id])
    if day_type
      day_type.destroy
    end
    redirect_to :controller => "calendar", :action => "settings", :id => params[:calendar_id], :tab => 'day_type'
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
