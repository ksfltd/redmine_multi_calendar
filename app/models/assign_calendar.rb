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

class AssignCalendar < ActiveRecord::Base
  unloadable

  belongs_to :calendar
  belongs_to :user

  validates_presence_of :calendar_id, :user_id
  validates_numericality_of :calendar_id, :allow_nil => true, :message => :invalid

  named_scope :user_have_calendar, lambda { |calendar_id| {:conditions => ["calendar_id = ?", calendar_id]} }

 def self.all_users
  self.assign_calendars_to_users(self.all)

 end

 def self.all_users_for_calendar(id)
  self.assign_calendars_to_users(self.user_have_calendar(id))
 end

private

  def self.assign_calendars_to_users(assing_c)
    users = []
    assing_c.each do |a_c|
      users << User.find(a_c.user_id)
    end
    users
 end

end
