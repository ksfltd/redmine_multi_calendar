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
  map.connect 'calendars/:id/view', :controller => 'calendar_vacation', :action => 'show'
  map.connect 'calendars/:id/holidays', :controller => 'calendar_vacation', :action => 'list_holidays'
  map.connect 'calendars/:id/assign_calendar', :controller => 'assign_calendar', :action => 'new'
  map.connect 'calendars/settings/:tab/:id/:date_year_for_list_holidays', :controller => 'calendar', :action => 'settings'
  map.connect 'calendars/settings/:tab/:id', :controller => 'calendar', :action => 'settings'
  map.connect 'calendars/settings/:tab/:id/:year', :controller => 'calendar', :action => 'settings'

  map.connect 'issues/calendar', :controller => 'calendars', :action => 'show'


end


