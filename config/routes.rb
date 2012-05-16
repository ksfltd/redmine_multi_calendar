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

ActionController::Routing::Routes.draw do |map|
  map.connect 'calendars/:id/settings', :controller => 'calendar', :action => 'settings'
  map.connect 'calendars/:id/settings/:tab', :controller => 'calendar', :action => 'settings'

 # map.connect 'calendar/:id/show', :controller => 'calendar_vacation', :action => 'show'
  map.connect 'calendars/:id/view', :controller => 'calendar_vacation', :action => 'show'
  #map.connect 'calendars/:id/holidays', :controller => 'calendar_vacation', :action => 'list_holidays'
  map.connect 'calendars/:id/assign_calendar', :controller => 'assign_calendar', :action => 'new'
  map.connect 'calendars/:id/settings/:tab/:date_year_for_list_holidays', :controller => 'calendar', :action => 'settings'
 # map.connect 'calendars/settings/:tab/:id/:date_year_for_list_holidays', :controller => 'calendar', :action => 'settings'
 # map.connect 'calendars/settings/:tab/:id', :controller => 'calendar', :action => 'settings'
  map.connect 'calendars/:id/settings/:tab/:year', :controller => 'calendar', :action => 'settings'
 # map.connect 'calendars/settings/:tab/:id/:year', :controller => 'calendar', :action => 'settings'

  map.connect 'issues/calendar', :controller => 'calendars', :action => 'show'
  map.connect 'calendar', :controller => 'calendar', :action => 'index'
  map.connect 'calendar/new', :controller => 'calendar', :action => 'new'
  map.connect 'calendar/create', :controller => 'calendar', :action => 'create'
  map.connect 'calendar/show', :controller => 'calendar', :action => 'show'
  map.connect 'calendar/assign', :controller => 'assign_calendar', :action => 'add_calendar'
  map.connect 'calendar/assign/create', :controller => 'assign_calendar', :action => 'create'
  map.connect 'calendar/assign/autocomplete', :controller => 'assign_calendar', :action => 'autocomplete_for_assign_calendar'
  map.connect 'calendar/assign/destroy', :controller => 'assign_calendar', :action => 'destroy'
  map.connect 'calendar/assign/add', :controller => 'assign_calendar', :action => 'add_calendar' 
  map.connect 'calendar/assign/destroy_cal', :controller => 'assign_calendar', :action => 'destroy_calendar'
  map.connect 'calendar/destroy', :controller => 'calendar', :action => 'destroy'
  map.connect 'calendar/update', :controller => 'calendar', :action => 'update'
  map.connect 'calendar/settings', :controller => 'calendar', :action => 'settings'
  map.connect 'calendar/edit', :controller => 'calendar', :action => 'edit'
  map.connect 'calendar/duplicate', :controller => 'calendar', :action => 'edit'
  map.connect 'calendar/vacation', :controller => 'calendar_vacation', :action => 'show'
  map.connect 'calendar/vacation/list', :controller => 'calendar_vacation', :action => 'list_holidays'
  map.connect 'calendar/vacation/create', :controller => 'calendar_vacation', :action => 'create'
  map.connect 'calendar/vacation/update', :controller => 'calendar_vacation', :action => 'update'
  map.connect 'calendar/vacation/destroy', :controller => 'calendar_vacation', :action => 'destroy'
  map.connect 'calendar/vacation/duplicate', :controller => 'calendar_vacation', :action => 'duplicate'
  map.connect 'calendar/weekly', :controller => 'pattern_weeklies', :action => 'index' 
  map.connect 'calendar/weekly/create', :controller => 'pattern_weeklies', :action => 'create' 
  map.connect 'calendar/weekly/edit', :controller => 'pattern_weeklies', :action => 'edit' 
  map.connect 'calendar/weekly/destroy', :controller => 'pattern_weeklies', :action => 'destroy' 
  map.connect 'calendar/week_days/edit', :controller => 'week_days', :action => 'edit'
  map.connect 'calendar/week_days/update', :controller => 'week_days', :action => 'update'
end


