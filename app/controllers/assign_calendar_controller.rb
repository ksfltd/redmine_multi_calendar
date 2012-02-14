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


class AssignCalendarController < ApplicationController
  unloadable

  before_filter :check_user
  before_filter :find_calendar, :only => [:new]

  def new

    @a_calendar = AssignCalendar.new(:calendar_id =>  @calendar.id)
  end

  def create
    @calendar = Calendar.find(params[:id])
    if params[:users_for_calendar]
        attrs = params[:users_for_calendar].dup
        if (user_ids = attrs.delete(:user_ids))
            user_ids.each do |user_id|
              a_calendar = AssignCalendar.new(:user_id => user_id, :calendar_id =>  @calendar.id)
              a_calendar.save
              puts attrs.merge(:user_id => user_id)

            end
        
         end
     end

     respond_to do |format|
        format.html { redirect_to :controller => "calendar", :action => "settings", :id => @calendar.id, :tab => 'calendar_view' }
        format.js {
          render(:update) {|page|
            page.replace_html "action_new", :partial => 'action_new'
          }
        }
    end

  end

 def autocomplete_for_assign_calendar

    @calendar = Calendar.find(params[:id])   
    @users = Principal.active.like(params[:q]).find(:all, :limit => 100) - AssignCalendar.all_users - Group.all

    render :layout => false
  end

  def new_assign_calendar

  end



  def destroy
    @calendar = Calendar.find(params[:calendar_id])
    assign_calendar = AssignCalendar.find_by_user_id(params[:user_id])
    if assign_calendar
      assign_calendar.destroy
    end
    respond_to do |format|
        format.html { redirect_to :controller => "calendar", :action => "settings", :id => @calendar.id, :tab => 'calendar_view' }
        format.js {
          render(:update) {|page|
            page.replace_html "action_new", :partial => 'action_new'
          }
        }
    end
  end


  def add_calendar
   a_calendar = AssignCalendar.new(:user_id => params[:id], :calendar_id =>  params[:calendars][:calendar_id])
   a_calendar.save if request.post?

    @user = User.find(params[:id])
     respond_to do |format|
       if a_calendar.valid?
         format.html { redirect_to :controller => 'users', :action => 'edit', :id => params[:id], :tab => 'assign_calendar' }
         format.js { render(:update) {|page| page.replace_html "tab-content-assign_calendar", :partial => 'assign_calendar/new_assign_calendar'} }
       else
         format.js {
           render(:update) {|page|
              page.alert(l(:notice_failed_to_save_calendar, :errors => a_calendar.errors.full_messages.join(', ')))
            }
         }
       end
    end
  end

  def destroy_calendar

    assign_calendar = AssignCalendar.find_by_user_id(params[:id])
 
    if request.post? && assign_calendar
    
      assign_calendar.destroy
    end
    @user = User.find(params[:id])
    respond_to do |format|
      format.html { redirect_to :controller => 'users', :action => 'edit', :id => params[:id], :tab => 'assign_calendar' }
      format.js { render(:update) {|page| page.replace_html "tab-content-assign_calendar", :partial => 'assign_calendar/new_assign_calendar'} }
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
